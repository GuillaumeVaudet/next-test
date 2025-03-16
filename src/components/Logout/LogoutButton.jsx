'use client';

import { signOut } from 'next-auth/react';

function LogoutButton(props) {
  return (
      <button className='p-2 bg-blue-500 rounded-lg mt-3'
              onClick={ () => signOut({ callbackUrl: '/'}) }>Déconnexion</button>
  );
}

export default LogoutButton;