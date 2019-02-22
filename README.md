# QA Test API
API for QA candidates testing

## How it works

QA Test API is a simple API to create and consult Users with simple data. 

The objective is evaluate QAs in API testing, test cases and bug reports.

### POST#/users

```json
{
	"name": "QA Candidate", # name
	"cpf": "780.443.260-73", # CPF with dots (.) and dash (-) with verification digit
	"email": "candidate@wirecard.com", # email
	"birthday": "1990-01-01" # date in ISO 8601 format
}
```

Result:
HTTP Status 201 -> Created
HTTP Header Location -> ID of the created resource

*Important*: There is a proposital bug that return HTTP 501 eventually. To deactivate this _feature_, send the adicional parameter `no_bug` with any value.

### GET#/users

Returns the list of all users

### GET#/users/:id

Returns the user by this `id` given on Location header when created.

## What it is been evaluated

- If candidate knows how to automate tests
- If candidate knows about API (we assume this kind of candidate knows screen Automation as well)
- Test cases: Good paths, Bad baths, how it is described, etc...
- If candidate finds easy bugs
- If candidate finds hard bugs
- How candidate reports bugs

## Proposital Bugs

We inserted some bugs that we hope the candidate may find:

1. (Easy level) When an invalid CPF is taken, API returns HTTP Status 500
2. (Easy level) API accepts email with invalid format (not name@domain.com)
3. (Easy level) Name without maximium value
3. (Easy level) 2 Users can have same CPF
4. (Medium level) Email mas size is 31, not 30 as in error message
2. (Medium level) Birthday allows future dates
4. (Hard level) Intermittent bug: in 1 of 5 command of Post#/users returns HTTP API 500 for no reason