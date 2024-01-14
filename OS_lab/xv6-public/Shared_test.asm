
_Shared_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
void shmctlTest();	// variants of shmctl
void shmatTest(); // variants of shmat
void permissionTest();	// tests for permissions on shared memory region
int forkTest();		// Two forks, parent write, child-1 write, child-2 write, parent read (parent attach)

int main(int argc, char *argv[]) {
       0:	f3 0f 1e fb          	endbr32 
       4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
       8:	83 e4 f0             	and    $0xfffffff0,%esp
       b:	ff 71 fc             	pushl  -0x4(%ecx)
       e:	55                   	push   %ebp
       f:	89 e5                	mov    %esp,%ebp
      11:	51                   	push   %ecx
      12:	83 ec 04             	sub    $0x4,%esp
	/*
		Basic shared memory test,
		create region - write - read - remove region
	*/
    if(basicSharedTest() < 0) {
      15:	e8 56 00 00 00       	call   70 <basicSharedTest>
      1a:	85 c0                	test   %eax,%eax
      1c:	78 27                	js     45 <main+0x45>
		printf(1, "failed\n");
	}
	// tests for different variants of shmget, w.r.t shmget flags
	shmgetTest();
      1e:	e8 4d 01 00 00       	call   170 <shmgetTest>
	// tests for different variants of shmat, w.r.t shmat flags
	shmatTest();
      23:	e8 c8 04 00 00       	call   4f0 <shmatTest>
	// tests for different variants of shmdt, w.r.t shmdt flags
	shmdtTest();
      28:	e8 13 0f 00 00       	call   f40 <shmdtTest>
	// tests for different variants of shmctl, w.r.t shmctl flags
	shmctlTest();
      2d:	e8 ee 0f 00 00       	call   1020 <shmctlTest>
	// tests for of different permissions on regions
	permissionTest();
      32:	e8 69 12 00 00       	call   12a0 <permissionTest>
	/* 
		test for fork,
		parent (attach) - parent write - child 1 write - child 2 write - parent read and verify - parent detach
	*/
	if(forkTest() < 0) {
      37:	e8 f4 13 00 00       	call   1430 <forkTest>
      3c:	85 c0                	test   %eax,%eax
      3e:	78 18                	js     58 <main+0x58>
		printf(1, "failed\n");
	}

    exit();
      40:	e8 ce 17 00 00       	call   1813 <exit>
		printf(1, "failed\n");
      45:	52                   	push   %edx
      46:	52                   	push   %edx
      47:	68 29 26 00 00       	push   $0x2629
      4c:	6a 01                	push   $0x1
      4e:	e8 8d 19 00 00       	call   19e0 <printf>
      53:	83 c4 10             	add    $0x10,%esp
      56:	eb c6                	jmp    1e <main+0x1e>
		printf(1, "failed\n");
      58:	50                   	push   %eax
      59:	50                   	push   %eax
      5a:	68 29 26 00 00       	push   $0x2629
      5f:	6a 01                	push   $0x1
      61:	e8 7a 19 00 00       	call   19e0 <printf>
      66:	83 c4 10             	add    $0x10,%esp
      69:	eb d5                	jmp    40 <main+0x40>
      6b:	66 90                	xchg   %ax,%ax
      6d:	66 90                	xchg   %ax,%ax
      6f:	90                   	nop

00000070 <basicSharedTest>:
}

// basic shared test
int basicSharedTest() {
      70:	f3 0f 1e fb          	endbr32 
      74:	55                   	push   %ebp
      75:	89 e5                	mov    %esp,%ebp
      77:	57                   	push   %edi
      78:	56                   	push   %esi
      79:	53                   	push   %ebx
      7a:	83 ec 14             	sub    $0x14,%esp
	printf(1, "* (Basic) Create segment, write, read and destroy test : ");
      7d:	68 48 1d 00 00       	push   $0x1d48
      82:	6a 01                	push   $0x1
      84:	e8 57 19 00 00       	call   19e0 <printf>
	char *string = "Test String";
	// get region
	int shmid = shmget(KEY1, 2565, 06 | IPC_CREAT);
      89:	83 c4 0c             	add    $0xc,%esp
      8c:	68 06 02 00 00       	push   $0x206
      91:	68 05 0a 00 00       	push   $0xa05
      96:	68 d0 07 00 00       	push   $0x7d0
      9b:	e8 63 18 00 00       	call   1903 <shmget>
	if(shmid < 0) {
      a0:	83 c4 10             	add    $0x10,%esp
      a3:	85 c0                	test   %eax,%eax
      a5:	78 78                	js     11f <basicSharedTest+0xaf>
		return -1;
	}
	// attach to shmid's region
	char *ptr = (char *)shmat(shmid, (void *)0, 0);
      a7:	83 ec 04             	sub    $0x4,%esp
      aa:	89 c6                	mov    %eax,%esi
      ac:	6a 00                	push   $0x0
      ae:	6a 00                	push   $0x0
      b0:	50                   	push   %eax
      b1:	e8 55 18 00 00       	call   190b <shmat>
	if((int)ptr < 0) {
      b6:	83 c4 10             	add    $0x10,%esp
      b9:	85 c0                	test   %eax,%eax
      bb:	78 62                	js     11f <basicSharedTest+0xaf>
      bd:	bb 50 25 00 00       	mov    $0x2550,%ebx
      c2:	89 c2                	mov    %eax,%edx
		return -1;
	}
	// write into region
	for(int i = 0; string[i] != 0; i++) {
      c4:	b9 54 00 00 00       	mov    $0x54,%ecx
      c9:	89 df                	mov    %ebx,%edi
      cb:	29 c7                	sub    %eax,%edi
      cd:	8d 76 00             	lea    0x0(%esi),%esi
		ptr[i] = string[i];
      d0:	88 0a                	mov    %cl,(%edx)
	for(int i = 0; string[i] != 0; i++) {
      d2:	83 c2 01             	add    $0x1,%edx
      d5:	0f b6 0c 17          	movzbl (%edi,%edx,1),%ecx
      d9:	84 c9                	test   %cl,%cl
      db:	75 f3                	jne    d0 <basicSharedTest+0x60>
	}
	// detach
	int dt = shmdt(ptr);
      dd:	83 ec 0c             	sub    $0xc,%esp
      e0:	50                   	push   %eax
      e1:	e8 2d 18 00 00       	call   1913 <shmdt>
	if(dt < 0) {
      e6:	83 c4 10             	add    $0x10,%esp
      e9:	85 c0                	test   %eax,%eax
      eb:	78 32                	js     11f <basicSharedTest+0xaf>
		return -1;
	}

	// re-attach for verification
	ptr = (char *)shmat(shmid, (void *)0, 0);
      ed:	83 ec 04             	sub    $0x4,%esp
      f0:	6a 00                	push   $0x0
      f2:	6a 00                	push   $0x0
      f4:	56                   	push   %esi
      f5:	e8 11 18 00 00       	call   190b <shmat>
	if((int)ptr < 0) {
      fa:	83 c4 10             	add    $0x10,%esp
      fd:	85 c0                	test   %eax,%eax
      ff:	78 1e                	js     11f <basicSharedTest+0xaf>
     101:	89 c2                	mov    %eax,%edx
		return -1;
	}

	// read, written data
	for(int i = 0; string[i] != 0; i++) {
     103:	b9 54 00 00 00       	mov    $0x54,%ecx
     108:	29 c3                	sub    %eax,%ebx
     10a:	eb 0f                	jmp    11b <basicSharedTest+0xab>
     10c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     110:	83 c2 01             	add    $0x1,%edx
     113:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
     117:	84 c9                	test   %cl,%cl
     119:	74 15                	je     130 <basicSharedTest+0xc0>
		if(ptr[i] != string[i]) {
     11b:	38 0a                	cmp    %cl,(%edx)
     11d:	74 f1                	je     110 <basicSharedTest+0xa0>
	if(ctl < 0) {
		return -1;
	}
	printf(1, "Pass\n");
	return 0;
}
     11f:	8d 65 f4             	lea    -0xc(%ebp),%esp
		return -1;
     122:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     127:	5b                   	pop    %ebx
     128:	5e                   	pop    %esi
     129:	5f                   	pop    %edi
     12a:	5d                   	pop    %ebp
     12b:	c3                   	ret    
     12c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	dt = shmdt(ptr);
     130:	83 ec 0c             	sub    $0xc,%esp
     133:	50                   	push   %eax
     134:	e8 da 17 00 00       	call   1913 <shmdt>
	if(dt < 0) {
     139:	83 c4 10             	add    $0x10,%esp
     13c:	85 c0                	test   %eax,%eax
     13e:	78 df                	js     11f <basicSharedTest+0xaf>
	int ctl = shmctl(shmid, IPC_RMID, (void *)0);
     140:	83 ec 04             	sub    $0x4,%esp
     143:	6a 00                	push   $0x0
     145:	6a 00                	push   $0x0
     147:	56                   	push   %esi
     148:	e8 ce 17 00 00       	call   191b <shmctl>
	if(ctl < 0) {
     14d:	83 c4 10             	add    $0x10,%esp
     150:	85 c0                	test   %eax,%eax
     152:	78 cb                	js     11f <basicSharedTest+0xaf>
	printf(1, "Pass\n");
     154:	83 ec 08             	sub    $0x8,%esp
     157:	68 b0 25 00 00       	push   $0x25b0
     15c:	6a 01                	push   $0x1
     15e:	e8 7d 18 00 00       	call   19e0 <printf>
	return 0;
     163:	83 c4 10             	add    $0x10,%esp
}
     166:	8d 65 f4             	lea    -0xc(%ebp),%esp
	return 0;
     169:	31 c0                	xor    %eax,%eax
}
     16b:	5b                   	pop    %ebx
     16c:	5e                   	pop    %esi
     16d:	5f                   	pop    %edi
     16e:	5d                   	pop    %ebp
     16f:	c3                   	ret    

00000170 <shmgetTest>:

// variants of shmget
void shmgetTest() {
     170:	f3 0f 1e fb          	endbr32 
     174:	55                   	push   %ebp
     175:	89 e5                	mov    %esp,%ebp
     177:	53                   	push   %ebx
     178:	83 ec 0c             	sub    $0xc,%esp
	printf(1, "* Tests for variants of shmget :\n");
     17b:	68 84 1d 00 00       	push   $0x1d84
     180:	6a 01                	push   $0x1
     182:	e8 59 18 00 00       	call   19e0 <printf>
	printf(1, "\t- To check negative key input : ");
     187:	58                   	pop    %eax
     188:	5a                   	pop    %edx
     189:	68 a8 1d 00 00       	push   $0x1da8
     18e:	6a 01                	push   $0x1
     190:	e8 4b 18 00 00       	call   19e0 <printf>
	// negative key
	int shmid = shmget(-1, 5000, 06 | IPC_CREAT);
     195:	83 c4 0c             	add    $0xc,%esp
     198:	68 06 02 00 00       	push   $0x206
     19d:	68 88 13 00 00       	push   $0x1388
     1a2:	6a ff                	push   $0xffffffff
     1a4:	e8 5a 17 00 00       	call   1903 <shmget>
	if(shmid < 0) {
     1a9:	83 c4 10             	add    $0x10,%esp
     1ac:	85 c0                	test   %eax,%eax
     1ae:	0f 88 1c 02 00 00    	js     3d0 <shmgetTest+0x260>
		printf(1, "Pass\n");
	} else {
		printf(1, "Fail\n");
     1b4:	83 ec 08             	sub    $0x8,%esp
     1b7:	68 a6 25 00 00       	push   $0x25a6
     1bc:	6a 01                	push   $0x1
     1be:	e8 1d 18 00 00       	call   19e0 <printf>
     1c3:	83 c4 10             	add    $0x10,%esp
	}
	printf(1, "\t- Region permission other than Read / Read-Write (no permissions) : ");
     1c6:	83 ec 08             	sub    $0x8,%esp
     1c9:	68 cc 1d 00 00       	push   $0x1dcc
     1ce:	6a 01                	push   $0x1
     1d0:	e8 0b 18 00 00       	call   19e0 <printf>
	// invalid permission check
	shmid = shmget(KEY1, 4000, IPC_CREAT);
     1d5:	83 c4 0c             	add    $0xc,%esp
     1d8:	68 00 02 00 00       	push   $0x200
     1dd:	68 a0 0f 00 00       	push   $0xfa0
     1e2:	68 d0 07 00 00       	push   $0x7d0
     1e7:	e8 17 17 00 00       	call   1903 <shmget>
	if(shmid < 0) {
     1ec:	83 c4 10             	add    $0x10,%esp
     1ef:	85 c0                	test   %eax,%eax
     1f1:	0f 88 b9 02 00 00    	js     4b0 <shmgetTest+0x340>
		printf(1, "Pass\n");
	} else {
		printf(1, "Fail\n");
     1f7:	83 ec 08             	sub    $0x8,%esp
     1fa:	68 a6 25 00 00       	push   $0x25a6
     1ff:	6a 01                	push   $0x1
     201:	e8 da 17 00 00       	call   19e0 <printf>
     206:	83 c4 10             	add    $0x10,%esp
	}
	printf(1, "\t- Requesting region with more than decided pages ( > 64) : ");
     209:	83 ec 08             	sub    $0x8,%esp
     20c:	68 14 1e 00 00       	push   $0x1e14
     211:	6a 01                	push   $0x1
     213:	e8 c8 17 00 00       	call   19e0 <printf>
	// more than allowed size
	shmid = shmget(KEY1, 1.6e+7 + 40, 06 | IPC_CREAT);
     218:	83 c4 0c             	add    $0xc,%esp
     21b:	68 06 02 00 00       	push   $0x206
     220:	68 28 24 f4 00       	push   $0xf42428
     225:	68 d0 07 00 00       	push   $0x7d0
     22a:	e8 d4 16 00 00       	call   1903 <shmget>
	if(shmid < 0) {
     22f:	83 c4 10             	add    $0x10,%esp
     232:	85 c0                	test   %eax,%eax
     234:	0f 88 56 02 00 00    	js     490 <shmgetTest+0x320>
		printf(1, "Pass\n");
	} else {
		printf(1, "Fail\n");
     23a:	83 ec 08             	sub    $0x8,%esp
     23d:	68 a6 25 00 00       	push   $0x25a6
     242:	6a 01                	push   $0x1
     244:	e8 97 17 00 00       	call   19e0 <printf>
     249:	83 c4 10             	add    $0x10,%esp
	}
	printf(1, "\t- Requesting region with zero size : ");
     24c:	83 ec 08             	sub    $0x8,%esp
     24f:	68 54 1e 00 00       	push   $0x1e54
     254:	6a 01                	push   $0x1
     256:	e8 85 17 00 00       	call   19e0 <printf>
	// empty region
	shmid = shmget(KEY1, 0, 06 | IPC_CREAT);
     25b:	83 c4 0c             	add    $0xc,%esp
     25e:	68 06 02 00 00       	push   $0x206
     263:	6a 00                	push   $0x0
     265:	68 d0 07 00 00       	push   $0x7d0
     26a:	e8 94 16 00 00       	call   1903 <shmget>
	if(shmid < 0) {
     26f:	83 c4 10             	add    $0x10,%esp
     272:	85 c0                	test   %eax,%eax
     274:	0f 88 f6 01 00 00    	js     470 <shmgetTest+0x300>
		printf(1, "Pass\n");
	} else {
		printf(1, "Fail\n");
     27a:	83 ec 08             	sub    $0x8,%esp
     27d:	68 a6 25 00 00       	push   $0x25a6
     282:	6a 01                	push   $0x1
     284:	e8 57 17 00 00       	call   19e0 <printf>
     289:	83 c4 10             	add    $0x10,%esp
	}
	printf(1, "\t- Check for creation of valid region with IPC_CREAT : ");
     28c:	83 ec 08             	sub    $0x8,%esp
     28f:	68 7c 1e 00 00       	push   $0x1e7c
     294:	6a 01                	push   $0x1
     296:	e8 45 17 00 00       	call   19e0 <printf>
	// IPC_CREAT
	shmid = shmget(KEY1, 2000, 06 | IPC_CREAT);
     29b:	83 c4 0c             	add    $0xc,%esp
     29e:	68 06 02 00 00       	push   $0x206
     2a3:	68 d0 07 00 00       	push   $0x7d0
     2a8:	68 d0 07 00 00       	push   $0x7d0
     2ad:	e8 51 16 00 00       	call   1903 <shmget>
	if(shmid < 0) {
     2b2:	83 c4 10             	add    $0x10,%esp
	shmid = shmget(KEY1, 2000, 06 | IPC_CREAT);
     2b5:	89 c3                	mov    %eax,%ebx
	if(shmid < 0) {
     2b7:	85 c0                	test   %eax,%eax
     2b9:	0f 88 91 01 00 00    	js     450 <shmgetTest+0x2e0>
		printf(1, "Fail\n");
	} else {
		printf(1, "Pass\n");
     2bf:	83 ec 08             	sub    $0x8,%esp
     2c2:	68 b0 25 00 00       	push   $0x25b0
     2c7:	6a 01                	push   $0x1
     2c9:	e8 12 17 00 00       	call   19e0 <printf>
     2ce:	83 c4 10             	add    $0x10,%esp
	}
	printf(1, "\t- Check for retrieving previously created region's shmid : ");
     2d1:	83 ec 08             	sub    $0x8,%esp
     2d4:	68 b4 1e 00 00       	push   $0x1eb4
     2d9:	6a 01                	push   $0x1
     2db:	e8 00 17 00 00       	call   19e0 <printf>
	// get existing region shmid
	int prevShmid = shmget(KEY1, 2000, 0);
     2e0:	83 c4 0c             	add    $0xc,%esp
     2e3:	6a 00                	push   $0x0
     2e5:	68 d0 07 00 00       	push   $0x7d0
     2ea:	68 d0 07 00 00       	push   $0x7d0
     2ef:	e8 0f 16 00 00       	call   1903 <shmget>
	if(prevShmid == shmid) {
     2f4:	83 c4 10             	add    $0x10,%esp
     2f7:	39 c3                	cmp    %eax,%ebx
     2f9:	0f 84 d1 01 00 00    	je     4d0 <shmgetTest+0x360>
		printf(1, "Pass\n");
	} else {
		printf(1, "Fail\n");
     2ff:	83 ec 08             	sub    $0x8,%esp
     302:	68 a6 25 00 00       	push   $0x25a6
     307:	6a 01                	push   $0x1
     309:	e8 d2 16 00 00       	call   19e0 <printf>
     30e:	83 c4 10             	add    $0x10,%esp
	}
	printf(1, "\t- Check for creation of valid region with IPC_PRIVATE : ");
     311:	83 ec 08             	sub    $0x8,%esp
     314:	68 f4 1e 00 00       	push   $0x1ef4
     319:	6a 01                	push   $0x1
     31b:	e8 c0 16 00 00       	call   19e0 <printf>
	// IPC_PRIVATE
	shmid = shmget(IPC_PRIVATE, 2000, 06);
     320:	83 c4 0c             	add    $0xc,%esp
     323:	6a 06                	push   $0x6
     325:	68 d0 07 00 00       	push   $0x7d0
     32a:	6a 00                	push   $0x0
     32c:	e8 d2 15 00 00       	call   1903 <shmget>
	if(shmid < 0) {
     331:	83 c4 10             	add    $0x10,%esp
     334:	85 c0                	test   %eax,%eax
     336:	0f 88 f4 00 00 00    	js     430 <shmgetTest+0x2c0>
		printf(1, "Fail\n");
	} else {
		printf(1, "Pass\n");
     33c:	83 ec 08             	sub    $0x8,%esp
     33f:	68 b0 25 00 00       	push   $0x25b0
     344:	6a 01                	push   $0x1
     346:	e8 95 16 00 00       	call   19e0 <printf>
     34b:	83 c4 10             	add    $0x10,%esp
	}
	printf(1, "\t- Check for IPC_CREAT | IPC_EXCL on existing region : ");
     34e:	83 ec 08             	sub    $0x8,%esp
     351:	68 30 1f 00 00       	push   $0x1f30
     356:	6a 01                	push   $0x1
     358:	e8 83 16 00 00       	call   19e0 <printf>
	shmid = shmget(KEY1, 0, 06 | IPC_CREAT | IPC_EXCL);
     35d:	83 c4 0c             	add    $0xc,%esp
     360:	68 06 06 00 00       	push   $0x606
     365:	6a 00                	push   $0x0
     367:	68 d0 07 00 00       	push   $0x7d0
     36c:	e8 92 15 00 00       	call   1903 <shmget>
	if(shmid < 0) {
     371:	83 c4 10             	add    $0x10,%esp
     374:	85 c0                	test   %eax,%eax
     376:	0f 88 94 00 00 00    	js     410 <shmgetTest+0x2a0>
		printf(1, "Pass\n");
	} else {
		printf(1, "Fail\n");
     37c:	83 ec 08             	sub    $0x8,%esp
     37f:	68 a6 25 00 00       	push   $0x25a6
     384:	6a 01                	push   $0x1
     386:	e8 55 16 00 00       	call   19e0 <printf>
     38b:	83 c4 10             	add    $0x10,%esp
	}
	printf(1, "\t- Check for IPC_EXCL alone, without IPC_CREAT : ");
     38e:	83 ec 08             	sub    $0x8,%esp
     391:	68 68 1f 00 00       	push   $0x1f68
     396:	6a 01                	push   $0x1
     398:	e8 43 16 00 00       	call   19e0 <printf>
	// Only IPC_EXCL
	shmid = shmget(KEY2, 0, 06 | IPC_EXCL);
     39d:	83 c4 0c             	add    $0xc,%esp
     3a0:	68 06 04 00 00       	push   $0x406
     3a5:	6a 00                	push   $0x0
     3a7:	68 a0 0f 00 00       	push   $0xfa0
     3ac:	e8 52 15 00 00       	call   1903 <shmget>
	if(shmid < 0) {
     3b1:	83 c4 10             	add    $0x10,%esp
     3b4:	85 c0                	test   %eax,%eax
     3b6:	78 38                	js     3f0 <shmgetTest+0x280>
		printf(1, "Pass\n");
	} else {
		printf(1, "Fail\n");
     3b8:	83 ec 08             	sub    $0x8,%esp
     3bb:	68 a6 25 00 00       	push   $0x25a6
     3c0:	6a 01                	push   $0x1
     3c2:	e8 19 16 00 00       	call   19e0 <printf>
	}
}
     3c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
		printf(1, "Fail\n");
     3ca:	83 c4 10             	add    $0x10,%esp
}
     3cd:	c9                   	leave  
     3ce:	c3                   	ret    
     3cf:	90                   	nop
		printf(1, "Pass\n");
     3d0:	83 ec 08             	sub    $0x8,%esp
     3d3:	68 b0 25 00 00       	push   $0x25b0
     3d8:	6a 01                	push   $0x1
     3da:	e8 01 16 00 00       	call   19e0 <printf>
     3df:	83 c4 10             	add    $0x10,%esp
     3e2:	e9 df fd ff ff       	jmp    1c6 <shmgetTest+0x56>
     3e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     3ee:	66 90                	xchg   %ax,%ax
		printf(1, "Pass\n");
     3f0:	83 ec 08             	sub    $0x8,%esp
     3f3:	68 b0 25 00 00       	push   $0x25b0
     3f8:	6a 01                	push   $0x1
     3fa:	e8 e1 15 00 00       	call   19e0 <printf>
}
     3ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     402:	83 c4 10             	add    $0x10,%esp
     405:	c9                   	leave  
     406:	c3                   	ret    
     407:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     40e:	66 90                	xchg   %ax,%ax
		printf(1, "Pass\n");
     410:	83 ec 08             	sub    $0x8,%esp
     413:	68 b0 25 00 00       	push   $0x25b0
     418:	6a 01                	push   $0x1
     41a:	e8 c1 15 00 00       	call   19e0 <printf>
     41f:	83 c4 10             	add    $0x10,%esp
     422:	e9 67 ff ff ff       	jmp    38e <shmgetTest+0x21e>
     427:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     42e:	66 90                	xchg   %ax,%ax
		printf(1, "Fail\n");
     430:	83 ec 08             	sub    $0x8,%esp
     433:	68 a6 25 00 00       	push   $0x25a6
     438:	6a 01                	push   $0x1
     43a:	e8 a1 15 00 00       	call   19e0 <printf>
     43f:	83 c4 10             	add    $0x10,%esp
     442:	e9 07 ff ff ff       	jmp    34e <shmgetTest+0x1de>
     447:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     44e:	66 90                	xchg   %ax,%ax
		printf(1, "Fail\n");
     450:	83 ec 08             	sub    $0x8,%esp
     453:	68 a6 25 00 00       	push   $0x25a6
     458:	6a 01                	push   $0x1
     45a:	e8 81 15 00 00       	call   19e0 <printf>
     45f:	83 c4 10             	add    $0x10,%esp
     462:	e9 6a fe ff ff       	jmp    2d1 <shmgetTest+0x161>
     467:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     46e:	66 90                	xchg   %ax,%ax
		printf(1, "Pass\n");
     470:	83 ec 08             	sub    $0x8,%esp
     473:	68 b0 25 00 00       	push   $0x25b0
     478:	6a 01                	push   $0x1
     47a:	e8 61 15 00 00       	call   19e0 <printf>
     47f:	83 c4 10             	add    $0x10,%esp
     482:	e9 05 fe ff ff       	jmp    28c <shmgetTest+0x11c>
     487:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     48e:	66 90                	xchg   %ax,%ax
		printf(1, "Pass\n");
     490:	83 ec 08             	sub    $0x8,%esp
     493:	68 b0 25 00 00       	push   $0x25b0
     498:	6a 01                	push   $0x1
     49a:	e8 41 15 00 00       	call   19e0 <printf>
     49f:	83 c4 10             	add    $0x10,%esp
     4a2:	e9 a5 fd ff ff       	jmp    24c <shmgetTest+0xdc>
     4a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     4ae:	66 90                	xchg   %ax,%ax
		printf(1, "Pass\n");
     4b0:	83 ec 08             	sub    $0x8,%esp
     4b3:	68 b0 25 00 00       	push   $0x25b0
     4b8:	6a 01                	push   $0x1
     4ba:	e8 21 15 00 00       	call   19e0 <printf>
     4bf:	83 c4 10             	add    $0x10,%esp
     4c2:	e9 42 fd ff ff       	jmp    209 <shmgetTest+0x99>
     4c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     4ce:	66 90                	xchg   %ax,%ax
		printf(1, "Pass\n");
     4d0:	83 ec 08             	sub    $0x8,%esp
     4d3:	68 b0 25 00 00       	push   $0x25b0
     4d8:	6a 01                	push   $0x1
     4da:	e8 01 15 00 00       	call   19e0 <printf>
     4df:	83 c4 10             	add    $0x10,%esp
     4e2:	e9 2a fe ff ff       	jmp    311 <shmgetTest+0x1a1>
     4e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     4ee:	66 90                	xchg   %ax,%ax

000004f0 <shmatTest>:

// variants of shmat
void shmatTest() {  
     4f0:	f3 0f 1e fb          	endbr32 
     4f4:	55                   	push   %ebp
     4f5:	89 e5                	mov    %esp,%ebp
     4f7:	57                   	push   %edi
     4f8:	56                   	push   %esi
     4f9:	53                   	push   %ebx
     4fa:	81 ec b4 01 00 00    	sub    $0x1b4,%esp
    int dt,i;
    char *ptr,*ptr2,*ptr3,*ptrarr[100];
	printf(1, "* Tests for variants of shmat :\n");
     500:	68 9c 1f 00 00       	push   $0x1f9c
     505:	6a 01                	push   $0x1
     507:	e8 d4 14 00 00       	call   19e0 <printf>
	int shmid = shmget(KEY4, 2565, 06 | IPC_CREAT);
     50c:	83 c4 0c             	add    $0xc,%esp
     50f:	68 06 02 00 00       	push   $0x206
     514:	68 05 0a 00 00       	push   $0xa05
     519:	68 d6 07 00 00       	push   $0x7d6
     51e:	e8 e0 13 00 00       	call   1903 <shmget>
    int shmid2 = shmget(KEY5,2565, 06 | IPC_CREAT);
     523:	83 c4 0c             	add    $0xc,%esp
     526:	68 06 02 00 00       	push   $0x206
	int shmid = shmget(KEY4, 2565, 06 | IPC_CREAT);
     52b:	89 c3                	mov    %eax,%ebx
    int shmid2 = shmget(KEY5,2565, 06 | IPC_CREAT);
     52d:	68 05 0a 00 00       	push   $0xa05
     532:	68 a1 0f 00 00       	push   $0xfa1
     537:	e8 c7 13 00 00       	call   1903 <shmget>
    int shmid3 = shmget(KEY6,2565, 06 | IPC_CREAT);
     53c:	83 c4 0c             	add    $0xc,%esp
     53f:	68 06 02 00 00       	push   $0x206
    int shmid2 = shmget(KEY5,2565, 06 | IPC_CREAT);
     544:	89 c6                	mov    %eax,%esi
    int shmid3 = shmget(KEY6,2565, 06 | IPC_CREAT);
     546:	68 05 0a 00 00       	push   $0xa05
     54b:	68 62 1e 00 00       	push   $0x1e62
     550:	e8 ae 13 00 00       	call   1903 <shmget>
	int shmid4 = shmget(KEY7,3000, 04 | IPC_CREAT);
     555:	83 c4 0c             	add    $0xc,%esp
     558:	68 04 02 00 00       	push   $0x204
     55d:	68 b8 0b 00 00       	push   $0xbb8
     562:	68 ef 0d 00 00       	push   $0xdef
    int shmid3 = shmget(KEY6,2565, 06 | IPC_CREAT);
     567:	89 85 54 fe ff ff    	mov    %eax,-0x1ac(%ebp)
	int shmid4 = shmget(KEY7,3000, 04 | IPC_CREAT);
     56d:	e8 91 13 00 00       	call   1903 <shmget>
	if(shmid < 0 || shmid2 < 0 || shmid3 < 0 || shmid4 < 0) {
     572:	83 c4 10             	add    $0x10,%esp
     575:	85 db                	test   %ebx,%ebx
     577:	0f 88 a8 04 00 00    	js     a25 <shmatTest+0x535>
     57d:	85 f6                	test   %esi,%esi
     57f:	0f 88 a0 04 00 00    	js     a25 <shmatTest+0x535>
     585:	8b bd 54 fe ff ff    	mov    -0x1ac(%ebp),%edi
     58b:	85 ff                	test   %edi,%edi
     58d:	0f 88 92 04 00 00    	js     a25 <shmatTest+0x535>
     593:	89 c7                	mov    %eax,%edi
     595:	85 c0                	test   %eax,%eax
     597:	0f 88 88 04 00 00    	js     a25 <shmatTest+0x535>
		printf(1, "Fail\n");
        return;
	}
	printf(1, "\t- Non-existent shmid within allowed range: ");
     59d:	83 ec 08             	sub    $0x8,%esp
     5a0:	68 c0 1f 00 00       	push   $0x1fc0
     5a5:	6a 01                	push   $0x1
     5a7:	e8 34 14 00 00       	call   19e0 <printf>
	ptr = (char *)shmat(35, (void *)0, 0);
     5ac:	83 c4 0c             	add    $0xc,%esp
     5af:	6a 00                	push   $0x0
     5b1:	6a 00                	push   $0x0
     5b3:	6a 23                	push   $0x23
     5b5:	e8 51 13 00 00       	call   190b <shmat>
	if((int)ptr < 0) {
     5ba:	83 c4 10             	add    $0x10,%esp
     5bd:	85 c0                	test   %eax,%eax
     5bf:	0f 88 eb 05 00 00    	js     bb0 <shmatTest+0x6c0>
		printf(1,"Pass\n");
	} else {
		printf(1, "Fail\n");
     5c5:	83 ec 08             	sub    $0x8,%esp
     5c8:	68 a6 25 00 00       	push   $0x25a6
     5cd:	6a 01                	push   $0x1
     5cf:	e8 0c 14 00 00       	call   19e0 <printf>
     5d4:	83 c4 10             	add    $0x10,%esp
	}
    printf(1, "\t- Check shmid beyond allowed range: ");
     5d7:	83 ec 08             	sub    $0x8,%esp
     5da:	68 f0 1f 00 00       	push   $0x1ff0
     5df:	6a 01                	push   $0x1
     5e1:	e8 fa 13 00 00       	call   19e0 <printf>
	ptr = (char *)shmat(1000, (void *)0, 0);
     5e6:	83 c4 0c             	add    $0xc,%esp
     5e9:	6a 00                	push   $0x0
     5eb:	6a 00                	push   $0x0
     5ed:	68 e8 03 00 00       	push   $0x3e8
     5f2:	e8 14 13 00 00       	call   190b <shmat>
	if((int)ptr < 0) {
     5f7:	83 c4 10             	add    $0x10,%esp
     5fa:	85 c0                	test   %eax,%eax
     5fc:	0f 88 8e 05 00 00    	js     b90 <shmatTest+0x6a0>
		printf(1,"Pass\n");
	} else {
		printf(1, "Fail\n");
     602:	83 ec 08             	sub    $0x8,%esp
     605:	68 a6 25 00 00       	push   $0x25a6
     60a:	6a 01                	push   $0x1
     60c:	e8 cf 13 00 00       	call   19e0 <printf>
     611:	83 c4 10             	add    $0x10,%esp
	}
    printf(1, "\t- Requesting for address beyond lower limit: ");
     614:	83 ec 08             	sub    $0x8,%esp
     617:	68 18 20 00 00       	push   $0x2018
     61c:	6a 01                	push   $0x1
     61e:	e8 bd 13 00 00       	call   19e0 <printf>
	ptr = (char *)shmat(shmid, (void *)(HEAPLIMIT - 10), 0);
     623:	83 c4 0c             	add    $0xc,%esp
     626:	6a 00                	push   $0x0
     628:	68 f6 ff ff 7e       	push   $0x7efffff6
     62d:	53                   	push   %ebx
     62e:	e8 d8 12 00 00       	call   190b <shmat>
	if((int)ptr < 0) {
     633:	83 c4 10             	add    $0x10,%esp
     636:	85 c0                	test   %eax,%eax
     638:	0f 88 32 05 00 00    	js     b70 <shmatTest+0x680>
		printf(1,"Pass\n");
	} else {
		printf(1, "Fail\n");
     63e:	83 ec 08             	sub    $0x8,%esp
     641:	68 a6 25 00 00       	push   $0x25a6
     646:	6a 01                	push   $0x1
     648:	e8 93 13 00 00       	call   19e0 <printf>
     64d:	83 c4 10             	add    $0x10,%esp
	}
    printf(1, "\t- Requesting for address beyond upper limit: ");
     650:	83 ec 08             	sub    $0x8,%esp
     653:	68 48 20 00 00       	push   $0x2048
     658:	6a 01                	push   $0x1
     65a:	e8 81 13 00 00       	call   19e0 <printf>
	ptr = (char *)shmat(shmid, (void *)(KERNBASE + 10), 0);
     65f:	83 c4 0c             	add    $0xc,%esp
     662:	6a 00                	push   $0x0
     664:	68 0a 00 00 80       	push   $0x8000000a
     669:	53                   	push   %ebx
     66a:	e8 9c 12 00 00       	call   190b <shmat>
	if((int)ptr < 0) {
     66f:	83 c4 10             	add    $0x10,%esp
     672:	85 c0                	test   %eax,%eax
     674:	0f 88 d6 04 00 00    	js     b50 <shmatTest+0x660>
		printf(1,"Pass\n");
	} else {
		printf(1, "Fail\n");
     67a:	83 ec 08             	sub    $0x8,%esp
     67d:	68 a6 25 00 00       	push   $0x25a6
     682:	6a 01                	push   $0x1
     684:	e8 57 13 00 00       	call   19e0 <printf>
     689:	83 c4 10             	add    $0x10,%esp
	}
    printf(1, "\t- Requesting for page-aligned address within range : ");
     68c:	83 ec 08             	sub    $0x8,%esp
     68f:	68 78 20 00 00       	push   $0x2078
     694:	6a 01                	push   $0x1
     696:	e8 45 13 00 00       	call   19e0 <printf>
	ptr = (char*)shmat(shmid, (void *)(allowedAddr), 0);
     69b:	83 c4 0c             	add    $0xc,%esp
     69e:	6a 00                	push   $0x0
     6a0:	68 00 30 00 7f       	push   $0x7f003000
     6a5:	53                   	push   %ebx
     6a6:	e8 60 12 00 00       	call   190b <shmat>
	if((uint)ptr == allowedAddr) {
     6ab:	83 c4 10             	add    $0x10,%esp
	ptr = (char*)shmat(shmid, (void *)(allowedAddr), 0);
     6ae:	89 85 50 fe ff ff    	mov    %eax,-0x1b0(%ebp)
	if((uint)ptr == allowedAddr) {
     6b4:	3d 00 30 00 7f       	cmp    $0x7f003000,%eax
     6b9:	0f 84 31 05 00 00    	je     bf0 <shmatTest+0x700>
		printf(1,"Pass\n");
	} else {
        
		printf(1, "Fail\n");
     6bf:	83 ec 08             	sub    $0x8,%esp
     6c2:	68 a6 25 00 00       	push   $0x25a6
     6c7:	6a 01                	push   $0x1
     6c9:	e8 12 13 00 00       	call   19e0 <printf>
     6ce:	83 c4 10             	add    $0x10,%esp
	}
    printf(1, "\t- Corresponding detach : ");
     6d1:	83 ec 08             	sub    $0x8,%esp
     6d4:	68 5c 25 00 00       	push   $0x255c
     6d9:	6a 01                	push   $0x1
     6db:	e8 00 13 00 00       	call   19e0 <printf>
    dt = shmdt(ptr);
     6e0:	59                   	pop    %ecx
     6e1:	ff b5 50 fe ff ff    	pushl  -0x1b0(%ebp)
     6e7:	e8 27 12 00 00       	call   1913 <shmdt>
    if(dt < 0) {
     6ec:	83 c4 10             	add    $0x10,%esp
     6ef:	85 c0                	test   %eax,%eax
     6f1:	0f 88 39 04 00 00    	js     b30 <shmatTest+0x640>
		printf(1, "Fail\n");
	} else {
        printf(1,"Pass\n");
     6f7:	83 ec 08             	sub    $0x8,%esp
     6fa:	68 b0 25 00 00       	push   $0x25b0
     6ff:	6a 01                	push   $0x1
     701:	e8 da 12 00 00       	call   19e0 <printf>
     706:	83 c4 10             	add    $0x10,%esp
    }
	printf(1, "\t- Requesting Read-Only access for Read-Only region : ");
     709:	83 ec 08             	sub    $0x8,%esp
     70c:	68 b0 20 00 00       	push   $0x20b0
     711:	6a 01                	push   $0x1
     713:	e8 c8 12 00 00       	call   19e0 <printf>
	ptr = (char*)shmat(shmid4, (void *)(0), SHM_RDONLY);
     718:	83 c4 0c             	add    $0xc,%esp
     71b:	68 00 10 00 00       	push   $0x1000
     720:	6a 00                	push   $0x0
     722:	57                   	push   %edi
     723:	e8 e3 11 00 00       	call   190b <shmat>
	if((int)ptr != -1) {
     728:	83 c4 10             	add    $0x10,%esp
	ptr = (char*)shmat(shmid4, (void *)(0), SHM_RDONLY);
     72b:	89 c7                	mov    %eax,%edi
	if((int)ptr != -1) {
     72d:	83 f8 ff             	cmp    $0xffffffff,%eax
     730:	0f 84 9a 04 00 00    	je     bd0 <shmatTest+0x6e0>
		printf(1,"Allowed ! : Pass\n");
     736:	83 ec 08             	sub    $0x8,%esp
     739:	68 77 25 00 00       	push   $0x2577
     73e:	6a 01                	push   $0x1
     740:	e8 9b 12 00 00       	call   19e0 <printf>
     745:	83 c4 10             	add    $0x10,%esp
	} else {    
		printf(1, "Not allowed ! : Fail\n");
	}
    printf(1, "\t- Corresponding detach : ");
     748:	83 ec 08             	sub    $0x8,%esp
     74b:	68 5c 25 00 00       	push   $0x255c
     750:	6a 01                	push   $0x1
     752:	e8 89 12 00 00       	call   19e0 <printf>
    dt = shmdt(ptr);
     757:	89 3c 24             	mov    %edi,(%esp)
     75a:	e8 b4 11 00 00       	call   1913 <shmdt>
    if(dt < 0) {
     75f:	83 c4 10             	add    $0x10,%esp
     762:	85 c0                	test   %eax,%eax
     764:	0f 88 a6 03 00 00    	js     b10 <shmatTest+0x620>
		printf(1, "Fail\n");
	} else {
        printf(1,"Pass\n");
     76a:	83 ec 08             	sub    $0x8,%esp
     76d:	68 b0 25 00 00       	push   $0x25b0
     772:	6a 01                	push   $0x1
     774:	e8 67 12 00 00       	call   19e0 <printf>
     779:	83 c4 10             	add    $0x10,%esp
    }
    printf(1, "\t- Checking rounding down for non page-aligned address within range : ");
     77c:	83 ec 08             	sub    $0x8,%esp
     77f:	68 e8 20 00 00       	push   $0x20e8
     784:	6a 01                	push   $0x1
     786:	e8 55 12 00 00       	call   19e0 <printf>
	// test attachment at rounded address after sending non page-aligned address with SHM_RND flag
	ptr = (char *)shmat(shmid, (void *)(allowedAddr + 7), SHM_RND);
     78b:	83 c4 0c             	add    $0xc,%esp
     78e:	68 00 20 00 00       	push   $0x2000
     793:	68 07 30 00 7f       	push   $0x7f003007
     798:	53                   	push   %ebx
     799:	e8 6d 11 00 00       	call   190b <shmat>

	if((uint)ptr == allowedAddr) {
     79e:	83 c4 10             	add    $0x10,%esp
	ptr = (char *)shmat(shmid, (void *)(allowedAddr + 7), SHM_RND);
     7a1:	89 c7                	mov    %eax,%edi
	if((uint)ptr == allowedAddr) {
     7a3:	3d 00 30 00 7f       	cmp    $0x7f003000,%eax
     7a8:	0f 84 92 04 00 00    	je     c40 <shmatTest+0x750>
		printf(1,"Pass\n");
	} else {
		printf(1, "Fail\n");
     7ae:	83 ec 08             	sub    $0x8,%esp
     7b1:	68 a6 25 00 00       	push   $0x25a6
     7b6:	6a 01                	push   $0x1
     7b8:	e8 23 12 00 00       	call   19e0 <printf>
     7bd:	83 c4 10             	add    $0x10,%esp
	}
    printf(1, "\t- Corresponding detach : ");
     7c0:	83 ec 08             	sub    $0x8,%esp
     7c3:	68 5c 25 00 00       	push   $0x255c
     7c8:	6a 01                	push   $0x1
     7ca:	e8 11 12 00 00       	call   19e0 <printf>
    dt = shmdt(ptr);
     7cf:	89 3c 24             	mov    %edi,(%esp)
     7d2:	e8 3c 11 00 00       	call   1913 <shmdt>
    if(dt < 0) {
     7d7:	83 c4 10             	add    $0x10,%esp
     7da:	85 c0                	test   %eax,%eax
     7dc:	0f 88 0e 03 00 00    	js     af0 <shmatTest+0x600>
		printf(1, "Fail\n");
	} else {
        printf(1,"Pass\n");
     7e2:	83 ec 08             	sub    $0x8,%esp
     7e5:	68 b0 25 00 00       	push   $0x25b0
     7ea:	6a 01                	push   $0x1
     7ec:	e8 ef 11 00 00       	call   19e0 <printf>
     7f1:	83 c4 10             	add    $0x10,%esp
    }
    printf(1, "\t- Checking compactness of memory mappings & filling of holes: ");
     7f4:	83 ec 08             	sub    $0x8,%esp
     7f7:	68 30 21 00 00       	push   $0x2130
     7fc:	6a 01                	push   $0x1
     7fe:	e8 dd 11 00 00       	call   19e0 <printf>
    ptr = (char *)shmat(shmid, (void *)0, 0);
     803:	83 c4 0c             	add    $0xc,%esp
     806:	6a 00                	push   $0x0
     808:	6a 00                	push   $0x0
     80a:	53                   	push   %ebx
     80b:	e8 fb 10 00 00       	call   190b <shmat>

	// attach at first available address
	if((uint)ptr != HEAPLIMIT) {
     810:	83 c4 10             	add    $0x10,%esp
    ptr = (char *)shmat(shmid, (void *)0, 0);
     813:	89 c7                	mov    %eax,%edi
	if((uint)ptr != HEAPLIMIT) {
     815:	3d 00 00 00 7f       	cmp    $0x7f000000,%eax
     81a:	0f 85 20 02 00 00    	jne    a40 <shmatTest+0x550>
        printf(1,"%x",(uint)ptr);
        shmdt(ptr);
        goto nexttest;
	}
	// deliberately skip one address in between to check compactness of attachment 
    ptr2 = (char *)shmat(shmid2, (void *)(HEAPLIMIT + 2*PGSIZE), 0);
     820:	83 ec 04             	sub    $0x4,%esp
     823:	6a 00                	push   $0x0
     825:	68 00 20 00 7f       	push   $0x7f002000
     82a:	56                   	push   %esi
     82b:	e8 db 10 00 00       	call   190b <shmat>
    if((uint)ptr2 != HEAPLIMIT+ 2*PGSIZE) {
     830:	83 c4 10             	add    $0x10,%esp
    ptr2 = (char *)shmat(shmid2, (void *)(HEAPLIMIT + 2*PGSIZE), 0);
     833:	89 c7                	mov    %eax,%edi
    if((uint)ptr2 != HEAPLIMIT+ 2*PGSIZE) {
     835:	3d 00 20 00 7f       	cmp    $0x7f002000,%eax
     83a:	0f 84 20 04 00 00    	je     c60 <shmatTest+0x770>
		printf(1, "Fail\n");
     840:	83 ec 08             	sub    $0x8,%esp
     843:	68 a6 25 00 00       	push   $0x25a6
     848:	6a 01                	push   $0x1
     84a:	e8 91 11 00 00       	call   19e0 <printf>
        shmdt(ptr2);
     84f:	89 3c 24             	mov    %edi,(%esp)
     852:	e8 bc 10 00 00       	call   1913 <shmdt>
        goto nexttest;
     857:	83 c4 10             	add    $0x10,%esp
    if(dt < 0) {
		printf(1, "\t\t- Fail\n");
	} else {
        printf(1,"\t\t- Pass\n");
    }
	nexttest: printf(1, "\t- Trying to overwrite existing mapping without SHM_REMAP flag : ");
     85a:	83 ec 08             	sub    $0x8,%esp
     85d:	68 94 21 00 00       	push   $0x2194
     862:	6a 01                	push   $0x1
     864:	e8 77 11 00 00       	call   19e0 <printf>
    ptr = (char *)shmat(shmid, (void *)HEAPLIMIT, 0);
     869:	83 c4 0c             	add    $0xc,%esp
     86c:	6a 00                	push   $0x0
     86e:	68 00 00 00 7f       	push   $0x7f000000
     873:	53                   	push   %ebx
     874:	e8 92 10 00 00       	call   190b <shmat>
	if((uint)ptr != HEAPLIMIT) {
     879:	83 c4 10             	add    $0x10,%esp
    ptr = (char *)shmat(shmid, (void *)HEAPLIMIT, 0);
     87c:	89 c7                	mov    %eax,%edi
	if((uint)ptr != HEAPLIMIT) {
     87e:	3d 00 00 00 7f       	cmp    $0x7f000000,%eax
     883:	0f 85 f7 01 00 00    	jne    a80 <shmatTest+0x590>
		printf(1, "Fail\n");
        shmdt(ptr);
        goto nexttest2;
	}
    ptr2 = (char *)shmat(shmid2, (void *)(HEAPLIMIT + PGSIZE), 0);
     889:	83 ec 04             	sub    $0x4,%esp
     88c:	6a 00                	push   $0x0
     88e:	68 00 10 00 7f       	push   $0x7f001000
     893:	56                   	push   %esi
     894:	e8 72 10 00 00       	call   190b <shmat>
    if((uint)ptr2 != HEAPLIMIT+ PGSIZE) {
     899:	83 c4 10             	add    $0x10,%esp
    ptr2 = (char *)shmat(shmid2, (void *)(HEAPLIMIT + PGSIZE), 0);
     89c:	89 c7                	mov    %eax,%edi
    if((uint)ptr2 != HEAPLIMIT+ PGSIZE) {
     89e:	3d 00 10 00 7f       	cmp    $0x7f001000,%eax
     8a3:	0f 85 d7 01 00 00    	jne    a80 <shmatTest+0x590>
		printf(1, "Fail\n");
        shmdt(ptr2);
        goto nexttest2;
	}
    ptr3 = (char *)shmat(shmid3, (void *)(HEAPLIMIT), 0);
     8a9:	83 ec 04             	sub    $0x4,%esp
     8ac:	6a 00                	push   $0x0
     8ae:	68 00 00 00 7f       	push   $0x7f000000
     8b3:	ff b5 54 fe ff ff    	pushl  -0x1ac(%ebp)
     8b9:	e8 4d 10 00 00       	call   190b <shmat>

	// -1 should be returned as remapping isnt allowed with explicit setting of SHM_REMAP flag
    if((int)ptr3 < 0) {
     8be:	83 c4 10             	add    $0x10,%esp
     8c1:	85 c0                	test   %eax,%eax
     8c3:	0f 88 27 05 00 00    	js     df0 <shmatTest+0x900>
		printf(1,"Cannot Overwrite! : Pass\n");
	} else {
        shmdt(ptr3);
     8c9:	83 ec 0c             	sub    $0xc,%esp
     8cc:	50                   	push   %eax
     8cd:	e8 41 10 00 00       	call   1913 <shmdt>
		printf(1, "Fail\n");
     8d2:	58                   	pop    %eax
     8d3:	5a                   	pop    %edx
     8d4:	68 a6 25 00 00       	push   $0x25a6
     8d9:	6a 01                	push   $0x1
     8db:	e8 00 11 00 00       	call   19e0 <printf>
     8e0:	83 c4 10             	add    $0x10,%esp
	}
    printf(1, "\t- Corresponding detaches (2) : \n ");
     8e3:	83 ec 08             	sub    $0x8,%esp
     8e6:	68 d8 21 00 00       	push   $0x21d8
     8eb:	6a 01                	push   $0x1
     8ed:	e8 ee 10 00 00       	call   19e0 <printf>
    dt = shmdt(ptr);
     8f2:	c7 04 24 00 00 00 7f 	movl   $0x7f000000,(%esp)
     8f9:	e8 15 10 00 00       	call   1913 <shmdt>
    if(dt < 0) {
     8fe:	83 c4 10             	add    $0x10,%esp
     901:	85 c0                	test   %eax,%eax
     903:	0f 88 e7 05 00 00    	js     ef0 <shmatTest+0xa00>
		printf(1, "\t\t- Fail\n");
	} else {
        printf(1,"\t\t- Pass\n");
     909:	83 ec 08             	sub    $0x8,%esp
     90c:	68 ac 25 00 00       	push   $0x25ac
     911:	6a 01                	push   $0x1
     913:	e8 c8 10 00 00       	call   19e0 <printf>
     918:	83 c4 10             	add    $0x10,%esp
    }
    dt = shmdt(ptr2);
     91b:	83 ec 0c             	sub    $0xc,%esp
     91e:	68 00 10 00 7f       	push   $0x7f001000
     923:	e8 eb 0f 00 00       	call   1913 <shmdt>
    if(dt < 0) {
     928:	83 c4 10             	add    $0x10,%esp
     92b:	85 c0                	test   %eax,%eax
     92d:	0f 88 9d 05 00 00    	js     ed0 <shmatTest+0x9e0>
		printf(1, "\t\t- Fail\n");
	} else {
        printf(1,"\t\t- Pass\n");
     933:	83 ec 08             	sub    $0x8,%esp
     936:	68 ac 25 00 00       	push   $0x25ac
     93b:	6a 01                	push   $0x1
     93d:	e8 9e 10 00 00       	call   19e0 <printf>
     942:	83 c4 10             	add    $0x10,%esp
     945:	8d 76 00             	lea    0x0(%esi),%esi
    }
	nexttest2: printf(1, "\t- Trying to overwrite existing mapping with SHM_REMAP flag: ");
     948:	83 ec 08             	sub    $0x8,%esp
     94b:	68 fc 21 00 00       	push   $0x21fc
     950:	6a 01                	push   $0x1
     952:	e8 89 10 00 00       	call   19e0 <printf>
    ptr = (char *)shmat(shmid, (void *)HEAPLIMIT, 0);
     957:	83 c4 0c             	add    $0xc,%esp
     95a:	6a 00                	push   $0x0
     95c:	68 00 00 00 7f       	push   $0x7f000000
     961:	53                   	push   %ebx
     962:	e8 a4 0f 00 00       	call   190b <shmat>
	if((uint)ptr != HEAPLIMIT) {
     967:	83 c4 10             	add    $0x10,%esp
    ptr = (char *)shmat(shmid, (void *)HEAPLIMIT, 0);
     96a:	89 c7                	mov    %eax,%edi
	if((uint)ptr != HEAPLIMIT) {
     96c:	3d 00 00 00 7f       	cmp    $0x7f000000,%eax
     971:	0f 84 29 01 00 00    	je     aa0 <shmatTest+0x5b0>
		printf(1, "Fail\n");
     977:	83 ec 08             	sub    $0x8,%esp
     97a:	68 a6 25 00 00       	push   $0x25a6
     97f:	6a 01                	push   $0x1
     981:	e8 5a 10 00 00       	call   19e0 <printf>
        shmdt(ptr);
     986:	89 3c 24             	mov    %edi,(%esp)
     989:	e8 85 0f 00 00       	call   1913 <shmdt>
        goto nexttest3;
     98e:	83 c4 10             	add    $0x10,%esp
    if(dt < 0) {
		printf(1, "\t\t- Pass\n");
	} else {
        printf(1,"\t\t- Fail\n");
    }
    nexttest3: printf(1, "\t- Trying to exhaust all regions for the process: ");
     991:	83 ec 08             	sub    $0x8,%esp
	for(i = 0; ; i++){
     994:	31 f6                	xor    %esi,%esi
    nexttest3: printf(1, "\t- Trying to exhaust all regions for the process: ");
     996:	68 3c 22 00 00       	push   $0x223c
     99b:	6a 01                	push   $0x1
     99d:	e8 3e 10 00 00       	call   19e0 <printf>
     9a2:	83 c4 10             	add    $0x10,%esp
     9a5:	eb 0c                	jmp    9b3 <shmatTest+0x4c3>
     9a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     9ae:	66 90                	xchg   %ax,%ax
	for(i = 0; ; i++){
     9b0:	83 c6 01             	add    $0x1,%esi
		ptrarr[i] = (char*)shmat(shmid,(void*)0,0);
     9b3:	83 ec 04             	sub    $0x4,%esp
     9b6:	6a 00                	push   $0x0
     9b8:	6a 00                	push   $0x0
     9ba:	53                   	push   %ebx
     9bb:	e8 4b 0f 00 00       	call   190b <shmat>
		if((int)ptrarr[i] < 0){
     9c0:	83 c4 10             	add    $0x10,%esp
		ptrarr[i] = (char*)shmat(shmid,(void*)0,0);
     9c3:	89 84 b5 58 fe ff ff 	mov    %eax,-0x1a8(%ebp,%esi,4)
		if((int)ptrarr[i] < 0){
     9ca:	85 c0                	test   %eax,%eax
     9cc:	79 e2                	jns    9b0 <shmatTest+0x4c0>
			break;
		}
	}
	// should not allow a process to attach more than prescribed regions
	if(i == SHAREDREGIONS) {
     9ce:	83 fe 40             	cmp    $0x40,%esi
     9d1:	0f 84 39 02 00 00    	je     c10 <shmatTest+0x720>
		printf(1, "Pass\n");
	} else {
		printf(1,"Fail\n");
     9d7:	83 ec 08             	sub    $0x8,%esp
     9da:	68 a6 25 00 00       	push   $0x25a6
     9df:	6a 01                	push   $0x1
     9e1:	e8 fa 0f 00 00       	call   19e0 <printf>
	}
	printf(1, "\t- Corresponding detaches (%d) : \n ",i);
     9e6:	83 c4 0c             	add    $0xc,%esp
     9e9:	56                   	push   %esi
     9ea:	68 70 22 00 00       	push   $0x2270
     9ef:	6a 01                	push   $0x1
     9f1:	e8 ea 0f 00 00       	call   19e0 <printf>
	for(int j = 0; j < i; j++)
     9f6:	83 c4 10             	add    $0x10,%esp
     9f9:	85 f6                	test   %esi,%esi
     9fb:	74 63                	je     a60 <shmatTest+0x570>
	for(i = 0; ; i++){
     9fd:	31 db                	xor    %ebx,%ebx
     9ff:	eb 0e                	jmp    a0f <shmatTest+0x51f>
     a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	for(int j = 0; j < i; j++)
     a08:	83 c3 01             	add    $0x1,%ebx
     a0b:	39 de                	cmp    %ebx,%esi
     a0d:	7e 51                	jle    a60 <shmatTest+0x570>
	{
		if(shmdt(ptrarr[j]) < 0) {
     a0f:	83 ec 0c             	sub    $0xc,%esp
     a12:	ff b4 9d 58 fe ff ff 	pushl  -0x1a8(%ebp,%ebx,4)
     a19:	e8 f5 0e 00 00       	call   1913 <shmdt>
     a1e:	83 c4 10             	add    $0x10,%esp
     a21:	85 c0                	test   %eax,%eax
     a23:	79 e3                	jns    a08 <shmatTest+0x518>
		printf(1, "Fail\n");
     a25:	83 ec 08             	sub    $0x8,%esp
     a28:	68 a6 25 00 00       	push   $0x25a6
     a2d:	6a 01                	push   $0x1
     a2f:	e8 ac 0f 00 00       	call   19e0 <printf>
        return;
     a34:	83 c4 10             	add    $0x10,%esp
			goto ret;
		}
	}
	printf(1, "\t\t- All Passed\n");
	ret: return;
}
     a37:	8d 65 f4             	lea    -0xc(%ebp),%esp
     a3a:	5b                   	pop    %ebx
     a3b:	5e                   	pop    %esi
     a3c:	5f                   	pop    %edi
     a3d:	5d                   	pop    %ebp
     a3e:	c3                   	ret    
     a3f:	90                   	nop
		printf(1, "Fail\n");
     a40:	83 ec 08             	sub    $0x8,%esp
     a43:	68 a6 25 00 00       	push   $0x25a6
     a48:	6a 01                	push   $0x1
     a4a:	e8 91 0f 00 00       	call   19e0 <printf>
        printf(1,"%x",(uint)ptr);
     a4f:	83 c4 0c             	add    $0xc,%esp
     a52:	57                   	push   %edi
     a53:	68 9f 25 00 00       	push   $0x259f
     a58:	e9 eb fd ff ff       	jmp    848 <shmatTest+0x358>
     a5d:	8d 76 00             	lea    0x0(%esi),%esi
	printf(1, "\t\t- All Passed\n");
     a60:	83 ec 08             	sub    $0x8,%esp
     a63:	68 e7 25 00 00       	push   $0x25e7
     a68:	6a 01                	push   $0x1
     a6a:	e8 71 0f 00 00       	call   19e0 <printf>
     a6f:	83 c4 10             	add    $0x10,%esp
}
     a72:	8d 65 f4             	lea    -0xc(%ebp),%esp
     a75:	5b                   	pop    %ebx
     a76:	5e                   	pop    %esi
     a77:	5f                   	pop    %edi
     a78:	5d                   	pop    %ebp
     a79:	c3                   	ret    
     a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		printf(1, "Fail\n");
     a80:	83 ec 08             	sub    $0x8,%esp
     a83:	68 a6 25 00 00       	push   $0x25a6
     a88:	6a 01                	push   $0x1
     a8a:	e8 51 0f 00 00       	call   19e0 <printf>
        shmdt(ptr2);
     a8f:	89 3c 24             	mov    %edi,(%esp)
     a92:	e8 7c 0e 00 00       	call   1913 <shmdt>
        goto nexttest2;
     a97:	83 c4 10             	add    $0x10,%esp
     a9a:	e9 a9 fe ff ff       	jmp    948 <shmatTest+0x458>
     a9f:	90                   	nop
    ptr2 = (char *)shmat(shmid2, (void *)(HEAPLIMIT + PGSIZE), 0);
     aa0:	83 ec 04             	sub    $0x4,%esp
     aa3:	6a 00                	push   $0x0
     aa5:	68 00 10 00 7f       	push   $0x7f001000
     aaa:	56                   	push   %esi
     aab:	e8 5b 0e 00 00       	call   190b <shmat>
    if((uint)ptr2 != HEAPLIMIT+ PGSIZE) {
     ab0:	83 c4 10             	add    $0x10,%esp
    ptr2 = (char *)shmat(shmid2, (void *)(HEAPLIMIT + PGSIZE), 0);
     ab3:	89 c6                	mov    %eax,%esi
    if((uint)ptr2 != HEAPLIMIT+ PGSIZE) {
     ab5:	3d 00 10 00 7f       	cmp    $0x7f001000,%eax
     aba:	0f 84 68 02 00 00    	je     d28 <shmatTest+0x838>
		printf(1, "Fail\n");
     ac0:	83 ec 08             	sub    $0x8,%esp
     ac3:	68 a6 25 00 00       	push   $0x25a6
     ac8:	6a 01                	push   $0x1
     aca:	e8 11 0f 00 00       	call   19e0 <printf>
        shmdt(ptr);
     acf:	c7 04 24 00 00 00 7f 	movl   $0x7f000000,(%esp)
     ad6:	e8 38 0e 00 00       	call   1913 <shmdt>
        shmdt(ptr2);
     adb:	89 34 24             	mov    %esi,(%esp)
     ade:	e8 30 0e 00 00       	call   1913 <shmdt>
        goto nexttest3;
     ae3:	83 c4 10             	add    $0x10,%esp
     ae6:	e9 a6 fe ff ff       	jmp    991 <shmatTest+0x4a1>
     aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     aef:	90                   	nop
		printf(1, "Fail\n");
     af0:	83 ec 08             	sub    $0x8,%esp
     af3:	68 a6 25 00 00       	push   $0x25a6
     af8:	6a 01                	push   $0x1
     afa:	e8 e1 0e 00 00       	call   19e0 <printf>
     aff:	83 c4 10             	add    $0x10,%esp
     b02:	e9 ed fc ff ff       	jmp    7f4 <shmatTest+0x304>
     b07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     b0e:	66 90                	xchg   %ax,%ax
		printf(1, "Fail\n");
     b10:	83 ec 08             	sub    $0x8,%esp
     b13:	68 a6 25 00 00       	push   $0x25a6
     b18:	6a 01                	push   $0x1
     b1a:	e8 c1 0e 00 00       	call   19e0 <printf>
     b1f:	83 c4 10             	add    $0x10,%esp
     b22:	e9 55 fc ff ff       	jmp    77c <shmatTest+0x28c>
     b27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     b2e:	66 90                	xchg   %ax,%ax
		printf(1, "Fail\n");
     b30:	83 ec 08             	sub    $0x8,%esp
     b33:	68 a6 25 00 00       	push   $0x25a6
     b38:	6a 01                	push   $0x1
     b3a:	e8 a1 0e 00 00       	call   19e0 <printf>
     b3f:	83 c4 10             	add    $0x10,%esp
     b42:	e9 c2 fb ff ff       	jmp    709 <shmatTest+0x219>
     b47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     b4e:	66 90                	xchg   %ax,%ax
		printf(1,"Pass\n");
     b50:	83 ec 08             	sub    $0x8,%esp
     b53:	68 b0 25 00 00       	push   $0x25b0
     b58:	6a 01                	push   $0x1
     b5a:	e8 81 0e 00 00       	call   19e0 <printf>
     b5f:	83 c4 10             	add    $0x10,%esp
     b62:	e9 25 fb ff ff       	jmp    68c <shmatTest+0x19c>
     b67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     b6e:	66 90                	xchg   %ax,%ax
		printf(1,"Pass\n");
     b70:	83 ec 08             	sub    $0x8,%esp
     b73:	68 b0 25 00 00       	push   $0x25b0
     b78:	6a 01                	push   $0x1
     b7a:	e8 61 0e 00 00       	call   19e0 <printf>
     b7f:	83 c4 10             	add    $0x10,%esp
     b82:	e9 c9 fa ff ff       	jmp    650 <shmatTest+0x160>
     b87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     b8e:	66 90                	xchg   %ax,%ax
		printf(1,"Pass\n");
     b90:	83 ec 08             	sub    $0x8,%esp
     b93:	68 b0 25 00 00       	push   $0x25b0
     b98:	6a 01                	push   $0x1
     b9a:	e8 41 0e 00 00       	call   19e0 <printf>
     b9f:	83 c4 10             	add    $0x10,%esp
     ba2:	e9 6d fa ff ff       	jmp    614 <shmatTest+0x124>
     ba7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     bae:	66 90                	xchg   %ax,%ax
		printf(1,"Pass\n");
     bb0:	83 ec 08             	sub    $0x8,%esp
     bb3:	68 b0 25 00 00       	push   $0x25b0
     bb8:	6a 01                	push   $0x1
     bba:	e8 21 0e 00 00       	call   19e0 <printf>
     bbf:	83 c4 10             	add    $0x10,%esp
     bc2:	e9 10 fa ff ff       	jmp    5d7 <shmatTest+0xe7>
     bc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     bce:	66 90                	xchg   %ax,%ax
		printf(1, "Not allowed ! : Fail\n");
     bd0:	83 ec 08             	sub    $0x8,%esp
     bd3:	68 89 25 00 00       	push   $0x2589
     bd8:	6a 01                	push   $0x1
     bda:	e8 01 0e 00 00       	call   19e0 <printf>
     bdf:	83 c4 10             	add    $0x10,%esp
     be2:	e9 61 fb ff ff       	jmp    748 <shmatTest+0x258>
     be7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     bee:	66 90                	xchg   %ax,%ax
		printf(1,"Pass\n");
     bf0:	83 ec 08             	sub    $0x8,%esp
     bf3:	68 b0 25 00 00       	push   $0x25b0
     bf8:	6a 01                	push   $0x1
     bfa:	e8 e1 0d 00 00       	call   19e0 <printf>
     bff:	83 c4 10             	add    $0x10,%esp
     c02:	e9 ca fa ff ff       	jmp    6d1 <shmatTest+0x1e1>
     c07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     c0e:	66 90                	xchg   %ax,%ax
		printf(1, "Pass\n");
     c10:	83 ec 08             	sub    $0x8,%esp
     c13:	68 b0 25 00 00       	push   $0x25b0
     c18:	6a 01                	push   $0x1
     c1a:	e8 c1 0d 00 00       	call   19e0 <printf>
	printf(1, "\t- Corresponding detaches (%d) : \n ",i);
     c1f:	83 c4 0c             	add    $0xc,%esp
     c22:	6a 40                	push   $0x40
     c24:	68 70 22 00 00       	push   $0x2270
     c29:	6a 01                	push   $0x1
     c2b:	e8 b0 0d 00 00       	call   19e0 <printf>
     c30:	83 c4 10             	add    $0x10,%esp
     c33:	e9 c5 fd ff ff       	jmp    9fd <shmatTest+0x50d>
     c38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     c3f:	90                   	nop
		printf(1,"Pass\n");
     c40:	83 ec 08             	sub    $0x8,%esp
     c43:	68 b0 25 00 00       	push   $0x25b0
     c48:	6a 01                	push   $0x1
     c4a:	e8 91 0d 00 00       	call   19e0 <printf>
     c4f:	83 c4 10             	add    $0x10,%esp
     c52:	e9 69 fb ff ff       	jmp    7c0 <shmatTest+0x2d0>
     c57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     c5e:	66 90                	xchg   %ax,%ax
    ptr3 = (char *)shmat(shmid3, (void *)(0), 0);
     c60:	83 ec 04             	sub    $0x4,%esp
     c63:	6a 00                	push   $0x0
     c65:	6a 00                	push   $0x0
     c67:	ff b5 54 fe ff ff    	pushl  -0x1ac(%ebp)
     c6d:	e8 99 0c 00 00       	call   190b <shmat>
    if((uint)ptr3 == HEAPLIMIT + PGSIZE) {
     c72:	83 c4 10             	add    $0x10,%esp
    ptr3 = (char *)shmat(shmid3, (void *)(0), 0);
     c75:	89 c7                	mov    %eax,%edi
    if((uint)ptr3 == HEAPLIMIT + PGSIZE) {
     c77:	3d 00 10 00 7f       	cmp    $0x7f001000,%eax
     c7c:	0f 84 9c 02 00 00    	je     f1e <shmatTest+0xa2e>
		printf(1, "Fail\n");
     c82:	83 ec 08             	sub    $0x8,%esp
     c85:	68 a6 25 00 00       	push   $0x25a6
     c8a:	6a 01                	push   $0x1
     c8c:	e8 4f 0d 00 00       	call   19e0 <printf>
     c91:	83 c4 10             	add    $0x10,%esp
    printf(1, "\t- Corresponding detaches (3) : \n ");
     c94:	83 ec 08             	sub    $0x8,%esp
     c97:	68 70 21 00 00       	push   $0x2170
     c9c:	6a 01                	push   $0x1
     c9e:	e8 3d 0d 00 00       	call   19e0 <printf>
    dt = shmdt(ptr);
     ca3:	c7 04 24 00 00 00 7f 	movl   $0x7f000000,(%esp)
     caa:	e8 64 0c 00 00       	call   1913 <shmdt>
    if(dt < 0) {
     caf:	83 c4 10             	add    $0x10,%esp
     cb2:	85 c0                	test   %eax,%eax
     cb4:	0f 88 f6 01 00 00    	js     eb0 <shmatTest+0x9c0>
        printf(1,"\t\t- Pass\n");
     cba:	83 ec 08             	sub    $0x8,%esp
     cbd:	68 ac 25 00 00       	push   $0x25ac
     cc2:	6a 01                	push   $0x1
     cc4:	e8 17 0d 00 00       	call   19e0 <printf>
     cc9:	83 c4 10             	add    $0x10,%esp
    dt = shmdt(ptr2);
     ccc:	83 ec 0c             	sub    $0xc,%esp
     ccf:	68 00 20 00 7f       	push   $0x7f002000
     cd4:	e8 3a 0c 00 00       	call   1913 <shmdt>
    if(dt < 0) {
     cd9:	83 c4 10             	add    $0x10,%esp
     cdc:	85 c0                	test   %eax,%eax
     cde:	0f 88 ac 01 00 00    	js     e90 <shmatTest+0x9a0>
        printf(1,"\t\t- Pass\n");
     ce4:	83 ec 08             	sub    $0x8,%esp
     ce7:	68 ac 25 00 00       	push   $0x25ac
     cec:	6a 01                	push   $0x1
     cee:	e8 ed 0c 00 00       	call   19e0 <printf>
     cf3:	83 c4 10             	add    $0x10,%esp
    dt = shmdt(ptr3);
     cf6:	83 ec 0c             	sub    $0xc,%esp
     cf9:	57                   	push   %edi
     cfa:	e8 14 0c 00 00       	call   1913 <shmdt>
    if(dt < 0) {
     cff:	83 c4 10             	add    $0x10,%esp
     d02:	85 c0                	test   %eax,%eax
     d04:	0f 88 66 01 00 00    	js     e70 <shmatTest+0x980>
        printf(1,"\t\t- Pass\n");
     d0a:	83 ec 08             	sub    $0x8,%esp
     d0d:	68 ac 25 00 00       	push   $0x25ac
     d12:	6a 01                	push   $0x1
     d14:	e8 c7 0c 00 00       	call   19e0 <printf>
     d19:	83 c4 10             	add    $0x10,%esp
     d1c:	e9 39 fb ff ff       	jmp    85a <shmatTest+0x36a>
     d21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ptr3 = (char *)shmat(shmid3, (void *)(HEAPLIMIT), SHM_REMAP);
     d28:	83 ec 04             	sub    $0x4,%esp
     d2b:	68 00 40 00 00       	push   $0x4000
     d30:	68 00 00 00 7f       	push   $0x7f000000
     d35:	ff b5 54 fe ff ff    	pushl  -0x1ac(%ebp)
     d3b:	e8 cb 0b 00 00       	call   190b <shmat>
    if((uint)ptr3 == HEAPLIMIT) {
     d40:	83 c4 10             	add    $0x10,%esp
    ptr3 = (char *)shmat(shmid3, (void *)(HEAPLIMIT), SHM_REMAP);
     d43:	89 c6                	mov    %eax,%esi
    if((uint)ptr3 == HEAPLIMIT) {
     d45:	3d 00 00 00 7f       	cmp    $0x7f000000,%eax
     d4a:	0f 84 b7 01 00 00    	je     f07 <shmatTest+0xa17>
		printf(1, "Fail\n");
     d50:	83 ec 08             	sub    $0x8,%esp
     d53:	68 a6 25 00 00       	push   $0x25a6
     d58:	6a 01                	push   $0x1
     d5a:	e8 81 0c 00 00       	call   19e0 <printf>
     d5f:	83 c4 10             	add    $0x10,%esp
    printf(1, "\t- Corresponding detaches (3) : \n ");
     d62:	83 ec 08             	sub    $0x8,%esp
     d65:	68 70 21 00 00       	push   $0x2170
     d6a:	6a 01                	push   $0x1
     d6c:	e8 6f 0c 00 00       	call   19e0 <printf>
    dt = shmdt(ptr);
     d71:	c7 04 24 00 00 00 7f 	movl   $0x7f000000,(%esp)
     d78:	e8 96 0b 00 00       	call   1913 <shmdt>
    if(dt < 0) {
     d7d:	83 c4 10             	add    $0x10,%esp
     d80:	85 c0                	test   %eax,%eax
     d82:	0f 88 c8 00 00 00    	js     e50 <shmatTest+0x960>
        printf(1,"\t\t- Pass\n");
     d88:	83 ec 08             	sub    $0x8,%esp
     d8b:	68 ac 25 00 00       	push   $0x25ac
     d90:	6a 01                	push   $0x1
     d92:	e8 49 0c 00 00       	call   19e0 <printf>
     d97:	83 c4 10             	add    $0x10,%esp
    dt = shmdt(ptr2);
     d9a:	83 ec 0c             	sub    $0xc,%esp
     d9d:	68 00 10 00 7f       	push   $0x7f001000
     da2:	e8 6c 0b 00 00       	call   1913 <shmdt>
    if(dt < 0) {
     da7:	83 c4 10             	add    $0x10,%esp
     daa:	85 c0                	test   %eax,%eax
     dac:	0f 88 7e 00 00 00    	js     e30 <shmatTest+0x940>
        printf(1,"\t\t- Pass\n");
     db2:	83 ec 08             	sub    $0x8,%esp
     db5:	68 ac 25 00 00       	push   $0x25ac
     dba:	6a 01                	push   $0x1
     dbc:	e8 1f 0c 00 00       	call   19e0 <printf>
     dc1:	83 c4 10             	add    $0x10,%esp
    dt = shmdt(ptr3);
     dc4:	83 ec 0c             	sub    $0xc,%esp
     dc7:	56                   	push   %esi
     dc8:	e8 46 0b 00 00       	call   1913 <shmdt>
    if(dt < 0) {
     dcd:	83 c4 10             	add    $0x10,%esp
     dd0:	85 c0                	test   %eax,%eax
     dd2:	78 3c                	js     e10 <shmatTest+0x920>
        printf(1,"\t\t- Fail\n");
     dd4:	83 ec 08             	sub    $0x8,%esp
     dd7:	68 a2 25 00 00       	push   $0x25a2
     ddc:	6a 01                	push   $0x1
     dde:	e8 fd 0b 00 00       	call   19e0 <printf>
     de3:	83 c4 10             	add    $0x10,%esp
     de6:	e9 a6 fb ff ff       	jmp    991 <shmatTest+0x4a1>
     deb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     def:	90                   	nop
		printf(1,"Cannot Overwrite! : Pass\n");
     df0:	83 ec 08             	sub    $0x8,%esp
     df3:	68 b6 25 00 00       	push   $0x25b6
     df8:	6a 01                	push   $0x1
     dfa:	e8 e1 0b 00 00       	call   19e0 <printf>
     dff:	83 c4 10             	add    $0x10,%esp
     e02:	e9 dc fa ff ff       	jmp    8e3 <shmatTest+0x3f3>
     e07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     e0e:	66 90                	xchg   %ax,%ax
		printf(1, "\t\t- Pass\n");
     e10:	83 ec 08             	sub    $0x8,%esp
     e13:	68 ac 25 00 00       	push   $0x25ac
     e18:	6a 01                	push   $0x1
     e1a:	e8 c1 0b 00 00       	call   19e0 <printf>
     e1f:	83 c4 10             	add    $0x10,%esp
     e22:	e9 6a fb ff ff       	jmp    991 <shmatTest+0x4a1>
     e27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     e2e:	66 90                	xchg   %ax,%ax
		printf(1, "\t\t- Fail\n");
     e30:	83 ec 08             	sub    $0x8,%esp
     e33:	68 a2 25 00 00       	push   $0x25a2
     e38:	6a 01                	push   $0x1
     e3a:	e8 a1 0b 00 00       	call   19e0 <printf>
     e3f:	83 c4 10             	add    $0x10,%esp
     e42:	e9 7d ff ff ff       	jmp    dc4 <shmatTest+0x8d4>
     e47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     e4e:	66 90                	xchg   %ax,%ax
		printf(1, "\t\t- Fail\n");
     e50:	83 ec 08             	sub    $0x8,%esp
     e53:	68 a2 25 00 00       	push   $0x25a2
     e58:	6a 01                	push   $0x1
     e5a:	e8 81 0b 00 00       	call   19e0 <printf>
     e5f:	83 c4 10             	add    $0x10,%esp
     e62:	e9 33 ff ff ff       	jmp    d9a <shmatTest+0x8aa>
     e67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     e6e:	66 90                	xchg   %ax,%ax
		printf(1, "\t\t- Fail\n");
     e70:	83 ec 08             	sub    $0x8,%esp
     e73:	68 a2 25 00 00       	push   $0x25a2
     e78:	6a 01                	push   $0x1
     e7a:	e8 61 0b 00 00       	call   19e0 <printf>
     e7f:	83 c4 10             	add    $0x10,%esp
     e82:	e9 d3 f9 ff ff       	jmp    85a <shmatTest+0x36a>
     e87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     e8e:	66 90                	xchg   %ax,%ax
		printf(1, "\t\t- Fail\n");
     e90:	83 ec 08             	sub    $0x8,%esp
     e93:	68 a2 25 00 00       	push   $0x25a2
     e98:	6a 01                	push   $0x1
     e9a:	e8 41 0b 00 00       	call   19e0 <printf>
     e9f:	83 c4 10             	add    $0x10,%esp
     ea2:	e9 4f fe ff ff       	jmp    cf6 <shmatTest+0x806>
     ea7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     eae:	66 90                	xchg   %ax,%ax
		printf(1, "\t\t- Fail\n");
     eb0:	83 ec 08             	sub    $0x8,%esp
     eb3:	68 a2 25 00 00       	push   $0x25a2
     eb8:	6a 01                	push   $0x1
     eba:	e8 21 0b 00 00       	call   19e0 <printf>
     ebf:	83 c4 10             	add    $0x10,%esp
     ec2:	e9 05 fe ff ff       	jmp    ccc <shmatTest+0x7dc>
     ec7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     ece:	66 90                	xchg   %ax,%ax
		printf(1, "\t\t- Fail\n");
     ed0:	83 ec 08             	sub    $0x8,%esp
     ed3:	68 a2 25 00 00       	push   $0x25a2
     ed8:	6a 01                	push   $0x1
     eda:	e8 01 0b 00 00       	call   19e0 <printf>
     edf:	83 c4 10             	add    $0x10,%esp
     ee2:	e9 61 fa ff ff       	jmp    948 <shmatTest+0x458>
     ee7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     eee:	66 90                	xchg   %ax,%ax
		printf(1, "\t\t- Fail\n");
     ef0:	83 ec 08             	sub    $0x8,%esp
     ef3:	68 a2 25 00 00       	push   $0x25a2
     ef8:	6a 01                	push   $0x1
     efa:	e8 e1 0a 00 00       	call   19e0 <printf>
     eff:	83 c4 10             	add    $0x10,%esp
     f02:	e9 14 fa ff ff       	jmp    91b <shmatTest+0x42b>
		printf(1,"Can Overwrite! : Pass\n");
     f07:	83 ec 08             	sub    $0x8,%esp
     f0a:	68 d0 25 00 00       	push   $0x25d0
     f0f:	6a 01                	push   $0x1
     f11:	e8 ca 0a 00 00       	call   19e0 <printf>
     f16:	83 c4 10             	add    $0x10,%esp
     f19:	e9 44 fe ff ff       	jmp    d62 <shmatTest+0x872>
		printf(1,"Pass\n");
     f1e:	83 ec 08             	sub    $0x8,%esp
     f21:	68 b0 25 00 00       	push   $0x25b0
     f26:	6a 01                	push   $0x1
     f28:	e8 b3 0a 00 00       	call   19e0 <printf>
     f2d:	83 c4 10             	add    $0x10,%esp
     f30:	e9 5f fd ff ff       	jmp    c94 <shmatTest+0x7a4>
     f35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000f40 <shmdtTest>:

// variants of shmdt
void shmdtTest() {
     f40:	f3 0f 1e fb          	endbr32 
     f44:	55                   	push   %ebp
     f45:	89 e5                	mov    %esp,%ebp
     f47:	53                   	push   %ebx
     f48:	83 ec 0c             	sub    $0xc,%esp
	int dt,shmid;
	char* ptr;
	printf(1, "* Tests for variants of shmdt :\n");
     f4b:	68 94 22 00 00       	push   $0x2294
     f50:	6a 01                	push   $0x1
     f52:	e8 89 0a 00 00       	call   19e0 <printf>
	shmid = shmget(KEY4, 2565, 06 | IPC_CREAT);
     f57:	83 c4 0c             	add    $0xc,%esp
     f5a:	68 06 02 00 00       	push   $0x206
     f5f:	68 05 0a 00 00       	push   $0xa05
     f64:	68 d6 07 00 00       	push   $0x7d6
     f69:	e8 95 09 00 00       	call   1903 <shmget>
	ptr = (char *)shmat(shmid, (void *)0, 0);
     f6e:	83 c4 0c             	add    $0xc,%esp
     f71:	6a 00                	push   $0x0
     f73:	6a 00                	push   $0x0
     f75:	50                   	push   %eax
     f76:	e8 90 09 00 00       	call   190b <shmat>
     f7b:	89 c3                	mov    %eax,%ebx
	printf(1, "\t- Trying to detach previously attached region: ");
     f7d:	58                   	pop    %eax
     f7e:	5a                   	pop    %edx
     f7f:	68 b8 22 00 00       	push   $0x22b8
     f84:	6a 01                	push   $0x1
     f86:	e8 55 0a 00 00       	call   19e0 <printf>
	dt = shmdt(ptr);
     f8b:	89 1c 24             	mov    %ebx,(%esp)
     f8e:	e8 80 09 00 00       	call   1913 <shmdt>
    if(dt < 0) {
     f93:	83 c4 10             	add    $0x10,%esp
     f96:	85 c0                	test   %eax,%eax
     f98:	78 4e                	js     fe8 <shmdtTest+0xa8>
		printf(1, "Fail\n");
	} else {
		printf(1,"Pass\n");
     f9a:	83 ec 08             	sub    $0x8,%esp
     f9d:	68 b0 25 00 00       	push   $0x25b0
     fa2:	6a 01                	push   $0x1
     fa4:	e8 37 0a 00 00       	call   19e0 <printf>
     fa9:	83 c4 10             	add    $0x10,%esp
	}
	printf(1, "\t- Trying to detach at unattached virtual address: ");
     fac:	83 ec 08             	sub    $0x8,%esp
     faf:	68 ec 22 00 00       	push   $0x22ec
     fb4:	6a 01                	push   $0x1
     fb6:	e8 25 0a 00 00       	call   19e0 <printf>
	// try detaching address which is not previously attached
	dt = shmdt((void*)(KERNBASE - PGSIZE));
     fbb:	c7 04 24 00 f0 ff 7f 	movl   $0x7ffff000,(%esp)
     fc2:	e8 4c 09 00 00       	call   1913 <shmdt>

    if(dt < 0) {
     fc7:	83 c4 10             	add    $0x10,%esp
     fca:	85 c0                	test   %eax,%eax
     fcc:	78 32                	js     1000 <shmdtTest+0xc0>
		printf(1, "Pass\n");
	} else {
		printf(1,"Fail\n");
     fce:	83 ec 08             	sub    $0x8,%esp
     fd1:	68 a6 25 00 00       	push   $0x25a6
     fd6:	6a 01                	push   $0x1
     fd8:	e8 03 0a 00 00       	call   19e0 <printf>
	}
}	
     fdd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
		printf(1,"Fail\n");
     fe0:	83 c4 10             	add    $0x10,%esp
}	
     fe3:	c9                   	leave  
     fe4:	c3                   	ret    
     fe5:	8d 76 00             	lea    0x0(%esi),%esi
		printf(1, "Fail\n");
     fe8:	83 ec 08             	sub    $0x8,%esp
     feb:	68 a6 25 00 00       	push   $0x25a6
     ff0:	6a 01                	push   $0x1
     ff2:	e8 e9 09 00 00       	call   19e0 <printf>
     ff7:	83 c4 10             	add    $0x10,%esp
     ffa:	eb b0                	jmp    fac <shmdtTest+0x6c>
     ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		printf(1, "Pass\n");
    1000:	83 ec 08             	sub    $0x8,%esp
    1003:	68 b0 25 00 00       	push   $0x25b0
    1008:	6a 01                	push   $0x1
    100a:	e8 d1 09 00 00       	call   19e0 <printf>
}	
    100f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1012:	83 c4 10             	add    $0x10,%esp
    1015:	c9                   	leave  
    1016:	c3                   	ret    
    1017:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    101e:	66 90                	xchg   %ax,%ax

00001020 <shmctlTest>:

// variants of shmctl
void shmctlTest() {
    1020:	f3 0f 1e fb          	endbr32 
    1024:	55                   	push   %ebp
    1025:	89 e5                	mov    %esp,%ebp
    1027:	56                   	push   %esi
    1028:	53                   	push   %ebx
    1029:	83 ec 28             	sub    $0x28,%esp
	printf(1, "* Tests for variants of shmctl :\n");
    102c:	68 20 23 00 00       	push   $0x2320
    1031:	6a 01                	push   $0x1
    1033:	e8 a8 09 00 00       	call   19e0 <printf>
	char *string = "Test string";
	int shmid = shmget(KEY3, 8000, 06 | IPC_CREAT);
    1038:	83 c4 0c             	add    $0xc,%esp
    103b:	68 06 02 00 00       	push   $0x206
    1040:	68 40 1f 00 00       	push   $0x1f40
    1045:	68 61 1e 00 00       	push   $0x1e61
    104a:	e8 b4 08 00 00       	call   1903 <shmget>
	if(shmid < 0) {
    104f:	83 c4 10             	add    $0x10,%esp
    1052:	85 c0                	test   %eax,%eax
    1054:	0f 88 86 01 00 00    	js     11e0 <shmctlTest+0x1c0>
		printf(1, "\t- Fail shmctl tests\n");
		return;
	}
	char *ptr = (char *)shmat(shmid, (void *)0, 0);
    105a:	83 ec 04             	sub    $0x4,%esp
    105d:	89 c3                	mov    %eax,%ebx
    105f:	6a 00                	push   $0x0
    1061:	6a 00                	push   $0x0
    1063:	50                   	push   %eax
    1064:	e8 a2 08 00 00       	call   190b <shmat>
	if((int)ptr < 0) {
    1069:	83 c4 10             	add    $0x10,%esp
    106c:	85 c0                	test   %eax,%eax
    106e:	0f 88 6c 01 00 00    	js     11e0 <shmctlTest+0x1c0>
    1074:	be 0d 26 00 00       	mov    $0x260d,%esi
    1079:	89 c2                	mov    %eax,%edx
		printf(1, "\t- Fail shmctl tests\n");
		return;
	}
	for(int i = 0; string[i] != 0; i++) {
    107b:	b9 54 00 00 00       	mov    $0x54,%ecx
    1080:	29 c6                	sub    %eax,%esi
    1082:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		ptr[i] = string[i];
    1088:	88 0a                	mov    %cl,(%edx)
	for(int i = 0; string[i] != 0; i++) {
    108a:	83 c2 01             	add    $0x1,%edx
    108d:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    1091:	84 c9                	test   %cl,%cl
    1093:	75 f3                	jne    1088 <shmctlTest+0x68>
	}
	int dt = shmdt(ptr);
    1095:	83 ec 0c             	sub    $0xc,%esp
    1098:	50                   	push   %eax
    1099:	e8 75 08 00 00       	call   1913 <shmdt>
	if(dt < 0) {
    109e:	83 c4 10             	add    $0x10,%esp
    10a1:	85 c0                	test   %eax,%eax
    10a3:	0f 88 37 01 00 00    	js     11e0 <shmctlTest+0x1c0>
		printf(1, "\t- Fail shmctl tests\n");
		return;
	}
	printf(1, "\t- Destroy / Remove (IPC_RMID) non - existing region : ");
    10a9:	83 ec 08             	sub    $0x8,%esp
    10ac:	68 44 23 00 00       	push   $0x2344
    10b1:	6a 01                	push   $0x1
    10b3:	e8 28 09 00 00       	call   19e0 <printf>
	// remove non - existing region
	int ctl = shmctl(55555, IPC_RMID, (void *)0);
    10b8:	83 c4 0c             	add    $0xc,%esp
    10bb:	6a 00                	push   $0x0
    10bd:	6a 00                	push   $0x0
    10bf:	68 03 d9 00 00       	push   $0xd903
    10c4:	e8 52 08 00 00       	call   191b <shmctl>
	if(ctl < 0) {
    10c9:	83 c4 10             	add    $0x10,%esp
    10cc:	85 c0                	test   %eax,%eax
    10ce:	0f 88 2c 01 00 00    	js     1200 <shmctlTest+0x1e0>
		printf(1, "Pass\n");
	} else {
		printf(1, "Fail\n");
    10d4:	83 ec 08             	sub    $0x8,%esp
    10d7:	68 a6 25 00 00       	push   $0x25a6
    10dc:	6a 01                	push   $0x1
    10de:	e8 fd 08 00 00       	call   19e0 <printf>
    10e3:	83 c4 10             	add    $0x10,%esp
	}

	// user shmid_ds data structure
	struct shmid_ds bufferCheck;
	printf(1, "\t- Test IPC_STAT / SHM_STAT flags : ");
    10e6:	83 ec 08             	sub    $0x8,%esp
	ctl = shmctl(shmid, IPC_STAT, &bufferCheck);
    10e9:	8d 75 e0             	lea    -0x20(%ebp),%esi
	printf(1, "\t- Test IPC_STAT / SHM_STAT flags : ");
    10ec:	68 7c 23 00 00       	push   $0x237c
    10f1:	6a 01                	push   $0x1
    10f3:	e8 e8 08 00 00       	call   19e0 <printf>
	ctl = shmctl(shmid, IPC_STAT, &bufferCheck);
    10f8:	83 c4 0c             	add    $0xc,%esp
    10fb:	56                   	push   %esi
    10fc:	6a 02                	push   $0x2
    10fe:	53                   	push   %ebx
    10ff:	e8 17 08 00 00       	call   191b <shmctl>
	if(ctl < 0) {
    1104:	83 c4 10             	add    $0x10,%esp
    1107:	85 c0                	test   %eax,%eax
    1109:	0f 88 71 01 00 00    	js     1280 <shmctlTest+0x260>
		printf(1, "Fail\n");
	} else {
		printf(1, "Pass\n");
    110f:	83 ec 08             	sub    $0x8,%esp
    1112:	68 b0 25 00 00       	push   $0x25b0
    1117:	6a 01                	push   $0x1
    1119:	e8 c2 08 00 00       	call   19e0 <printf>
    111e:	83 c4 10             	add    $0x10,%esp
	}
	// change permission to read-only
	bufferCheck.shm_perm.mode = 04;
	printf(1, "\t- Test IPC_SET flag (change region mode to Read) : ");
    1121:	83 ec 08             	sub    $0x8,%esp
	bufferCheck.shm_perm.mode = 04;
    1124:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
	printf(1, "\t- Test IPC_SET flag (change region mode to Read) : ");
    112b:	68 a4 23 00 00       	push   $0x23a4
    1130:	6a 01                	push   $0x1
    1132:	e8 a9 08 00 00       	call   19e0 <printf>
	// set read-only permission to exisiting region
	ctl = shmctl(shmid, IPC_SET, &bufferCheck);
    1137:	83 c4 0c             	add    $0xc,%esp
    113a:	56                   	push   %esi
    113b:	6a 01                	push   $0x1
    113d:	53                   	push   %ebx
    113e:	e8 d8 07 00 00       	call   191b <shmctl>
	if(ctl < 0) {
    1143:	83 c4 10             	add    $0x10,%esp
    1146:	85 c0                	test   %eax,%eax
    1148:	0f 88 12 01 00 00    	js     1260 <shmctlTest+0x240>
		printf(1, "Fail\n");
	} else {
		printf(1, "Pass\n");
    114e:	83 ec 08             	sub    $0x8,%esp
    1151:	68 b0 25 00 00       	push   $0x25b0
    1156:	6a 01                	push   $0x1
    1158:	e8 83 08 00 00       	call   19e0 <printf>
    115d:	83 c4 10             	add    $0x10,%esp
	}

	bufferCheck.shm_perm.mode = 567;
	printf(1, "\t- Test IPC_SET flag (change region mode to a random number) : ");
    1160:	83 ec 08             	sub    $0x8,%esp
	bufferCheck.shm_perm.mode = 567;
    1163:	c7 45 e4 37 02 00 00 	movl   $0x237,-0x1c(%ebp)
	printf(1, "\t- Test IPC_SET flag (change region mode to a random number) : ");
    116a:	68 dc 23 00 00       	push   $0x23dc
    116f:	6a 01                	push   $0x1
    1171:	e8 6a 08 00 00       	call   19e0 <printf>
	// try setting random permission
	ctl = shmctl(shmid, IPC_SET, &bufferCheck);
    1176:	83 c4 0c             	add    $0xc,%esp
    1179:	56                   	push   %esi
    117a:	6a 01                	push   $0x1
    117c:	53                   	push   %ebx
    117d:	e8 99 07 00 00       	call   191b <shmctl>
	if(ctl < 0) {
    1182:	83 c4 10             	add    $0x10,%esp
    1185:	85 c0                	test   %eax,%eax
    1187:	0f 88 b3 00 00 00    	js     1240 <shmctlTest+0x220>
		printf(1, "Pass\n");
	} else {
		printf(1, "Fail\n");
    118d:	83 ec 08             	sub    $0x8,%esp
    1190:	68 a6 25 00 00       	push   $0x25a6
    1195:	6a 01                	push   $0x1
    1197:	e8 44 08 00 00       	call   19e0 <printf>
    119c:	83 c4 10             	add    $0x10,%esp
	}

	printf(1, "\t- Destroy / Remove (IPC_RMID) existing region : ");
    119f:	83 ec 08             	sub    $0x8,%esp
    11a2:	68 1c 24 00 00       	push   $0x241c
    11a7:	6a 01                	push   $0x1
    11a9:	e8 32 08 00 00       	call   19e0 <printf>
	// remove existing region
	ctl = shmctl(shmid, IPC_RMID, (void *)0);
    11ae:	83 c4 0c             	add    $0xc,%esp
    11b1:	6a 00                	push   $0x0
    11b3:	6a 00                	push   $0x0
    11b5:	53                   	push   %ebx
    11b6:	e8 60 07 00 00       	call   191b <shmctl>
	if(ctl < 0) {
    11bb:	83 c4 10             	add    $0x10,%esp
    11be:	85 c0                	test   %eax,%eax
    11c0:	78 5e                	js     1220 <shmctlTest+0x200>
		printf(1, "Fail\n");
	} else {
		printf(1, "Pass\n");
    11c2:	83 ec 08             	sub    $0x8,%esp
    11c5:	68 b0 25 00 00       	push   $0x25b0
    11ca:	6a 01                	push   $0x1
    11cc:	e8 0f 08 00 00       	call   19e0 <printf>
    11d1:	83 c4 10             	add    $0x10,%esp
	}
}
    11d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
    11d7:	5b                   	pop    %ebx
    11d8:	5e                   	pop    %esi
    11d9:	5d                   	pop    %ebp
    11da:	c3                   	ret    
    11db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    11df:	90                   	nop
		printf(1, "\t- Fail shmctl tests\n");
    11e0:	83 ec 08             	sub    $0x8,%esp
    11e3:	68 f7 25 00 00       	push   $0x25f7
    11e8:	6a 01                	push   $0x1
    11ea:	e8 f1 07 00 00       	call   19e0 <printf>
		return;
    11ef:	83 c4 10             	add    $0x10,%esp
}
    11f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
    11f5:	5b                   	pop    %ebx
    11f6:	5e                   	pop    %esi
    11f7:	5d                   	pop    %ebp
    11f8:	c3                   	ret    
    11f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		printf(1, "Pass\n");
    1200:	83 ec 08             	sub    $0x8,%esp
    1203:	68 b0 25 00 00       	push   $0x25b0
    1208:	6a 01                	push   $0x1
    120a:	e8 d1 07 00 00       	call   19e0 <printf>
    120f:	83 c4 10             	add    $0x10,%esp
    1212:	e9 cf fe ff ff       	jmp    10e6 <shmctlTest+0xc6>
    1217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    121e:	66 90                	xchg   %ax,%ax
		printf(1, "Fail\n");
    1220:	83 ec 08             	sub    $0x8,%esp
    1223:	68 a6 25 00 00       	push   $0x25a6
    1228:	6a 01                	push   $0x1
    122a:	e8 b1 07 00 00       	call   19e0 <printf>
    122f:	83 c4 10             	add    $0x10,%esp
}
    1232:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1235:	5b                   	pop    %ebx
    1236:	5e                   	pop    %esi
    1237:	5d                   	pop    %ebp
    1238:	c3                   	ret    
    1239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		printf(1, "Pass\n");
    1240:	83 ec 08             	sub    $0x8,%esp
    1243:	68 b0 25 00 00       	push   $0x25b0
    1248:	6a 01                	push   $0x1
    124a:	e8 91 07 00 00       	call   19e0 <printf>
    124f:	83 c4 10             	add    $0x10,%esp
    1252:	e9 48 ff ff ff       	jmp    119f <shmctlTest+0x17f>
    1257:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    125e:	66 90                	xchg   %ax,%ax
		printf(1, "Fail\n");
    1260:	83 ec 08             	sub    $0x8,%esp
    1263:	68 a6 25 00 00       	push   $0x25a6
    1268:	6a 01                	push   $0x1
    126a:	e8 71 07 00 00       	call   19e0 <printf>
    126f:	83 c4 10             	add    $0x10,%esp
    1272:	e9 e9 fe ff ff       	jmp    1160 <shmctlTest+0x140>
    1277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    127e:	66 90                	xchg   %ax,%ax
		printf(1, "Fail\n");
    1280:	83 ec 08             	sub    $0x8,%esp
    1283:	68 a6 25 00 00       	push   $0x25a6
    1288:	6a 01                	push   $0x1
    128a:	e8 51 07 00 00       	call   19e0 <printf>
    128f:	83 c4 10             	add    $0x10,%esp
    1292:	e9 8a fe ff ff       	jmp    1121 <shmctlTest+0x101>
    1297:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    129e:	66 90                	xchg   %ax,%ax

000012a0 <permissionTest>:

// combinations of different permissions on region
void permissionTest() {
    12a0:	f3 0f 1e fb          	endbr32 
    12a4:	55                   	push   %ebp
    12a5:	89 e5                	mov    %esp,%ebp
    12a7:	53                   	push   %ebx
    12a8:	83 ec 2c             	sub    $0x2c,%esp
	printf(1, "* Tests for combinations of region permissions :\n");
    12ab:	68 50 24 00 00       	push   $0x2450
    12b0:	6a 01                	push   $0x1
    12b2:	e8 29 07 00 00       	call   19e0 <printf>
	printf(1, "\t- Region permission other than Read / Read-Write : ");
    12b7:	58                   	pop    %eax
    12b8:	5a                   	pop    %edx
    12b9:	68 84 24 00 00       	push   $0x2484
    12be:	6a 01                	push   $0x1
    12c0:	e8 1b 07 00 00       	call   19e0 <printf>
	// invalid permission check
	int shmid = shmget(KEY1, 4000, 26 | IPC_CREAT);
    12c5:	83 c4 0c             	add    $0xc,%esp
    12c8:	68 1a 02 00 00       	push   $0x21a
    12cd:	68 a0 0f 00 00       	push   $0xfa0
    12d2:	68 d0 07 00 00       	push   $0x7d0
    12d7:	e8 27 06 00 00       	call   1903 <shmget>
	if(shmid < 0) {
    12dc:	83 c4 10             	add    $0x10,%esp
    12df:	85 c0                	test   %eax,%eax
    12e1:	0f 88 e9 00 00 00    	js     13d0 <permissionTest+0x130>
		printf(1, "Pass\n");
	} else {
		printf(1, "Fail\n");
    12e7:	83 ec 08             	sub    $0x8,%esp
    12ea:	68 a6 25 00 00       	push   $0x25a6
    12ef:	6a 01                	push   $0x1
    12f1:	e8 ea 06 00 00       	call   19e0 <printf>
    12f6:	83 c4 10             	add    $0x10,%esp
	}
	printf(1, "\t- Write into a read-write region : ");
    12f9:	83 ec 08             	sub    $0x8,%esp
    12fc:	68 bc 24 00 00       	push   $0x24bc
    1301:	6a 01                	push   $0x1
    1303:	e8 d8 06 00 00       	call   19e0 <printf>
	char testChar = 'a';
	shmid = shmget(KEY3, 2565, 06 | IPC_CREAT);
    1308:	83 c4 0c             	add    $0xc,%esp
    130b:	68 06 02 00 00       	push   $0x206
    1310:	68 05 0a 00 00       	push   $0xa05
    1315:	68 61 1e 00 00       	push   $0x1e61
    131a:	e8 e4 05 00 00       	call   1903 <shmget>
	if(shmid < 0) {
    131f:	83 c4 10             	add    $0x10,%esp
	shmid = shmget(KEY3, 2565, 06 | IPC_CREAT);
    1322:	89 c3                	mov    %eax,%ebx
	if(shmid < 0) {
    1324:	85 c0                	test   %eax,%eax
    1326:	0f 88 84 00 00 00    	js     13b0 <permissionTest+0x110>
		printf(1, "Fail\n");
		return;
	}
	char *ptr = (char *)shmat(shmid, (void *)0, 0);
    132c:	83 ec 04             	sub    $0x4,%esp
    132f:	6a 00                	push   $0x0
    1331:	6a 00                	push   $0x0
    1333:	50                   	push   %eax
    1334:	e8 d2 05 00 00       	call   190b <shmat>
	if((int)ptr < 0) {
    1339:	83 c4 10             	add    $0x10,%esp
    133c:	85 c0                	test   %eax,%eax
    133e:	78 70                	js     13b0 <permissionTest+0x110>
		printf(1, "Fail\n");
		return;
	}
	ptr[0] = testChar;
	int dt = shmdt(ptr);
    1340:	83 ec 0c             	sub    $0xc,%esp
	ptr[0] = testChar;
    1343:	c6 00 61             	movb   $0x61,(%eax)
	int dt = shmdt(ptr);
    1346:	50                   	push   %eax
    1347:	e8 c7 05 00 00       	call   1913 <shmdt>
	if(dt < 0) {
    134c:	83 c4 10             	add    $0x10,%esp
    134f:	85 c0                	test   %eax,%eax
    1351:	78 5d                	js     13b0 <permissionTest+0x110>
		printf(1, "Fail\n");
		return;
	}
	printf(1, "Pass\n");
    1353:	83 ec 08             	sub    $0x8,%esp
    1356:	68 b0 25 00 00       	push   $0x25b0
    135b:	6a 01                	push   $0x1
    135d:	e8 7e 06 00 00       	call   19e0 <printf>
	/* 
		change region mode to read-only	
	*/
	struct shmid_ds buffer;
	buffer.shm_perm.mode = 04;
	int ctl = shmctl(shmid, IPC_SET, &buffer);
    1362:	83 c4 0c             	add    $0xc,%esp
    1365:	8d 45 e0             	lea    -0x20(%ebp),%eax
	buffer.shm_perm.mode = 04;
    1368:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
	int ctl = shmctl(shmid, IPC_SET, &buffer);
    136f:	50                   	push   %eax
    1370:	6a 01                	push   $0x1
    1372:	53                   	push   %ebx
    1373:	e8 a3 05 00 00       	call   191b <shmctl>
	if(ctl < 0) {
    1378:	83 c4 10             	add    $0x10,%esp
    137b:	85 c0                	test   %eax,%eax
    137d:	78 31                	js     13b0 <permissionTest+0x110>
		printf(1, "Fail\n");
		return;
	}
	printf(1, "\t- Read from a read-only region : ");
    137f:	83 ec 08             	sub    $0x8,%esp
    1382:	68 e4 24 00 00       	push   $0x24e4
    1387:	6a 01                	push   $0x1
    1389:	e8 52 06 00 00       	call   19e0 <printf>
	ptr = (char *)shmat(shmid, (void *)0, 0);
    138e:	83 c4 0c             	add    $0xc,%esp
    1391:	6a 00                	push   $0x0
    1393:	6a 00                	push   $0x0
    1395:	53                   	push   %ebx
    1396:	e8 70 05 00 00       	call   190b <shmat>
	if((int)ptr < 0) {
    139b:	83 c4 10             	add    $0x10,%esp
    139e:	85 c0                	test   %eax,%eax
    13a0:	78 0e                	js     13b0 <permissionTest+0x110>
		printf(1, "Fail\n");
		return;
	}
	if(ptr[0] != testChar) {
    13a2:	80 38 61             	cmpb   $0x61,(%eax)
    13a5:	74 49                	je     13f0 <permissionTest+0x150>
    13a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    13ae:	66 90                	xchg   %ax,%ax
		printf(1, "Fail\n");
    13b0:	83 ec 08             	sub    $0x8,%esp
    13b3:	68 a6 25 00 00       	push   $0x25a6
    13b8:	6a 01                	push   $0x1
    13ba:	e8 21 06 00 00       	call   19e0 <printf>
		return;
    13bf:	83 c4 10             	add    $0x10,%esp
	// ctl = shmctl(shmid, IPC_RMID, (void *)0);
	// if(ctl < 0) {
	// 	printf(1, "Fail\n");
	// 	return;
	// }
}
    13c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    13c5:	c9                   	leave  
    13c6:	c3                   	ret    
    13c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    13ce:	66 90                	xchg   %ax,%ax
		printf(1, "Pass\n");
    13d0:	83 ec 08             	sub    $0x8,%esp
    13d3:	68 b0 25 00 00       	push   $0x25b0
    13d8:	6a 01                	push   $0x1
    13da:	e8 01 06 00 00       	call   19e0 <printf>
    13df:	83 c4 10             	add    $0x10,%esp
    13e2:	e9 12 ff ff ff       	jmp    12f9 <permissionTest+0x59>
    13e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    13ee:	66 90                	xchg   %ax,%ax
	dt = shmdt(ptr);
    13f0:	83 ec 0c             	sub    $0xc,%esp
    13f3:	50                   	push   %eax
    13f4:	e8 1a 05 00 00       	call   1913 <shmdt>
	if(dt < 0) {
    13f9:	83 c4 10             	add    $0x10,%esp
    13fc:	85 c0                	test   %eax,%eax
    13fe:	78 b0                	js     13b0 <permissionTest+0x110>
	printf(1, "Pass\n");
    1400:	83 ec 08             	sub    $0x8,%esp
    1403:	68 b0 25 00 00       	push   $0x25b0
    1408:	6a 01                	push   $0x1
    140a:	e8 d1 05 00 00       	call   19e0 <printf>
	ctl = shmctl(shmid, IPC_RMID, (void *)0);
    140f:	83 c4 0c             	add    $0xc,%esp
    1412:	6a 00                	push   $0x0
    1414:	6a 00                	push   $0x0
    1416:	53                   	push   %ebx
    1417:	e8 ff 04 00 00       	call   191b <shmctl>
	if(ctl < 0) {
    141c:	83 c4 10             	add    $0x10,%esp
    141f:	85 c0                	test   %eax,%eax
    1421:	79 9f                	jns    13c2 <permissionTest+0x122>
    1423:	eb 8b                	jmp    13b0 <permissionTest+0x110>
    1425:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    142c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001430 <forkTest>:

// 2 fork test
int forkTest() {
    1430:	f3 0f 1e fb          	endbr32 
    1434:	55                   	push   %ebp
    1435:	89 e5                	mov    %esp,%ebp
    1437:	57                   	push   %edi
    1438:	56                   	push   %esi
    1439:	53                   	push   %ebx
    143a:	83 ec 14             	sub    $0x14,%esp
	printf(1, "* 2 Forks (Parent attach; parent-child 1-child 2 write; parent read) : ");
    143d:	68 08 25 00 00       	push   $0x2508
    1442:	6a 01                	push   $0x1
    1444:	e8 97 05 00 00       	call   19e0 <printf>
	// test string
	char *string = "AAAAABBBBBCCCCC";
	// create
	int shmid = shmget(KEY1, 2565, 06 | IPC_CREAT);
    1449:	83 c4 0c             	add    $0xc,%esp
    144c:	68 06 02 00 00       	push   $0x206
    1451:	68 05 0a 00 00       	push   $0xa05
    1456:	68 d0 07 00 00       	push   $0x7d0
    145b:	e8 a3 04 00 00       	call   1903 <shmget>
	if(shmid < 0) {
    1460:	83 c4 10             	add    $0x10,%esp
    1463:	85 c0                	test   %eax,%eax
    1465:	0f 88 ac 00 00 00    	js     1517 <forkTest+0xe7>
		return -1;
	}
	// attach
	char *ptr = (char *)shmat(shmid, (void *)0, 0);
    146b:	83 ec 04             	sub    $0x4,%esp
    146e:	89 c3                	mov    %eax,%ebx
    1470:	6a 00                	push   $0x0
    1472:	6a 00                	push   $0x0
    1474:	50                   	push   %eax
    1475:	e8 91 04 00 00       	call   190b <shmat>
	if((int)ptr < 0) {
    147a:	83 c4 10             	add    $0x10,%esp
	char *ptr = (char *)shmat(shmid, (void *)0, 0);
    147d:	89 c6                	mov    %eax,%esi
	if((int)ptr < 0) {
    147f:	85 c0                	test   %eax,%eax
    1481:	0f 88 90 00 00 00    	js     1517 <forkTest+0xe7>
		return -1;
	}
	// parent-write
	for(int i = 0; i < 5; i++) {
    1487:	31 c0                	xor    %eax,%eax
		ptr[i] = string[i];
    1489:	ba 41 00 00 00       	mov    $0x41,%edx
    148e:	88 14 30             	mov    %dl,(%eax,%esi,1)
	for(int i = 0; i < 5; i++) {
    1491:	83 c0 01             	add    $0x1,%eax
    1494:	83 f8 05             	cmp    $0x5,%eax
    1497:	74 13                	je     14ac <forkTest+0x7c>
    1499:	0f b6 90 19 26 00 00 	movzbl 0x2619(%eax),%edx
    14a0:	83 c0 01             	add    $0x1,%eax
		ptr[i] = string[i];
    14a3:	88 54 30 ff          	mov    %dl,-0x1(%eax,%esi,1)
	for(int i = 0; i < 5; i++) {
    14a7:	83 f8 05             	cmp    $0x5,%eax
    14aa:	75 ed                	jne    1499 <forkTest+0x69>
	}
	int pid = fork();
    14ac:	e8 5a 03 00 00       	call   180b <fork>
    14b1:	89 c7                	mov    %eax,%edi
	if(pid < 0) {
    14b3:	85 c0                	test   %eax,%eax
    14b5:	78 60                	js     1517 <forkTest+0xe7>
		return -1;
	} else if(pid == 0) {
    14b7:	75 37                	jne    14f0 <forkTest+0xc0>
		int pid1 = fork();
    14b9:	e8 4d 03 00 00       	call   180b <fork>
		if(pid1 < 0) {
    14be:	85 c0                	test   %eax,%eax
    14c0:	78 55                	js     1517 <forkTest+0xe7>
			return -1;
		} else if(pid1 == 0) {
    14c2:	0f 85 b0 00 00 00    	jne    1578 <forkTest+0x148>
    14c8:	b9 19 26 00 00       	mov    $0x2619,%ecx
    14cd:	8d 46 05             	lea    0x5(%esi),%eax
    14d0:	8d 5e 0a             	lea    0xa(%esi),%ebx
			// child 2-write
			for(int i = 5; i < 10; i++) {
				ptr[i] = string[i];
    14d3:	29 f1                	sub    %esi,%ecx
    14d5:	0f b6 14 01          	movzbl (%ecx,%eax,1),%edx
    14d9:	83 c0 01             	add    $0x1,%eax
    14dc:	88 50 ff             	mov    %dl,-0x1(%eax)
			for(int i = 5; i < 10; i++) {
    14df:	39 d8                	cmp    %ebx,%eax
    14e1:	75 f2                	jne    14d5 <forkTest+0xa5>
		}
		printf(1, "Pass\n");
		return 0;
	}
	return 0;
}
    14e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
    14e6:	89 f8                	mov    %edi,%eax
    14e8:	5b                   	pop    %ebx
    14e9:	5e                   	pop    %esi
    14ea:	5f                   	pop    %edi
    14eb:	5d                   	pop    %ebp
    14ec:	c3                   	ret    
    14ed:	8d 76 00             	lea    0x0(%esi),%esi
		wait();
    14f0:	e8 26 03 00 00       	call   181b <wait>
		for(int i = 0; string[i] != 0; i++) {
    14f5:	b9 19 26 00 00       	mov    $0x2619,%ecx
		wait();
    14fa:	89 f0                	mov    %esi,%eax
		for(int i = 0; string[i] != 0; i++) {
    14fc:	ba 41 00 00 00       	mov    $0x41,%edx
    1501:	29 f1                	sub    %esi,%ecx
    1503:	eb 0e                	jmp    1513 <forkTest+0xe3>
    1505:	8d 76 00             	lea    0x0(%esi),%esi
    1508:	83 c0 01             	add    $0x1,%eax
    150b:	0f b6 14 01          	movzbl (%ecx,%eax,1),%edx
    150f:	84 d2                	test   %dl,%dl
    1511:	74 1d                	je     1530 <forkTest+0x100>
			if(ptr[i] != string[i]) {
    1513:	38 10                	cmp    %dl,(%eax)
    1515:	74 f1                	je     1508 <forkTest+0xd8>
}
    1517:	8d 65 f4             	lea    -0xc(%ebp),%esp
		return -1;
    151a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
    151f:	5b                   	pop    %ebx
    1520:	89 f8                	mov    %edi,%eax
    1522:	5e                   	pop    %esi
    1523:	5f                   	pop    %edi
    1524:	5d                   	pop    %ebp
    1525:	c3                   	ret    
    1526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    152d:	8d 76 00             	lea    0x0(%esi),%esi
		int dt = shmdt(ptr);
    1530:	83 ec 0c             	sub    $0xc,%esp
    1533:	56                   	push   %esi
    1534:	e8 da 03 00 00       	call   1913 <shmdt>
		if(dt < 0) {
    1539:	83 c4 10             	add    $0x10,%esp
    153c:	85 c0                	test   %eax,%eax
    153e:	78 d7                	js     1517 <forkTest+0xe7>
		int ctl = shmctl(shmid, IPC_RMID, (void *)0);
    1540:	83 ec 04             	sub    $0x4,%esp
    1543:	6a 00                	push   $0x0
    1545:	6a 00                	push   $0x0
    1547:	53                   	push   %ebx
    1548:	e8 ce 03 00 00       	call   191b <shmctl>
		if(ctl < 0) {
    154d:	83 c4 10             	add    $0x10,%esp
    1550:	85 c0                	test   %eax,%eax
    1552:	78 c3                	js     1517 <forkTest+0xe7>
		printf(1, "Pass\n");
    1554:	83 ec 08             	sub    $0x8,%esp
		return 0;
    1557:	31 ff                	xor    %edi,%edi
		printf(1, "Pass\n");
    1559:	68 b0 25 00 00       	push   $0x25b0
    155e:	6a 01                	push   $0x1
    1560:	e8 7b 04 00 00       	call   19e0 <printf>
		return 0;
    1565:	83 c4 10             	add    $0x10,%esp
}
    1568:	8d 65 f4             	lea    -0xc(%ebp),%esp
    156b:	89 f8                	mov    %edi,%eax
    156d:	5b                   	pop    %ebx
    156e:	5e                   	pop    %esi
    156f:	5f                   	pop    %edi
    1570:	5d                   	pop    %ebp
    1571:	c3                   	ret    
    1572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
			wait();
    1578:	e8 9e 02 00 00       	call   181b <wait>
			for(int i = 10; string[i] != 0; i++) {
    157d:	b9 19 26 00 00       	mov    $0x2619,%ecx
    1582:	8d 46 0a             	lea    0xa(%esi),%eax
    1585:	ba 43 00 00 00       	mov    $0x43,%edx
    158a:	29 f1                	sub    %esi,%ecx
    158c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
				ptr[i] = string[i];
    1590:	88 10                	mov    %dl,(%eax)
			for(int i = 10; string[i] != 0; i++) {
    1592:	83 c0 01             	add    $0x1,%eax
    1595:	0f b6 14 01          	movzbl (%ecx,%eax,1),%edx
    1599:	84 d2                	test   %dl,%dl
    159b:	75 f3                	jne    1590 <forkTest+0x160>
}
    159d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    15a0:	89 f8                	mov    %edi,%eax
    15a2:	5b                   	pop    %ebx
    15a3:	5e                   	pop    %esi
    15a4:	5f                   	pop    %edi
    15a5:	5d                   	pop    %ebp
    15a6:	c3                   	ret    
    15a7:	66 90                	xchg   %ax,%ax
    15a9:	66 90                	xchg   %ax,%ax
    15ab:	66 90                	xchg   %ax,%ax
    15ad:	66 90                	xchg   %ax,%ax
    15af:	90                   	nop

000015b0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    15b0:	f3 0f 1e fb          	endbr32 
    15b4:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    15b5:	31 c0                	xor    %eax,%eax
{
    15b7:	89 e5                	mov    %esp,%ebp
    15b9:	53                   	push   %ebx
    15ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
    15bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
    15c0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
    15c4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
    15c7:	83 c0 01             	add    $0x1,%eax
    15ca:	84 d2                	test   %dl,%dl
    15cc:	75 f2                	jne    15c0 <strcpy+0x10>
    ;
  return os;
}
    15ce:	89 c8                	mov    %ecx,%eax
    15d0:	5b                   	pop    %ebx
    15d1:	5d                   	pop    %ebp
    15d2:	c3                   	ret    
    15d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    15da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000015e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    15e0:	f3 0f 1e fb          	endbr32 
    15e4:	55                   	push   %ebp
    15e5:	89 e5                	mov    %esp,%ebp
    15e7:	53                   	push   %ebx
    15e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
    15eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    15ee:	0f b6 01             	movzbl (%ecx),%eax
    15f1:	0f b6 1a             	movzbl (%edx),%ebx
    15f4:	84 c0                	test   %al,%al
    15f6:	75 19                	jne    1611 <strcmp+0x31>
    15f8:	eb 26                	jmp    1620 <strcmp+0x40>
    15fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1600:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
    1604:	83 c1 01             	add    $0x1,%ecx
    1607:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    160a:	0f b6 1a             	movzbl (%edx),%ebx
    160d:	84 c0                	test   %al,%al
    160f:	74 0f                	je     1620 <strcmp+0x40>
    1611:	38 d8                	cmp    %bl,%al
    1613:	74 eb                	je     1600 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
    1615:	29 d8                	sub    %ebx,%eax
}
    1617:	5b                   	pop    %ebx
    1618:	5d                   	pop    %ebp
    1619:	c3                   	ret    
    161a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1620:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
    1622:	29 d8                	sub    %ebx,%eax
}
    1624:	5b                   	pop    %ebx
    1625:	5d                   	pop    %ebp
    1626:	c3                   	ret    
    1627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    162e:	66 90                	xchg   %ax,%ax

00001630 <strlen>:

uint
strlen(const char *s)
{
    1630:	f3 0f 1e fb          	endbr32 
    1634:	55                   	push   %ebp
    1635:	89 e5                	mov    %esp,%ebp
    1637:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
    163a:	80 3a 00             	cmpb   $0x0,(%edx)
    163d:	74 21                	je     1660 <strlen+0x30>
    163f:	31 c0                	xor    %eax,%eax
    1641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1648:	83 c0 01             	add    $0x1,%eax
    164b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
    164f:	89 c1                	mov    %eax,%ecx
    1651:	75 f5                	jne    1648 <strlen+0x18>
    ;
  return n;
}
    1653:	89 c8                	mov    %ecx,%eax
    1655:	5d                   	pop    %ebp
    1656:	c3                   	ret    
    1657:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    165e:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
    1660:	31 c9                	xor    %ecx,%ecx
}
    1662:	5d                   	pop    %ebp
    1663:	89 c8                	mov    %ecx,%eax
    1665:	c3                   	ret    
    1666:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    166d:	8d 76 00             	lea    0x0(%esi),%esi

00001670 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1670:	f3 0f 1e fb          	endbr32 
    1674:	55                   	push   %ebp
    1675:	89 e5                	mov    %esp,%ebp
    1677:	57                   	push   %edi
    1678:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    167b:	8b 4d 10             	mov    0x10(%ebp),%ecx
    167e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1681:	89 d7                	mov    %edx,%edi
    1683:	fc                   	cld    
    1684:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    1686:	89 d0                	mov    %edx,%eax
    1688:	5f                   	pop    %edi
    1689:	5d                   	pop    %ebp
    168a:	c3                   	ret    
    168b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    168f:	90                   	nop

00001690 <strchr>:

char*
strchr(const char *s, char c)
{
    1690:	f3 0f 1e fb          	endbr32 
    1694:	55                   	push   %ebp
    1695:	89 e5                	mov    %esp,%ebp
    1697:	8b 45 08             	mov    0x8(%ebp),%eax
    169a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    169e:	0f b6 10             	movzbl (%eax),%edx
    16a1:	84 d2                	test   %dl,%dl
    16a3:	75 16                	jne    16bb <strchr+0x2b>
    16a5:	eb 21                	jmp    16c8 <strchr+0x38>
    16a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    16ae:	66 90                	xchg   %ax,%ax
    16b0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
    16b4:	83 c0 01             	add    $0x1,%eax
    16b7:	84 d2                	test   %dl,%dl
    16b9:	74 0d                	je     16c8 <strchr+0x38>
    if(*s == c)
    16bb:	38 d1                	cmp    %dl,%cl
    16bd:	75 f1                	jne    16b0 <strchr+0x20>
      return (char*)s;
  return 0;
}
    16bf:	5d                   	pop    %ebp
    16c0:	c3                   	ret    
    16c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
    16c8:	31 c0                	xor    %eax,%eax
}
    16ca:	5d                   	pop    %ebp
    16cb:	c3                   	ret    
    16cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000016d0 <gets>:

char*
gets(char *buf, int max)
{
    16d0:	f3 0f 1e fb          	endbr32 
    16d4:	55                   	push   %ebp
    16d5:	89 e5                	mov    %esp,%ebp
    16d7:	57                   	push   %edi
    16d8:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    16d9:	31 f6                	xor    %esi,%esi
{
    16db:	53                   	push   %ebx
    16dc:	89 f3                	mov    %esi,%ebx
    16de:	83 ec 1c             	sub    $0x1c,%esp
    16e1:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
    16e4:	eb 33                	jmp    1719 <gets+0x49>
    16e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    16ed:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
    16f0:	83 ec 04             	sub    $0x4,%esp
    16f3:	8d 45 e7             	lea    -0x19(%ebp),%eax
    16f6:	6a 01                	push   $0x1
    16f8:	50                   	push   %eax
    16f9:	6a 00                	push   $0x0
    16fb:	e8 2b 01 00 00       	call   182b <read>
    if(cc < 1)
    1700:	83 c4 10             	add    $0x10,%esp
    1703:	85 c0                	test   %eax,%eax
    1705:	7e 1c                	jle    1723 <gets+0x53>
      break;
    buf[i++] = c;
    1707:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    170b:	83 c7 01             	add    $0x1,%edi
    170e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
    1711:	3c 0a                	cmp    $0xa,%al
    1713:	74 23                	je     1738 <gets+0x68>
    1715:	3c 0d                	cmp    $0xd,%al
    1717:	74 1f                	je     1738 <gets+0x68>
  for(i=0; i+1 < max; ){
    1719:	83 c3 01             	add    $0x1,%ebx
    171c:	89 fe                	mov    %edi,%esi
    171e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    1721:	7c cd                	jl     16f0 <gets+0x20>
    1723:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
    1725:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
    1728:	c6 03 00             	movb   $0x0,(%ebx)
}
    172b:	8d 65 f4             	lea    -0xc(%ebp),%esp
    172e:	5b                   	pop    %ebx
    172f:	5e                   	pop    %esi
    1730:	5f                   	pop    %edi
    1731:	5d                   	pop    %ebp
    1732:	c3                   	ret    
    1733:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1737:	90                   	nop
    1738:	8b 75 08             	mov    0x8(%ebp),%esi
    173b:	8b 45 08             	mov    0x8(%ebp),%eax
    173e:	01 de                	add    %ebx,%esi
    1740:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
    1742:	c6 03 00             	movb   $0x0,(%ebx)
}
    1745:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1748:	5b                   	pop    %ebx
    1749:	5e                   	pop    %esi
    174a:	5f                   	pop    %edi
    174b:	5d                   	pop    %ebp
    174c:	c3                   	ret    
    174d:	8d 76 00             	lea    0x0(%esi),%esi

00001750 <stat>:

int
stat(const char *n, struct stat *st)
{
    1750:	f3 0f 1e fb          	endbr32 
    1754:	55                   	push   %ebp
    1755:	89 e5                	mov    %esp,%ebp
    1757:	56                   	push   %esi
    1758:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1759:	83 ec 08             	sub    $0x8,%esp
    175c:	6a 00                	push   $0x0
    175e:	ff 75 08             	pushl  0x8(%ebp)
    1761:	e8 ed 00 00 00       	call   1853 <open>
  if(fd < 0)
    1766:	83 c4 10             	add    $0x10,%esp
    1769:	85 c0                	test   %eax,%eax
    176b:	78 2b                	js     1798 <stat+0x48>
    return -1;
  r = fstat(fd, st);
    176d:	83 ec 08             	sub    $0x8,%esp
    1770:	ff 75 0c             	pushl  0xc(%ebp)
    1773:	89 c3                	mov    %eax,%ebx
    1775:	50                   	push   %eax
    1776:	e8 f0 00 00 00       	call   186b <fstat>
  close(fd);
    177b:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    177e:	89 c6                	mov    %eax,%esi
  close(fd);
    1780:	e8 b6 00 00 00       	call   183b <close>
  return r;
    1785:	83 c4 10             	add    $0x10,%esp
}
    1788:	8d 65 f8             	lea    -0x8(%ebp),%esp
    178b:	89 f0                	mov    %esi,%eax
    178d:	5b                   	pop    %ebx
    178e:	5e                   	pop    %esi
    178f:	5d                   	pop    %ebp
    1790:	c3                   	ret    
    1791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
    1798:	be ff ff ff ff       	mov    $0xffffffff,%esi
    179d:	eb e9                	jmp    1788 <stat+0x38>
    179f:	90                   	nop

000017a0 <atoi>:

int
atoi(const char *s)
{
    17a0:	f3 0f 1e fb          	endbr32 
    17a4:	55                   	push   %ebp
    17a5:	89 e5                	mov    %esp,%ebp
    17a7:	53                   	push   %ebx
    17a8:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    17ab:	0f be 02             	movsbl (%edx),%eax
    17ae:	8d 48 d0             	lea    -0x30(%eax),%ecx
    17b1:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
    17b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
    17b9:	77 1a                	ja     17d5 <atoi+0x35>
    17bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    17bf:	90                   	nop
    n = n*10 + *s++ - '0';
    17c0:	83 c2 01             	add    $0x1,%edx
    17c3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
    17c6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
    17ca:	0f be 02             	movsbl (%edx),%eax
    17cd:	8d 58 d0             	lea    -0x30(%eax),%ebx
    17d0:	80 fb 09             	cmp    $0x9,%bl
    17d3:	76 eb                	jbe    17c0 <atoi+0x20>
  return n;
}
    17d5:	89 c8                	mov    %ecx,%eax
    17d7:	5b                   	pop    %ebx
    17d8:	5d                   	pop    %ebp
    17d9:	c3                   	ret    
    17da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000017e0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    17e0:	f3 0f 1e fb          	endbr32 
    17e4:	55                   	push   %ebp
    17e5:	89 e5                	mov    %esp,%ebp
    17e7:	57                   	push   %edi
    17e8:	8b 45 10             	mov    0x10(%ebp),%eax
    17eb:	8b 55 08             	mov    0x8(%ebp),%edx
    17ee:	56                   	push   %esi
    17ef:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    17f2:	85 c0                	test   %eax,%eax
    17f4:	7e 0f                	jle    1805 <memmove+0x25>
    17f6:	01 d0                	add    %edx,%eax
  dst = vdst;
    17f8:	89 d7                	mov    %edx,%edi
    17fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
    1800:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
    1801:	39 f8                	cmp    %edi,%eax
    1803:	75 fb                	jne    1800 <memmove+0x20>
  return vdst;
}
    1805:	5e                   	pop    %esi
    1806:	89 d0                	mov    %edx,%eax
    1808:	5f                   	pop    %edi
    1809:	5d                   	pop    %ebp
    180a:	c3                   	ret    

0000180b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    180b:	b8 01 00 00 00       	mov    $0x1,%eax
    1810:	cd 40                	int    $0x40
    1812:	c3                   	ret    

00001813 <exit>:
SYSCALL(exit)
    1813:	b8 02 00 00 00       	mov    $0x2,%eax
    1818:	cd 40                	int    $0x40
    181a:	c3                   	ret    

0000181b <wait>:
SYSCALL(wait)
    181b:	b8 03 00 00 00       	mov    $0x3,%eax
    1820:	cd 40                	int    $0x40
    1822:	c3                   	ret    

00001823 <pipe>:
SYSCALL(pipe)
    1823:	b8 04 00 00 00       	mov    $0x4,%eax
    1828:	cd 40                	int    $0x40
    182a:	c3                   	ret    

0000182b <read>:
SYSCALL(read)
    182b:	b8 05 00 00 00       	mov    $0x5,%eax
    1830:	cd 40                	int    $0x40
    1832:	c3                   	ret    

00001833 <write>:
SYSCALL(write)
    1833:	b8 10 00 00 00       	mov    $0x10,%eax
    1838:	cd 40                	int    $0x40
    183a:	c3                   	ret    

0000183b <close>:
SYSCALL(close)
    183b:	b8 15 00 00 00       	mov    $0x15,%eax
    1840:	cd 40                	int    $0x40
    1842:	c3                   	ret    

00001843 <kill>:
SYSCALL(kill)
    1843:	b8 06 00 00 00       	mov    $0x6,%eax
    1848:	cd 40                	int    $0x40
    184a:	c3                   	ret    

0000184b <exec>:
SYSCALL(exec)
    184b:	b8 07 00 00 00       	mov    $0x7,%eax
    1850:	cd 40                	int    $0x40
    1852:	c3                   	ret    

00001853 <open>:
SYSCALL(open)
    1853:	b8 0f 00 00 00       	mov    $0xf,%eax
    1858:	cd 40                	int    $0x40
    185a:	c3                   	ret    

0000185b <mknod>:
SYSCALL(mknod)
    185b:	b8 11 00 00 00       	mov    $0x11,%eax
    1860:	cd 40                	int    $0x40
    1862:	c3                   	ret    

00001863 <unlink>:
SYSCALL(unlink)
    1863:	b8 12 00 00 00       	mov    $0x12,%eax
    1868:	cd 40                	int    $0x40
    186a:	c3                   	ret    

0000186b <fstat>:
SYSCALL(fstat)
    186b:	b8 08 00 00 00       	mov    $0x8,%eax
    1870:	cd 40                	int    $0x40
    1872:	c3                   	ret    

00001873 <link>:
SYSCALL(link)
    1873:	b8 13 00 00 00       	mov    $0x13,%eax
    1878:	cd 40                	int    $0x40
    187a:	c3                   	ret    

0000187b <mkdir>:
SYSCALL(mkdir)
    187b:	b8 14 00 00 00       	mov    $0x14,%eax
    1880:	cd 40                	int    $0x40
    1882:	c3                   	ret    

00001883 <chdir>:
SYSCALL(chdir)
    1883:	b8 09 00 00 00       	mov    $0x9,%eax
    1888:	cd 40                	int    $0x40
    188a:	c3                   	ret    

0000188b <dup>:
SYSCALL(dup)
    188b:	b8 0a 00 00 00       	mov    $0xa,%eax
    1890:	cd 40                	int    $0x40
    1892:	c3                   	ret    

00001893 <getpid>:
SYSCALL(getpid)
    1893:	b8 0b 00 00 00       	mov    $0xb,%eax
    1898:	cd 40                	int    $0x40
    189a:	c3                   	ret    

0000189b <sbrk>:
SYSCALL(sbrk)
    189b:	b8 0c 00 00 00       	mov    $0xc,%eax
    18a0:	cd 40                	int    $0x40
    18a2:	c3                   	ret    

000018a3 <sleep>:
SYSCALL(sleep)
    18a3:	b8 0d 00 00 00       	mov    $0xd,%eax
    18a8:	cd 40                	int    $0x40
    18aa:	c3                   	ret    

000018ab <uptime>:
SYSCALL(uptime)
    18ab:	b8 0e 00 00 00       	mov    $0xe,%eax
    18b0:	cd 40                	int    $0x40
    18b2:	c3                   	ret    

000018b3 <find_digital_root>:
SYSCALL(find_digital_root)
    18b3:	b8 16 00 00 00       	mov    $0x16,%eax
    18b8:	cd 40                	int    $0x40
    18ba:	c3                   	ret    

000018bb <get_process_lifetime>:
SYSCALL(get_process_lifetime)
    18bb:	b8 17 00 00 00       	mov    $0x17,%eax
    18c0:	cd 40                	int    $0x40
    18c2:	c3                   	ret    

000018c3 <copy_file>:
SYSCALL(copy_file)
    18c3:	b8 18 00 00 00       	mov    $0x18,%eax
    18c8:	cd 40                	int    $0x40
    18ca:	c3                   	ret    

000018cb <get_uncle_count>:
SYSCALL(get_uncle_count)
    18cb:	b8 19 00 00 00       	mov    $0x19,%eax
    18d0:	cd 40                	int    $0x40
    18d2:	c3                   	ret    

000018d3 <change_sched_Q>:
SYSCALL(change_sched_Q)
    18d3:	b8 1b 00 00 00       	mov    $0x1b,%eax
    18d8:	cd 40                	int    $0x40
    18da:	c3                   	ret    

000018db <show_process_info>:
SYSCALL(show_process_info)
    18db:	b8 1a 00 00 00       	mov    $0x1a,%eax
    18e0:	cd 40                	int    $0x40
    18e2:	c3                   	ret    

000018e3 <set_proc_bjf_params>:
SYSCALL(set_proc_bjf_params)
    18e3:	b8 1d 00 00 00       	mov    $0x1d,%eax
    18e8:	cd 40                	int    $0x40
    18ea:	c3                   	ret    

000018eb <set_system_bjf_params>:
SYSCALL(set_system_bjf_params)
    18eb:	b8 1c 00 00 00       	mov    $0x1c,%eax
    18f0:	cd 40                	int    $0x40
    18f2:	c3                   	ret    

000018f3 <priorityLock_test>:
SYSCALL(priorityLock_test)
    18f3:	b8 1e 00 00 00       	mov    $0x1e,%eax
    18f8:	cd 40                	int    $0x40
    18fa:	c3                   	ret    

000018fb <syscalls_count>:
SYSCALL(syscalls_count)
    18fb:	b8 1f 00 00 00       	mov    $0x1f,%eax
    1900:	cd 40                	int    $0x40
    1902:	c3                   	ret    

00001903 <shmget>:
SYSCALL(shmget)
    1903:	b8 20 00 00 00       	mov    $0x20,%eax
    1908:	cd 40                	int    $0x40
    190a:	c3                   	ret    

0000190b <shmat>:
SYSCALL(shmat)
    190b:	b8 21 00 00 00       	mov    $0x21,%eax
    1910:	cd 40                	int    $0x40
    1912:	c3                   	ret    

00001913 <shmdt>:
SYSCALL(shmdt)
    1913:	b8 22 00 00 00       	mov    $0x22,%eax
    1918:	cd 40                	int    $0x40
    191a:	c3                   	ret    

0000191b <shmctl>:
SYSCALL(shmctl)
    191b:	b8 23 00 00 00       	mov    $0x23,%eax
    1920:	cd 40                	int    $0x40
    1922:	c3                   	ret    
    1923:	66 90                	xchg   %ax,%ax
    1925:	66 90                	xchg   %ax,%ax
    1927:	66 90                	xchg   %ax,%ax
    1929:	66 90                	xchg   %ax,%ax
    192b:	66 90                	xchg   %ax,%ax
    192d:	66 90                	xchg   %ax,%ax
    192f:	90                   	nop

00001930 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    1930:	55                   	push   %ebp
    1931:	89 e5                	mov    %esp,%ebp
    1933:	57                   	push   %edi
    1934:	56                   	push   %esi
    1935:	53                   	push   %ebx
    1936:	83 ec 3c             	sub    $0x3c,%esp
    1939:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    193c:	89 d1                	mov    %edx,%ecx
{
    193e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
    1941:	85 d2                	test   %edx,%edx
    1943:	0f 89 7f 00 00 00    	jns    19c8 <printint+0x98>
    1949:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    194d:	74 79                	je     19c8 <printint+0x98>
    neg = 1;
    194f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
    1956:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
    1958:	31 db                	xor    %ebx,%ebx
    195a:	8d 75 d7             	lea    -0x29(%ebp),%esi
    195d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
    1960:	89 c8                	mov    %ecx,%eax
    1962:	31 d2                	xor    %edx,%edx
    1964:	89 cf                	mov    %ecx,%edi
    1966:	f7 75 c4             	divl   -0x3c(%ebp)
    1969:	0f b6 92 38 26 00 00 	movzbl 0x2638(%edx),%edx
    1970:	89 45 c0             	mov    %eax,-0x40(%ebp)
    1973:	89 d8                	mov    %ebx,%eax
    1975:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
    1978:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
    197b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
    197e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
    1981:	76 dd                	jbe    1960 <printint+0x30>
  if(neg)
    1983:	8b 4d bc             	mov    -0x44(%ebp),%ecx
    1986:	85 c9                	test   %ecx,%ecx
    1988:	74 0c                	je     1996 <printint+0x66>
    buf[i++] = '-';
    198a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
    198f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
    1991:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
    1996:	8b 7d b8             	mov    -0x48(%ebp),%edi
    1999:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
    199d:	eb 07                	jmp    19a6 <printint+0x76>
    199f:	90                   	nop
    19a0:	0f b6 13             	movzbl (%ebx),%edx
    19a3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
    19a6:	83 ec 04             	sub    $0x4,%esp
    19a9:	88 55 d7             	mov    %dl,-0x29(%ebp)
    19ac:	6a 01                	push   $0x1
    19ae:	56                   	push   %esi
    19af:	57                   	push   %edi
    19b0:	e8 7e fe ff ff       	call   1833 <write>
  while(--i >= 0)
    19b5:	83 c4 10             	add    $0x10,%esp
    19b8:	39 de                	cmp    %ebx,%esi
    19ba:	75 e4                	jne    19a0 <printint+0x70>
    putc(fd, buf[i]);
}
    19bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    19bf:	5b                   	pop    %ebx
    19c0:	5e                   	pop    %esi
    19c1:	5f                   	pop    %edi
    19c2:	5d                   	pop    %ebp
    19c3:	c3                   	ret    
    19c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    19c8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
    19cf:	eb 87                	jmp    1958 <printint+0x28>
    19d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    19d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    19df:	90                   	nop

000019e0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    19e0:	f3 0f 1e fb          	endbr32 
    19e4:	55                   	push   %ebp
    19e5:	89 e5                	mov    %esp,%ebp
    19e7:	57                   	push   %edi
    19e8:	56                   	push   %esi
    19e9:	53                   	push   %ebx
    19ea:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    19ed:	8b 75 0c             	mov    0xc(%ebp),%esi
    19f0:	0f b6 1e             	movzbl (%esi),%ebx
    19f3:	84 db                	test   %bl,%bl
    19f5:	0f 84 b4 00 00 00    	je     1aaf <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
    19fb:	8d 45 10             	lea    0x10(%ebp),%eax
    19fe:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
    1a01:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
    1a04:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
    1a06:	89 45 d0             	mov    %eax,-0x30(%ebp)
    1a09:	eb 33                	jmp    1a3e <printf+0x5e>
    1a0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1a0f:	90                   	nop
    1a10:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    1a13:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
    1a18:	83 f8 25             	cmp    $0x25,%eax
    1a1b:	74 17                	je     1a34 <printf+0x54>
  write(fd, &c, 1);
    1a1d:	83 ec 04             	sub    $0x4,%esp
    1a20:	88 5d e7             	mov    %bl,-0x19(%ebp)
    1a23:	6a 01                	push   $0x1
    1a25:	57                   	push   %edi
    1a26:	ff 75 08             	pushl  0x8(%ebp)
    1a29:	e8 05 fe ff ff       	call   1833 <write>
    1a2e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
    1a31:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    1a34:	0f b6 1e             	movzbl (%esi),%ebx
    1a37:	83 c6 01             	add    $0x1,%esi
    1a3a:	84 db                	test   %bl,%bl
    1a3c:	74 71                	je     1aaf <printf+0xcf>
    c = fmt[i] & 0xff;
    1a3e:	0f be cb             	movsbl %bl,%ecx
    1a41:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    1a44:	85 d2                	test   %edx,%edx
    1a46:	74 c8                	je     1a10 <printf+0x30>
      }
    } else if(state == '%'){
    1a48:	83 fa 25             	cmp    $0x25,%edx
    1a4b:	75 e7                	jne    1a34 <printf+0x54>
      if(c == 'd'){
    1a4d:	83 f8 64             	cmp    $0x64,%eax
    1a50:	0f 84 9a 00 00 00    	je     1af0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    1a56:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
    1a5c:	83 f9 70             	cmp    $0x70,%ecx
    1a5f:	74 5f                	je     1ac0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    1a61:	83 f8 73             	cmp    $0x73,%eax
    1a64:	0f 84 d6 00 00 00    	je     1b40 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1a6a:	83 f8 63             	cmp    $0x63,%eax
    1a6d:	0f 84 8d 00 00 00    	je     1b00 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    1a73:	83 f8 25             	cmp    $0x25,%eax
    1a76:	0f 84 b4 00 00 00    	je     1b30 <printf+0x150>
  write(fd, &c, 1);
    1a7c:	83 ec 04             	sub    $0x4,%esp
    1a7f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    1a83:	6a 01                	push   $0x1
    1a85:	57                   	push   %edi
    1a86:	ff 75 08             	pushl  0x8(%ebp)
    1a89:	e8 a5 fd ff ff       	call   1833 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    1a8e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    1a91:	83 c4 0c             	add    $0xc,%esp
    1a94:	6a 01                	push   $0x1
    1a96:	83 c6 01             	add    $0x1,%esi
    1a99:	57                   	push   %edi
    1a9a:	ff 75 08             	pushl  0x8(%ebp)
    1a9d:	e8 91 fd ff ff       	call   1833 <write>
  for(i = 0; fmt[i]; i++){
    1aa2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
    1aa6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    1aa9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
    1aab:	84 db                	test   %bl,%bl
    1aad:	75 8f                	jne    1a3e <printf+0x5e>
    }
  }
}
    1aaf:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1ab2:	5b                   	pop    %ebx
    1ab3:	5e                   	pop    %esi
    1ab4:	5f                   	pop    %edi
    1ab5:	5d                   	pop    %ebp
    1ab6:	c3                   	ret    
    1ab7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1abe:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
    1ac0:	83 ec 0c             	sub    $0xc,%esp
    1ac3:	b9 10 00 00 00       	mov    $0x10,%ecx
    1ac8:	6a 00                	push   $0x0
    1aca:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    1acd:	8b 45 08             	mov    0x8(%ebp),%eax
    1ad0:	8b 13                	mov    (%ebx),%edx
    1ad2:	e8 59 fe ff ff       	call   1930 <printint>
        ap++;
    1ad7:	89 d8                	mov    %ebx,%eax
    1ad9:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1adc:	31 d2                	xor    %edx,%edx
        ap++;
    1ade:	83 c0 04             	add    $0x4,%eax
    1ae1:	89 45 d0             	mov    %eax,-0x30(%ebp)
    1ae4:	e9 4b ff ff ff       	jmp    1a34 <printf+0x54>
    1ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
    1af0:	83 ec 0c             	sub    $0xc,%esp
    1af3:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1af8:	6a 01                	push   $0x1
    1afa:	eb ce                	jmp    1aca <printf+0xea>
    1afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
    1b00:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
    1b03:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    1b06:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
    1b08:	6a 01                	push   $0x1
        ap++;
    1b0a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
    1b0d:	57                   	push   %edi
    1b0e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
    1b11:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    1b14:	e8 1a fd ff ff       	call   1833 <write>
        ap++;
    1b19:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    1b1c:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1b1f:	31 d2                	xor    %edx,%edx
    1b21:	e9 0e ff ff ff       	jmp    1a34 <printf+0x54>
    1b26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1b2d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
    1b30:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    1b33:	83 ec 04             	sub    $0x4,%esp
    1b36:	e9 59 ff ff ff       	jmp    1a94 <printf+0xb4>
    1b3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1b3f:	90                   	nop
        s = (char*)*ap;
    1b40:	8b 45 d0             	mov    -0x30(%ebp),%eax
    1b43:	8b 18                	mov    (%eax),%ebx
        ap++;
    1b45:	83 c0 04             	add    $0x4,%eax
    1b48:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    1b4b:	85 db                	test   %ebx,%ebx
    1b4d:	74 17                	je     1b66 <printf+0x186>
        while(*s != 0){
    1b4f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
    1b52:	31 d2                	xor    %edx,%edx
        while(*s != 0){
    1b54:	84 c0                	test   %al,%al
    1b56:	0f 84 d8 fe ff ff    	je     1a34 <printf+0x54>
    1b5c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    1b5f:	89 de                	mov    %ebx,%esi
    1b61:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1b64:	eb 1a                	jmp    1b80 <printf+0x1a0>
          s = "(null)";
    1b66:	bb 31 26 00 00       	mov    $0x2631,%ebx
        while(*s != 0){
    1b6b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    1b6e:	b8 28 00 00 00       	mov    $0x28,%eax
    1b73:	89 de                	mov    %ebx,%esi
    1b75:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1b78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1b7f:	90                   	nop
  write(fd, &c, 1);
    1b80:	83 ec 04             	sub    $0x4,%esp
          s++;
    1b83:	83 c6 01             	add    $0x1,%esi
    1b86:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    1b89:	6a 01                	push   $0x1
    1b8b:	57                   	push   %edi
    1b8c:	53                   	push   %ebx
    1b8d:	e8 a1 fc ff ff       	call   1833 <write>
        while(*s != 0){
    1b92:	0f b6 06             	movzbl (%esi),%eax
    1b95:	83 c4 10             	add    $0x10,%esp
    1b98:	84 c0                	test   %al,%al
    1b9a:	75 e4                	jne    1b80 <printf+0x1a0>
    1b9c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
    1b9f:	31 d2                	xor    %edx,%edx
    1ba1:	e9 8e fe ff ff       	jmp    1a34 <printf+0x54>
    1ba6:	66 90                	xchg   %ax,%ax
    1ba8:	66 90                	xchg   %ax,%ax
    1baa:	66 90                	xchg   %ax,%ax
    1bac:	66 90                	xchg   %ax,%ax
    1bae:	66 90                	xchg   %ax,%ax

00001bb0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1bb0:	f3 0f 1e fb          	endbr32 
    1bb4:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1bb5:	a1 7c 2a 00 00       	mov    0x2a7c,%eax
{
    1bba:	89 e5                	mov    %esp,%ebp
    1bbc:	57                   	push   %edi
    1bbd:	56                   	push   %esi
    1bbe:	53                   	push   %ebx
    1bbf:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1bc2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
    1bc4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1bc7:	39 c8                	cmp    %ecx,%eax
    1bc9:	73 15                	jae    1be0 <free+0x30>
    1bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1bcf:	90                   	nop
    1bd0:	39 d1                	cmp    %edx,%ecx
    1bd2:	72 14                	jb     1be8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1bd4:	39 d0                	cmp    %edx,%eax
    1bd6:	73 10                	jae    1be8 <free+0x38>
{
    1bd8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1bda:	8b 10                	mov    (%eax),%edx
    1bdc:	39 c8                	cmp    %ecx,%eax
    1bde:	72 f0                	jb     1bd0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1be0:	39 d0                	cmp    %edx,%eax
    1be2:	72 f4                	jb     1bd8 <free+0x28>
    1be4:	39 d1                	cmp    %edx,%ecx
    1be6:	73 f0                	jae    1bd8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1be8:	8b 73 fc             	mov    -0x4(%ebx),%esi
    1beb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    1bee:	39 fa                	cmp    %edi,%edx
    1bf0:	74 1e                	je     1c10 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    1bf2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1bf5:	8b 50 04             	mov    0x4(%eax),%edx
    1bf8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1bfb:	39 f1                	cmp    %esi,%ecx
    1bfd:	74 28                	je     1c27 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    1bff:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
    1c01:	5b                   	pop    %ebx
  freep = p;
    1c02:	a3 7c 2a 00 00       	mov    %eax,0x2a7c
}
    1c07:	5e                   	pop    %esi
    1c08:	5f                   	pop    %edi
    1c09:	5d                   	pop    %ebp
    1c0a:	c3                   	ret    
    1c0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1c0f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
    1c10:	03 72 04             	add    0x4(%edx),%esi
    1c13:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1c16:	8b 10                	mov    (%eax),%edx
    1c18:	8b 12                	mov    (%edx),%edx
    1c1a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1c1d:	8b 50 04             	mov    0x4(%eax),%edx
    1c20:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1c23:	39 f1                	cmp    %esi,%ecx
    1c25:	75 d8                	jne    1bff <free+0x4f>
    p->s.size += bp->s.size;
    1c27:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    1c2a:	a3 7c 2a 00 00       	mov    %eax,0x2a7c
    p->s.size += bp->s.size;
    1c2f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1c32:	8b 53 f8             	mov    -0x8(%ebx),%edx
    1c35:	89 10                	mov    %edx,(%eax)
}
    1c37:	5b                   	pop    %ebx
    1c38:	5e                   	pop    %esi
    1c39:	5f                   	pop    %edi
    1c3a:	5d                   	pop    %ebp
    1c3b:	c3                   	ret    
    1c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001c40 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1c40:	f3 0f 1e fb          	endbr32 
    1c44:	55                   	push   %ebp
    1c45:	89 e5                	mov    %esp,%ebp
    1c47:	57                   	push   %edi
    1c48:	56                   	push   %esi
    1c49:	53                   	push   %ebx
    1c4a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    1c50:	8b 3d 7c 2a 00 00    	mov    0x2a7c,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1c56:	8d 70 07             	lea    0x7(%eax),%esi
    1c59:	c1 ee 03             	shr    $0x3,%esi
    1c5c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    1c5f:	85 ff                	test   %edi,%edi
    1c61:	0f 84 a9 00 00 00    	je     1d10 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1c67:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
    1c69:	8b 48 04             	mov    0x4(%eax),%ecx
    1c6c:	39 f1                	cmp    %esi,%ecx
    1c6e:	73 6d                	jae    1cdd <malloc+0x9d>
    1c70:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
    1c76:	bb 00 10 00 00       	mov    $0x1000,%ebx
    1c7b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    1c7e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
    1c85:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    1c88:	eb 17                	jmp    1ca1 <malloc+0x61>
    1c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1c90:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
    1c92:	8b 4a 04             	mov    0x4(%edx),%ecx
    1c95:	39 f1                	cmp    %esi,%ecx
    1c97:	73 4f                	jae    1ce8 <malloc+0xa8>
    1c99:	8b 3d 7c 2a 00 00    	mov    0x2a7c,%edi
    1c9f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1ca1:	39 c7                	cmp    %eax,%edi
    1ca3:	75 eb                	jne    1c90 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
    1ca5:	83 ec 0c             	sub    $0xc,%esp
    1ca8:	ff 75 e4             	pushl  -0x1c(%ebp)
    1cab:	e8 eb fb ff ff       	call   189b <sbrk>
  if(p == (char*)-1)
    1cb0:	83 c4 10             	add    $0x10,%esp
    1cb3:	83 f8 ff             	cmp    $0xffffffff,%eax
    1cb6:	74 1b                	je     1cd3 <malloc+0x93>
  hp->s.size = nu;
    1cb8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    1cbb:	83 ec 0c             	sub    $0xc,%esp
    1cbe:	83 c0 08             	add    $0x8,%eax
    1cc1:	50                   	push   %eax
    1cc2:	e8 e9 fe ff ff       	call   1bb0 <free>
  return freep;
    1cc7:	a1 7c 2a 00 00       	mov    0x2a7c,%eax
      if((p = morecore(nunits)) == 0)
    1ccc:	83 c4 10             	add    $0x10,%esp
    1ccf:	85 c0                	test   %eax,%eax
    1cd1:	75 bd                	jne    1c90 <malloc+0x50>
        return 0;
  }
}
    1cd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    1cd6:	31 c0                	xor    %eax,%eax
}
    1cd8:	5b                   	pop    %ebx
    1cd9:	5e                   	pop    %esi
    1cda:	5f                   	pop    %edi
    1cdb:	5d                   	pop    %ebp
    1cdc:	c3                   	ret    
    if(p->s.size >= nunits){
    1cdd:	89 c2                	mov    %eax,%edx
    1cdf:	89 f8                	mov    %edi,%eax
    1ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
    1ce8:	39 ce                	cmp    %ecx,%esi
    1cea:	74 54                	je     1d40 <malloc+0x100>
        p->s.size -= nunits;
    1cec:	29 f1                	sub    %esi,%ecx
    1cee:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
    1cf1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
    1cf4:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
    1cf7:	a3 7c 2a 00 00       	mov    %eax,0x2a7c
}
    1cfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    1cff:	8d 42 08             	lea    0x8(%edx),%eax
}
    1d02:	5b                   	pop    %ebx
    1d03:	5e                   	pop    %esi
    1d04:	5f                   	pop    %edi
    1d05:	5d                   	pop    %ebp
    1d06:	c3                   	ret    
    1d07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1d0e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
    1d10:	c7 05 7c 2a 00 00 80 	movl   $0x2a80,0x2a7c
    1d17:	2a 00 00 
    base.s.size = 0;
    1d1a:	bf 80 2a 00 00       	mov    $0x2a80,%edi
    base.s.ptr = freep = prevp = &base;
    1d1f:	c7 05 80 2a 00 00 80 	movl   $0x2a80,0x2a80
    1d26:	2a 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1d29:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
    1d2b:	c7 05 84 2a 00 00 00 	movl   $0x0,0x2a84
    1d32:	00 00 00 
    if(p->s.size >= nunits){
    1d35:	e9 36 ff ff ff       	jmp    1c70 <malloc+0x30>
    1d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    1d40:	8b 0a                	mov    (%edx),%ecx
    1d42:	89 08                	mov    %ecx,(%eax)
    1d44:	eb b1                	jmp    1cf7 <malloc+0xb7>
