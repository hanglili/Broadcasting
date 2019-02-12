# Instructions

## How to run my solutions:
#### To run locally on version n with p number of peers, use the following commands:
```
make run VERSION=n PEERS=p
```

####  To run on docker on version n with p number of peers, use the following commands:
```
make drun dockerrun VERSION=n PEERS=p
```

#### Note that after running this command, use commands:
```
make kill
```
#### or
```
make down
```
#### to stop and remove the containers.

#### The project has the following structure:
```bash
├── README.md
├── lib
│   ├── broadcasting.ex
│   ├── dac.ex
│   ├── broadcast1
│   ├── broadcast2
│   ├── broadcast3
│   ├── broadcast4
│   ├── broadcast5
|   └── broadcast6   
└── test
```
