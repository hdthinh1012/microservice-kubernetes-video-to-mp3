import jwt, datetime, os
from flask import Flask, request
from flask_mysqldb import MySQL

server = Flask(__name__)

#config
server.config['MYSQL_HOST'] = os.environ.get("MYSQL_HOST")
server.config['MYSQL_USER'] = os.environ.get("MYSQL_USER")
server.config['MYSQL_PASSWORD'] = os.environ.get("MYSQL_PASSWORD")
server.config['MYSQL_DB'] = os.environ.get("MYSQL_DB")
server.config['MYSQL_PORT'] = int(os.environ.get("MYSQL_PORT"))

mysql = MySQL(server)

@server.route("/login", methods=["POST"])
def login():
    auth = request.authorization # Basic Authorization scheme header
    if not auth:
        return "missing credentials", 401
    
    # check db for username, password
    cur = mysql.connection.cursor()
    res = cur.execute(
        "SELECT email, password FROM user WHERE email=%s", (auth.username,)
    )

    if res > 0: # res is array of ROWs
        user_row = cur.fetchone()
        email = user_row[0]
        password = user_row[1]
        if (email != auth.username or password != auth.password):
            return "invalid credentials", 401
        else:
            return createJWT(auth.username, os.environ.get("JWT_SECRET"), True)
    else:
        return "invalid credentials", 401

@server.route("/validate", methods=["POST"])
def validate():
    encoded_jwt = request.headers["Authorization"]
    
    if not encoded_jwt:
        return "invalid credentials", 401
    
    encoded_jwt = encoded_jwt.split(" ")[1] # Authorization: Bearer <token>
    
    try:
        decode = jwt.decode(
            encoded_jwt, os.environ.get("JWT_SECRET"), algorithms=["HS256"]
        )
    except:
        return "not authorized", 403
    
    return decode, 200

def createJWT(username, secret, authz):
    return jwt.encode(
        {
            "username": username,
            "exp": datetime.datetime.now(tz=datetime.timezone.utc) + datetime.timedelta(days=1),
            "iat": datetime.datetime.now(tz=datetime.timezone.utc),
            "admin": authz
        },
        secret,
        algorithm="HS256"
    )

# Run this file as entrypoint
if __name__ == '__main__':
    server.run(host="0.0.0.0", port=5000) # Ask Flask application listen from any IP from public (0.0.0.0/0, including the loopback address that is accessible only by localhost itself) find in the server (in this case docker container) NIC IP list (one docker container may be assigned to 2 network with 2 different IP address)
