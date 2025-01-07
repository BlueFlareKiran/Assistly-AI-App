import React from 'react'
import Link from "next/link";
import Avatar from "@/components/Avatar";
import {SignedIn, SignedOut, SignInButton, UserButton} from "@clerk/nextjs";

export default function Header() {
    return (
        <header className={'bg-white shadow-sm text-gray-800 flex justify-between p-5'}>
            <Link href={'/'} className={'flex items-center text-4xl font-thin'}>
                <Avatar seed={'kiran Support Agent'}/>
                <div className={'space-y-1'}>
                    <h1>Assistly</h1>
                    <h2 className={'text-sm'}>Your Customisable AI Chat Agent</h2>
                </div>
            </Link>
            <div className={'flex items-center'}>
                <SignedIn>
                    <UserButton showName={true}/>
                </SignedIn>
                <SignedOut>
                    <SignInButton/>
                </SignedOut>
            </div>
        </header>
    )
}
