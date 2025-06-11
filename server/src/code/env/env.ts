import fs from 'fs';
import dotenv from 'dotenv';
import readline from 'readline';
import { randomUUID } from 'crypto';
import { stdin, stdout } from 'process';

export async function initEnv() {
    if (!fs.existsSync(".env")) {
        console.log("Cannot Find .env, setting up environment...");
        const rl = readline.createInterface(stdin, stdout);

        const username = await queryString(rl, "Please enter a username: ", "Invalid Username.");
        const password = await queryString(rl, "Please enter a password: ", "Invalid password.");
        const port = await queryInt(
            rl, 
            "Please enter a Port number (e.g. 3000): ", 
            "Invalid Port Number.",
            (num: number) => (num > 0 && num < 65536)
        );
        const is_dev = await queryString(
            rl,
            "Are you the currently developing this repo? (y/n):",
            "Invalid Input",
            (ans: string) => (ans.toLowerCase() === "y" || ans.toLowerCase() === "n")
        );

        fs.writeFileSync(".env", `
            USERNAME_ = ${username}
            PASSWORD_ = ${password}
            PORT = ${port}
            SECRET = ${randomUUID()}
            IS_DEV = ${is_dev.toLowerCase() === "y"}
        `);
    }
    dotenv.config();
}
async function queryString(
    rl: readline.Interface, 
    question: string, 
    error_text: string,
    checkValid?: (ans: string) => boolean,
): Promise<string> {
    let answer = await rawQuery(rl, question);
    const needCheck = (checkValid !== null);
    while (answer.trim() === "" && (!needCheck || checkValid!(answer))) {
        console.log(error_text);
        answer = await rawQuery(rl, question);
    }
    return answer;
}
async function queryInt(
    rl: readline.Interface, 
    question: string, 
    error_text: string,
    checkValid?: (ans: number) => boolean,
): Promise<number> {
    let answer = await rawQuery(rl, question);
    const needCheck = (checkValid !== null);
    while (isNaN(parseInt(answer)) && (!needCheck || checkValid!(parseInt(answer)))) {
        console.log(error_text);
        answer = await rawQuery(rl, question);
    }
    return parseInt(answer);
}
async function rawQuery(rl: readline.Interface, question: string): Promise<string> {
    return new Promise((res, rej) => {
        rl.question(question, (answer) => {
            res(answer);
        });
    });
}