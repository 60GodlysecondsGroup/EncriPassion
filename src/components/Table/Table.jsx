"use client";
import { useEffect, useState } from "react";

export default function Table() {
  const [users, setUsers] = useState([]);
  const [showDecrypted, setShowDecrypted] = useState({}); // track row visibility

  useEffect(() => {
    fetch("/api/users")
      .then((res) => res.json())
      .then((data) => setUsers(data))
      .catch((err) => console.error("Error fetching users:", err));
  }, []);

  const toggleShow = (idx) => {
    setShowDecrypted((prev) => ({
      ...prev,
      [idx]: !prev[idx],
    }));
  };

  return (
    <div className="w-full min-h-screen bg-black text-white flex justify-center">
      <div className="w-full max-w-6xl px-6 overflow-x-auto">
        <table className="w-full border-collapse border border-white text-white text-center shadow-lg">
          <thead>
            <tr className="border-b border-white bg-gray-900">
              <th className="p-3 border-r border-white">Cédula</th>
              <th className="p-3 border-r border-white">Nombre</th>
              <th className="p-3 border-r border-white">Correo</th>
              <th className="p-3 border-r border-white">Celular</th>
              <th className="p-3">Acción</th>
            </tr>
          </thead>
          <tbody>
            {users.map((u, idx) => (
              <tr
                key={idx}
                className="border-b border-white hover:bg-gray-800 transition"
              >
                <td className="p-3 border-r border-white">{u.cedula}</td>
                <td className="p-3 border-r border-white">{u.nombre}</td>
                <td
                    className="p-3 border-r border-white max-w-[200px] truncate"
                    title={showDecrypted[idx] ? u.decrypted_email : u.email}
                    >
                    {showDecrypted[idx] ? u.decrypted_email : u.email}
                    </td>

                    <td
                    className="p-3 border-r border-white max-w-[200px] truncate"
                    title={showDecrypted[idx] ? u.decrypted_celular : u.celular}
                    >
                    {showDecrypted[idx] ? u.decrypted_celular : u.celular}
                </td>

                <td className="p-3">
                  <button
                    onClick={() => toggleShow(idx)}
                    className="px-3 py-1 border border-white rounded hover:bg-white hover:text-black transition"
                  >
                    {showDecrypted[idx] ? "Hide" : "Show"}
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
