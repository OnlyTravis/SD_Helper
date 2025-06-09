import { Router } from "express";
import jwt from "jsonwebtoken";

const authRouter = Router();

authRouter.all("/api/{*any}", (req, res, next) => {
    let token = "";
    if (req.query && req.query.token) token = req.query.token.toString();
    if (req.body && req.body.token) token = req.body.token.toString();
    if (!token) {
        res.status(401).json({
            message: "Unauthorized",
        });
        return;
    }
    

    const secret = process.env.SECRET ?? "";
    if (!jwt.verify(token, secret)) {
        res.status(401).json({
            message: "Unauthorized",
        });
        return;
    }

    next();
});

export default authRouter;