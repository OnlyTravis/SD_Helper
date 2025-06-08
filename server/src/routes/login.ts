import { Router } from "express";
import jwt from "jsonwebtoken";

const loginRouter = Router();

loginRouter.post("/login", (req, res) => {
    // 1. Check if req is valid
    if (!req.body || !req.body.username || !req.body.password) {
        res.status(400).json({
            success: false,
            message: "Invalid request",
        });
        return;
    }

    // 2. Check Username & Password
    const username: string = req.body.username;
    const password: string = req.body.password;
    if (username !== process.env.USERNAME || password !== process.env.PASSWORD) {
        res.status(401).json({
            success: false,
            message: "Incorrect Username or Password!",
        });
        return;
    }

    // 3. Get token & response
    const secret = process.env.SECRET ?? "";
    const token = jwt.sign({
        username: username
    }, secret);

    res.status(200).json({
        success: true,
        token: token,
    });
});

export default loginRouter;