import React from 'react';
import Link from 'next/link';

export default function Header(props) {
  return (
      <nav className="navbar navbar-expand-lg navbar-dark bg-dark py-3">
        <Link href='/profile'>Profil</Link>
      </nav>
  );
}