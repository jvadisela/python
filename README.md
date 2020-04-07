
docker build -t flask-web:latest .
docker run -d -p 5000:5000 flask-web
