Local setup means installing the OpenTelemetry application either on your personal machine or on the EC2 instance that has been configured.

To install this project, Docker Compose is required, which was previously installed on the EC2 instance.  
You can confirm its installation by running the command: 

```bash
docker compose -h.
```
## Why Docker Compose?

When working with multiple services, such as in this e-commerce project, we have a front end, back end, database, and several supporting services running across them. 
Managing such a complex setup locally can be challenging. Therefore, it is generally preferred to use Docker Compose to simplify the process of running and managing these services together.

## Steps to Run Locally

Clone the OpenTelemetry repository to your local machine:

```bash
git clone <repo-url>
```
Navigate to the cloned directory:

```bash
cd <cloned-repo>
```
Run the Docker Compose file:

```bash
docker compose up
```
# IMAGES.........................................
