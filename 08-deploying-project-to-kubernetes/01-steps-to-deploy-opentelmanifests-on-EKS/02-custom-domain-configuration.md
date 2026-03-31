# Custom-Domain-Configuration

  - Previously, the application was accessed using Kubernetes Ingress with a dummy domain (naveen-opentel-demo.com).
  - To use a custom domain, first, purchase a domain from providers like GoDaddy or Hostinger.
  - After purchasing, connect the domain to the AWS load balancer created by the Ingress controller.
  - Use AWS Route 53 for DNS management.
  - Create a public hosted zone in Route 53 for the purchased domain.
  - Create a DNS record (e.g., www) and configure it as an alias to the load balancer.
  - Copy the Route 53 name server (NS) records.
  - Update these name servers in the domain provider (GoDaddy) so Route 53 manages DNS.

# Configuration update in ingress.yaml

  - Update the Ingress resource by replacing `naveen-opentel-demo.com` with the custom domain.
  - Apply the changes using `kubectl apply -f ingress.yaml`.
  - The Ingress controller updates the load balancer rules with the new domain.
  - DNS propagation takes time (few minutes to up to 48 hours).
  - Verify DNS propagation using DNS checker, nslookup, or curl --resolve.
  - Once propagation is complete, accessing the custom domain opens the frontend proxy through the Ingress.

## Useful DNS websites
  - whatmydns.net
  - w3schools.com
