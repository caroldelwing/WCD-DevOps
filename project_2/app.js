import express from "express";
import { MongoClient } from "mongodb";

const app = express();
app.use(express.json());

const { DB_HOST, DB_PORT, DB_NAME } = process.env;

(async function () {
  const { db } = await createConnection(DB_HOST, DB_PORT, DB_NAME);
  if (db) {
    //ensure that the players collection exists
    const players = db.collection("nhl_stats_2022");

    //error if there are no documents in the collection
    if ((await players.countDocuments({})) === 0) {
      console.log("No documents in players collection   ...exiting");
      process.exit(1);
    }

    //return all documents in the nhl_stats_2022 collection
    app.get("/", async (req, res) => {
      const cursor = await players.find({});
      const results = await cursor.toArray();
      res.json(results);
    });
    //return top players
    app.get("/players/top/:number", async (req, res) => {
      //convert the number to an integer
      const number = parseInt(req.params.number);
      const cursor = await players.find({}).sort({ Pts: -1 }).limit(number).project({ _id: 0, "Player Name": 1, Team: 1, Pts: 1 });
      const results = await cursor.toArray();
      res.json(results);
    });
    //returns all players with teamName
    app.get("/players/team/:teamName", async (req, res) => {
      const cursor = await players.find({ Team: req.params.teamName });
      const results = await cursor.project({ _id: 0, "Player Name": 1, Team: 1, Pts: 1 }).toArray();
      res.json(results);
    });
    //list all team names
    app.get("/teams", async (req, res) => {
      const cursor = await players.distinct("Team");
      res.json(cursor);
    });
    app.listen(3000, () => {
      console.log("Server started on port 3000");
    });
  } else {
    console.log("No database connection");
  }
})();

async function createConnection(host, port, dbName) {
  const url = `mongodb://${host}:${port}`; // Replace with your MongoDB connection string
  //const dbName = "my-database"; // Replace with your database name
  try {
    const client = await MongoClient.connect(url);
    const db = client.db(dbName);

    console.log("Connected to MongoDB successfully");
    return { db, client };
  } catch (error) {
    console.log("Failed to connect to MongoDB");
    console.log(error);
    return null;
  }
}  