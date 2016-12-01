const createNuBank = require('nubank').default;
const NuBank = createNuBank();

NuBank.getLoginToken({
	password: process.argv[3],
	login: process.argv[2]
}).then(response => {
	NuBank.getWholeFeed().then(history => {
		console.log(JSON.stringify(history));
	})
});
