start-celestia:
	cd celestia && docker compose up -d && cd -

start-axelar:
	cd axlear && docker compose up -d && cd -

start-cronos:
	cd cronos && docker compose up -d && cd -

start-gaia:
	cd gaia && docker compose up -d && cd -

start-injective:
	cd injective && docker compose up -d && cd -

calc-celestia:
	go run send_tx.go 2000 2