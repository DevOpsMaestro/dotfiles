# GPG Cheatsheet

Reference guide for GPG key management, Git commit signing, and chezmoi encrypted file support.

---

## Key Concepts

| Term | Description |
|---|---|
| **Primary key** | The root key pair. The public half identifies you; the private half must be kept secure. |
| **Signing subkey** | Used to sign Git commits and tags. Algorithm: Ed25519. |
| **Encryption subkey** | Used to encrypt files (including chezmoi secrets). Algorithm: Cv25519. |
| **Fingerprint** | A 40-character hex string that uniquely identifies a key. Always use the fingerprint instead of the short key ID to avoid collisions. |
| **pinentry-mac** | A macOS-native passphrase dialog. Stores the passphrase in the macOS Keychain so re-entry is infrequent. |

---

## Initial Setup — New Machine With No Existing Key

Follow these steps in order when setting up a machine from scratch.

### 1. Configure the GPG agent

Create `~/.gnupg/gpg-agent.conf` with the following content:

```
pinentry-program /opt/homebrew/bin/pinentry-mac
default-cache-ttl 28800
max-cache-ttl 86400
```

- `default-cache-ttl 28800` — passphrase is cached for 8 hours before re-prompting.
- `max-cache-ttl 86400` — the hard ceiling is 24 hours regardless of activity.

Apply the configuration without rebooting:

```shell
gpgconf --kill gpg-agent
gpgconf --launch gpg-agent
```

### 2. Generate the primary signing key

```shell
gpg --quick-generate-key "Full Name <email@example.com>" ed25519 sign 2y
```

A macOS Keychain dialog will appear asking for a passphrase. Enter and confirm a strong passphrase. The key expires in two years; the expiry date can be extended before it lapses.

### 3. Add an encryption subkey

Copy the fingerprint from the output of step 2, then run:

```shell
gpg --quick-add-key <FINGERPRINT> cv25519 encr 2y
```

### 4. Verify both keys are present

```shell
gpg --list-secret-keys --keyid-format long "email@example.com"
```

Expected output structure:

```
sec   ed25519/XXXXXXXXXXXXXXXX 2026-06-13 [SC] [expires: 2028-06-12]
      <40-character fingerprint>
uid                 [ultimate] Full Name <email@example.com>
ssb   cv25519/XXXXXXXXXXXXXXXX 2026-06-13 [E] [expires: 2028-06-12]
```

`[SC]` = sign and certify. `[E]` = encrypt.

### 5. Upload the public key to GitHub

```shell
gpg --armor --export <FINGERPRINT> | pbcopy
```

Paste the copied key at: **GitHub → Settings → SSH and GPG keys → New GPG key**

### 6. Configure Git to sign commits

```shell
git config --global user.signingkey <FINGERPRINT>
git config --global gpg.program /opt/homebrew/bin/gpg
git config --global commit.gpgsign true
git config --global tag.gpgsign true
```

### 7. Verify signing works

```shell
echo "test" | gpg --clearsign --default-key <FINGERPRINT>
```

The output should contain `-----BEGIN PGP SIGNED MESSAGE-----`. If pinentry-mac prompts for the passphrase, it is working correctly.

---

## Restoring a Missing GPG Key on a New Machine

This section covers the scenario where chezmoi has been initialized but the GPG key is absent from the local keyring. Without the private key, chezmoi cannot decrypt the SSH config or GPG config files stored in the repository.

### Step 1 — Determine which key is needed

```shell
cat ~/.config/chezmoi/chezmoi.toml | grep recipient
```

The fingerprint shown is the key that chezmoi expects to find in the local keyring.

### Step 2 — Export the private key from a machine that has it

On the machine where the key exists, export the full key pair:

```shell
gpg --armor --export-secret-keys <FINGERPRINT> > gpg-private-key.asc
```

Transfer this file to the new machine using a secure channel (encrypted USB drive, age-encrypted file transfer, or similar). Do not send it over email or unencrypted messaging.

### Step 3 — Import the private key on the new machine

```shell
gpg --import gpg-private-key.asc
```

Delete the export file after the import completes:

```shell
rm gpg-private-key.asc
```

### Step 4 — Set the key trust level

After import, GPG assigns the key an unknown trust level. Set it to ultimate (required for chezmoi decryption and signing to work without warnings):

```shell
gpg --edit-key <FINGERPRINT>
```

At the `gpg>` prompt, run:

```
trust
5
y
quit
```

### Step 5 — Verify the key is available

```shell
gpg --list-secret-keys --keyid-format long
```

The key should appear with `[ultimate]` trust.

### Step 6 — Re-run chezmoi apply

```shell
chezmoi apply
```

chezmoi will now be able to decrypt the SSH and GPG configuration files.

---

## Extending a Key Before It Expires

Do not generate a new key when the existing key approaches its expiry date. Extend the expiry instead to preserve the trust chain.

```shell
gpg --quick-set-expire <FINGERPRINT> 2y
gpg --quick-set-expire <FINGERPRINT> 2y "*"
```

The second command extends all subkeys. After extending, upload the updated public key to GitHub again (step 5 above).

---

## Reference — Common Commands

### List all keys

```shell
gpg --list-secret-keys --keyid-format long
gpg --list-public-keys --keyid-format long
```

### Export the public key (for sharing or uploading)

```shell
gpg --armor --export <FINGERPRINT>
```

### Export the private key (for backup only)

```shell
gpg --armor --export-secret-keys <FINGERPRINT> > gpg-private-key.asc
```

### Delete a key from the local keyring

```shell
gpg --delete-secret-and-public-key <FINGERPRINT>
```

### Restart the GPG agent

```shell
gpgconf --kill gpg-agent
gpgconf --launch gpg-agent
```

### Test encryption and decryption

```shell
echo "test message" | gpg --encrypt --armor --recipient <FINGERPRINT> | gpg --decrypt
```

### Verify a signed Git commit

```shell
git log --show-signature -1
```

---

## Key Values for This Setup

| Setting | Value |
|---|---|
| Fingerprint | `412D990A41E880F4645E3E3E5AA9018FE9C21542` |
| Long key ID | `5AA9018FE9C21542` |
| Email | `unixmaestro@gmail.com` |
| Signing algorithm | Ed25519 |
| Encryption algorithm | Cv25519 |
| Expiry | 2028-06-12 |
| pinentry | `/opt/homebrew/bin/pinentry-mac` |
| GPG binary | `/opt/homebrew/bin/gpg` |
