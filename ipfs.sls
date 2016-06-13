/var/local/ipfs/:
  file:
    - directory
    - user: root
    - group: root
    - mode: 0755

/opt/ipfs:
  archive:
    - extracted
    - archive_format: tar
    - source: {{ pillar['ipfs']['source'] }}
    - source_hash: {{ pillar['ipfs']['source_hash'] }}

/usr/local/bin/ipfs:
  file:
    - symlink
    - target: /opt/ipfs/go-ipfs/ipfs
    - user: root
    - group: root

/srv/ipfs:
  file:
    - directory
    - user: ipfs
    - group: ipfs
    - mode: 0755

  ipfs_repository:
    - initialized
    - user: ipfs
    - group: ipfs
    - require:
      - file: /srv/ipfs
      - file: /usr/local/bin/ipfs

ipfs:
  user:
    - present
    - shell: /bin/nologin
    - home: /srv/ipfs
    - groups:
      - ipfs

  group:
    - present
    - members:
      - ipfs
    - require:
      - user: ipfs
