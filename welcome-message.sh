#!/bin/bash -e

# Add preview banner to MOTD
cat >> /etc/motd << EOF
*******************************************************
**            This is custom OS for Orion            **
**      !! Orion OS for Service Fabric v 1.0.0 !!    **
**         You have just been Customized :-)         **
*******************************************************
EOF
