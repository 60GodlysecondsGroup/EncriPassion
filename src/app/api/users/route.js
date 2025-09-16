import { NextResponse } from "next/server";
import { getPool } from "@/lib/db";

export async function GET() {
  try {
    const pool = getPool();

    // Encrypted
        const { rows: encrypted } = await pool.query(`
        SELECT cedula, nombre, email AS encrypted_email, celular AS encrypted_celular
        FROM f_show(1);
        `);

        // Decrypted
        const { rows: decrypted } = await pool.query(`
        SELECT cedula, nombre, email AS decrypted_email, celular AS decrypted_celular
        FROM f_show(2);
        `);


    // Merge safely
    const merged = encrypted.map((encRow, idx) => ({
    cedula: encRow.cedula,
    nombre: encRow.nombre,
    email: encRow.encrypted_email,
    celular: encRow.encrypted_celular,
    decrypted_email: decrypted[idx]?.decrypted_email,
    decrypted_celular: decrypted[idx]?.decrypted_celular,
    }));


    return NextResponse.json(merged);
  } catch (e) {
    console.error("USERS API ERROR:", e);
    return NextResponse.json({ error: e.message }, { status: 500 });
  }
}
