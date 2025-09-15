"use client";
import { useRef } from "react";
import { useRouter } from "next/navigation";

export default function LoginForm() {
  const router = useRouter();
  const userRef = useRef(null);
  const pwdRef = useRef(null);
  const errorRef = useRef(null);

  async function handleSubmit(e) {
    e.preventDefault();

    // limpiar error anterior
    if (errorRef.current) errorRef.current.textContent = "";

    const user = userRef.current.value.trim();
    const pwd = pwdRef.current.value.trim();

    // Validación simple en frontend
    if (!user || !pwd) {
      if (errorRef.current) errorRef.current.textContent = "Usuario y contraseña son obligatorios";
      return;
    }

    try {
      const res = await fetch("/api/login", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ user, pwd }),
      });

      const data = await res.json();

      if (res.ok && data.ok) {
        router.push("/table");
      } else {
        if (errorRef.current) {
          errorRef.current.textContent = data.error || "Usuario o contraseña incorrectos";
        }
      }
    } catch (err) {
      if (errorRef.current) {
        errorRef.current.textContent = "Error de red: " + err.message;
      }
    }
  }

  return (
    <div className="flex items-center justify-center p-6">
      <form
        onSubmit={handleSubmit}
        className="w-full max-w-sm space-y-4 border p-6 rounded-xl"
      >
        <h1 className="text-2xl font-semibold">Iniciar Sesión</h1>

        <div>
          <label className="block text-sm mb-1">Usuario</label>
          <input
            ref={userRef}
            type="text"
            className="w-full border rounded px-3 py-2"
            placeholder="Escribe tu usuario"
          />
        </div>

        <div>
          <label className="block text-sm mb-1">Contraseña</label>
          <input
            ref={pwdRef}
            type="password"
            className="w-full border rounded px-3 py-2"
            placeholder="Escribe tu contraseña"
          />
        </div>

        <p ref={errorRef} className="text-red-600 text-sm"></p>

        <button
          type="submit"
          className="w-full rounded bg-black text-white py-2 cursor-pointer hover:bg-white hover:text-black transition-colors ease-in-out"
        >
          Iniciar Sesión
        </button>
      </form>
    </div>
  );
}
