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