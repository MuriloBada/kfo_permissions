# KFO_PERMISSIONS - Registering and checking roles RedEM:RP 2023

## 1. Installation
- 1° step - Clone this repository into your resources folder
- 2° step - Add ```ensure kfo_permissions``` in server.cfg
- 3° step - run the sql into your database, check the file ```kfo_permissions.sql```

## 2. Usage

- You can only verify people roles in server side, for this you must use this export ```exports.kfo_permissions.checkPlayerJob(playersource, roleName, identifier, charid)```

- ```checkPlayerJob``` params table:

| Param order 	|  Param Name  	| Expected Value                                   	| Param Value Type 	|
|:-----------:	|:------------:	|--------------------------------------------------	|:----------------:	|
|      1      	| playersource 	| usually Player.source on RedEM:RP 2023           	|   string/number  	|
|      2      	|   roleName   	| Name of the job you want to check must be quoted 	|      string      	|
|      3      	|  identifier  	| usually Player.identifier on RedEM:RP 2023       	|      string      	|
|      4      	|    charid    	| usually Player.charid on RedEM:RP 2023           	|      number      	|

## 3. Features
- This resource basically control players permissions by a fixed id (that is the PK of redemrp ```characters``` table)
- You can get players that are online by a jobName ```exports.kfo_permissions.getJobs()```
- Supports multi role (the character can be the same time ex: Admin, Police and Doctor etc. if you want)
- SQL based so it's aways up to date

## 4. Commands
- ```/id``` - Gets the player fixed ID **no params**

<hr>

- ```/addjob``` - Add new / update a player job **3 params needed**

| Order 	|      Param      	| Value Expected 	|                         Description                        	|
|:-----:	|:---------------:	|:--------------:	|---------------------------------------------------------- 	|
|   1   	|     Fixed ID    	|     number     	|           Fixed ID of the player returned by /id           	|
|   2   	| Permission Name 	|     string     	| Permission name that you want to be applyed to that player 	|
|   3   	| Permission Rank 	|     number     	|           Permission rank of the permission above          	|

<hr>

- ```/rmjob``` - Remove a permission from a player **2 params needed**

| Order 	|      Param      	| Value Expected 	|                         Description                        	|
|:-----:	|:---------------:	|:--------------:	|---------------------------------------------------------- 	|
|   1   	|     Fixed ID    	|     number     	|           Fixed ID of the player returned by /id           	|
|   2   	| Permission Name 	|     string     	| Permission name that you want to be applyed to that player 	|

<hr>