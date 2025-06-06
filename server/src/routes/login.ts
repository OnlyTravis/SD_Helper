import { Router } from "express"

const router = Router();

router.post("/login", (req, res) => {
    // 1. Check if req is valid
    if (!req.body || !req.body.username || !req.body.password) {
        res.status(400).send("Invalid request");
        return;
    }

    // 2. Check Username & Password
    const username: string = req.body.username;
    const password: string = req.body.password;
    if (username !== process.env.USERNAME || password !== process.env.PASSWORD) {
        res.status(401).send("Incorrect Username or Password!");
        return;
    }

    // 3. Set cookies & response
    req.session.logged_in = true;
    res.status(200).send();
});

export default router;