start-celestia:
	cd celestia && docker compose up -d && cd -

start-axlear:
	cd axlear && docker compose up -d && cd -

start-cronos:
	cd cronos && docker compose up -d && cd -

start-gaia:
	cd gaia && docker compose up -d && cd -

start-injective:
	cd injective && docker compose up -d && cd -