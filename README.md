# ldap2rest
ldap2rest is a small ruby Rack application intended to be a REST service providing 
access to users and groups stored in a LDAP backend.

## rest api description
For conveninence we named current version as number 1 to be prepared if a meaningfull 
change in future releases will not affect your installed applications using v1 service


This fact means that every request to services provided will need to be prefixed with

     /v1

Api will return results in JSON format

## Get users list

     /:version/users

Returns a list of users from LDAP. List might be truncated if LDAP server limits response size

### Parameters

This service only receives one parameter named *filter* which will be used to filter users by 
specified attributes in config file, using special character * (asterisk) as wildcard character

An example list of users whose name begins with chrod is issued by the following URL:

     http://SERVER_NAME/API_BASE/v1/users?filter=chrod*

See documentation section to configure filtering attributes for users

## Get single user

     /:version/users/:username

Return a single user maching specified username

## Get group membership of single user

     /:version/users/:username/groups

Returns a list of groups specified username is member of

## Get groups list

  /:version/groups

Returns a list of groups from LDAP. List might be truncated if LDAP server limits response size

### Parameters

This service only receives one parameter named *filter* which will be used to filter gorups by 
specified attributes in config file, using special character * (asterisk) as wildcard character

An example list of groups whose name begins with vpn is issued by the following URL:

     http://SERVER_NAME/API_BASE/v1/groups?filter=vpn*

See documentation section to configure filtering attributes for users

## Get list of group members

    /:version/groups/:name/members

Returns a list of users that are members of specified group

# Configuring ldap2rest

This simple RACK application is configured using an yml file. This file should be named *config/config.yml*.

## Sample configuration file config/config.yml
```yml
ldap:
  cache:
    ttl: 3600
  connection:
    host: localhost
    base: o=acme
    bind_dn: cn=admin,o=acme
    password: pass
  user:
    dn_attribute: uid
    prefix: ou=Users
    classes:
      - inetorgperson
    filter: (|(uid=%s)(sn=%s)(cn=%s)(givenName=%s))
    attributes:
      uid: username
      sn: last_name
      givenName: first_name
      cn: display_name
      departmentNumber: office
      employeeNumber: document_number
  group:
    dn_attribute: cn
    member_attribute: member
    user_membership_attribute: dn
    classes:
      - groupofnames
    attributes:
      cn: name
```

A sample configuration file is provided in config directory
directory. 

## Configuration file sections

### Cache

*  *ttl:* is a time in seconds to cache results in memory by server, without quering LDAP for same result just queried

### Connection

* *host:* LDAP host server
* *base:* LDAP base dn
* *bind_dn:* LDAP user to bind into LDAP as
* *password:* LDAP user password
* *allow_anonymous:* if specified anonymous access to LDAP will be used

### User

* *dn_attribute:* attribute used as dn: for example uid or cn
* *prefix:* prefix where users reside. If omited, ldap.base will be used
* *classess:* array of objectclass retrieved users must meet. Array elements must 
be listed in separate lines prefixed with minus sign
* *filter:* filter to be used when filtering user listing
* *attributes:* attribute mapping array. You must define a dictionary (hash) of 
attribute mappings from LDAP attribute name on the left, to a service name attribute
on the right. In the given example above, you can see that cn ldap attribute will
be retrieved as display_name by rest service

### Group

* *dn_attribute:* attribute used as dn: for example cn
* *prefix:* prefix where groups reside. If omited, ldap.base will be used
* *classess:* array of objectclass retrieved groups must meet. Array elements must 
be listed in separate lines prefixed with minus sign
* *member_attribute:* attribute used by ldap groups to specify members. For example: member
* *user_membership_attribute:* attribute used by group membership to reference a user. 
For example: dn means users are specified as full dn
* *filter:* filter to be used when filtering group listing
* *attributes:* attribute mapping array. You must define a dictionary (hash) of 
attribute mappings from LDAP attribute name on the left, to a service name attribute
on the right. In the given example above, you can see that cn ldap attribute will
be retrieved as name by rest service

