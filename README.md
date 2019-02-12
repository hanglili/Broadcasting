# Instructions

## How to run my solutions:
#### First cd into the code directory.
#### To run locally on version n with p number of peers, use the following command:
```
make run VERSION=n PEERS=p
```

####  To run on docker on version n with p number of peers, use the following command:
```
make drun VERSION=n PEERS=p
```

#### Note that after running the previous command, use the following command:
```
make kill
```
#### to stop and remove any containers.

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
