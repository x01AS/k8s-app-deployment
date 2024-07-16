# Adding required module from flask to handle web request and JSON respons.
from flask import Flask, jsonify
# datetime for working with timestamps
from datetime import datetime
# socket for getting the hostname
import socket

app = Flask(__name__)

@app.route('/')
def get_info():
    # Get the current timestamp
    timestamp = datetime.utcnow().isoformat()
    
    # Get the hostname
    hostname = socket.gethostname()
    
    # Return the information as JSON
    return jsonify(timestamp=timestamp, hostname=hostname)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
    