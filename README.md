#  Terraform AWS EC2 Web Server Project

This project uses **Terraform** to provision a complete AWS infrastructure that deploys an Ubuntu-based EC2 instance with an Apache web server. It's designed to demonstrate proficiency in Infrastructure as Code (IaC), cloud networking, and automation using Terraform on AWS.

---

##  What This Project Does

-  Creates a **custom VPC** with a public subnet
-  Attaches an **Internet Gateway** and sets up a **route table**
-  Deploys a **security group** that allows HTTP (port 80) and SSH (port 22) from anywhere
-  Launches an **EC2 instance** in the public subnet
-  Installs and starts the **Apache2 web server** using a `user_data` script
-  Returns a **public IP** where you can view the deployed web server

---

##  Project Structure
main.tf
README.md
##  What You See in the Browser

After running `terraform apply`, Terraform deploys an EC2 instance, installs Apache, and serves a basic web page.

If everything works, visiting the EC2's public IP in a browser displays:
my first server

## 🧰 Technologies Used

- **Terraform** – for infrastructure provisioning
- **AWS EC2** – virtual server in the cloud
- **AWS VPC/Subnet/IGW/Route Table** – custom network setup
- **Apache2** – web server installed on the instance
- **Ubuntu** – EC2 AMI used in the deployment

---

## 📌 How to Deploy

> Prerequisites:
> - Terraform installed
> - AWS CLI configured or access/secret keys set up

1. Clone this repository
2. Run `terraform init`
3. Run `terraform plan`
4. Run `terraform apply`
5. Grab the public IP from the output or AWS Console
6. Visit the IP in your browser

---

## ✅ Example Output (`user_data`)

```bash
#!/bin/bash
sudo apt update -y
sudo apt install apache2 -y
sudo systemctl start apache2
echo "your first server" > /var/www/html/index.html
