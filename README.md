## RUNNING

```bash
cd api
rackup --host 0.0.0.0 --port 5000
``

## UID

```
EUONEDUBAYFNVCOKAXRMKPLASJDRTRJO
```

## CURL

```
curl "http://localhost:5000/tables?database=octopus_development&uid=EUONEDUBAYFNVCOKAXRMKPLASJDRTRJO" | jq
curl "http://localhost:5000/tables/schema?database=octopus_development&uid=EUONEDUBAYFNVCOKAXRMKPLASJDRTRJO&table=users" | jq
curl -d '{"host":"172.28.5.254", "username": "postgres", "password":"postgres", "port": 5434}' -H "Content-Type: application/json" -X POST http://localhost:5000/connection
```
