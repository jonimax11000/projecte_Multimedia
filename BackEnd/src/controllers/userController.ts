import { Request, Response } from "express";
import {afegirUsuari, obtenirUsuaris, obtenirUsuariPerId} from "./../model/usuaris.js";



export const createUser = (req: Request, res: Response) => {
  const { nom, edat } = req.body;

  if (!nom || !edat) {
    return res.status(400).json({ error: "Nom i edat són obligatoris." });
  }
  let id: number = obtenirUsuaris().length;
  // Simula la creació de l'usuari
  const usuariCreat = { id, nom, edat };
  afegirUsuari(usuariCreat);

  res.status(201).json({ missatge: "Usuari creat correctament", usuari: usuariCreat });
};


export const getUsers=(req: Request, res:Response) =>{ res.json(obtenirUsuaris()); };

interface UserParams {
  id: string;
}

export const getUserById = (req: Request<UserParams>, res: Response) => {
  const id = parseInt(req.params.id);
  const usuari = obtenirUsuariPerId(id);

  if (!usuari) {
    return res.status(404).json({ error: "Usuari no trobat" });
  }

  res.json(usuari);
};