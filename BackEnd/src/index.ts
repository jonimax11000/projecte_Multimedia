import { buildServer } from "./app/http/server";
const app = buildServer();
const port = 3000;
app.listen(port, () => console.log(`Escoltant per localhost:${port}`));