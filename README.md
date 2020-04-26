My own slightly modified version of the instructions on setting up a
containerized Huginn instance with Lets encrypt that can be found here
https://docs.bytemark.co.uk/article/how-to-deploy-huginn-on-your-own-server-using-docker/

Check out the project and run the setup.sh script.

There is no admin user created, but instead a invitation code has been 
created in the .env file that can be used for new signups.

Inside the .env file, all domains that will point to the server can be
set with the HUGIN_DOMAINS value, seperated with a ",".

Traefik will automatically configure a Lets Encrypt certificate for all the set 
domains.
Comment out HSTS line in docker-compose when forcing TLS.

A password will be generated for the Traefik and phpmyadmin dashboards and piped
out to a file called auth-password.txt. Copy the contents and delete the file!