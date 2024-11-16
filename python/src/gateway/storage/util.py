import pika, json

def upload(f, fs, channel, access):
    print(f"upload f: {f}")
    try:
        fid = fs.put(f)
    except Exception as err:
        print("fs.put(f) err", err)
        return "internal server error", 500
    
    message = {
        "video_fid": str(fid),
        "mp3_fid": None,
        "username": access["username"],
    }

    try: 
        channel.basic_publish(
            exchange="",
            routing_key="video",
            body=json.dumps(message),
            properties=pika.BasicProperties(
                delivery_mode=pika.spec.PERSISTENT_DELIVERY_MODE # If the K8s pods crash and restart to it last active state, the message (not only the queue) on pod's RabbitMQ queue is peristed
            )
        )
    except Exception as err:
        fs.delete(fid)
        print("channel.basic_publish err", err)
        return "internal server error", 500