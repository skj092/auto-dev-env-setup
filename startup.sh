# Build the image
docker build -t setup-test .

# Run the container
docker run -it setup-test
