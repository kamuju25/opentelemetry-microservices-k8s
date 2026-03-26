Local setup means installing the OpenTelemetry application either on your personal machine or on the EC2 instance that has been configured.

To install this project, Docker Compose is required, which was previously installed on the EC2 instance.  
You can confirm its installation by running the command: 

```bash
docker compose -h
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

<img width="1902" height="553" alt="image" src="https://github.com/user-attachments/assets/4ee974b2-b6ff-4546-aa42-6eaf8f9ef806" />


As mentioned in the OpenTelemetry Docker Deployment documentation [open telemetry](https://opentelemetry.io/docs/demo/docker-deployment/), to access the application in a browser, port 8080 needs to be opened. Therefore, you must open port 8080 for the EC2 instance by updating its security group settings, as all ports are blocked by default for an EC2 instance.

<img width="1899" height="961" alt="image" src="https://github.com/user-attachments/assets/8a242979-7f94-4cd5-9783-9e88d4b90bb6" />

