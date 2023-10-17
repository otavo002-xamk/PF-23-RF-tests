Robot Framework tests for Portfolio 2023. Run Robot Framework tests with full-sized window by setting the ${browser-opening} -variable to value full-width_opening (default). Run with small-sized window by setting it to small-width_opening. Before running the tests ensure the Portfolio 2023 project is up and running.

Before running the Database suite (excluding with_no_connection test case) ensure:
	1. the Portfolio-Server project is up and running and it has the database-connection set up.
	2. the MySQL database-server is up and running.
	3. the MySQL database has tables in it.
	4. the MySQL database has at least one table that has data in it and this table's name is written to the ${non-empty_table-name} variable in the Database suite.
	5. the MySQL database has at least one empty table and this table's name is written to the ${empty_table-name} variable in the Database suite.
	6. the Portfolio-2023-RPA-tests/jsonfiles-folder has alltables.json- and table-content.json -files in it.
	7. the alltables.json must have exactly the same table names that are in the database in json format, for example:
	
		[
		  {
		    "Table": "Table 1"
		  },
		  {
		    "Table": "Table 2"
		  },
		  {
		    "Table": "Table 3"
		  },
		  ...
		]
		
	8. the table-content.json must have the exactly the same table content that's in the ${non-empty_table-name} -table in a json format for example:
	
		[
		  {
		    "id": 1,
		    "name": "John Doe",
		    "address": Gatepark 77,
		    "email": "jd@bbbb.it"
		  },
		  {
		    "id": 2,
		    ...
		  },
		  ...
		]

Copyright 2023 Tapani Voutilainen

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
