# Use a base image that includes Flyway
FROM flyway/flyway

# Copy migration files into the image
COPY ./migration /flyway/sql

