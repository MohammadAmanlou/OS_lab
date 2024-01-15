#include "types.h"
#include "stat.h"
#include "user.h"
#include "mmu.h"
#include "ipc.h"
#include "shm.h"
#include "memlayout.h"

// test keys
#define KEY1 2000
#define KEY2 4000
#define KEY3 7777
#define KEY4 2006
#define KEY5 4001
#define KEY6 7778
#define KEY7 3567

#define allowedAddr HEAPLIMIT + 3*PGSIZE

int basicSharedTest();	// Create segment, write, read and destroy test
int forkTest();		// Two forks, parent write, child-1 write, child-2 write, parent read (parent attach)

int main(int argc, char *argv[]) {
	/*
		Basic shared memory test,
		create region - write - read - remove region
	*/
    if(basicSharedTest() < 0) {
		printf(1, "failed\n");
	}
	if(forkTest() < 0) {
		printf(1, "failed\n");
	}

    exit();
}

// basic shared test
int basicSharedTest() {
	printf(1, "* (Basic) Create segment, write, read and destroy test : ");
	char *string = "Test String";
	// get region
	int shmid = shmget(KEY1, 2565, 06 | IPC_CREAT);
	if(shmid < 0) {
		return -1;
	}
	// attach to shmid's region
	char *ptr = (char *)shmat(shmid, (void *)0, 0);
	if((int)ptr < 0) {
		return -1;
	}
	// write into region
	for(int i = 0; string[i] != 0; i++) {
		ptr[i] = string[i];
	}
	// detach
	int dt = shmdt(ptr);
	if(dt < 0) {
		return -1;
	}

	// re-attach for verification
	ptr = (char *)shmat(shmid, (void *)0, 0);
	if((int)ptr < 0) {
		return -1;
	}

	// read, written data
	for(int i = 0; string[i] != 0; i++) {
		if(ptr[i] != string[i]) {
			return -1;
		}
	}
	// detach
	dt = shmdt(ptr);
	if(dt < 0) {
		return -1;
	}
	// remove region
	int ctl = shmctl(shmid, IPC_RMID, (void *)0);
	if(ctl < 0) {
		return -1;
	}
	printf(1, "Pass\n");
	return 0;
}


// 2 fork test
int forkTest() {
	printf(1, "* 2 Forks (Parent attach; parent-child 1-child 2 write; parent read) : ");
	// test string
	char *string = "AAAAABBBBBCCCCC";
	// create
	int shmid = shmget(KEY1, 2565, 06 | IPC_CREAT);
	if(shmid < 0) {
		return -1;
	}
	// attach
	char *ptr = (char *)shmat(shmid, (void *)0, 0);
	if((int)ptr < 0) {
		return -1;
	}
	// parent-write
	for(int i = 0; i < 5; i++) {
		ptr[i] = string[i];
	}
	int pid = fork();
	if(pid < 0) {
		return -1;
	} else if(pid == 0) {
		int pid1 = fork();
		if(pid1 < 0) {
			return -1;
		} else if(pid1 == 0) {
			// child 2-write
			for(int i = 5; i < 10; i++) {
				ptr[i] = string[i];
			}
		} else {
			wait();
			// child 1-write
			for(int i = 10; string[i] != 0; i++) {
				ptr[i] = string[i];
			}
		}
	} else {
		wait();
		// parent read-verify
		for(int i = 0; string[i] != 0; i++) {
			if(ptr[i] != string[i]) {
				return -1;
			}
		}
		// detach
		int dt = shmdt(ptr);
		if(dt < 0) {
			return -1;
		}
		// remove
		int ctl = shmctl(shmid, IPC_RMID, (void *)0);
		if(ctl < 0) {
			return -1;
		}
		printf(1, "Pass\n");
		return 0;
	}
	return 0;
}