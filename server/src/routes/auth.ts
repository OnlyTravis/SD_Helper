import { Router } from "express";
import jwt from "jsonwebtoken";

const authRouter = Router();

authRouter.all("/api/{*any}", (req, res, next) => {
    if (!req.body || !req.body.token) {
        res.status(401).json({
            message: "Unauthorized",
        });
        return;
    }
    
    const secret = process.env.SECRET ?? "";
    if (!jwt.verify(req.body.token, secret)) {
        res.status(401).json({
            message: "Unauthorized",
        });
        return;
    }

    next();
});

export default authRouter;