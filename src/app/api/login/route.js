// src/app/api/login/route.js
import { NextResponse } from "next/server";
import { getPool } from "@/lib/db";

export async function POST(req) {
  try {
    const { user, pwd } = await req.json();
    if (!user || !pwd) {
      return NextResponse.json({ ok:false, error:"Faltan campos" }, { status:400 });
    }

    const pool = getPool();
    const { rows } = await pool.query("SELECT f_login2($1,$2) AS ok", [user, pwd]);
    return NextResponse.json({ ok: rows?.[0]?.ok === true });
  } catch (e) {
    console.error("LOGIN API ERROR:", e);
    return NextResponse.json({ ok:false, error: e.message }, { status:500 });
  }
}
