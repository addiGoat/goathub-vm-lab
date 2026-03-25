from http.server import BaseHTTPRequestHandler, HTTPServer

class StatusHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        from datetime import datetime
        import socket
        current_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        hostname = socket.gethostname()

        response = f"""
        <html>
            <head><title>goatHub - Status</title></head>
            <body>
                <h1>goatHub Current Status</h1>
                <p><strong>Server Status:</strong> OK</p>
                <p><strong>Time:</strong> {current_time}</p>
                <p><strong>Hostname:</strong> {hostname}</p>
            </body>
        </html>
        """
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()
        self.wfile.write(response.encode())
server = HTTPServer(("0.0.0.0", 3001), StatusHandler)
server.serve_forever()