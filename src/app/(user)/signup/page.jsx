"use client";
import { useState } from "react";
import { useRouter } from "next/navigation";

export default function SignupPage() {
  const [formData, setFormData] = useState({
    email: "",
    password: "",
    first_name: "",
    last_name: "",
    roles: ['9'],
    organizations: [],
  });

  const router = useRouter();

  const handleChange = (e) => {
    setFormData((prev) => ({
      ...prev,
      [e.target.name]: e.target.value,
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      // Envoie une requête POST à ton API /api/users
      const response = await fetch("/api/users", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(formData),
      });

      if (response.ok) {
        // Succès : tu peux rediriger l’utilisateur, afficher un message, etc.
        router.push("/login");
      } else {
        // Erreur de création : tu peux gérer l’erreur ici
        const data = await response.json();
        console.error(data.error || "Erreur inattendue");
      }
    } catch (error) {
      console.error("Erreur lors de la requête:", error);
    }
  };

  return (
      <div>
        <h1>Inscription</h1>
        <form onSubmit={handleSubmit}>
          <div>
            <label>Email&nbsp;</label>
            <input className='border-blue-100 border-2'
                type="email"
                name="email"
                required
                value={formData.email}
                onChange={handleChange}
            />
          </div>
          <div>
            <label>Mot de passe&nbsp;</label>
            <input className='border-blue-100 border-2'
                type="password"
                name="password"
                required
                value={formData.password}
                onChange={handleChange}
            />
          </div>
          <div>
            <label>Prénom&nbsp;</label>
            <input className='border-blue-100 border-2'
                type="text"
                name="first_name"
                required
                value={formData.first_name}
                onChange={handleChange}
            />
          </div>
          <div>
            <label>Nom&nbsp;</label>
            <input className='border-blue-100 border-2'
                type="text"
                name="last_name"
                required
                value={formData.last_name}
                onChange={handleChange}
            />
          </div>

          <button type="submit">S’inscrire</button>
        </form>
      </div>
  );
}