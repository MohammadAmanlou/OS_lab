
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  close(fd);
}

int
main(int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	56                   	push   %esi
  12:	53                   	push   %ebx
  13:	51                   	push   %ecx
  14:	83 ec 0c             	sub    $0xc,%esp
  17:	8b 01                	mov    (%ecx),%eax
  19:	8b 51 04             	mov    0x4(%ecx),%edx
  int i;

  if(argc < 2){
  1c:	83 f8 01             	cmp    $0x1,%eax
  1f:	7e 28                	jle    49 <main+0x49>
  21:	8d 5a 04             	lea    0x4(%edx),%ebx
  24:	8d 34 82             	lea    (%edx,%eax,4),%esi
  27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  2e:	66 90                	xchg   %ax,%ax
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
  30:	83 ec 0c             	sub    $0xc,%esp
  33:	ff 33                	pushl  (%ebx)
  35:	83 c3 04             	add    $0x4,%ebx
  38:	e8 c3 00 00 00       	call   100 <ls>
  for(i=1; i<argc; i++)
  3d:	83 c4 10             	add    $0x10,%esp
  40:	39 f3                	cmp    %esi,%ebx
  42:	75 ec                	jne    30 <main+0x30>
  exit();
  44:	e8 5a 05 00 00       	call   5a3 <exit>
    ls(".");
  49:	83 ec 0c             	sub    $0xc,%esp
  4c:	68 00 0b 00 00       	push   $0xb00
  51:	e8 aa 00 00 00       	call   100 <ls>
    exit();
  56:	e8 48 05 00 00       	call   5a3 <exit>
  5b:	66 90                	xchg   %ax,%ax
  5d:	66 90                	xchg   %ax,%ax
  5f:	90                   	nop

00000060 <fmtname>:
{
  60:	f3 0f 1e fb          	endbr32 
  64:	55                   	push   %ebp
  65:	89 e5                	mov    %esp,%ebp
  67:	56                   	push   %esi
  68:	53                   	push   %ebx
  69:	8b 75 08             	mov    0x8(%ebp),%esi
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
  6c:	83 ec 0c             	sub    $0xc,%esp
  6f:	56                   	push   %esi
  70:	e8 4b 03 00 00       	call   3c0 <strlen>
  75:	83 c4 10             	add    $0x10,%esp
  78:	01 f0                	add    %esi,%eax
  7a:	89 c3                	mov    %eax,%ebx
  7c:	73 0b                	jae    89 <fmtname+0x29>
  7e:	eb 0e                	jmp    8e <fmtname+0x2e>
  80:	8d 43 ff             	lea    -0x1(%ebx),%eax
  83:	39 c6                	cmp    %eax,%esi
  85:	77 0a                	ja     91 <fmtname+0x31>
  87:	89 c3                	mov    %eax,%ebx
  89:	80 3b 2f             	cmpb   $0x2f,(%ebx)
  8c:	75 f2                	jne    80 <fmtname+0x20>
  8e:	83 c3 01             	add    $0x1,%ebx
  if(strlen(p) >= DIRSIZ)
  91:	83 ec 0c             	sub    $0xc,%esp
  94:	53                   	push   %ebx
  95:	e8 26 03 00 00       	call   3c0 <strlen>
  9a:	83 c4 10             	add    $0x10,%esp
  9d:	83 f8 0d             	cmp    $0xd,%eax
  a0:	77 4a                	ja     ec <fmtname+0x8c>
  memmove(buf, p, strlen(p));
  a2:	83 ec 0c             	sub    $0xc,%esp
  a5:	53                   	push   %ebx
  a6:	e8 15 03 00 00       	call   3c0 <strlen>
  ab:	83 c4 0c             	add    $0xc,%esp
  ae:	50                   	push   %eax
  af:	53                   	push   %ebx
  b0:	68 34 0e 00 00       	push   $0xe34
  b5:	e8 b6 04 00 00       	call   570 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  ba:	89 1c 24             	mov    %ebx,(%esp)
  bd:	e8 fe 02 00 00       	call   3c0 <strlen>
  c2:	89 1c 24             	mov    %ebx,(%esp)
  return buf;
  c5:	bb 34 0e 00 00       	mov    $0xe34,%ebx
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  ca:	89 c6                	mov    %eax,%esi
  cc:	e8 ef 02 00 00       	call   3c0 <strlen>
  d1:	ba 0e 00 00 00       	mov    $0xe,%edx
  d6:	83 c4 0c             	add    $0xc,%esp
  d9:	29 f2                	sub    %esi,%edx
  db:	05 34 0e 00 00       	add    $0xe34,%eax
  e0:	52                   	push   %edx
  e1:	6a 20                	push   $0x20
  e3:	50                   	push   %eax
  e4:	e8 17 03 00 00       	call   400 <memset>
  return buf;
  e9:	83 c4 10             	add    $0x10,%esp
}
  ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  ef:	89 d8                	mov    %ebx,%eax
  f1:	5b                   	pop    %ebx
  f2:	5e                   	pop    %esi
  f3:	5d                   	pop    %ebp
  f4:	c3                   	ret    
  f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000100 <ls>:
{
 100:	f3 0f 1e fb          	endbr32 
 104:	55                   	push   %ebp
 105:	89 e5                	mov    %esp,%ebp
 107:	57                   	push   %edi
 108:	56                   	push   %esi
 109:	53                   	push   %ebx
 10a:	81 ec 64 02 00 00    	sub    $0x264,%esp
 110:	8b 7d 08             	mov    0x8(%ebp),%edi
  if((fd = open(path, 0)) < 0){
 113:	6a 00                	push   $0x0
 115:	57                   	push   %edi
 116:	e8 c8 04 00 00       	call   5e3 <open>
 11b:	83 c4 10             	add    $0x10,%esp
 11e:	85 c0                	test   %eax,%eax
 120:	0f 88 9a 01 00 00    	js     2c0 <ls+0x1c0>
  if(fstat(fd, &st) < 0){
 126:	83 ec 08             	sub    $0x8,%esp
 129:	8d b5 d4 fd ff ff    	lea    -0x22c(%ebp),%esi
 12f:	89 c3                	mov    %eax,%ebx
 131:	56                   	push   %esi
 132:	50                   	push   %eax
 133:	e8 c3 04 00 00       	call   5fb <fstat>
 138:	83 c4 10             	add    $0x10,%esp
 13b:	85 c0                	test   %eax,%eax
 13d:	0f 88 bd 01 00 00    	js     300 <ls+0x200>
  switch(st.type){
 143:	0f b7 85 d4 fd ff ff 	movzwl -0x22c(%ebp),%eax
 14a:	66 83 f8 01          	cmp    $0x1,%ax
 14e:	74 60                	je     1b0 <ls+0xb0>
 150:	66 83 f8 02          	cmp    $0x2,%ax
 154:	74 1a                	je     170 <ls+0x70>
  close(fd);
 156:	83 ec 0c             	sub    $0xc,%esp
 159:	53                   	push   %ebx
 15a:	e8 6c 04 00 00       	call   5cb <close>
 15f:	83 c4 10             	add    $0x10,%esp
}
 162:	8d 65 f4             	lea    -0xc(%ebp),%esp
 165:	5b                   	pop    %ebx
 166:	5e                   	pop    %esi
 167:	5f                   	pop    %edi
 168:	5d                   	pop    %ebp
 169:	c3                   	ret    
 16a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 170:	83 ec 0c             	sub    $0xc,%esp
 173:	8b 95 e4 fd ff ff    	mov    -0x21c(%ebp),%edx
 179:	8b b5 dc fd ff ff    	mov    -0x224(%ebp),%esi
 17f:	57                   	push   %edi
 180:	89 95 b4 fd ff ff    	mov    %edx,-0x24c(%ebp)
 186:	e8 d5 fe ff ff       	call   60 <fmtname>
 18b:	8b 95 b4 fd ff ff    	mov    -0x24c(%ebp),%edx
 191:	59                   	pop    %ecx
 192:	5f                   	pop    %edi
 193:	52                   	push   %edx
 194:	56                   	push   %esi
 195:	6a 02                	push   $0x2
 197:	50                   	push   %eax
 198:	68 e0 0a 00 00       	push   $0xae0
 19d:	6a 01                	push   $0x1
 19f:	e8 ac 05 00 00       	call   750 <printf>
    break;
 1a4:	83 c4 20             	add    $0x20,%esp
 1a7:	eb ad                	jmp    156 <ls+0x56>
 1a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 1b0:	83 ec 0c             	sub    $0xc,%esp
 1b3:	57                   	push   %edi
 1b4:	e8 07 02 00 00       	call   3c0 <strlen>
 1b9:	83 c4 10             	add    $0x10,%esp
 1bc:	83 c0 10             	add    $0x10,%eax
 1bf:	3d 00 02 00 00       	cmp    $0x200,%eax
 1c4:	0f 87 16 01 00 00    	ja     2e0 <ls+0x1e0>
    strcpy(buf, path);
 1ca:	83 ec 08             	sub    $0x8,%esp
 1cd:	57                   	push   %edi
 1ce:	8d bd e8 fd ff ff    	lea    -0x218(%ebp),%edi
 1d4:	57                   	push   %edi
 1d5:	e8 66 01 00 00       	call   340 <strcpy>
    p = buf+strlen(buf);
 1da:	89 3c 24             	mov    %edi,(%esp)
 1dd:	e8 de 01 00 00       	call   3c0 <strlen>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1e2:	83 c4 10             	add    $0x10,%esp
    p = buf+strlen(buf);
 1e5:	01 f8                	add    %edi,%eax
    *p++ = '/';
 1e7:	8d 48 01             	lea    0x1(%eax),%ecx
    p = buf+strlen(buf);
 1ea:	89 85 a8 fd ff ff    	mov    %eax,-0x258(%ebp)
    *p++ = '/';
 1f0:	89 8d a4 fd ff ff    	mov    %ecx,-0x25c(%ebp)
 1f6:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 200:	83 ec 04             	sub    $0x4,%esp
 203:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 209:	6a 10                	push   $0x10
 20b:	50                   	push   %eax
 20c:	53                   	push   %ebx
 20d:	e8 a9 03 00 00       	call   5bb <read>
 212:	83 c4 10             	add    $0x10,%esp
 215:	83 f8 10             	cmp    $0x10,%eax
 218:	0f 85 38 ff ff ff    	jne    156 <ls+0x56>
      if(de.inum == 0)
 21e:	66 83 bd c4 fd ff ff 	cmpw   $0x0,-0x23c(%ebp)
 225:	00 
 226:	74 d8                	je     200 <ls+0x100>
      memmove(p, de.name, DIRSIZ);
 228:	83 ec 04             	sub    $0x4,%esp
 22b:	8d 85 c6 fd ff ff    	lea    -0x23a(%ebp),%eax
 231:	6a 0e                	push   $0xe
 233:	50                   	push   %eax
 234:	ff b5 a4 fd ff ff    	pushl  -0x25c(%ebp)
 23a:	e8 31 03 00 00       	call   570 <memmove>
      p[DIRSIZ] = 0;
 23f:	8b 85 a8 fd ff ff    	mov    -0x258(%ebp),%eax
 245:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
      if(stat(buf, &st) < 0){
 249:	58                   	pop    %eax
 24a:	5a                   	pop    %edx
 24b:	56                   	push   %esi
 24c:	57                   	push   %edi
 24d:	e8 8e 02 00 00       	call   4e0 <stat>
 252:	83 c4 10             	add    $0x10,%esp
 255:	85 c0                	test   %eax,%eax
 257:	0f 88 cb 00 00 00    	js     328 <ls+0x228>
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 25d:	83 ec 0c             	sub    $0xc,%esp
 260:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
 266:	8b 95 dc fd ff ff    	mov    -0x224(%ebp),%edx
 26c:	57                   	push   %edi
 26d:	0f bf 85 d4 fd ff ff 	movswl -0x22c(%ebp),%eax
 274:	89 8d ac fd ff ff    	mov    %ecx,-0x254(%ebp)
 27a:	89 95 b0 fd ff ff    	mov    %edx,-0x250(%ebp)
 280:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
 286:	e8 d5 fd ff ff       	call   60 <fmtname>
 28b:	5a                   	pop    %edx
 28c:	8b 95 b0 fd ff ff    	mov    -0x250(%ebp),%edx
 292:	59                   	pop    %ecx
 293:	8b 8d ac fd ff ff    	mov    -0x254(%ebp),%ecx
 299:	51                   	push   %ecx
 29a:	52                   	push   %edx
 29b:	ff b5 b4 fd ff ff    	pushl  -0x24c(%ebp)
 2a1:	50                   	push   %eax
 2a2:	68 e0 0a 00 00       	push   $0xae0
 2a7:	6a 01                	push   $0x1
 2a9:	e8 a2 04 00 00       	call   750 <printf>
 2ae:	83 c4 20             	add    $0x20,%esp
 2b1:	e9 4a ff ff ff       	jmp    200 <ls+0x100>
 2b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2bd:	8d 76 00             	lea    0x0(%esi),%esi
    printf(2, "ls: cannot open %s\n", path);
 2c0:	83 ec 04             	sub    $0x4,%esp
 2c3:	57                   	push   %edi
 2c4:	68 b8 0a 00 00       	push   $0xab8
 2c9:	6a 02                	push   $0x2
 2cb:	e8 80 04 00 00       	call   750 <printf>
    return;
 2d0:	83 c4 10             	add    $0x10,%esp
}
 2d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2d6:	5b                   	pop    %ebx
 2d7:	5e                   	pop    %esi
 2d8:	5f                   	pop    %edi
 2d9:	5d                   	pop    %ebp
 2da:	c3                   	ret    
 2db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2df:	90                   	nop
      printf(1, "ls: path too long\n");
 2e0:	83 ec 08             	sub    $0x8,%esp
 2e3:	68 ed 0a 00 00       	push   $0xaed
 2e8:	6a 01                	push   $0x1
 2ea:	e8 61 04 00 00       	call   750 <printf>
      break;
 2ef:	83 c4 10             	add    $0x10,%esp
 2f2:	e9 5f fe ff ff       	jmp    156 <ls+0x56>
 2f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2fe:	66 90                	xchg   %ax,%ax
    printf(2, "ls: cannot stat %s\n", path);
 300:	83 ec 04             	sub    $0x4,%esp
 303:	57                   	push   %edi
 304:	68 cc 0a 00 00       	push   $0xacc
 309:	6a 02                	push   $0x2
 30b:	e8 40 04 00 00       	call   750 <printf>
    close(fd);
 310:	89 1c 24             	mov    %ebx,(%esp)
 313:	e8 b3 02 00 00       	call   5cb <close>
    return;
 318:	83 c4 10             	add    $0x10,%esp
}
 31b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 31e:	5b                   	pop    %ebx
 31f:	5e                   	pop    %esi
 320:	5f                   	pop    %edi
 321:	5d                   	pop    %ebp
 322:	c3                   	ret    
 323:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 327:	90                   	nop
        printf(1, "ls: cannot stat %s\n", buf);
 328:	83 ec 04             	sub    $0x4,%esp
 32b:	57                   	push   %edi
 32c:	68 cc 0a 00 00       	push   $0xacc
 331:	6a 01                	push   $0x1
 333:	e8 18 04 00 00       	call   750 <printf>
        continue;
 338:	83 c4 10             	add    $0x10,%esp
 33b:	e9 c0 fe ff ff       	jmp    200 <ls+0x100>

00000340 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 340:	f3 0f 1e fb          	endbr32 
 344:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 345:	31 c0                	xor    %eax,%eax
{
 347:	89 e5                	mov    %esp,%ebp
 349:	53                   	push   %ebx
 34a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 34d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 350:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 354:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 357:	83 c0 01             	add    $0x1,%eax
 35a:	84 d2                	test   %dl,%dl
 35c:	75 f2                	jne    350 <strcpy+0x10>
    ;
  return os;
}
 35e:	89 c8                	mov    %ecx,%eax
 360:	5b                   	pop    %ebx
 361:	5d                   	pop    %ebp
 362:	c3                   	ret    
 363:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 36a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000370 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 370:	f3 0f 1e fb          	endbr32 
 374:	55                   	push   %ebp
 375:	89 e5                	mov    %esp,%ebp
 377:	53                   	push   %ebx
 378:	8b 4d 08             	mov    0x8(%ebp),%ecx
 37b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 37e:	0f b6 01             	movzbl (%ecx),%eax
 381:	0f b6 1a             	movzbl (%edx),%ebx
 384:	84 c0                	test   %al,%al
 386:	75 19                	jne    3a1 <strcmp+0x31>
 388:	eb 26                	jmp    3b0 <strcmp+0x40>
 38a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 390:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 394:	83 c1 01             	add    $0x1,%ecx
 397:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 39a:	0f b6 1a             	movzbl (%edx),%ebx
 39d:	84 c0                	test   %al,%al
 39f:	74 0f                	je     3b0 <strcmp+0x40>
 3a1:	38 d8                	cmp    %bl,%al
 3a3:	74 eb                	je     390 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 3a5:	29 d8                	sub    %ebx,%eax
}
 3a7:	5b                   	pop    %ebx
 3a8:	5d                   	pop    %ebp
 3a9:	c3                   	ret    
 3aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3b0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 3b2:	29 d8                	sub    %ebx,%eax
}
 3b4:	5b                   	pop    %ebx
 3b5:	5d                   	pop    %ebp
 3b6:	c3                   	ret    
 3b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3be:	66 90                	xchg   %ax,%ax

000003c0 <strlen>:

uint
strlen(const char *s)
{
 3c0:	f3 0f 1e fb          	endbr32 
 3c4:	55                   	push   %ebp
 3c5:	89 e5                	mov    %esp,%ebp
 3c7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 3ca:	80 3a 00             	cmpb   $0x0,(%edx)
 3cd:	74 21                	je     3f0 <strlen+0x30>
 3cf:	31 c0                	xor    %eax,%eax
 3d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3d8:	83 c0 01             	add    $0x1,%eax
 3db:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 3df:	89 c1                	mov    %eax,%ecx
 3e1:	75 f5                	jne    3d8 <strlen+0x18>
    ;
  return n;
}
 3e3:	89 c8                	mov    %ecx,%eax
 3e5:	5d                   	pop    %ebp
 3e6:	c3                   	ret    
 3e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ee:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 3f0:	31 c9                	xor    %ecx,%ecx
}
 3f2:	5d                   	pop    %ebp
 3f3:	89 c8                	mov    %ecx,%eax
 3f5:	c3                   	ret    
 3f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3fd:	8d 76 00             	lea    0x0(%esi),%esi

00000400 <memset>:

void*
memset(void *dst, int c, uint n)
{
 400:	f3 0f 1e fb          	endbr32 
 404:	55                   	push   %ebp
 405:	89 e5                	mov    %esp,%ebp
 407:	57                   	push   %edi
 408:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 40b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 40e:	8b 45 0c             	mov    0xc(%ebp),%eax
 411:	89 d7                	mov    %edx,%edi
 413:	fc                   	cld    
 414:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 416:	89 d0                	mov    %edx,%eax
 418:	5f                   	pop    %edi
 419:	5d                   	pop    %ebp
 41a:	c3                   	ret    
 41b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 41f:	90                   	nop

00000420 <strchr>:

char*
strchr(const char *s, char c)
{
 420:	f3 0f 1e fb          	endbr32 
 424:	55                   	push   %ebp
 425:	89 e5                	mov    %esp,%ebp
 427:	8b 45 08             	mov    0x8(%ebp),%eax
 42a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 42e:	0f b6 10             	movzbl (%eax),%edx
 431:	84 d2                	test   %dl,%dl
 433:	75 16                	jne    44b <strchr+0x2b>
 435:	eb 21                	jmp    458 <strchr+0x38>
 437:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 43e:	66 90                	xchg   %ax,%ax
 440:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 444:	83 c0 01             	add    $0x1,%eax
 447:	84 d2                	test   %dl,%dl
 449:	74 0d                	je     458 <strchr+0x38>
    if(*s == c)
 44b:	38 d1                	cmp    %dl,%cl
 44d:	75 f1                	jne    440 <strchr+0x20>
      return (char*)s;
  return 0;
}
 44f:	5d                   	pop    %ebp
 450:	c3                   	ret    
 451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 458:	31 c0                	xor    %eax,%eax
}
 45a:	5d                   	pop    %ebp
 45b:	c3                   	ret    
 45c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000460 <gets>:

char*
gets(char *buf, int max)
{
 460:	f3 0f 1e fb          	endbr32 
 464:	55                   	push   %ebp
 465:	89 e5                	mov    %esp,%ebp
 467:	57                   	push   %edi
 468:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 469:	31 f6                	xor    %esi,%esi
{
 46b:	53                   	push   %ebx
 46c:	89 f3                	mov    %esi,%ebx
 46e:	83 ec 1c             	sub    $0x1c,%esp
 471:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 474:	eb 33                	jmp    4a9 <gets+0x49>
 476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 47d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 480:	83 ec 04             	sub    $0x4,%esp
 483:	8d 45 e7             	lea    -0x19(%ebp),%eax
 486:	6a 01                	push   $0x1
 488:	50                   	push   %eax
 489:	6a 00                	push   $0x0
 48b:	e8 2b 01 00 00       	call   5bb <read>
    if(cc < 1)
 490:	83 c4 10             	add    $0x10,%esp
 493:	85 c0                	test   %eax,%eax
 495:	7e 1c                	jle    4b3 <gets+0x53>
      break;
    buf[i++] = c;
 497:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 49b:	83 c7 01             	add    $0x1,%edi
 49e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 4a1:	3c 0a                	cmp    $0xa,%al
 4a3:	74 23                	je     4c8 <gets+0x68>
 4a5:	3c 0d                	cmp    $0xd,%al
 4a7:	74 1f                	je     4c8 <gets+0x68>
  for(i=0; i+1 < max; ){
 4a9:	83 c3 01             	add    $0x1,%ebx
 4ac:	89 fe                	mov    %edi,%esi
 4ae:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 4b1:	7c cd                	jl     480 <gets+0x20>
 4b3:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 4b5:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 4b8:	c6 03 00             	movb   $0x0,(%ebx)
}
 4bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4be:	5b                   	pop    %ebx
 4bf:	5e                   	pop    %esi
 4c0:	5f                   	pop    %edi
 4c1:	5d                   	pop    %ebp
 4c2:	c3                   	ret    
 4c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4c7:	90                   	nop
 4c8:	8b 75 08             	mov    0x8(%ebp),%esi
 4cb:	8b 45 08             	mov    0x8(%ebp),%eax
 4ce:	01 de                	add    %ebx,%esi
 4d0:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 4d2:	c6 03 00             	movb   $0x0,(%ebx)
}
 4d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4d8:	5b                   	pop    %ebx
 4d9:	5e                   	pop    %esi
 4da:	5f                   	pop    %edi
 4db:	5d                   	pop    %ebp
 4dc:	c3                   	ret    
 4dd:	8d 76 00             	lea    0x0(%esi),%esi

000004e0 <stat>:

int
stat(const char *n, struct stat *st)
{
 4e0:	f3 0f 1e fb          	endbr32 
 4e4:	55                   	push   %ebp
 4e5:	89 e5                	mov    %esp,%ebp
 4e7:	56                   	push   %esi
 4e8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4e9:	83 ec 08             	sub    $0x8,%esp
 4ec:	6a 00                	push   $0x0
 4ee:	ff 75 08             	pushl  0x8(%ebp)
 4f1:	e8 ed 00 00 00       	call   5e3 <open>
  if(fd < 0)
 4f6:	83 c4 10             	add    $0x10,%esp
 4f9:	85 c0                	test   %eax,%eax
 4fb:	78 2b                	js     528 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 4fd:	83 ec 08             	sub    $0x8,%esp
 500:	ff 75 0c             	pushl  0xc(%ebp)
 503:	89 c3                	mov    %eax,%ebx
 505:	50                   	push   %eax
 506:	e8 f0 00 00 00       	call   5fb <fstat>
  close(fd);
 50b:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 50e:	89 c6                	mov    %eax,%esi
  close(fd);
 510:	e8 b6 00 00 00       	call   5cb <close>
  return r;
 515:	83 c4 10             	add    $0x10,%esp
}
 518:	8d 65 f8             	lea    -0x8(%ebp),%esp
 51b:	89 f0                	mov    %esi,%eax
 51d:	5b                   	pop    %ebx
 51e:	5e                   	pop    %esi
 51f:	5d                   	pop    %ebp
 520:	c3                   	ret    
 521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 528:	be ff ff ff ff       	mov    $0xffffffff,%esi
 52d:	eb e9                	jmp    518 <stat+0x38>
 52f:	90                   	nop

00000530 <atoi>:

int
atoi(const char *s)
{
 530:	f3 0f 1e fb          	endbr32 
 534:	55                   	push   %ebp
 535:	89 e5                	mov    %esp,%ebp
 537:	53                   	push   %ebx
 538:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 53b:	0f be 02             	movsbl (%edx),%eax
 53e:	8d 48 d0             	lea    -0x30(%eax),%ecx
 541:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 544:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 549:	77 1a                	ja     565 <atoi+0x35>
 54b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 54f:	90                   	nop
    n = n*10 + *s++ - '0';
 550:	83 c2 01             	add    $0x1,%edx
 553:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 556:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 55a:	0f be 02             	movsbl (%edx),%eax
 55d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 560:	80 fb 09             	cmp    $0x9,%bl
 563:	76 eb                	jbe    550 <atoi+0x20>
  return n;
}
 565:	89 c8                	mov    %ecx,%eax
 567:	5b                   	pop    %ebx
 568:	5d                   	pop    %ebp
 569:	c3                   	ret    
 56a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000570 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 570:	f3 0f 1e fb          	endbr32 
 574:	55                   	push   %ebp
 575:	89 e5                	mov    %esp,%ebp
 577:	57                   	push   %edi
 578:	8b 45 10             	mov    0x10(%ebp),%eax
 57b:	8b 55 08             	mov    0x8(%ebp),%edx
 57e:	56                   	push   %esi
 57f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 582:	85 c0                	test   %eax,%eax
 584:	7e 0f                	jle    595 <memmove+0x25>
 586:	01 d0                	add    %edx,%eax
  dst = vdst;
 588:	89 d7                	mov    %edx,%edi
 58a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 590:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 591:	39 f8                	cmp    %edi,%eax
 593:	75 fb                	jne    590 <memmove+0x20>
  return vdst;
}
 595:	5e                   	pop    %esi
 596:	89 d0                	mov    %edx,%eax
 598:	5f                   	pop    %edi
 599:	5d                   	pop    %ebp
 59a:	c3                   	ret    

0000059b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 59b:	b8 01 00 00 00       	mov    $0x1,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret    

000005a3 <exit>:
SYSCALL(exit)
 5a3:	b8 02 00 00 00       	mov    $0x2,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret    

000005ab <wait>:
SYSCALL(wait)
 5ab:	b8 03 00 00 00       	mov    $0x3,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret    

000005b3 <pipe>:
SYSCALL(pipe)
 5b3:	b8 04 00 00 00       	mov    $0x4,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret    

000005bb <read>:
SYSCALL(read)
 5bb:	b8 05 00 00 00       	mov    $0x5,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret    

000005c3 <write>:
SYSCALL(write)
 5c3:	b8 10 00 00 00       	mov    $0x10,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret    

000005cb <close>:
SYSCALL(close)
 5cb:	b8 15 00 00 00       	mov    $0x15,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret    

000005d3 <kill>:
SYSCALL(kill)
 5d3:	b8 06 00 00 00       	mov    $0x6,%eax
 5d8:	cd 40                	int    $0x40
 5da:	c3                   	ret    

000005db <exec>:
SYSCALL(exec)
 5db:	b8 07 00 00 00       	mov    $0x7,%eax
 5e0:	cd 40                	int    $0x40
 5e2:	c3                   	ret    

000005e3 <open>:
SYSCALL(open)
 5e3:	b8 0f 00 00 00       	mov    $0xf,%eax
 5e8:	cd 40                	int    $0x40
 5ea:	c3                   	ret    

000005eb <mknod>:
SYSCALL(mknod)
 5eb:	b8 11 00 00 00       	mov    $0x11,%eax
 5f0:	cd 40                	int    $0x40
 5f2:	c3                   	ret    

000005f3 <unlink>:
SYSCALL(unlink)
 5f3:	b8 12 00 00 00       	mov    $0x12,%eax
 5f8:	cd 40                	int    $0x40
 5fa:	c3                   	ret    

000005fb <fstat>:
SYSCALL(fstat)
 5fb:	b8 08 00 00 00       	mov    $0x8,%eax
 600:	cd 40                	int    $0x40
 602:	c3                   	ret    

00000603 <link>:
SYSCALL(link)
 603:	b8 13 00 00 00       	mov    $0x13,%eax
 608:	cd 40                	int    $0x40
 60a:	c3                   	ret    

0000060b <mkdir>:
SYSCALL(mkdir)
 60b:	b8 14 00 00 00       	mov    $0x14,%eax
 610:	cd 40                	int    $0x40
 612:	c3                   	ret    

00000613 <chdir>:
SYSCALL(chdir)
 613:	b8 09 00 00 00       	mov    $0x9,%eax
 618:	cd 40                	int    $0x40
 61a:	c3                   	ret    

0000061b <dup>:
SYSCALL(dup)
 61b:	b8 0a 00 00 00       	mov    $0xa,%eax
 620:	cd 40                	int    $0x40
 622:	c3                   	ret    

00000623 <getpid>:
SYSCALL(getpid)
 623:	b8 0b 00 00 00       	mov    $0xb,%eax
 628:	cd 40                	int    $0x40
 62a:	c3                   	ret    

0000062b <sbrk>:
SYSCALL(sbrk)
 62b:	b8 0c 00 00 00       	mov    $0xc,%eax
 630:	cd 40                	int    $0x40
 632:	c3                   	ret    

00000633 <sleep>:
SYSCALL(sleep)
 633:	b8 0d 00 00 00       	mov    $0xd,%eax
 638:	cd 40                	int    $0x40
 63a:	c3                   	ret    

0000063b <uptime>:
SYSCALL(uptime)
 63b:	b8 0e 00 00 00       	mov    $0xe,%eax
 640:	cd 40                	int    $0x40
 642:	c3                   	ret    

00000643 <find_digital_root>:
SYSCALL(find_digital_root)
 643:	b8 16 00 00 00       	mov    $0x16,%eax
 648:	cd 40                	int    $0x40
 64a:	c3                   	ret    

0000064b <get_process_lifetime>:
SYSCALL(get_process_lifetime)
 64b:	b8 17 00 00 00       	mov    $0x17,%eax
 650:	cd 40                	int    $0x40
 652:	c3                   	ret    

00000653 <copy_file>:
SYSCALL(copy_file)
 653:	b8 18 00 00 00       	mov    $0x18,%eax
 658:	cd 40                	int    $0x40
 65a:	c3                   	ret    

0000065b <get_uncle_count>:
SYSCALL(get_uncle_count)
 65b:	b8 19 00 00 00       	mov    $0x19,%eax
 660:	cd 40                	int    $0x40
 662:	c3                   	ret    

00000663 <change_sched_Q>:
SYSCALL(change_sched_Q)
 663:	b8 1b 00 00 00       	mov    $0x1b,%eax
 668:	cd 40                	int    $0x40
 66a:	c3                   	ret    

0000066b <show_process_info>:
SYSCALL(show_process_info)
 66b:	b8 1a 00 00 00       	mov    $0x1a,%eax
 670:	cd 40                	int    $0x40
 672:	c3                   	ret    

00000673 <set_proc_bjf_params>:
SYSCALL(set_proc_bjf_params)
 673:	b8 1d 00 00 00       	mov    $0x1d,%eax
 678:	cd 40                	int    $0x40
 67a:	c3                   	ret    

0000067b <set_system_bjf_params>:
SYSCALL(set_system_bjf_params)
 67b:	b8 1c 00 00 00       	mov    $0x1c,%eax
 680:	cd 40                	int    $0x40
 682:	c3                   	ret    

00000683 <priorityLock_test>:
SYSCALL(priorityLock_test)
 683:	b8 1e 00 00 00       	mov    $0x1e,%eax
 688:	cd 40                	int    $0x40
 68a:	c3                   	ret    

0000068b <syscalls_count>:
SYSCALL(syscalls_count)
 68b:	b8 1f 00 00 00       	mov    $0x1f,%eax
 690:	cd 40                	int    $0x40
 692:	c3                   	ret    
 693:	66 90                	xchg   %ax,%ax
 695:	66 90                	xchg   %ax,%ax
 697:	66 90                	xchg   %ax,%ax
 699:	66 90                	xchg   %ax,%ax
 69b:	66 90                	xchg   %ax,%ax
 69d:	66 90                	xchg   %ax,%ax
 69f:	90                   	nop

000006a0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 6a0:	55                   	push   %ebp
 6a1:	89 e5                	mov    %esp,%ebp
 6a3:	57                   	push   %edi
 6a4:	56                   	push   %esi
 6a5:	53                   	push   %ebx
 6a6:	83 ec 3c             	sub    $0x3c,%esp
 6a9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 6ac:	89 d1                	mov    %edx,%ecx
{
 6ae:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 6b1:	85 d2                	test   %edx,%edx
 6b3:	0f 89 7f 00 00 00    	jns    738 <printint+0x98>
 6b9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 6bd:	74 79                	je     738 <printint+0x98>
    neg = 1;
 6bf:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 6c6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 6c8:	31 db                	xor    %ebx,%ebx
 6ca:	8d 75 d7             	lea    -0x29(%ebp),%esi
 6cd:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 6d0:	89 c8                	mov    %ecx,%eax
 6d2:	31 d2                	xor    %edx,%edx
 6d4:	89 cf                	mov    %ecx,%edi
 6d6:	f7 75 c4             	divl   -0x3c(%ebp)
 6d9:	0f b6 92 0c 0b 00 00 	movzbl 0xb0c(%edx),%edx
 6e0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 6e3:	89 d8                	mov    %ebx,%eax
 6e5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 6e8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 6eb:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 6ee:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 6f1:	76 dd                	jbe    6d0 <printint+0x30>
  if(neg)
 6f3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 6f6:	85 c9                	test   %ecx,%ecx
 6f8:	74 0c                	je     706 <printint+0x66>
    buf[i++] = '-';
 6fa:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 6ff:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 701:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 706:	8b 7d b8             	mov    -0x48(%ebp),%edi
 709:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 70d:	eb 07                	jmp    716 <printint+0x76>
 70f:	90                   	nop
 710:	0f b6 13             	movzbl (%ebx),%edx
 713:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 716:	83 ec 04             	sub    $0x4,%esp
 719:	88 55 d7             	mov    %dl,-0x29(%ebp)
 71c:	6a 01                	push   $0x1
 71e:	56                   	push   %esi
 71f:	57                   	push   %edi
 720:	e8 9e fe ff ff       	call   5c3 <write>
  while(--i >= 0)
 725:	83 c4 10             	add    $0x10,%esp
 728:	39 de                	cmp    %ebx,%esi
 72a:	75 e4                	jne    710 <printint+0x70>
    putc(fd, buf[i]);
}
 72c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 72f:	5b                   	pop    %ebx
 730:	5e                   	pop    %esi
 731:	5f                   	pop    %edi
 732:	5d                   	pop    %ebp
 733:	c3                   	ret    
 734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 738:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 73f:	eb 87                	jmp    6c8 <printint+0x28>
 741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 748:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 74f:	90                   	nop

00000750 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 750:	f3 0f 1e fb          	endbr32 
 754:	55                   	push   %ebp
 755:	89 e5                	mov    %esp,%ebp
 757:	57                   	push   %edi
 758:	56                   	push   %esi
 759:	53                   	push   %ebx
 75a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 75d:	8b 75 0c             	mov    0xc(%ebp),%esi
 760:	0f b6 1e             	movzbl (%esi),%ebx
 763:	84 db                	test   %bl,%bl
 765:	0f 84 b4 00 00 00    	je     81f <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 76b:	8d 45 10             	lea    0x10(%ebp),%eax
 76e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 771:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 774:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 776:	89 45 d0             	mov    %eax,-0x30(%ebp)
 779:	eb 33                	jmp    7ae <printf+0x5e>
 77b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 77f:	90                   	nop
 780:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 783:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 788:	83 f8 25             	cmp    $0x25,%eax
 78b:	74 17                	je     7a4 <printf+0x54>
  write(fd, &c, 1);
 78d:	83 ec 04             	sub    $0x4,%esp
 790:	88 5d e7             	mov    %bl,-0x19(%ebp)
 793:	6a 01                	push   $0x1
 795:	57                   	push   %edi
 796:	ff 75 08             	pushl  0x8(%ebp)
 799:	e8 25 fe ff ff       	call   5c3 <write>
 79e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 7a1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 7a4:	0f b6 1e             	movzbl (%esi),%ebx
 7a7:	83 c6 01             	add    $0x1,%esi
 7aa:	84 db                	test   %bl,%bl
 7ac:	74 71                	je     81f <printf+0xcf>
    c = fmt[i] & 0xff;
 7ae:	0f be cb             	movsbl %bl,%ecx
 7b1:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 7b4:	85 d2                	test   %edx,%edx
 7b6:	74 c8                	je     780 <printf+0x30>
      }
    } else if(state == '%'){
 7b8:	83 fa 25             	cmp    $0x25,%edx
 7bb:	75 e7                	jne    7a4 <printf+0x54>
      if(c == 'd'){
 7bd:	83 f8 64             	cmp    $0x64,%eax
 7c0:	0f 84 9a 00 00 00    	je     860 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 7c6:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 7cc:	83 f9 70             	cmp    $0x70,%ecx
 7cf:	74 5f                	je     830 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 7d1:	83 f8 73             	cmp    $0x73,%eax
 7d4:	0f 84 d6 00 00 00    	je     8b0 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7da:	83 f8 63             	cmp    $0x63,%eax
 7dd:	0f 84 8d 00 00 00    	je     870 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 7e3:	83 f8 25             	cmp    $0x25,%eax
 7e6:	0f 84 b4 00 00 00    	je     8a0 <printf+0x150>
  write(fd, &c, 1);
 7ec:	83 ec 04             	sub    $0x4,%esp
 7ef:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 7f3:	6a 01                	push   $0x1
 7f5:	57                   	push   %edi
 7f6:	ff 75 08             	pushl  0x8(%ebp)
 7f9:	e8 c5 fd ff ff       	call   5c3 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 7fe:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 801:	83 c4 0c             	add    $0xc,%esp
 804:	6a 01                	push   $0x1
 806:	83 c6 01             	add    $0x1,%esi
 809:	57                   	push   %edi
 80a:	ff 75 08             	pushl  0x8(%ebp)
 80d:	e8 b1 fd ff ff       	call   5c3 <write>
  for(i = 0; fmt[i]; i++){
 812:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 816:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 819:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 81b:	84 db                	test   %bl,%bl
 81d:	75 8f                	jne    7ae <printf+0x5e>
    }
  }
}
 81f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 822:	5b                   	pop    %ebx
 823:	5e                   	pop    %esi
 824:	5f                   	pop    %edi
 825:	5d                   	pop    %ebp
 826:	c3                   	ret    
 827:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 82e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 830:	83 ec 0c             	sub    $0xc,%esp
 833:	b9 10 00 00 00       	mov    $0x10,%ecx
 838:	6a 00                	push   $0x0
 83a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 83d:	8b 45 08             	mov    0x8(%ebp),%eax
 840:	8b 13                	mov    (%ebx),%edx
 842:	e8 59 fe ff ff       	call   6a0 <printint>
        ap++;
 847:	89 d8                	mov    %ebx,%eax
 849:	83 c4 10             	add    $0x10,%esp
      state = 0;
 84c:	31 d2                	xor    %edx,%edx
        ap++;
 84e:	83 c0 04             	add    $0x4,%eax
 851:	89 45 d0             	mov    %eax,-0x30(%ebp)
 854:	e9 4b ff ff ff       	jmp    7a4 <printf+0x54>
 859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 860:	83 ec 0c             	sub    $0xc,%esp
 863:	b9 0a 00 00 00       	mov    $0xa,%ecx
 868:	6a 01                	push   $0x1
 86a:	eb ce                	jmp    83a <printf+0xea>
 86c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 870:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 873:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 876:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 878:	6a 01                	push   $0x1
        ap++;
 87a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 87d:	57                   	push   %edi
 87e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 881:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 884:	e8 3a fd ff ff       	call   5c3 <write>
        ap++;
 889:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 88c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 88f:	31 d2                	xor    %edx,%edx
 891:	e9 0e ff ff ff       	jmp    7a4 <printf+0x54>
 896:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 89d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 8a0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 8a3:	83 ec 04             	sub    $0x4,%esp
 8a6:	e9 59 ff ff ff       	jmp    804 <printf+0xb4>
 8ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8af:	90                   	nop
        s = (char*)*ap;
 8b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 8b3:	8b 18                	mov    (%eax),%ebx
        ap++;
 8b5:	83 c0 04             	add    $0x4,%eax
 8b8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 8bb:	85 db                	test   %ebx,%ebx
 8bd:	74 17                	je     8d6 <printf+0x186>
        while(*s != 0){
 8bf:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 8c2:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 8c4:	84 c0                	test   %al,%al
 8c6:	0f 84 d8 fe ff ff    	je     7a4 <printf+0x54>
 8cc:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 8cf:	89 de                	mov    %ebx,%esi
 8d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8d4:	eb 1a                	jmp    8f0 <printf+0x1a0>
          s = "(null)";
 8d6:	bb 02 0b 00 00       	mov    $0xb02,%ebx
        while(*s != 0){
 8db:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 8de:	b8 28 00 00 00       	mov    $0x28,%eax
 8e3:	89 de                	mov    %ebx,%esi
 8e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8ef:	90                   	nop
  write(fd, &c, 1);
 8f0:	83 ec 04             	sub    $0x4,%esp
          s++;
 8f3:	83 c6 01             	add    $0x1,%esi
 8f6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 8f9:	6a 01                	push   $0x1
 8fb:	57                   	push   %edi
 8fc:	53                   	push   %ebx
 8fd:	e8 c1 fc ff ff       	call   5c3 <write>
        while(*s != 0){
 902:	0f b6 06             	movzbl (%esi),%eax
 905:	83 c4 10             	add    $0x10,%esp
 908:	84 c0                	test   %al,%al
 90a:	75 e4                	jne    8f0 <printf+0x1a0>
 90c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 90f:	31 d2                	xor    %edx,%edx
 911:	e9 8e fe ff ff       	jmp    7a4 <printf+0x54>
 916:	66 90                	xchg   %ax,%ax
 918:	66 90                	xchg   %ax,%ax
 91a:	66 90                	xchg   %ax,%ax
 91c:	66 90                	xchg   %ax,%ax
 91e:	66 90                	xchg   %ax,%ax

00000920 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 920:	f3 0f 1e fb          	endbr32 
 924:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 925:	a1 44 0e 00 00       	mov    0xe44,%eax
{
 92a:	89 e5                	mov    %esp,%ebp
 92c:	57                   	push   %edi
 92d:	56                   	push   %esi
 92e:	53                   	push   %ebx
 92f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 932:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 934:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 937:	39 c8                	cmp    %ecx,%eax
 939:	73 15                	jae    950 <free+0x30>
 93b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 93f:	90                   	nop
 940:	39 d1                	cmp    %edx,%ecx
 942:	72 14                	jb     958 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 944:	39 d0                	cmp    %edx,%eax
 946:	73 10                	jae    958 <free+0x38>
{
 948:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 94a:	8b 10                	mov    (%eax),%edx
 94c:	39 c8                	cmp    %ecx,%eax
 94e:	72 f0                	jb     940 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 950:	39 d0                	cmp    %edx,%eax
 952:	72 f4                	jb     948 <free+0x28>
 954:	39 d1                	cmp    %edx,%ecx
 956:	73 f0                	jae    948 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 958:	8b 73 fc             	mov    -0x4(%ebx),%esi
 95b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 95e:	39 fa                	cmp    %edi,%edx
 960:	74 1e                	je     980 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 962:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 965:	8b 50 04             	mov    0x4(%eax),%edx
 968:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 96b:	39 f1                	cmp    %esi,%ecx
 96d:	74 28                	je     997 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 96f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 971:	5b                   	pop    %ebx
  freep = p;
 972:	a3 44 0e 00 00       	mov    %eax,0xe44
}
 977:	5e                   	pop    %esi
 978:	5f                   	pop    %edi
 979:	5d                   	pop    %ebp
 97a:	c3                   	ret    
 97b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 97f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 980:	03 72 04             	add    0x4(%edx),%esi
 983:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 986:	8b 10                	mov    (%eax),%edx
 988:	8b 12                	mov    (%edx),%edx
 98a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 98d:	8b 50 04             	mov    0x4(%eax),%edx
 990:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 993:	39 f1                	cmp    %esi,%ecx
 995:	75 d8                	jne    96f <free+0x4f>
    p->s.size += bp->s.size;
 997:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 99a:	a3 44 0e 00 00       	mov    %eax,0xe44
    p->s.size += bp->s.size;
 99f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9a2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 9a5:	89 10                	mov    %edx,(%eax)
}
 9a7:	5b                   	pop    %ebx
 9a8:	5e                   	pop    %esi
 9a9:	5f                   	pop    %edi
 9aa:	5d                   	pop    %ebp
 9ab:	c3                   	ret    
 9ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000009b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9b0:	f3 0f 1e fb          	endbr32 
 9b4:	55                   	push   %ebp
 9b5:	89 e5                	mov    %esp,%ebp
 9b7:	57                   	push   %edi
 9b8:	56                   	push   %esi
 9b9:	53                   	push   %ebx
 9ba:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9bd:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 9c0:	8b 3d 44 0e 00 00    	mov    0xe44,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9c6:	8d 70 07             	lea    0x7(%eax),%esi
 9c9:	c1 ee 03             	shr    $0x3,%esi
 9cc:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 9cf:	85 ff                	test   %edi,%edi
 9d1:	0f 84 a9 00 00 00    	je     a80 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d7:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 9d9:	8b 48 04             	mov    0x4(%eax),%ecx
 9dc:	39 f1                	cmp    %esi,%ecx
 9de:	73 6d                	jae    a4d <malloc+0x9d>
 9e0:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 9e6:	bb 00 10 00 00       	mov    $0x1000,%ebx
 9eb:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 9ee:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 9f5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 9f8:	eb 17                	jmp    a11 <malloc+0x61>
 9fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a00:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 a02:	8b 4a 04             	mov    0x4(%edx),%ecx
 a05:	39 f1                	cmp    %esi,%ecx
 a07:	73 4f                	jae    a58 <malloc+0xa8>
 a09:	8b 3d 44 0e 00 00    	mov    0xe44,%edi
 a0f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a11:	39 c7                	cmp    %eax,%edi
 a13:	75 eb                	jne    a00 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 a15:	83 ec 0c             	sub    $0xc,%esp
 a18:	ff 75 e4             	pushl  -0x1c(%ebp)
 a1b:	e8 0b fc ff ff       	call   62b <sbrk>
  if(p == (char*)-1)
 a20:	83 c4 10             	add    $0x10,%esp
 a23:	83 f8 ff             	cmp    $0xffffffff,%eax
 a26:	74 1b                	je     a43 <malloc+0x93>
  hp->s.size = nu;
 a28:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 a2b:	83 ec 0c             	sub    $0xc,%esp
 a2e:	83 c0 08             	add    $0x8,%eax
 a31:	50                   	push   %eax
 a32:	e8 e9 fe ff ff       	call   920 <free>
  return freep;
 a37:	a1 44 0e 00 00       	mov    0xe44,%eax
      if((p = morecore(nunits)) == 0)
 a3c:	83 c4 10             	add    $0x10,%esp
 a3f:	85 c0                	test   %eax,%eax
 a41:	75 bd                	jne    a00 <malloc+0x50>
        return 0;
  }
}
 a43:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 a46:	31 c0                	xor    %eax,%eax
}
 a48:	5b                   	pop    %ebx
 a49:	5e                   	pop    %esi
 a4a:	5f                   	pop    %edi
 a4b:	5d                   	pop    %ebp
 a4c:	c3                   	ret    
    if(p->s.size >= nunits){
 a4d:	89 c2                	mov    %eax,%edx
 a4f:	89 f8                	mov    %edi,%eax
 a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 a58:	39 ce                	cmp    %ecx,%esi
 a5a:	74 54                	je     ab0 <malloc+0x100>
        p->s.size -= nunits;
 a5c:	29 f1                	sub    %esi,%ecx
 a5e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 a61:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 a64:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 a67:	a3 44 0e 00 00       	mov    %eax,0xe44
}
 a6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 a6f:	8d 42 08             	lea    0x8(%edx),%eax
}
 a72:	5b                   	pop    %ebx
 a73:	5e                   	pop    %esi
 a74:	5f                   	pop    %edi
 a75:	5d                   	pop    %ebp
 a76:	c3                   	ret    
 a77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a7e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 a80:	c7 05 44 0e 00 00 48 	movl   $0xe48,0xe44
 a87:	0e 00 00 
    base.s.size = 0;
 a8a:	bf 48 0e 00 00       	mov    $0xe48,%edi
    base.s.ptr = freep = prevp = &base;
 a8f:	c7 05 48 0e 00 00 48 	movl   $0xe48,0xe48
 a96:	0e 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a99:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 a9b:	c7 05 4c 0e 00 00 00 	movl   $0x0,0xe4c
 aa2:	00 00 00 
    if(p->s.size >= nunits){
 aa5:	e9 36 ff ff ff       	jmp    9e0 <malloc+0x30>
 aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 ab0:	8b 0a                	mov    (%edx),%ecx
 ab2:	89 08                	mov    %ecx,(%eax)
 ab4:	eb b1                	jmp    a67 <malloc+0xb7>
