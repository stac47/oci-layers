FROM fedora
COPY info.txt /
LABEL version="1.0.0"
CMD ["echo", "Hello, World!"]
