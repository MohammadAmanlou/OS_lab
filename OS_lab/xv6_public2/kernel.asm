
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 c0 10 00       	mov    $0x10c000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 30 e6 10 80       	mov    $0x8010e630,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 b0 35 10 80       	mov    $0x801035b0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb 74 e6 10 80       	mov    $0x8010e674,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 20 9c 10 80       	push   $0x80109c20
80100055:	68 40 e6 10 80       	push   $0x8010e640
8010005a:	e8 d1 5a 00 00       	call   80105b30 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 3c 2d 11 80       	mov    $0x80112d3c,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 8c 2d 11 80 3c 	movl   $0x80112d3c,0x80112d8c
8010006e:	2d 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 90 2d 11 80 3c 	movl   $0x80112d3c,0x80112d90
80100078:	2d 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 3c 2d 11 80 	movl   $0x80112d3c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 9c 10 80       	push   $0x80109c27
80100097:	50                   	push   %eax
80100098:	e8 33 58 00 00       	call   801058d0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 90 2d 11 80       	mov    0x80112d90,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 90 2d 11 80    	mov    %ebx,0x80112d90
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb e0 2a 11 80    	cmp    $0x80112ae0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 40 e6 10 80       	push   $0x8010e640
801000e8:	e8 c3 5b 00 00       	call   80105cb0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 90 2d 11 80    	mov    0x80112d90,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb 3c 2d 11 80    	cmp    $0x80112d3c,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 3c 2d 11 80    	cmp    $0x80112d3c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 8c 2d 11 80    	mov    0x80112d8c,%ebx
80100126:	81 fb 3c 2d 11 80    	cmp    $0x80112d3c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 3c 2d 11 80    	cmp    $0x80112d3c,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 40 e6 10 80       	push   $0x8010e640
80100162:	e8 09 5c 00 00       	call   80105d70 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 9e 57 00 00       	call   80105910 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 5f 26 00 00       	call   801027f0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 2e 9c 10 80       	push   $0x80109c2e
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 e9 57 00 00       	call   801059b0 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 13 26 00 00       	jmp    801027f0 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 3f 9c 10 80       	push   $0x80109c3f
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 a8 57 00 00       	call   801059b0 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 58 57 00 00       	call   80105970 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 40 e6 10 80 	movl   $0x8010e640,(%esp)
8010021f:	e8 8c 5a 00 00       	call   80105cb0 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 90 2d 11 80       	mov    0x80112d90,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 3c 2d 11 80 	movl   $0x80112d3c,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 90 2d 11 80       	mov    0x80112d90,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 90 2d 11 80    	mov    %ebx,0x80112d90
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 40 e6 10 80 	movl   $0x8010e640,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 fb 5a 00 00       	jmp    80105d70 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 46 9c 10 80       	push   $0x80109c46
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 06 1b 00 00       	call   80101db0 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 d5 10 80 	movl   $0x8010d520,(%esp)
801002b1:	e8 fa 59 00 00       	call   80105cb0 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 20 30 11 80       	mov    0x80113020,%eax
801002cb:	3b 05 24 30 11 80    	cmp    0x80113024,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 d5 10 80       	push   $0x8010d520
801002e0:	68 20 30 11 80       	push   $0x80113020
801002e5:	e8 36 42 00 00       	call   80104520 <sleep>
    while(input.r == input.w){
801002ea:	a1 20 30 11 80       	mov    0x80113020,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 24 30 11 80    	cmp    0x80113024,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 41 3c 00 00       	call   80103f40 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 d5 10 80       	push   $0x8010d520
8010030e:	e8 5d 5a 00 00       	call   80105d70 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 b4 19 00 00       	call   80101cd0 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 20 30 11 80    	mov    %edx,0x80113020
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a a0 2f 11 80 	movsbl -0x7feed060(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 d5 10 80       	push   $0x8010d520
80100365:	e8 06 5a 00 00       	call   80105d70 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 5d 19 00 00       	call   80101cd0 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 20 30 11 80       	mov    %eax,0x80113020
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 54 d5 10 80 00 	movl   $0x0,0x8010d554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 5e 2a 00 00       	call   80102e10 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 4d 9c 10 80       	push   $0x80109c4d
801003bb:	e8 00 05 00 00       	call   801008c0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 f7 04 00 00       	call   801008c0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 a5 a2 10 80 	movl   $0x8010a2a5,(%esp)
801003d0:	e8 eb 04 00 00       	call   801008c0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 6f 57 00 00       	call   80105b50 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 61 9c 10 80       	push   $0x80109c61
801003f1:	e8 ca 04 00 00       	call   801008c0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 5c d5 10 80 01 	movl   $0x1,0x8010d55c
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c) // Important function 
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	89 c6                	mov    %eax,%esi
80100417:	53                   	push   %ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 62 01 00 00    	je     80100588 <consputc.part.0+0x178>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 f1 76 00 00       	call   80107b20 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c3                	mov    %eax,%ebx
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 d8                	or     %ebx,%eax
  if(c == '\n'){
8010045f:	83 fe 0a             	cmp    $0xa,%esi
80100462:	0f 84 f8 00 00 00    	je     80100560 <consputc.part.0+0x150>
  else if(c == BACKSPACE){
80100468:	8b 3d 58 d5 10 80    	mov    0x8010d558,%edi
8010046e:	8d 0c 38             	lea    (%eax,%edi,1),%ecx
80100471:	81 fe 00 01 00 00    	cmp    $0x100,%esi
80100477:	0f 84 a3 00 00 00    	je     80100520 <consputc.part.0+0x110>
  for (int i = pos + backs; i > pos; i--)
8010047d:	39 c8                	cmp    %ecx,%eax
8010047f:	7d 1d                	jge    8010049e <consputc.part.0+0x8e>
80100481:	8d 94 09 fe 7f 0b 80 	lea    -0x7ff48002(%ecx,%ecx,1),%edx
80100488:	8d 9c 00 fe 7f 0b 80 	lea    -0x7ff48002(%eax,%eax,1),%ebx
8010048f:	90                   	nop
    crt[i] = crt[i - 1];
80100490:	0f b7 0a             	movzwl (%edx),%ecx
80100493:	83 ea 02             	sub    $0x2,%edx
80100496:	66 89 4a 04          	mov    %cx,0x4(%edx)
  for (int i = pos + backs; i > pos; i--)
8010049a:	39 d3                	cmp    %edx,%ebx
8010049c:	75 f2                	jne    80100490 <consputc.part.0+0x80>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010049e:	89 f1                	mov    %esi,%ecx
801004a0:	8d 58 01             	lea    0x1(%eax),%ebx
801004a3:	0f b6 f1             	movzbl %cl,%esi
801004a6:	66 81 ce 00 07       	or     $0x700,%si
801004ab:	66 89 b4 00 00 80 0b 	mov    %si,-0x7ff48000(%eax,%eax,1)
801004b2:	80 
  if(pos < 0 || pos > 25*80)
801004b3:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
801004b9:	0f 8f 45 01 00 00    	jg     80100604 <consputc.part.0+0x1f4>
  if((pos/80) >= 24){  // Scroll up.
801004bf:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004c5:	0f 8f ed 00 00 00    	jg     801005b8 <consputc.part.0+0x1a8>
801004cb:	0f b6 c7             	movzbl %bh,%eax
801004ce:	8b 3d 58 d5 10 80    	mov    0x8010d558,%edi
801004d4:	89 de                	mov    %ebx,%esi
801004d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801004d9:	01 df                	add    %ebx,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004db:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004e0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004e5:	89 da                	mov    %ebx,%edx
801004e7:	ee                   	out    %al,(%dx)
801004e8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ed:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
801004f1:	89 ca                	mov    %ecx,%edx
801004f3:	ee                   	out    %al,(%dx)
801004f4:	b8 0f 00 00 00       	mov    $0xf,%eax
801004f9:	89 da                	mov    %ebx,%edx
801004fb:	ee                   	out    %al,(%dx)
801004fc:	89 f0                	mov    %esi,%eax
801004fe:	89 ca                	mov    %ecx,%edx
80100500:	ee                   	out    %al,(%dx)
  crt[pos + backs] = ' ' | 0x0700; //
80100501:	b8 20 07 00 00       	mov    $0x720,%eax
80100506:	66 89 84 3f 00 80 0b 	mov    %ax,-0x7ff48000(%edi,%edi,1)
8010050d:	80 
}
8010050e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100511:	5b                   	pop    %ebx
80100512:	5e                   	pop    %esi
80100513:	5f                   	pop    %edi
80100514:	5d                   	pop    %ebp
80100515:	c3                   	ret    
80100516:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010051d:	8d 76 00             	lea    0x0(%esi),%esi
  for (int i = pos - 1; i < pos + backs; i++)
80100520:	8d 58 ff             	lea    -0x1(%eax),%ebx
80100523:	8d 94 00 00 80 0b 80 	lea    -0x7ff48000(%eax,%eax,1),%edx
8010052a:	89 de                	mov    %ebx,%esi
8010052c:	85 ff                	test   %edi,%edi
8010052e:	78 1c                	js     8010054c <consputc.part.0+0x13c>
80100530:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100533:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100537:	90                   	nop
      crt[i] = crt[i + 1];
80100538:	0f b7 02             	movzwl (%edx),%eax
  for (int i = pos - 1; i < pos + backs; i++)
8010053b:	83 c6 01             	add    $0x1,%esi
8010053e:	83 c2 02             	add    $0x2,%edx
      crt[i] = crt[i + 1];
80100541:	66 89 42 fc          	mov    %ax,-0x4(%edx)
  for (int i = pos - 1; i < pos + backs; i++)
80100545:	39 ce                	cmp    %ecx,%esi
80100547:	7c ef                	jl     80100538 <consputc.part.0+0x128>
80100549:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if(pos > 0) --pos;
8010054c:	85 c0                	test   %eax,%eax
8010054e:	0f 85 5f ff ff ff    	jne    801004b3 <consputc.part.0+0xa3>
80100554:	c6 45 e4 00          	movb   $0x0,-0x1c(%ebp)
80100558:	31 f6                	xor    %esi,%esi
8010055a:	e9 7c ff ff ff       	jmp    801004db <consputc.part.0+0xcb>
8010055f:	90                   	nop
    backs = 0;
80100560:	c7 05 58 d5 10 80 00 	movl   $0x0,0x8010d558
80100567:	00 00 00 
    pos += 80 - pos%80;
8010056a:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
8010056f:	f7 e2                	mul    %edx
80100571:	c1 ea 06             	shr    $0x6,%edx
80100574:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100577:	c1 e0 04             	shl    $0x4,%eax
8010057a:	8d 58 50             	lea    0x50(%eax),%ebx
    backs = 0;
8010057d:	e9 31 ff ff ff       	jmp    801004b3 <consputc.part.0+0xa3>
80100582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');      
80100588:	83 ec 0c             	sub    $0xc,%esp
8010058b:	6a 08                	push   $0x8
8010058d:	e8 8e 75 00 00       	call   80107b20 <uartputc>
80100592:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100599:	e8 82 75 00 00       	call   80107b20 <uartputc>
8010059e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801005a5:	e8 76 75 00 00       	call   80107b20 <uartputc>
801005aa:	83 c4 10             	add    $0x10,%esp
801005ad:	e9 80 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
801005b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801005b8:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801005bb:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801005be:	68 60 0e 00 00       	push   $0xe60
801005c3:	89 de                	mov    %ebx,%esi
801005c5:	68 a0 80 0b 80       	push   $0x800b80a0
801005ca:	68 00 80 0b 80       	push   $0x800b8000
801005cf:	e8 8c 58 00 00       	call   80105e60 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801005d4:	b8 80 07 00 00       	mov    $0x780,%eax
801005d9:	83 c4 0c             	add    $0xc,%esp
801005dc:	29 d8                	sub    %ebx,%eax
801005de:	01 c0                	add    %eax,%eax
801005e0:	50                   	push   %eax
801005e1:	8d 84 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%eax
801005e8:	6a 00                	push   $0x0
801005ea:	50                   	push   %eax
801005eb:	e8 d0 57 00 00       	call   80105dc0 <memset>
801005f0:	8b 3d 58 d5 10 80    	mov    0x8010d558,%edi
801005f6:	c6 45 e4 07          	movb   $0x7,-0x1c(%ebp)
801005fa:	83 c4 10             	add    $0x10,%esp
801005fd:	01 df                	add    %ebx,%edi
801005ff:	e9 d7 fe ff ff       	jmp    801004db <consputc.part.0+0xcb>
    panic("pos under/overflow");
80100604:	83 ec 0c             	sub    $0xc,%esp
80100607:	68 65 9c 10 80       	push   $0x80109c65
8010060c:	e8 7f fd ff ff       	call   80100390 <panic>
80100611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100618:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010061f:	90                   	nop

80100620 <printint>:
{
80100620:	55                   	push   %ebp
80100621:	89 e5                	mov    %esp,%ebp
80100623:	57                   	push   %edi
80100624:	56                   	push   %esi
80100625:	53                   	push   %ebx
80100626:	83 ec 2c             	sub    $0x2c,%esp
80100629:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
8010062c:	85 c9                	test   %ecx,%ecx
8010062e:	74 04                	je     80100634 <printint+0x14>
80100630:	85 c0                	test   %eax,%eax
80100632:	78 6d                	js     801006a1 <printint+0x81>
    x = xx;
80100634:	89 c1                	mov    %eax,%ecx
80100636:	31 f6                	xor    %esi,%esi
  i = 0;
80100638:	89 75 cc             	mov    %esi,-0x34(%ebp)
8010063b:	31 db                	xor    %ebx,%ebx
8010063d:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
80100640:	89 c8                	mov    %ecx,%eax
80100642:	31 d2                	xor    %edx,%edx
80100644:	89 ce                	mov    %ecx,%esi
80100646:	f7 75 d4             	divl   -0x2c(%ebp)
80100649:	0f b6 92 e8 9c 10 80 	movzbl -0x7fef6318(%edx),%edx
80100650:	89 45 d0             	mov    %eax,-0x30(%ebp)
80100653:	89 d8                	mov    %ebx,%eax
80100655:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
80100658:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010065b:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
8010065e:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
80100661:	8b 75 d4             	mov    -0x2c(%ebp),%esi
80100664:	39 75 d0             	cmp    %esi,-0x30(%ebp)
80100667:	73 d7                	jae    80100640 <printint+0x20>
80100669:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
8010066c:	85 f6                	test   %esi,%esi
8010066e:	74 0c                	je     8010067c <printint+0x5c>
    buf[i++] = '-';
80100670:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100675:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
80100677:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010067c:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100680:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100683:	8b 15 5c d5 10 80    	mov    0x8010d55c,%edx
80100689:	85 d2                	test   %edx,%edx
8010068b:	74 03                	je     80100690 <printint+0x70>
  asm volatile("cli");
8010068d:	fa                   	cli    
    for(;;)
8010068e:	eb fe                	jmp    8010068e <printint+0x6e>
80100690:	e8 7b fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100695:	39 fb                	cmp    %edi,%ebx
80100697:	74 10                	je     801006a9 <printint+0x89>
80100699:	0f be 03             	movsbl (%ebx),%eax
8010069c:	83 eb 01             	sub    $0x1,%ebx
8010069f:	eb e2                	jmp    80100683 <printint+0x63>
    x = -xx;
801006a1:	f7 d8                	neg    %eax
801006a3:	89 ce                	mov    %ecx,%esi
801006a5:	89 c1                	mov    %eax,%ecx
801006a7:	eb 8f                	jmp    80100638 <printint+0x18>
}
801006a9:	83 c4 2c             	add    $0x2c,%esp
801006ac:	5b                   	pop    %ebx
801006ad:	5e                   	pop    %esi
801006ae:	5f                   	pop    %edi
801006af:	5d                   	pop    %ebp
801006b0:	c3                   	ret    
801006b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801006b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801006bf:	90                   	nop

801006c0 <arrow>:
static void arrow(enum Arrow arr){
801006c0:	55                   	push   %ebp
801006c1:	89 e5                	mov    %esp,%ebp
801006c3:	57                   	push   %edi
801006c4:	56                   	push   %esi
801006c5:	53                   	push   %ebx
801006c6:	83 ec 1c             	sub    $0x1c,%esp
801006c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for (int i= 0 ; i < backs ; i ++){
801006cc:	a1 58 d5 10 80       	mov    0x8010d558,%eax
801006d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d4:	85 c0                	test   %eax,%eax
801006d6:	7e 57                	jle    8010072f <arrow+0x6f>
801006d8:	31 ff                	xor    %edi,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801006da:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801006df:	b8 0e 00 00 00       	mov    $0xe,%eax
801006e4:	89 da                	mov    %ebx,%edx
801006e6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801006e7:	be d5 03 00 00       	mov    $0x3d5,%esi
801006ec:	89 f2                	mov    %esi,%edx
801006ee:	ec                   	in     (%dx),%al
801006ef:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801006f2:	89 da                	mov    %ebx,%edx
801006f4:	b8 0f 00 00 00       	mov    $0xf,%eax
  pos = inb(CRTPORT + 1) << 8;
801006f9:	c1 e1 08             	shl    $0x8,%ecx
801006fc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801006fd:	89 f2                	mov    %esi,%edx
801006ff:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100700:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100703:	89 da                	mov    %ebx,%edx
80100705:	09 c1                	or     %eax,%ecx
80100707:	b8 0e 00 00 00       	mov    $0xe,%eax
    pos++;
8010070c:	83 c1 01             	add    $0x1,%ecx
8010070f:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
80100710:	89 ca                	mov    %ecx,%edx
80100712:	c1 fa 08             	sar    $0x8,%edx
80100715:	89 d0                	mov    %edx,%eax
80100717:	89 f2                	mov    %esi,%edx
80100719:	ee                   	out    %al,(%dx)
8010071a:	b8 0f 00 00 00       	mov    $0xf,%eax
8010071f:	89 da                	mov    %ebx,%edx
80100721:	ee                   	out    %al,(%dx)
80100722:	89 c8                	mov    %ecx,%eax
80100724:	89 f2                	mov    %esi,%edx
80100726:	ee                   	out    %al,(%dx)
  for (int i= 0 ; i < backs ; i ++){
80100727:	83 c7 01             	add    $0x1,%edi
8010072a:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
8010072d:	75 b0                	jne    801006df <arrow+0x1f>
  backs = 0;
8010072f:	c7 05 58 d5 10 80 00 	movl   $0x0,0x8010d558
80100736:	00 00 00 
  for ( int i = input.e ; i > input.w ; i-- ){
80100739:	8b 1d 28 30 11 80    	mov    0x80113028,%ebx
8010073f:	3b 1d 24 30 11 80    	cmp    0x80113024,%ebx
80100745:	76 2b                	jbe    80100772 <arrow+0xb2>
    if (input.buf[i - 1] != '\n'){
80100747:	83 eb 01             	sub    $0x1,%ebx
8010074a:	80 bb a0 2f 11 80 0a 	cmpb   $0xa,-0x7feed060(%ebx)
80100751:	74 17                	je     8010076a <arrow+0xaa>
  if(panicked){
80100753:	8b 15 5c d5 10 80    	mov    0x8010d55c,%edx
80100759:	85 d2                	test   %edx,%edx
8010075b:	74 03                	je     80100760 <arrow+0xa0>
  asm volatile("cli");
8010075d:	fa                   	cli    
    for(;;)
8010075e:	eb fe                	jmp    8010075e <arrow+0x9e>
80100760:	b8 00 01 00 00       	mov    $0x100,%eax
80100765:	e8 a6 fc ff ff       	call   80100410 <consputc.part.0>
  for ( int i = input.e ; i > input.w ; i-- ){
8010076a:	39 1d 24 30 11 80    	cmp    %ebx,0x80113024
80100770:	72 d5                	jb     80100747 <arrow+0x87>
  if (arr == UP){
80100772:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80100775:	a1 b8 35 11 80       	mov    0x801135b8,%eax
8010077a:	85 c9                	test   %ecx,%ecx
8010077c:	74 50                	je     801007ce <arrow+0x10e>
  if ((arr == DOWN)&&(history.index < 9)&&(history.index + 1 < history.last )){
8010077e:	83 f8 08             	cmp    $0x8,%eax
80100781:	0f 8f b8 00 00 00    	jg     8010083f <arrow+0x17f>
80100787:	8d 50 01             	lea    0x1(%eax),%edx
8010078a:	3b 15 c0 35 11 80    	cmp    0x801135c0,%edx
80100790:	0f 8d a9 00 00 00    	jge    8010083f <arrow+0x17f>
    input = history.hist[history.index + 2 ];
80100796:	8d 70 02             	lea    0x2(%eax),%esi
80100799:	bf a0 2f 11 80       	mov    $0x80112fa0,%edi
8010079e:	b9 23 00 00 00       	mov    $0x23,%ecx
    history.index ++ ;
801007a3:	89 15 b8 35 11 80    	mov    %edx,0x801135b8
    input = history.hist[history.index + 2 ];
801007a9:	69 f6 8c 00 00 00    	imul   $0x8c,%esi,%esi
801007af:	81 c6 40 30 11 80    	add    $0x80113040,%esi
801007b5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    input.e -- ;
801007b7:	8b 15 28 30 11 80    	mov    0x80113028,%edx
801007bd:	8d 42 ff             	lea    -0x1(%edx),%eax
    input.buf[input.e] = '\0';
801007c0:	c6 82 9f 2f 11 80 00 	movb   $0x0,-0x7feed061(%edx)
    input.e -- ;
801007c7:	a3 28 30 11 80       	mov    %eax,0x80113028
    input.buf[input.e] = '\0';
801007cc:	eb 35                	jmp    80100803 <arrow+0x143>
    input = history.hist[history.index ];
801007ce:	69 f0 8c 00 00 00    	imul   $0x8c,%eax,%esi
801007d4:	bf a0 2f 11 80       	mov    $0x80112fa0,%edi
801007d9:	b9 23 00 00 00       	mov    $0x23,%ecx
    history.index -- ;
801007de:	83 e8 01             	sub    $0x1,%eax
801007e1:	a3 b8 35 11 80       	mov    %eax,0x801135b8
    input = history.hist[history.index ];
801007e6:	81 c6 40 30 11 80    	add    $0x80113040,%esi
801007ec:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    input.e -- ;
801007ee:	8b 15 28 30 11 80    	mov    0x80113028,%edx
801007f4:	8d 42 ff             	lea    -0x1(%edx),%eax
    input.buf[input.e] = '\0';
801007f7:	c6 82 9f 2f 11 80 00 	movb   $0x0,-0x7feed061(%edx)
    input.e -- ;
801007fe:	a3 28 30 11 80       	mov    %eax,0x80113028
  for (int i = input.w ; i < input.e; i++)
80100803:	8b 1d 24 30 11 80    	mov    0x80113024,%ebx
80100809:	39 d8                	cmp    %ebx,%eax
8010080b:	76 2a                	jbe    80100837 <arrow+0x177>
  if(panicked){
8010080d:	a1 5c d5 10 80       	mov    0x8010d55c,%eax
80100812:	85 c0                	test   %eax,%eax
80100814:	74 0a                	je     80100820 <arrow+0x160>
80100816:	fa                   	cli    
    for(;;)
80100817:	eb fe                	jmp    80100817 <arrow+0x157>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(input.buf[i]);
80100820:	0f be 83 a0 2f 11 80 	movsbl -0x7feed060(%ebx),%eax
  for (int i = input.w ; i < input.e; i++)
80100827:	83 c3 01             	add    $0x1,%ebx
8010082a:	e8 e1 fb ff ff       	call   80100410 <consputc.part.0>
8010082f:	39 1d 28 30 11 80    	cmp    %ebx,0x80113028
80100835:	77 d6                	ja     8010080d <arrow+0x14d>
}
80100837:	83 c4 1c             	add    $0x1c,%esp
8010083a:	5b                   	pop    %ebx
8010083b:	5e                   	pop    %esi
8010083c:	5f                   	pop    %edi
8010083d:	5d                   	pop    %ebp
8010083e:	c3                   	ret    
8010083f:	a1 28 30 11 80       	mov    0x80113028,%eax
80100844:	eb bd                	jmp    80100803 <arrow+0x143>
80100846:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010084d:	8d 76 00             	lea    0x0(%esi),%esi

80100850 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100850:	f3 0f 1e fb          	endbr32 
80100854:	55                   	push   %ebp
80100855:	89 e5                	mov    %esp,%ebp
80100857:	57                   	push   %edi
80100858:	56                   	push   %esi
80100859:	53                   	push   %ebx
8010085a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010085d:	ff 75 08             	pushl  0x8(%ebp)
{
80100860:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100863:	e8 48 15 00 00       	call   80101db0 <iunlock>
  acquire(&cons.lock);
80100868:	c7 04 24 20 d5 10 80 	movl   $0x8010d520,(%esp)
8010086f:	e8 3c 54 00 00       	call   80105cb0 <acquire>
  for(i = 0; i < n; i++)
80100874:	83 c4 10             	add    $0x10,%esp
80100877:	85 db                	test   %ebx,%ebx
80100879:	7e 24                	jle    8010089f <consolewrite+0x4f>
8010087b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010087e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100881:	8b 15 5c d5 10 80    	mov    0x8010d55c,%edx
80100887:	85 d2                	test   %edx,%edx
80100889:	74 05                	je     80100890 <consolewrite+0x40>
8010088b:	fa                   	cli    
    for(;;)
8010088c:	eb fe                	jmp    8010088c <consolewrite+0x3c>
8010088e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100890:	0f b6 07             	movzbl (%edi),%eax
80100893:	83 c7 01             	add    $0x1,%edi
80100896:	e8 75 fb ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010089b:	39 fe                	cmp    %edi,%esi
8010089d:	75 e2                	jne    80100881 <consolewrite+0x31>
  release(&cons.lock);
8010089f:	83 ec 0c             	sub    $0xc,%esp
801008a2:	68 20 d5 10 80       	push   $0x8010d520
801008a7:	e8 c4 54 00 00       	call   80105d70 <release>
  ilock(ip);
801008ac:	58                   	pop    %eax
801008ad:	ff 75 08             	pushl  0x8(%ebp)
801008b0:	e8 1b 14 00 00       	call   80101cd0 <ilock>

  return n;
}
801008b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801008b8:	89 d8                	mov    %ebx,%eax
801008ba:	5b                   	pop    %ebx
801008bb:	5e                   	pop    %esi
801008bc:	5f                   	pop    %edi
801008bd:	5d                   	pop    %ebp
801008be:	c3                   	ret    
801008bf:	90                   	nop

801008c0 <cprintf>:
{
801008c0:	f3 0f 1e fb          	endbr32 
801008c4:	55                   	push   %ebp
801008c5:	89 e5                	mov    %esp,%ebp
801008c7:	57                   	push   %edi
801008c8:	56                   	push   %esi
801008c9:	53                   	push   %ebx
801008ca:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801008cd:	a1 54 d5 10 80       	mov    0x8010d554,%eax
801008d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801008d5:	85 c0                	test   %eax,%eax
801008d7:	0f 85 e8 00 00 00    	jne    801009c5 <cprintf+0x105>
  if (fmt == 0)
801008dd:	8b 45 08             	mov    0x8(%ebp),%eax
801008e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801008e3:	85 c0                	test   %eax,%eax
801008e5:	0f 84 5a 01 00 00    	je     80100a45 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801008eb:	0f b6 00             	movzbl (%eax),%eax
801008ee:	85 c0                	test   %eax,%eax
801008f0:	74 36                	je     80100928 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801008f2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801008f5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801008f7:	83 f8 25             	cmp    $0x25,%eax
801008fa:	74 44                	je     80100940 <cprintf+0x80>
  if(panicked){
801008fc:	8b 0d 5c d5 10 80    	mov    0x8010d55c,%ecx
80100902:	85 c9                	test   %ecx,%ecx
80100904:	74 0f                	je     80100915 <cprintf+0x55>
80100906:	fa                   	cli    
    for(;;)
80100907:	eb fe                	jmp    80100907 <cprintf+0x47>
80100909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100910:	b8 25 00 00 00       	mov    $0x25,%eax
80100915:	e8 f6 fa ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010091a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010091d:	83 c6 01             	add    $0x1,%esi
80100920:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100924:	85 c0                	test   %eax,%eax
80100926:	75 cf                	jne    801008f7 <cprintf+0x37>
  if(locking)
80100928:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010092b:	85 c0                	test   %eax,%eax
8010092d:	0f 85 fd 00 00 00    	jne    80100a30 <cprintf+0x170>
}
80100933:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100936:	5b                   	pop    %ebx
80100937:	5e                   	pop    %esi
80100938:	5f                   	pop    %edi
80100939:	5d                   	pop    %ebp
8010093a:	c3                   	ret    
8010093b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010093f:	90                   	nop
    c = fmt[++i] & 0xff;
80100940:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100943:	83 c6 01             	add    $0x1,%esi
80100946:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010094a:	85 ff                	test   %edi,%edi
8010094c:	74 da                	je     80100928 <cprintf+0x68>
    switch(c){
8010094e:	83 ff 70             	cmp    $0x70,%edi
80100951:	74 5a                	je     801009ad <cprintf+0xed>
80100953:	7f 2a                	jg     8010097f <cprintf+0xbf>
80100955:	83 ff 25             	cmp    $0x25,%edi
80100958:	0f 84 92 00 00 00    	je     801009f0 <cprintf+0x130>
8010095e:	83 ff 64             	cmp    $0x64,%edi
80100961:	0f 85 a1 00 00 00    	jne    80100a08 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100967:	8b 03                	mov    (%ebx),%eax
80100969:	8d 7b 04             	lea    0x4(%ebx),%edi
8010096c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100971:	ba 0a 00 00 00       	mov    $0xa,%edx
80100976:	89 fb                	mov    %edi,%ebx
80100978:	e8 a3 fc ff ff       	call   80100620 <printint>
      break;
8010097d:	eb 9b                	jmp    8010091a <cprintf+0x5a>
    switch(c){
8010097f:	83 ff 73             	cmp    $0x73,%edi
80100982:	75 24                	jne    801009a8 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100984:	8d 7b 04             	lea    0x4(%ebx),%edi
80100987:	8b 1b                	mov    (%ebx),%ebx
80100989:	85 db                	test   %ebx,%ebx
8010098b:	75 55                	jne    801009e2 <cprintf+0x122>
        s = "(null)";
8010098d:	bb 78 9c 10 80       	mov    $0x80109c78,%ebx
      for(; *s; s++)
80100992:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100997:	8b 15 5c d5 10 80    	mov    0x8010d55c,%edx
8010099d:	85 d2                	test   %edx,%edx
8010099f:	74 39                	je     801009da <cprintf+0x11a>
801009a1:	fa                   	cli    
    for(;;)
801009a2:	eb fe                	jmp    801009a2 <cprintf+0xe2>
801009a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
801009a8:	83 ff 78             	cmp    $0x78,%edi
801009ab:	75 5b                	jne    80100a08 <cprintf+0x148>
      printint(*argp++, 16, 0);
801009ad:	8b 03                	mov    (%ebx),%eax
801009af:	8d 7b 04             	lea    0x4(%ebx),%edi
801009b2:	31 c9                	xor    %ecx,%ecx
801009b4:	ba 10 00 00 00       	mov    $0x10,%edx
801009b9:	89 fb                	mov    %edi,%ebx
801009bb:	e8 60 fc ff ff       	call   80100620 <printint>
      break;
801009c0:	e9 55 ff ff ff       	jmp    8010091a <cprintf+0x5a>
    acquire(&cons.lock);
801009c5:	83 ec 0c             	sub    $0xc,%esp
801009c8:	68 20 d5 10 80       	push   $0x8010d520
801009cd:	e8 de 52 00 00       	call   80105cb0 <acquire>
801009d2:	83 c4 10             	add    $0x10,%esp
801009d5:	e9 03 ff ff ff       	jmp    801008dd <cprintf+0x1d>
801009da:	e8 31 fa ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801009df:	83 c3 01             	add    $0x1,%ebx
801009e2:	0f be 03             	movsbl (%ebx),%eax
801009e5:	84 c0                	test   %al,%al
801009e7:	75 ae                	jne    80100997 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801009e9:	89 fb                	mov    %edi,%ebx
801009eb:	e9 2a ff ff ff       	jmp    8010091a <cprintf+0x5a>
  if(panicked){
801009f0:	8b 3d 5c d5 10 80    	mov    0x8010d55c,%edi
801009f6:	85 ff                	test   %edi,%edi
801009f8:	0f 84 12 ff ff ff    	je     80100910 <cprintf+0x50>
801009fe:	fa                   	cli    
    for(;;)
801009ff:	eb fe                	jmp    801009ff <cprintf+0x13f>
80100a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
80100a08:	8b 0d 5c d5 10 80    	mov    0x8010d55c,%ecx
80100a0e:	85 c9                	test   %ecx,%ecx
80100a10:	74 06                	je     80100a18 <cprintf+0x158>
80100a12:	fa                   	cli    
    for(;;)
80100a13:	eb fe                	jmp    80100a13 <cprintf+0x153>
80100a15:	8d 76 00             	lea    0x0(%esi),%esi
80100a18:	b8 25 00 00 00       	mov    $0x25,%eax
80100a1d:	e8 ee f9 ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100a22:	8b 15 5c d5 10 80    	mov    0x8010d55c,%edx
80100a28:	85 d2                	test   %edx,%edx
80100a2a:	74 2c                	je     80100a58 <cprintf+0x198>
80100a2c:	fa                   	cli    
    for(;;)
80100a2d:	eb fe                	jmp    80100a2d <cprintf+0x16d>
80100a2f:	90                   	nop
    release(&cons.lock);
80100a30:	83 ec 0c             	sub    $0xc,%esp
80100a33:	68 20 d5 10 80       	push   $0x8010d520
80100a38:	e8 33 53 00 00       	call   80105d70 <release>
80100a3d:	83 c4 10             	add    $0x10,%esp
}
80100a40:	e9 ee fe ff ff       	jmp    80100933 <cprintf+0x73>
    panic("null fmt");
80100a45:	83 ec 0c             	sub    $0xc,%esp
80100a48:	68 7f 9c 10 80       	push   $0x80109c7f
80100a4d:	e8 3e f9 ff ff       	call   80100390 <panic>
80100a52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100a58:	89 f8                	mov    %edi,%eax
80100a5a:	e8 b1 f9 ff ff       	call   80100410 <consputc.part.0>
80100a5f:	e9 b6 fe ff ff       	jmp    8010091a <cprintf+0x5a>
80100a64:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100a6f:	90                   	nop

80100a70 <consoleintr>:
{
80100a70:	f3 0f 1e fb          	endbr32 
80100a74:	55                   	push   %ebp
80100a75:	89 e5                	mov    %esp,%ebp
80100a77:	57                   	push   %edi
80100a78:	56                   	push   %esi
80100a79:	53                   	push   %ebx
  int c, doprocdump = 0;
80100a7a:	31 db                	xor    %ebx,%ebx
{
80100a7c:	83 ec 28             	sub    $0x28,%esp
80100a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  acquire(&cons.lock);
80100a82:	68 20 d5 10 80       	push   $0x8010d520
{
80100a87:	89 45 dc             	mov    %eax,-0x24(%ebp)
  acquire(&cons.lock);
80100a8a:	e8 21 52 00 00       	call   80105cb0 <acquire>
  while((c = getc()) >= 0){
80100a8f:	83 c4 10             	add    $0x10,%esp
80100a92:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100a95:	ff d0                	call   *%eax
80100a97:	89 c6                	mov    %eax,%esi
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	0f 88 bc 02 00 00    	js     80100d5d <consoleintr+0x2ed>
    switch(c){
80100aa1:	83 fe 15             	cmp    $0x15,%esi
80100aa4:	7f 5a                	jg     80100b00 <consoleintr+0x90>
80100aa6:	83 fe 01             	cmp    $0x1,%esi
80100aa9:	0f 8e b1 01 00 00    	jle    80100c60 <consoleintr+0x1f0>
80100aaf:	83 fe 15             	cmp    $0x15,%esi
80100ab2:	0f 87 a8 01 00 00    	ja     80100c60 <consoleintr+0x1f0>
80100ab8:	3e ff 24 b5 90 9c 10 	notrack jmp *-0x7fef6370(,%esi,4)
80100abf:	80 
80100ac0:	bb 01 00 00 00       	mov    $0x1,%ebx
80100ac5:	eb cb                	jmp    80100a92 <consoleintr+0x22>
80100ac7:	b8 00 01 00 00       	mov    $0x100,%eax
80100acc:	e8 3f f9 ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
80100ad1:	a1 28 30 11 80       	mov    0x80113028,%eax
80100ad6:	3b 05 24 30 11 80    	cmp    0x80113024,%eax
80100adc:	74 b4                	je     80100a92 <consoleintr+0x22>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100ade:	83 e8 01             	sub    $0x1,%eax
80100ae1:	89 c2                	mov    %eax,%edx
80100ae3:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100ae6:	80 ba a0 2f 11 80 0a 	cmpb   $0xa,-0x7feed060(%edx)
80100aed:	74 a3                	je     80100a92 <consoleintr+0x22>
        input.e--;
80100aef:	a3 28 30 11 80       	mov    %eax,0x80113028
  if(panicked){
80100af4:	a1 5c d5 10 80       	mov    0x8010d55c,%eax
80100af9:	85 c0                	test   %eax,%eax
80100afb:	74 ca                	je     80100ac7 <consoleintr+0x57>
80100afd:	fa                   	cli    
    for(;;)
80100afe:	eb fe                	jmp    80100afe <consoleintr+0x8e>
    switch(c){
80100b00:	81 fe e2 00 00 00    	cmp    $0xe2,%esi
80100b06:	0f 84 24 02 00 00    	je     80100d30 <consoleintr+0x2c0>
80100b0c:	81 fe e3 00 00 00    	cmp    $0xe3,%esi
80100b12:	75 34                	jne    80100b48 <consoleintr+0xd8>
      if ((history.count != 0 ) && (history.last - history.index > 0))
80100b14:	a1 bc 35 11 80       	mov    0x801135bc,%eax
80100b19:	85 c0                	test   %eax,%eax
80100b1b:	0f 84 71 ff ff ff    	je     80100a92 <consoleintr+0x22>
80100b21:	a1 c0 35 11 80       	mov    0x801135c0,%eax
80100b26:	2b 05 b8 35 11 80    	sub    0x801135b8,%eax
80100b2c:	85 c0                	test   %eax,%eax
80100b2e:	0f 8e 5e ff ff ff    	jle    80100a92 <consoleintr+0x22>
        arrow(DOWN);
80100b34:	b8 01 00 00 00       	mov    $0x1,%eax
80100b39:	e8 82 fb ff ff       	call   801006c0 <arrow>
80100b3e:	e9 4f ff ff ff       	jmp    80100a92 <consoleintr+0x22>
80100b43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b47:	90                   	nop
    switch(c){
80100b48:	83 fe 7f             	cmp    $0x7f,%esi
80100b4b:	0f 85 17 01 00 00    	jne    80100c68 <consoleintr+0x1f8>
      if(input.e != input.w){
80100b51:	a1 28 30 11 80       	mov    0x80113028,%eax
80100b56:	3b 05 24 30 11 80    	cmp    0x80113024,%eax
80100b5c:	0f 84 30 ff ff ff    	je     80100a92 <consoleintr+0x22>
        input.e--;  
80100b62:	83 e8 01             	sub    $0x1,%eax
80100b65:	a3 28 30 11 80       	mov    %eax,0x80113028
  if(panicked){
80100b6a:	a1 5c d5 10 80       	mov    0x8010d55c,%eax
80100b6f:	85 c0                	test   %eax,%eax
80100b71:	0f 84 06 02 00 00    	je     80100d7d <consoleintr+0x30d>
80100b77:	fa                   	cli    
    for(;;)
80100b78:	eb fe                	jmp    80100b78 <consoleintr+0x108>
      if (backs > 0) {
80100b7a:	a1 58 d5 10 80       	mov    0x8010d558,%eax
80100b7f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100b82:	85 c0                	test   %eax,%eax
80100b84:	0f 8e 08 ff ff ff    	jle    80100a92 <consoleintr+0x22>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100b8a:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100b8f:	b8 0e 00 00 00       	mov    $0xe,%eax
80100b94:	89 fa                	mov    %edi,%edx
80100b96:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100b97:	be d5 03 00 00       	mov    $0x3d5,%esi
80100b9c:	89 f2                	mov    %esi,%edx
80100b9e:	ec                   	in     (%dx),%al
80100b9f:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100ba2:	89 fa                	mov    %edi,%edx
80100ba4:	b8 0f 00 00 00       	mov    $0xf,%eax
  pos = inb(CRTPORT + 1) << 8;
80100ba9:	c1 e1 08             	shl    $0x8,%ecx
80100bac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100bad:	89 f2                	mov    %esi,%edx
80100baf:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100bb0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100bb3:	89 fa                	mov    %edi,%edx
80100bb5:	09 c1                	or     %eax,%ecx
80100bb7:	b8 0e 00 00 00       	mov    $0xe,%eax
    pos++;
80100bbc:	83 c1 01             	add    $0x1,%ecx
80100bbf:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
80100bc0:	89 ca                	mov    %ecx,%edx
80100bc2:	c1 fa 08             	sar    $0x8,%edx
80100bc5:	89 d0                	mov    %edx,%eax
80100bc7:	89 f2                	mov    %esi,%edx
80100bc9:	ee                   	out    %al,(%dx)
80100bca:	b8 0f 00 00 00       	mov    $0xf,%eax
80100bcf:	89 fa                	mov    %edi,%edx
80100bd1:	ee                   	out    %al,(%dx)
80100bd2:	89 c8                	mov    %ecx,%eax
80100bd4:	89 f2                	mov    %esi,%edx
80100bd6:	ee                   	out    %al,(%dx)
        backs--;
80100bd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100bda:	83 e8 01             	sub    $0x1,%eax
80100bdd:	a3 58 d5 10 80       	mov    %eax,0x8010d558
80100be2:	e9 ab fe ff ff       	jmp    80100a92 <consoleintr+0x22>
      if ((input.e - backs) > input.w)
80100be7:	a1 58 d5 10 80       	mov    0x8010d558,%eax
80100bec:	8b 3d 28 30 11 80    	mov    0x80113028,%edi
80100bf2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100bf5:	29 c7                	sub    %eax,%edi
80100bf7:	3b 3d 24 30 11 80    	cmp    0x80113024,%edi
80100bfd:	0f 86 8f fe ff ff    	jbe    80100a92 <consoleintr+0x22>
80100c03:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100c08:	b8 0e 00 00 00       	mov    $0xe,%eax
80100c0d:	89 fa                	mov    %edi,%edx
80100c0f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100c10:	be d5 03 00 00       	mov    $0x3d5,%esi
80100c15:	89 f2                	mov    %esi,%edx
80100c17:	ec                   	in     (%dx),%al
80100c18:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100c1b:	89 fa                	mov    %edi,%edx
80100c1d:	b8 0f 00 00 00       	mov    $0xf,%eax
  pos = inb(CRTPORT + 1) << 8;
80100c22:	c1 e1 08             	shl    $0x8,%ecx
80100c25:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100c26:	89 f2                	mov    %esi,%edx
80100c28:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT + 1);
80100c29:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100c2c:	89 fa                	mov    %edi,%edx
80100c2e:	09 c1                	or     %eax,%ecx
80100c30:	b8 0e 00 00 00       	mov    $0xe,%eax
    pos--;
80100c35:	83 e9 01             	sub    $0x1,%ecx
80100c38:	ee                   	out    %al,(%dx)
  outb(CRTPORT + 1, pos >> 8);
80100c39:	89 ca                	mov    %ecx,%edx
80100c3b:	c1 fa 08             	sar    $0x8,%edx
80100c3e:	89 d0                	mov    %edx,%eax
80100c40:	89 f2                	mov    %esi,%edx
80100c42:	ee                   	out    %al,(%dx)
80100c43:	b8 0f 00 00 00       	mov    $0xf,%eax
80100c48:	89 fa                	mov    %edi,%edx
80100c4a:	ee                   	out    %al,(%dx)
80100c4b:	89 c8                	mov    %ecx,%eax
80100c4d:	89 f2                	mov    %esi,%edx
80100c4f:	ee                   	out    %al,(%dx)
        backs++;
80100c50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100c53:	83 c0 01             	add    $0x1,%eax
80100c56:	a3 58 d5 10 80       	mov    %eax,0x8010d558
80100c5b:	e9 32 fe ff ff       	jmp    80100a92 <consoleintr+0x22>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100c60:	85 f6                	test   %esi,%esi
80100c62:	0f 84 2a fe ff ff    	je     80100a92 <consoleintr+0x22>
80100c68:	a1 28 30 11 80       	mov    0x80113028,%eax
80100c6d:	89 c2                	mov    %eax,%edx
80100c6f:	2b 15 20 30 11 80    	sub    0x80113020,%edx
80100c75:	83 fa 7f             	cmp    $0x7f,%edx
80100c78:	0f 87 14 fe ff ff    	ja     80100a92 <consoleintr+0x22>
        c = (c == '\r') ? '\n' : c;
80100c7e:	8d 48 01             	lea    0x1(%eax),%ecx
80100c81:	8b 15 5c d5 10 80    	mov    0x8010d55c,%edx
80100c87:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
80100c8a:	89 0d 28 30 11 80    	mov    %ecx,0x80113028
        c = (c == '\r') ? '\n' : c;
80100c90:	83 fe 0d             	cmp    $0xd,%esi
80100c93:	0f 84 f3 00 00 00    	je     80100d8c <consoleintr+0x31c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100c99:	89 f1                	mov    %esi,%ecx
80100c9b:	88 88 a0 2f 11 80    	mov    %cl,-0x7feed060(%eax)
  if(panicked){
80100ca1:	85 d2                	test   %edx,%edx
80100ca3:	0f 84 d7 01 00 00    	je     80100e80 <consoleintr+0x410>
  asm volatile("cli");
80100ca9:	fa                   	cli    
    for(;;)
80100caa:	eb fe                	jmp    80100caa <consoleintr+0x23a>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100cac:	be d4 03 00 00       	mov    $0x3d4,%esi
80100cb1:	b8 0e 00 00 00       	mov    $0xe,%eax
80100cb6:	89 f2                	mov    %esi,%edx
80100cb8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100cb9:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100cbe:	89 ca                	mov    %ecx,%edx
80100cc0:	ec                   	in     (%dx),%al
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100cc1:	b8 0f 00 00 00       	mov    $0xf,%eax
80100cc6:	89 f2                	mov    %esi,%edx
80100cc8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100cc9:	89 ca                	mov    %ecx,%edx
80100ccb:	ec                   	in     (%dx),%al
80100ccc:	be d0 07 00 00       	mov    $0x7d0,%esi
  if(panicked){
80100cd1:	8b 3d 5c d5 10 80    	mov    0x8010d55c,%edi
80100cd7:	85 ff                	test   %edi,%edi
80100cd9:	74 05                	je     80100ce0 <consoleintr+0x270>
  asm volatile("cli");
80100cdb:	fa                   	cli    
    for(;;)
80100cdc:	eb fe                	jmp    80100cdc <consoleintr+0x26c>
80100cde:	66 90                	xchg   %ax,%ax
80100ce0:	b8 00 01 00 00       	mov    $0x100,%eax
80100ce5:	e8 26 f7 ff ff       	call   80100410 <consputc.part.0>
  for (int pos = 0; pos < SCREEN_SIZE ; pos++){
80100cea:	83 ee 01             	sub    $0x1,%esi
80100ced:	75 e2                	jne    80100cd1 <consoleintr+0x261>
  if(panicked){
80100cef:	8b 0d 5c d5 10 80    	mov    0x8010d55c,%ecx
  backs = 0;
80100cf5:	c7 05 58 d5 10 80 00 	movl   $0x0,0x8010d558
80100cfc:	00 00 00 
  input.e = input.w = input.r = 0;
80100cff:	c7 05 20 30 11 80 00 	movl   $0x0,0x80113020
80100d06:	00 00 00 
80100d09:	c7 05 24 30 11 80 00 	movl   $0x0,0x80113024
80100d10:	00 00 00 
80100d13:	c7 05 28 30 11 80 00 	movl   $0x0,0x80113028
80100d1a:	00 00 00 
  if(panicked){
80100d1d:	85 c9                	test   %ecx,%ecx
80100d1f:	0f 84 fb 00 00 00    	je     80100e20 <consoleintr+0x3b0>
80100d25:	fa                   	cli    
    for(;;)
80100d26:	eb fe                	jmp    80100d26 <consoleintr+0x2b6>
80100d28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100d2f:	90                   	nop
      if ((history.count != 0)  && (history.last - history.index < history.count))
80100d30:	8b 15 bc 35 11 80    	mov    0x801135bc,%edx
80100d36:	85 d2                	test   %edx,%edx
80100d38:	0f 84 54 fd ff ff    	je     80100a92 <consoleintr+0x22>
80100d3e:	a1 c0 35 11 80       	mov    0x801135c0,%eax
80100d43:	2b 05 b8 35 11 80    	sub    0x801135b8,%eax
80100d49:	39 c2                	cmp    %eax,%edx
80100d4b:	0f 8e 41 fd ff ff    	jle    80100a92 <consoleintr+0x22>
        arrow(UP);
80100d51:	31 c0                	xor    %eax,%eax
80100d53:	e8 68 f9 ff ff       	call   801006c0 <arrow>
80100d58:	e9 35 fd ff ff       	jmp    80100a92 <consoleintr+0x22>
  release(&cons.lock);
80100d5d:	83 ec 0c             	sub    $0xc,%esp
80100d60:	68 20 d5 10 80       	push   $0x8010d520
80100d65:	e8 06 50 00 00       	call   80105d70 <release>
  if(doprocdump) {
80100d6a:	83 c4 10             	add    $0x10,%esp
80100d6d:	85 db                	test   %ebx,%ebx
80100d6f:	0f 85 40 01 00 00    	jne    80100eb5 <consoleintr+0x445>
}
80100d75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d78:	5b                   	pop    %ebx
80100d79:	5e                   	pop    %esi
80100d7a:	5f                   	pop    %edi
80100d7b:	5d                   	pop    %ebp
80100d7c:	c3                   	ret    
80100d7d:	b8 00 01 00 00       	mov    $0x100,%eax
80100d82:	e8 89 f6 ff ff       	call   80100410 <consputc.part.0>
80100d87:	e9 06 fd ff ff       	jmp    80100a92 <consoleintr+0x22>
        input.buf[input.e++ % INPUT_BUF] = c;
80100d8c:	c6 80 a0 2f 11 80 0a 	movb   $0xa,-0x7feed060(%eax)
  if(panicked){
80100d93:	85 d2                	test   %edx,%edx
80100d95:	0f 85 0e ff ff ff    	jne    80100ca9 <consoleintr+0x239>
80100d9b:	b8 0a 00 00 00       	mov    $0xa,%eax
80100da0:	e8 6b f6 ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100da5:	8b 15 28 30 11 80    	mov    0x80113028,%edx
          if (history.count < 9){
80100dab:	a1 bc 35 11 80       	mov    0x801135bc,%eax
80100db0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100db3:	83 f8 08             	cmp    $0x8,%eax
80100db6:	0f 8f 05 01 00 00    	jg     80100ec1 <consoleintr+0x451>
            history.hist[history.last + 1] = input;
80100dbc:	8b 3d c0 35 11 80    	mov    0x801135c0,%edi
80100dc2:	b9 23 00 00 00       	mov    $0x23,%ecx
80100dc7:	be a0 2f 11 80       	mov    $0x80112fa0,%esi
80100dcc:	83 c7 01             	add    $0x1,%edi
80100dcf:	69 c7 8c 00 00 00    	imul   $0x8c,%edi,%eax
80100dd5:	89 7d e0             	mov    %edi,-0x20(%ebp)
80100dd8:	05 40 30 11 80       	add    $0x80113040,%eax
80100ddd:	89 c7                	mov    %eax,%edi
            history.count ++ ;
80100ddf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
            history.hist[history.last + 1] = input;
80100de2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            history.last ++ ;
80100de4:	8b 7d e0             	mov    -0x20(%ebp),%edi
            history.count ++ ;
80100de7:	83 c0 01             	add    $0x1,%eax
            history.last ++ ;
80100dea:	89 3d c0 35 11 80    	mov    %edi,0x801135c0
            history.index = history.last;
80100df0:	89 3d b8 35 11 80    	mov    %edi,0x801135b8
            history.count ++ ;
80100df6:	a3 bc 35 11 80       	mov    %eax,0x801135bc
          wakeup(&input.r);
80100dfb:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100dfe:	89 15 24 30 11 80    	mov    %edx,0x80113024
          wakeup(&input.r);
80100e04:	68 20 30 11 80       	push   $0x80113020
          backs = 0;
80100e09:	c7 05 58 d5 10 80 00 	movl   $0x0,0x8010d558
80100e10:	00 00 00 
          wakeup(&input.r);
80100e13:	e8 c8 38 00 00       	call   801046e0 <wakeup>
80100e18:	83 c4 10             	add    $0x10,%esp
80100e1b:	e9 72 fc ff ff       	jmp    80100a92 <consoleintr+0x22>
80100e20:	b8 24 00 00 00       	mov    $0x24,%eax
80100e25:	e8 e6 f5 ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100e2a:	8b 15 5c d5 10 80    	mov    0x8010d55c,%edx
80100e30:	85 d2                	test   %edx,%edx
80100e32:	74 0c                	je     80100e40 <consoleintr+0x3d0>
80100e34:	fa                   	cli    
    for(;;)
80100e35:	eb fe                	jmp    80100e35 <consoleintr+0x3c5>
80100e37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100e3e:	66 90                	xchg   %ax,%ax
80100e40:	b8 20 00 00 00       	mov    $0x20,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100e45:	be d4 03 00 00       	mov    $0x3d4,%esi
80100e4a:	e8 c1 f5 ff ff       	call   80100410 <consputc.part.0>
80100e4f:	b8 0e 00 00 00       	mov    $0xe,%eax
80100e54:	89 f2                	mov    %esi,%edx
80100e56:	ee                   	out    %al,(%dx)
80100e57:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100e5c:	31 c0                	xor    %eax,%eax
80100e5e:	89 ca                	mov    %ecx,%edx
80100e60:	ee                   	out    %al,(%dx)
80100e61:	b8 0f 00 00 00       	mov    $0xf,%eax
80100e66:	89 f2                	mov    %esi,%edx
80100e68:	ee                   	out    %al,(%dx)
80100e69:	b8 02 00 00 00       	mov    $0x2,%eax
80100e6e:	89 ca                	mov    %ecx,%edx
80100e70:	ee                   	out    %al,(%dx)
}
80100e71:	e9 1c fc ff ff       	jmp    80100a92 <consoleintr+0x22>
80100e76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100e7d:	8d 76 00             	lea    0x0(%esi),%esi
80100e80:	89 f0                	mov    %esi,%eax
80100e82:	e8 89 f5 ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100e87:	83 fe 0a             	cmp    $0xa,%esi
80100e8a:	0f 84 15 ff ff ff    	je     80100da5 <consoleintr+0x335>
80100e90:	83 fe 04             	cmp    $0x4,%esi
80100e93:	0f 84 0c ff ff ff    	je     80100da5 <consoleintr+0x335>
80100e99:	a1 20 30 11 80       	mov    0x80113020,%eax
80100e9e:	8d 90 80 00 00 00    	lea    0x80(%eax),%edx
80100ea4:	39 15 28 30 11 80    	cmp    %edx,0x80113028
80100eaa:	0f 85 e2 fb ff ff    	jne    80100a92 <consoleintr+0x22>
80100eb0:	e9 f6 fe ff ff       	jmp    80100dab <consoleintr+0x33b>
}
80100eb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100eb8:	5b                   	pop    %ebx
80100eb9:	5e                   	pop    %esi
80100eba:	5f                   	pop    %edi
80100ebb:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100ebc:	e9 ff 39 00 00       	jmp    801048c0 <procdump>
80100ec1:	b8 40 30 11 80       	mov    $0x80113040,%eax
              history.hist[h] = history.hist[h+1]; 
80100ec6:	8d b0 8c 00 00 00    	lea    0x8c(%eax),%esi
80100ecc:	89 c7                	mov    %eax,%edi
80100ece:	b9 23 00 00 00       	mov    $0x23,%ecx
80100ed3:	05 8c 00 00 00       	add    $0x8c,%eax
80100ed8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            for (int h = 0; h < 9; h++) {
80100eda:	bf 2c 35 11 80       	mov    $0x8011352c,%edi
80100edf:	39 c7                	cmp    %eax,%edi
80100ee1:	75 e3                	jne    80100ec6 <consoleintr+0x456>
            history.hist[9] = input;
80100ee3:	b9 23 00 00 00       	mov    $0x23,%ecx
80100ee8:	be a0 2f 11 80       	mov    $0x80112fa0,%esi
            history.index = 9;
80100eed:	c7 05 b8 35 11 80 09 	movl   $0x9,0x801135b8
80100ef4:	00 00 00 
            history.hist[9] = input;
80100ef7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            history.last = 9;
80100ef9:	c7 05 c0 35 11 80 09 	movl   $0x9,0x801135c0
80100f00:	00 00 00 
            history.count = 10;
80100f03:	c7 05 bc 35 11 80 0a 	movl   $0xa,0x801135bc
80100f0a:	00 00 00 
80100f0d:	e9 e9 fe ff ff       	jmp    80100dfb <consoleintr+0x38b>
80100f12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f20 <consoleinit>:

void
consoleinit(void)
{
80100f20:	f3 0f 1e fb          	endbr32 
80100f24:	55                   	push   %ebp
80100f25:	89 e5                	mov    %esp,%ebp
80100f27:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100f2a:	68 88 9c 10 80       	push   $0x80109c88
80100f2f:	68 20 d5 10 80       	push   $0x8010d520
80100f34:	e8 f7 4b 00 00       	call   80105b30 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100f39:	58                   	pop    %eax
80100f3a:	5a                   	pop    %edx
80100f3b:	6a 00                	push   $0x0
80100f3d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100f3f:	c7 05 8c 3f 11 80 50 	movl   $0x80100850,0x80113f8c
80100f46:	08 10 80 
  devsw[CONSOLE].read = consoleread;
80100f49:	c7 05 88 3f 11 80 90 	movl   $0x80100290,0x80113f88
80100f50:	02 10 80 
  cons.locking = 1;
80100f53:	c7 05 54 d5 10 80 01 	movl   $0x1,0x8010d554
80100f5a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100f5d:	e8 3e 1a 00 00       	call   801029a0 <ioapicenable>
}
80100f62:	83 c4 10             	add    $0x10,%esp
80100f65:	c9                   	leave  
80100f66:	c3                   	ret    
80100f67:	66 90                	xchg   %ax,%ax
80100f69:	66 90                	xchg   %ax,%ax
80100f6b:	66 90                	xchg   %ax,%ax
80100f6d:	66 90                	xchg   %ax,%ax
80100f6f:	90                   	nop

80100f70 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100f70:	f3 0f 1e fb          	endbr32 
80100f74:	55                   	push   %ebp
80100f75:	89 e5                	mov    %esp,%ebp
80100f77:	57                   	push   %edi
80100f78:	56                   	push   %esi
80100f79:	53                   	push   %ebx
80100f7a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  pushcli();
80100f80:	e8 2b 4c 00 00       	call   80105bb0 <pushcli>
  for (int i = 0; i < ncpu; i++){
80100f85:	8b 15 40 63 11 80    	mov    0x80116340,%edx
80100f8b:	85 d2                	test   %edx,%edx
80100f8d:	7e 24                	jle    80100fb3 <exec+0x43>
80100f8f:	69 d2 b4 00 00 00    	imul   $0xb4,%edx,%edx
80100f95:	31 c0                	xor    %eax,%eax
80100f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9e:	66 90                	xchg   %ax,%ax
    cpus[i].syscalls_count = 0;
80100fa0:	c7 80 50 5e 11 80 00 	movl   $0x0,-0x7feea1b0(%eax)
80100fa7:	00 00 00 
  for (int i = 0; i < ncpu; i++){
80100faa:	05 b4 00 00 00       	add    $0xb4,%eax
80100faf:	39 d0                	cmp    %edx,%eax
80100fb1:	75 ed                	jne    80100fa0 <exec+0x30>
  }
  count_shared_syscalls = 0;
80100fb3:	c7 05 c0 d5 10 80 00 	movl   $0x0,0x8010d5c0
80100fba:	00 00 00 
  popcli();
80100fbd:	e8 3e 4c 00 00       	call   80105c00 <popcli>
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100fc2:	e8 79 2f 00 00       	call   80103f40 <myproc>
80100fc7:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100fcd:	e8 ce 22 00 00       	call   801032a0 <begin_op>

  if((ip = namei(path)) == 0){
80100fd2:	83 ec 0c             	sub    $0xc,%esp
80100fd5:	ff 75 08             	pushl  0x8(%ebp)
80100fd8:	e8 c3 15 00 00       	call   801025a0 <namei>
80100fdd:	83 c4 10             	add    $0x10,%esp
80100fe0:	89 c3                	mov    %eax,%ebx
80100fe2:	85 c0                	test   %eax,%eax
80100fe4:	0f 84 2d 03 00 00    	je     80101317 <exec+0x3a7>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100fea:	83 ec 0c             	sub    $0xc,%esp
80100fed:	50                   	push   %eax
80100fee:	e8 dd 0c 00 00       	call   80101cd0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ff3:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ff9:	6a 34                	push   $0x34
80100ffb:	6a 00                	push   $0x0
80100ffd:	50                   	push   %eax
80100ffe:	53                   	push   %ebx
80100fff:	e8 cc 0f 00 00       	call   80101fd0 <readi>
80101004:	83 c4 20             	add    $0x20,%esp
80101007:	83 f8 34             	cmp    $0x34,%eax
8010100a:	74 24                	je     80101030 <exec+0xc0>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
8010100c:	83 ec 0c             	sub    $0xc,%esp
8010100f:	53                   	push   %ebx
80101010:	e8 5b 0f 00 00       	call   80101f70 <iunlockput>
    end_op();
80101015:	e8 f6 22 00 00       	call   80103310 <end_op>
8010101a:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
8010101d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101022:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101025:	5b                   	pop    %ebx
80101026:	5e                   	pop    %esi
80101027:	5f                   	pop    %edi
80101028:	5d                   	pop    %ebp
80101029:	c3                   	ret    
8010102a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(elf.magic != ELF_MAGIC)
80101030:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80101037:	45 4c 46 
8010103a:	75 d0                	jne    8010100c <exec+0x9c>
  if((pgdir = setupkvm()) == 0)
8010103c:	e8 4f 7c 00 00       	call   80108c90 <setupkvm>
80101041:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80101047:	85 c0                	test   %eax,%eax
80101049:	74 c1                	je     8010100c <exec+0x9c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
8010104b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80101052:	00 
80101053:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80101059:	0f 84 d7 02 00 00    	je     80101336 <exec+0x3c6>
  sz = 0;
8010105f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80101066:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101069:	31 ff                	xor    %edi,%edi
8010106b:	e9 86 00 00 00       	jmp    801010f6 <exec+0x186>
    if(ph.type != ELF_PROG_LOAD)
80101070:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80101077:	75 6c                	jne    801010e5 <exec+0x175>
    if(ph.memsz < ph.filesz)
80101079:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
8010107f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80101085:	0f 82 87 00 00 00    	jb     80101112 <exec+0x1a2>
    if(ph.vaddr + ph.memsz < ph.vaddr)
8010108b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80101091:	72 7f                	jb     80101112 <exec+0x1a2>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80101093:	83 ec 04             	sub    $0x4,%esp
80101096:	50                   	push   %eax
80101097:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
8010109d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801010a3:	e8 08 7a 00 00       	call   80108ab0 <allocuvm>
801010a8:	83 c4 10             	add    $0x10,%esp
801010ab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
801010b1:	85 c0                	test   %eax,%eax
801010b3:	74 5d                	je     80101112 <exec+0x1a2>
    if(ph.vaddr % PGSIZE != 0)
801010b5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
801010bb:	a9 ff 0f 00 00       	test   $0xfff,%eax
801010c0:	75 50                	jne    80101112 <exec+0x1a2>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
801010c2:	83 ec 0c             	sub    $0xc,%esp
801010c5:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
801010cb:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
801010d1:	53                   	push   %ebx
801010d2:	50                   	push   %eax
801010d3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801010d9:	e8 02 79 00 00       	call   801089e0 <loaduvm>
801010de:	83 c4 20             	add    $0x20,%esp
801010e1:	85 c0                	test   %eax,%eax
801010e3:	78 2d                	js     80101112 <exec+0x1a2>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801010e5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
801010ec:	83 c7 01             	add    $0x1,%edi
801010ef:	83 c6 20             	add    $0x20,%esi
801010f2:	39 f8                	cmp    %edi,%eax
801010f4:	7e 32                	jle    80101128 <exec+0x1b8>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
801010f6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
801010fc:	6a 20                	push   $0x20
801010fe:	56                   	push   %esi
801010ff:	50                   	push   %eax
80101100:	53                   	push   %ebx
80101101:	e8 ca 0e 00 00       	call   80101fd0 <readi>
80101106:	83 c4 10             	add    $0x10,%esp
80101109:	83 f8 20             	cmp    $0x20,%eax
8010110c:	0f 84 5e ff ff ff    	je     80101070 <exec+0x100>
    freevm(pgdir);
80101112:	83 ec 0c             	sub    $0xc,%esp
80101115:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
8010111b:	e8 f0 7a 00 00       	call   80108c10 <freevm>
  if(ip){
80101120:	83 c4 10             	add    $0x10,%esp
80101123:	e9 e4 fe ff ff       	jmp    8010100c <exec+0x9c>
80101128:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
8010112e:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80101134:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
8010113a:	8d be 00 20 00 00    	lea    0x2000(%esi),%edi
  iunlockput(ip);
80101140:	83 ec 0c             	sub    $0xc,%esp
80101143:	53                   	push   %ebx
80101144:	e8 27 0e 00 00       	call   80101f70 <iunlockput>
  end_op();
80101149:	e8 c2 21 00 00       	call   80103310 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
8010114e:	83 c4 0c             	add    $0xc,%esp
80101151:	57                   	push   %edi
80101152:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80101158:	56                   	push   %esi
80101159:	57                   	push   %edi
8010115a:	e8 51 79 00 00       	call   80108ab0 <allocuvm>
8010115f:	83 c4 10             	add    $0x10,%esp
80101162:	89 c6                	mov    %eax,%esi
80101164:	85 c0                	test   %eax,%eax
80101166:	0f 84 8f 00 00 00    	je     801011fb <exec+0x28b>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
8010116c:	83 ec 08             	sub    $0x8,%esp
8010116f:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80101175:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80101177:	50                   	push   %eax
80101178:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80101179:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
8010117b:	e8 b0 7b 00 00       	call   80108d30 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80101180:	8b 45 0c             	mov    0xc(%ebp),%eax
80101183:	83 c4 10             	add    $0x10,%esp
80101186:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
8010118c:	8b 00                	mov    (%eax),%eax
8010118e:	85 c0                	test   %eax,%eax
80101190:	0f 84 86 00 00 00    	je     8010121c <exec+0x2ac>
80101196:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
8010119c:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
801011a2:	eb 23                	jmp    801011c7 <exec+0x257>
801011a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801011a8:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
801011ab:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
801011b2:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
801011b5:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
801011bb:	8b 04 b8             	mov    (%eax,%edi,4),%eax
801011be:	85 c0                	test   %eax,%eax
801011c0:	74 54                	je     80101216 <exec+0x2a6>
    if(argc >= MAXARG)
801011c2:	83 ff 20             	cmp    $0x20,%edi
801011c5:	74 34                	je     801011fb <exec+0x28b>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
801011c7:	83 ec 0c             	sub    $0xc,%esp
801011ca:	50                   	push   %eax
801011cb:	e8 f0 4d 00 00       	call   80105fc0 <strlen>
801011d0:	f7 d0                	not    %eax
801011d2:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
801011d4:	58                   	pop    %eax
801011d5:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
801011d8:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
801011db:	ff 34 b8             	pushl  (%eax,%edi,4)
801011de:	e8 dd 4d 00 00       	call   80105fc0 <strlen>
801011e3:	83 c0 01             	add    $0x1,%eax
801011e6:	50                   	push   %eax
801011e7:	8b 45 0c             	mov    0xc(%ebp),%eax
801011ea:	ff 34 b8             	pushl  (%eax,%edi,4)
801011ed:	53                   	push   %ebx
801011ee:	56                   	push   %esi
801011ef:	e8 9c 7c 00 00       	call   80108e90 <copyout>
801011f4:	83 c4 20             	add    $0x20,%esp
801011f7:	85 c0                	test   %eax,%eax
801011f9:	79 ad                	jns    801011a8 <exec+0x238>
    freevm(pgdir);
801011fb:	83 ec 0c             	sub    $0xc,%esp
801011fe:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101204:	e8 07 7a 00 00       	call   80108c10 <freevm>
80101209:	83 c4 10             	add    $0x10,%esp
  return -1;
8010120c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101211:	e9 0c fe ff ff       	jmp    80101022 <exec+0xb2>
80101216:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010121c:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80101223:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80101225:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
8010122c:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101230:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80101232:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80101235:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
8010123b:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
8010123d:	50                   	push   %eax
8010123e:	52                   	push   %edx
8010123f:	53                   	push   %ebx
80101240:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80101246:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
8010124d:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101250:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  sp -= (3+argc+1) * 4;
80101256:	89 9d f0 fe ff ff    	mov    %ebx,-0x110(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
8010125c:	e8 2f 7c 00 00       	call   80108e90 <copyout>
80101261:	83 c4 10             	add    $0x10,%esp
80101264:	85 c0                	test   %eax,%eax
80101266:	78 93                	js     801011fb <exec+0x28b>
  for(last=s=path; *s; s++)
80101268:	8b 45 08             	mov    0x8(%ebp),%eax
8010126b:	8b 55 08             	mov    0x8(%ebp),%edx
8010126e:	0f b6 00             	movzbl (%eax),%eax
80101271:	84 c0                	test   %al,%al
80101273:	74 11                	je     80101286 <exec+0x316>
80101275:	89 d1                	mov    %edx,%ecx
    if(*s == '/')
80101277:	83 c1 01             	add    $0x1,%ecx
8010127a:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
8010127c:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
8010127f:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80101282:	84 c0                	test   %al,%al
80101284:	75 f1                	jne    80101277 <exec+0x307>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80101286:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
8010128c:	83 ec 04             	sub    $0x4,%esp
8010128f:	6a 10                	push   $0x10
80101291:	89 f8                	mov    %edi,%eax
80101293:	52                   	push   %edx
80101294:	83 c0 6c             	add    $0x6c,%eax
80101297:	50                   	push   %eax
80101298:	e8 e3 4c 00 00       	call   80105f80 <safestrcpy>
  for(int i = 0; i < SHAREDREGIONS; i++) {
8010129d:	89 f8                	mov    %edi,%eax
8010129f:	83 c4 10             	add    $0x10,%esp
801012a2:	8d bf ac 00 00 00    	lea    0xac(%edi),%edi
801012a8:	8d 98 ac 05 00 00    	lea    0x5ac(%eax),%ebx
801012ae:	66 90                	xchg   %ax,%ax
    if(curproc->pages[i].shmid != -1 && curproc->pages[i].key != -1) {
801012b0:	83 7f 08 ff          	cmpl   $0xffffffff,0x8(%edi)
801012b4:	74 13                	je     801012c9 <exec+0x359>
801012b6:	83 3f ff             	cmpl   $0xffffffff,(%edi)
801012b9:	74 0e                	je     801012c9 <exec+0x359>
      shmdtWrapper(curproc->pages[i].virtualAddr);
801012bb:	83 ec 0c             	sub    $0xc,%esp
801012be:	ff 77 10             	pushl  0x10(%edi)
801012c1:	e8 3a 89 00 00       	call   80109c00 <shmdtWrapper>
801012c6:	83 c4 10             	add    $0x10,%esp
  for(int i = 0; i < SHAREDREGIONS; i++) {
801012c9:	83 c7 14             	add    $0x14,%edi
801012cc:	39 fb                	cmp    %edi,%ebx
801012ce:	75 e0                	jne    801012b0 <exec+0x340>
  oldpgdir = curproc->pgdir;
801012d0:	8b 8d ec fe ff ff    	mov    -0x114(%ebp),%ecx
  curproc->pgdir = pgdir;
801012d6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  switchuvm(curproc);
801012dc:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
801012df:	89 31                	mov    %esi,(%ecx)
  oldpgdir = curproc->pgdir;
801012e1:	8b 79 04             	mov    0x4(%ecx),%edi
  curproc->pgdir = pgdir;
801012e4:	89 41 04             	mov    %eax,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
801012e7:	8b 41 18             	mov    0x18(%ecx),%eax
801012ea:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  curproc->tf->esp = sp;
801012f0:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  curproc->tf->eip = elf.entry;  // main
801012f6:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
801012f9:	8b 41 18             	mov    0x18(%ecx),%eax
801012fc:	89 70 44             	mov    %esi,0x44(%eax)
  switchuvm(curproc);
801012ff:	51                   	push   %ecx
80101300:	e8 4b 75 00 00       	call   80108850 <switchuvm>
  freevm(oldpgdir);
80101305:	89 3c 24             	mov    %edi,(%esp)
80101308:	e8 03 79 00 00       	call   80108c10 <freevm>
  return 0;
8010130d:	83 c4 10             	add    $0x10,%esp
80101310:	31 c0                	xor    %eax,%eax
80101312:	e9 0b fd ff ff       	jmp    80101022 <exec+0xb2>
    end_op();
80101317:	e8 f4 1f 00 00       	call   80103310 <end_op>
    cprintf("exec: fail\n");
8010131c:	83 ec 0c             	sub    $0xc,%esp
8010131f:	68 f9 9c 10 80       	push   $0x80109cf9
80101324:	e8 97 f5 ff ff       	call   801008c0 <cprintf>
    return -1;
80101329:	83 c4 10             	add    $0x10,%esp
8010132c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101331:	e9 ec fc ff ff       	jmp    80101022 <exec+0xb2>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80101336:	31 f6                	xor    %esi,%esi
80101338:	bf 00 20 00 00       	mov    $0x2000,%edi
8010133d:	e9 fe fd ff ff       	jmp    80101140 <exec+0x1d0>
80101342:	66 90                	xchg   %ax,%ax
80101344:	66 90                	xchg   %ax,%ax
80101346:	66 90                	xchg   %ax,%ax
80101348:	66 90                	xchg   %ax,%ax
8010134a:	66 90                	xchg   %ax,%ax
8010134c:	66 90                	xchg   %ax,%ax
8010134e:	66 90                	xchg   %ax,%ax

80101350 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101350:	f3 0f 1e fb          	endbr32 
80101354:	55                   	push   %ebp
80101355:	89 e5                	mov    %esp,%ebp
80101357:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
8010135a:	68 05 9d 10 80       	push   $0x80109d05
8010135f:	68 e0 35 11 80       	push   $0x801135e0
80101364:	e8 c7 47 00 00       	call   80105b30 <initlock>
}
80101369:	83 c4 10             	add    $0x10,%esp
8010136c:	c9                   	leave  
8010136d:	c3                   	ret    
8010136e:	66 90                	xchg   %ax,%ax

80101370 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101370:	f3 0f 1e fb          	endbr32 
80101374:	55                   	push   %ebp
80101375:	89 e5                	mov    %esp,%ebp
80101377:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101378:	bb 14 36 11 80       	mov    $0x80113614,%ebx
{
8010137d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80101380:	68 e0 35 11 80       	push   $0x801135e0
80101385:	e8 26 49 00 00       	call   80105cb0 <acquire>
8010138a:	83 c4 10             	add    $0x10,%esp
8010138d:	eb 0c                	jmp    8010139b <filealloc+0x2b>
8010138f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101390:	83 c3 18             	add    $0x18,%ebx
80101393:	81 fb 74 3f 11 80    	cmp    $0x80113f74,%ebx
80101399:	74 25                	je     801013c0 <filealloc+0x50>
    if(f->ref == 0){
8010139b:	8b 43 04             	mov    0x4(%ebx),%eax
8010139e:	85 c0                	test   %eax,%eax
801013a0:	75 ee                	jne    80101390 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
801013a2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
801013a5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
801013ac:	68 e0 35 11 80       	push   $0x801135e0
801013b1:	e8 ba 49 00 00       	call   80105d70 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
801013b6:	89 d8                	mov    %ebx,%eax
      return f;
801013b8:	83 c4 10             	add    $0x10,%esp
}
801013bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013be:	c9                   	leave  
801013bf:	c3                   	ret    
  release(&ftable.lock);
801013c0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801013c3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
801013c5:	68 e0 35 11 80       	push   $0x801135e0
801013ca:	e8 a1 49 00 00       	call   80105d70 <release>
}
801013cf:	89 d8                	mov    %ebx,%eax
  return 0;
801013d1:	83 c4 10             	add    $0x10,%esp
}
801013d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013d7:	c9                   	leave  
801013d8:	c3                   	ret    
801013d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801013e0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801013e0:	f3 0f 1e fb          	endbr32 
801013e4:	55                   	push   %ebp
801013e5:	89 e5                	mov    %esp,%ebp
801013e7:	53                   	push   %ebx
801013e8:	83 ec 10             	sub    $0x10,%esp
801013eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
801013ee:	68 e0 35 11 80       	push   $0x801135e0
801013f3:	e8 b8 48 00 00       	call   80105cb0 <acquire>
  if(f->ref < 1)
801013f8:	8b 43 04             	mov    0x4(%ebx),%eax
801013fb:	83 c4 10             	add    $0x10,%esp
801013fe:	85 c0                	test   %eax,%eax
80101400:	7e 1a                	jle    8010141c <filedup+0x3c>
    panic("filedup");
  f->ref++;
80101402:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80101405:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80101408:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
8010140b:	68 e0 35 11 80       	push   $0x801135e0
80101410:	e8 5b 49 00 00       	call   80105d70 <release>
  return f;
}
80101415:	89 d8                	mov    %ebx,%eax
80101417:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010141a:	c9                   	leave  
8010141b:	c3                   	ret    
    panic("filedup");
8010141c:	83 ec 0c             	sub    $0xc,%esp
8010141f:	68 0c 9d 10 80       	push   $0x80109d0c
80101424:	e8 67 ef ff ff       	call   80100390 <panic>
80101429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101430 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101430:	f3 0f 1e fb          	endbr32 
80101434:	55                   	push   %ebp
80101435:	89 e5                	mov    %esp,%ebp
80101437:	57                   	push   %edi
80101438:	56                   	push   %esi
80101439:	53                   	push   %ebx
8010143a:	83 ec 28             	sub    $0x28,%esp
8010143d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80101440:	68 e0 35 11 80       	push   $0x801135e0
80101445:	e8 66 48 00 00       	call   80105cb0 <acquire>
  if(f->ref < 1)
8010144a:	8b 53 04             	mov    0x4(%ebx),%edx
8010144d:	83 c4 10             	add    $0x10,%esp
80101450:	85 d2                	test   %edx,%edx
80101452:	0f 8e a1 00 00 00    	jle    801014f9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101458:	83 ea 01             	sub    $0x1,%edx
8010145b:	89 53 04             	mov    %edx,0x4(%ebx)
8010145e:	75 40                	jne    801014a0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80101460:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101464:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101467:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101469:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010146f:	8b 73 0c             	mov    0xc(%ebx),%esi
80101472:	88 45 e7             	mov    %al,-0x19(%ebp)
80101475:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101478:	68 e0 35 11 80       	push   $0x801135e0
  ff = *f;
8010147d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101480:	e8 eb 48 00 00       	call   80105d70 <release>

  if(ff.type == FD_PIPE)
80101485:	83 c4 10             	add    $0x10,%esp
80101488:	83 ff 01             	cmp    $0x1,%edi
8010148b:	74 53                	je     801014e0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
8010148d:	83 ff 02             	cmp    $0x2,%edi
80101490:	74 26                	je     801014b8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80101492:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101495:	5b                   	pop    %ebx
80101496:	5e                   	pop    %esi
80101497:	5f                   	pop    %edi
80101498:	5d                   	pop    %ebp
80101499:	c3                   	ret    
8010149a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
801014a0:	c7 45 08 e0 35 11 80 	movl   $0x801135e0,0x8(%ebp)
}
801014a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014aa:	5b                   	pop    %ebx
801014ab:	5e                   	pop    %esi
801014ac:	5f                   	pop    %edi
801014ad:	5d                   	pop    %ebp
    release(&ftable.lock);
801014ae:	e9 bd 48 00 00       	jmp    80105d70 <release>
801014b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801014b7:	90                   	nop
    begin_op();
801014b8:	e8 e3 1d 00 00       	call   801032a0 <begin_op>
    iput(ff.ip);
801014bd:	83 ec 0c             	sub    $0xc,%esp
801014c0:	ff 75 e0             	pushl  -0x20(%ebp)
801014c3:	e8 38 09 00 00       	call   80101e00 <iput>
    end_op();
801014c8:	83 c4 10             	add    $0x10,%esp
}
801014cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014ce:	5b                   	pop    %ebx
801014cf:	5e                   	pop    %esi
801014d0:	5f                   	pop    %edi
801014d1:	5d                   	pop    %ebp
    end_op();
801014d2:	e9 39 1e 00 00       	jmp    80103310 <end_op>
801014d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014de:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
801014e0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801014e4:	83 ec 08             	sub    $0x8,%esp
801014e7:	53                   	push   %ebx
801014e8:	56                   	push   %esi
801014e9:	e8 92 25 00 00       	call   80103a80 <pipeclose>
801014ee:	83 c4 10             	add    $0x10,%esp
}
801014f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014f4:	5b                   	pop    %ebx
801014f5:	5e                   	pop    %esi
801014f6:	5f                   	pop    %edi
801014f7:	5d                   	pop    %ebp
801014f8:	c3                   	ret    
    panic("fileclose");
801014f9:	83 ec 0c             	sub    $0xc,%esp
801014fc:	68 14 9d 10 80       	push   $0x80109d14
80101501:	e8 8a ee ff ff       	call   80100390 <panic>
80101506:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010150d:	8d 76 00             	lea    0x0(%esi),%esi

80101510 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101510:	f3 0f 1e fb          	endbr32 
80101514:	55                   	push   %ebp
80101515:	89 e5                	mov    %esp,%ebp
80101517:	53                   	push   %ebx
80101518:	83 ec 04             	sub    $0x4,%esp
8010151b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010151e:	83 3b 02             	cmpl   $0x2,(%ebx)
80101521:	75 2d                	jne    80101550 <filestat+0x40>
    ilock(f->ip);
80101523:	83 ec 0c             	sub    $0xc,%esp
80101526:	ff 73 10             	pushl  0x10(%ebx)
80101529:	e8 a2 07 00 00       	call   80101cd0 <ilock>
    stati(f->ip, st);
8010152e:	58                   	pop    %eax
8010152f:	5a                   	pop    %edx
80101530:	ff 75 0c             	pushl  0xc(%ebp)
80101533:	ff 73 10             	pushl  0x10(%ebx)
80101536:	e8 65 0a 00 00       	call   80101fa0 <stati>
    iunlock(f->ip);
8010153b:	59                   	pop    %ecx
8010153c:	ff 73 10             	pushl  0x10(%ebx)
8010153f:	e8 6c 08 00 00       	call   80101db0 <iunlock>
    return 0;
  }
  return -1;
}
80101544:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101547:	83 c4 10             	add    $0x10,%esp
8010154a:	31 c0                	xor    %eax,%eax
}
8010154c:	c9                   	leave  
8010154d:	c3                   	ret    
8010154e:	66 90                	xchg   %ax,%ax
80101550:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101553:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101558:	c9                   	leave  
80101559:	c3                   	ret    
8010155a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101560 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101560:	f3 0f 1e fb          	endbr32 
80101564:	55                   	push   %ebp
80101565:	89 e5                	mov    %esp,%ebp
80101567:	57                   	push   %edi
80101568:	56                   	push   %esi
80101569:	53                   	push   %ebx
8010156a:	83 ec 0c             	sub    $0xc,%esp
8010156d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101570:	8b 75 0c             	mov    0xc(%ebp),%esi
80101573:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101576:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010157a:	74 64                	je     801015e0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010157c:	8b 03                	mov    (%ebx),%eax
8010157e:	83 f8 01             	cmp    $0x1,%eax
80101581:	74 45                	je     801015c8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101583:	83 f8 02             	cmp    $0x2,%eax
80101586:	75 5f                	jne    801015e7 <fileread+0x87>
    ilock(f->ip);
80101588:	83 ec 0c             	sub    $0xc,%esp
8010158b:	ff 73 10             	pushl  0x10(%ebx)
8010158e:	e8 3d 07 00 00       	call   80101cd0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101593:	57                   	push   %edi
80101594:	ff 73 14             	pushl  0x14(%ebx)
80101597:	56                   	push   %esi
80101598:	ff 73 10             	pushl  0x10(%ebx)
8010159b:	e8 30 0a 00 00       	call   80101fd0 <readi>
801015a0:	83 c4 20             	add    $0x20,%esp
801015a3:	89 c6                	mov    %eax,%esi
801015a5:	85 c0                	test   %eax,%eax
801015a7:	7e 03                	jle    801015ac <fileread+0x4c>
      f->off += r;
801015a9:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801015ac:	83 ec 0c             	sub    $0xc,%esp
801015af:	ff 73 10             	pushl  0x10(%ebx)
801015b2:	e8 f9 07 00 00       	call   80101db0 <iunlock>
    return r;
801015b7:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801015ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015bd:	89 f0                	mov    %esi,%eax
801015bf:	5b                   	pop    %ebx
801015c0:	5e                   	pop    %esi
801015c1:	5f                   	pop    %edi
801015c2:	5d                   	pop    %ebp
801015c3:	c3                   	ret    
801015c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
801015c8:	8b 43 0c             	mov    0xc(%ebx),%eax
801015cb:	89 45 08             	mov    %eax,0x8(%ebp)
}
801015ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015d1:	5b                   	pop    %ebx
801015d2:	5e                   	pop    %esi
801015d3:	5f                   	pop    %edi
801015d4:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801015d5:	e9 46 26 00 00       	jmp    80103c20 <piperead>
801015da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801015e0:	be ff ff ff ff       	mov    $0xffffffff,%esi
801015e5:	eb d3                	jmp    801015ba <fileread+0x5a>
  panic("fileread");
801015e7:	83 ec 0c             	sub    $0xc,%esp
801015ea:	68 1e 9d 10 80       	push   $0x80109d1e
801015ef:	e8 9c ed ff ff       	call   80100390 <panic>
801015f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801015ff:	90                   	nop

80101600 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101600:	f3 0f 1e fb          	endbr32 
80101604:	55                   	push   %ebp
80101605:	89 e5                	mov    %esp,%ebp
80101607:	57                   	push   %edi
80101608:	56                   	push   %esi
80101609:	53                   	push   %ebx
8010160a:	83 ec 1c             	sub    $0x1c,%esp
8010160d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101610:	8b 75 08             	mov    0x8(%ebp),%esi
80101613:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101616:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101619:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
8010161d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80101620:	0f 84 c1 00 00 00    	je     801016e7 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
80101626:	8b 06                	mov    (%esi),%eax
80101628:	83 f8 01             	cmp    $0x1,%eax
8010162b:	0f 84 c3 00 00 00    	je     801016f4 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101631:	83 f8 02             	cmp    $0x2,%eax
80101634:	0f 85 cc 00 00 00    	jne    80101706 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010163a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
8010163d:	31 ff                	xor    %edi,%edi
    while(i < n){
8010163f:	85 c0                	test   %eax,%eax
80101641:	7f 34                	jg     80101677 <filewrite+0x77>
80101643:	e9 98 00 00 00       	jmp    801016e0 <filewrite+0xe0>
80101648:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010164f:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101650:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80101653:	83 ec 0c             	sub    $0xc,%esp
80101656:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101659:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010165c:	e8 4f 07 00 00       	call   80101db0 <iunlock>
      end_op();
80101661:	e8 aa 1c 00 00       	call   80103310 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101666:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101669:	83 c4 10             	add    $0x10,%esp
8010166c:	39 c3                	cmp    %eax,%ebx
8010166e:	75 60                	jne    801016d0 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101670:	01 df                	add    %ebx,%edi
    while(i < n){
80101672:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101675:	7e 69                	jle    801016e0 <filewrite+0xe0>
      int n1 = n - i;
80101677:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010167a:	b8 00 06 00 00       	mov    $0x600,%eax
8010167f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101681:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101687:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010168a:	e8 11 1c 00 00       	call   801032a0 <begin_op>
      ilock(f->ip);
8010168f:	83 ec 0c             	sub    $0xc,%esp
80101692:	ff 76 10             	pushl  0x10(%esi)
80101695:	e8 36 06 00 00       	call   80101cd0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010169a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010169d:	53                   	push   %ebx
8010169e:	ff 76 14             	pushl  0x14(%esi)
801016a1:	01 f8                	add    %edi,%eax
801016a3:	50                   	push   %eax
801016a4:	ff 76 10             	pushl  0x10(%esi)
801016a7:	e8 24 0a 00 00       	call   801020d0 <writei>
801016ac:	83 c4 20             	add    $0x20,%esp
801016af:	85 c0                	test   %eax,%eax
801016b1:	7f 9d                	jg     80101650 <filewrite+0x50>
      iunlock(f->ip);
801016b3:	83 ec 0c             	sub    $0xc,%esp
801016b6:	ff 76 10             	pushl  0x10(%esi)
801016b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801016bc:	e8 ef 06 00 00       	call   80101db0 <iunlock>
      end_op();
801016c1:	e8 4a 1c 00 00       	call   80103310 <end_op>
      if(r < 0)
801016c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801016c9:	83 c4 10             	add    $0x10,%esp
801016cc:	85 c0                	test   %eax,%eax
801016ce:	75 17                	jne    801016e7 <filewrite+0xe7>
        panic("short filewrite");
801016d0:	83 ec 0c             	sub    $0xc,%esp
801016d3:	68 27 9d 10 80       	push   $0x80109d27
801016d8:	e8 b3 ec ff ff       	call   80100390 <panic>
801016dd:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
801016e0:	89 f8                	mov    %edi,%eax
801016e2:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801016e5:	74 05                	je     801016ec <filewrite+0xec>
801016e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801016ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016ef:	5b                   	pop    %ebx
801016f0:	5e                   	pop    %esi
801016f1:	5f                   	pop    %edi
801016f2:	5d                   	pop    %ebp
801016f3:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801016f4:	8b 46 0c             	mov    0xc(%esi),%eax
801016f7:	89 45 08             	mov    %eax,0x8(%ebp)
}
801016fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016fd:	5b                   	pop    %ebx
801016fe:	5e                   	pop    %esi
801016ff:	5f                   	pop    %edi
80101700:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101701:	e9 1a 24 00 00       	jmp    80103b20 <pipewrite>
  panic("filewrite");
80101706:	83 ec 0c             	sub    $0xc,%esp
80101709:	68 2d 9d 10 80       	push   $0x80109d2d
8010170e:	e8 7d ec ff ff       	call   80100390 <panic>
80101713:	66 90                	xchg   %ax,%ax
80101715:	66 90                	xchg   %ax,%ax
80101717:	66 90                	xchg   %ax,%ax
80101719:	66 90                	xchg   %ax,%ax
8010171b:	66 90                	xchg   %ax,%ax
8010171d:	66 90                	xchg   %ax,%ax
8010171f:	90                   	nop

80101720 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101720:	55                   	push   %ebp
80101721:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101723:	89 d0                	mov    %edx,%eax
80101725:	c1 e8 0c             	shr    $0xc,%eax
80101728:	03 05 f8 3f 11 80    	add    0x80113ff8,%eax
{
8010172e:	89 e5                	mov    %esp,%ebp
80101730:	56                   	push   %esi
80101731:	53                   	push   %ebx
80101732:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101734:	83 ec 08             	sub    $0x8,%esp
80101737:	50                   	push   %eax
80101738:	51                   	push   %ecx
80101739:	e8 92 e9 ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010173e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101740:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101743:	ba 01 00 00 00       	mov    $0x1,%edx
80101748:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010174b:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80101751:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101754:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101756:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
8010175b:	85 d1                	test   %edx,%ecx
8010175d:	74 25                	je     80101784 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010175f:	f7 d2                	not    %edx
  log_write(bp);
80101761:	83 ec 0c             	sub    $0xc,%esp
80101764:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101766:	21 ca                	and    %ecx,%edx
80101768:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
8010176c:	50                   	push   %eax
8010176d:	e8 0e 1d 00 00       	call   80103480 <log_write>
  brelse(bp);
80101772:	89 34 24             	mov    %esi,(%esp)
80101775:	e8 76 ea ff ff       	call   801001f0 <brelse>
}
8010177a:	83 c4 10             	add    $0x10,%esp
8010177d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101780:	5b                   	pop    %ebx
80101781:	5e                   	pop    %esi
80101782:	5d                   	pop    %ebp
80101783:	c3                   	ret    
    panic("freeing free block");
80101784:	83 ec 0c             	sub    $0xc,%esp
80101787:	68 37 9d 10 80       	push   $0x80109d37
8010178c:	e8 ff eb ff ff       	call   80100390 <panic>
80101791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101798:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010179f:	90                   	nop

801017a0 <balloc>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	57                   	push   %edi
801017a4:	56                   	push   %esi
801017a5:	53                   	push   %ebx
801017a6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801017a9:	8b 0d e0 3f 11 80    	mov    0x80113fe0,%ecx
{
801017af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801017b2:	85 c9                	test   %ecx,%ecx
801017b4:	0f 84 87 00 00 00    	je     80101841 <balloc+0xa1>
801017ba:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801017c1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801017c4:	83 ec 08             	sub    $0x8,%esp
801017c7:	89 f0                	mov    %esi,%eax
801017c9:	c1 f8 0c             	sar    $0xc,%eax
801017cc:	03 05 f8 3f 11 80    	add    0x80113ff8,%eax
801017d2:	50                   	push   %eax
801017d3:	ff 75 d8             	pushl  -0x28(%ebp)
801017d6:	e8 f5 e8 ff ff       	call   801000d0 <bread>
801017db:	83 c4 10             	add    $0x10,%esp
801017de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801017e1:	a1 e0 3f 11 80       	mov    0x80113fe0,%eax
801017e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801017e9:	31 c0                	xor    %eax,%eax
801017eb:	eb 2f                	jmp    8010181c <balloc+0x7c>
801017ed:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801017f0:	89 c1                	mov    %eax,%ecx
801017f2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801017f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801017fa:	83 e1 07             	and    $0x7,%ecx
801017fd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801017ff:	89 c1                	mov    %eax,%ecx
80101801:	c1 f9 03             	sar    $0x3,%ecx
80101804:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101809:	89 fa                	mov    %edi,%edx
8010180b:	85 df                	test   %ebx,%edi
8010180d:	74 41                	je     80101850 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010180f:	83 c0 01             	add    $0x1,%eax
80101812:	83 c6 01             	add    $0x1,%esi
80101815:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010181a:	74 05                	je     80101821 <balloc+0x81>
8010181c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010181f:	77 cf                	ja     801017f0 <balloc+0x50>
    brelse(bp);
80101821:	83 ec 0c             	sub    $0xc,%esp
80101824:	ff 75 e4             	pushl  -0x1c(%ebp)
80101827:	e8 c4 e9 ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010182c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101833:	83 c4 10             	add    $0x10,%esp
80101836:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101839:	39 05 e0 3f 11 80    	cmp    %eax,0x80113fe0
8010183f:	77 80                	ja     801017c1 <balloc+0x21>
  panic("balloc: out of blocks");
80101841:	83 ec 0c             	sub    $0xc,%esp
80101844:	68 4a 9d 10 80       	push   $0x80109d4a
80101849:	e8 42 eb ff ff       	call   80100390 <panic>
8010184e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101850:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101853:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101856:	09 da                	or     %ebx,%edx
80101858:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010185c:	57                   	push   %edi
8010185d:	e8 1e 1c 00 00       	call   80103480 <log_write>
        brelse(bp);
80101862:	89 3c 24             	mov    %edi,(%esp)
80101865:	e8 86 e9 ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010186a:	58                   	pop    %eax
8010186b:	5a                   	pop    %edx
8010186c:	56                   	push   %esi
8010186d:	ff 75 d8             	pushl  -0x28(%ebp)
80101870:	e8 5b e8 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101875:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101878:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010187a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010187d:	68 00 02 00 00       	push   $0x200
80101882:	6a 00                	push   $0x0
80101884:	50                   	push   %eax
80101885:	e8 36 45 00 00       	call   80105dc0 <memset>
  log_write(bp);
8010188a:	89 1c 24             	mov    %ebx,(%esp)
8010188d:	e8 ee 1b 00 00       	call   80103480 <log_write>
  brelse(bp);
80101892:	89 1c 24             	mov    %ebx,(%esp)
80101895:	e8 56 e9 ff ff       	call   801001f0 <brelse>
}
8010189a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010189d:	89 f0                	mov    %esi,%eax
8010189f:	5b                   	pop    %ebx
801018a0:	5e                   	pop    %esi
801018a1:	5f                   	pop    %edi
801018a2:	5d                   	pop    %ebp
801018a3:	c3                   	ret    
801018a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018af:	90                   	nop

801018b0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	57                   	push   %edi
801018b4:	89 c7                	mov    %eax,%edi
801018b6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801018b7:	31 f6                	xor    %esi,%esi
{
801018b9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018ba:	bb 34 40 11 80       	mov    $0x80114034,%ebx
{
801018bf:	83 ec 28             	sub    $0x28,%esp
801018c2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801018c5:	68 00 40 11 80       	push   $0x80114000
801018ca:	e8 e1 43 00 00       	call   80105cb0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801018d2:	83 c4 10             	add    $0x10,%esp
801018d5:	eb 1b                	jmp    801018f2 <iget+0x42>
801018d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018de:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801018e0:	39 3b                	cmp    %edi,(%ebx)
801018e2:	74 6c                	je     80101950 <iget+0xa0>
801018e4:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018ea:	81 fb 54 5c 11 80    	cmp    $0x80115c54,%ebx
801018f0:	73 26                	jae    80101918 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801018f2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801018f5:	85 c9                	test   %ecx,%ecx
801018f7:	7f e7                	jg     801018e0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801018f9:	85 f6                	test   %esi,%esi
801018fb:	75 e7                	jne    801018e4 <iget+0x34>
801018fd:	89 d8                	mov    %ebx,%eax
801018ff:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101905:	85 c9                	test   %ecx,%ecx
80101907:	75 6e                	jne    80101977 <iget+0xc7>
80101909:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010190b:	81 fb 54 5c 11 80    	cmp    $0x80115c54,%ebx
80101911:	72 df                	jb     801018f2 <iget+0x42>
80101913:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101917:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101918:	85 f6                	test   %esi,%esi
8010191a:	74 73                	je     8010198f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010191c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010191f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101921:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101924:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010192b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101932:	68 00 40 11 80       	push   $0x80114000
80101937:	e8 34 44 00 00       	call   80105d70 <release>

  return ip;
8010193c:	83 c4 10             	add    $0x10,%esp
}
8010193f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101942:	89 f0                	mov    %esi,%eax
80101944:	5b                   	pop    %ebx
80101945:	5e                   	pop    %esi
80101946:	5f                   	pop    %edi
80101947:	5d                   	pop    %ebp
80101948:	c3                   	ret    
80101949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101950:	39 53 04             	cmp    %edx,0x4(%ebx)
80101953:	75 8f                	jne    801018e4 <iget+0x34>
      release(&icache.lock);
80101955:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101958:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010195b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010195d:	68 00 40 11 80       	push   $0x80114000
      ip->ref++;
80101962:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101965:	e8 06 44 00 00       	call   80105d70 <release>
      return ip;
8010196a:	83 c4 10             	add    $0x10,%esp
}
8010196d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101970:	89 f0                	mov    %esi,%eax
80101972:	5b                   	pop    %ebx
80101973:	5e                   	pop    %esi
80101974:	5f                   	pop    %edi
80101975:	5d                   	pop    %ebp
80101976:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101977:	81 fb 54 5c 11 80    	cmp    $0x80115c54,%ebx
8010197d:	73 10                	jae    8010198f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010197f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101982:	85 c9                	test   %ecx,%ecx
80101984:	0f 8f 56 ff ff ff    	jg     801018e0 <iget+0x30>
8010198a:	e9 6e ff ff ff       	jmp    801018fd <iget+0x4d>
    panic("iget: no inodes");
8010198f:	83 ec 0c             	sub    $0xc,%esp
80101992:	68 60 9d 10 80       	push   $0x80109d60
80101997:	e8 f4 e9 ff ff       	call   80100390 <panic>
8010199c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019a0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801019a0:	55                   	push   %ebp
801019a1:	89 e5                	mov    %esp,%ebp
801019a3:	57                   	push   %edi
801019a4:	56                   	push   %esi
801019a5:	89 c6                	mov    %eax,%esi
801019a7:	53                   	push   %ebx
801019a8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801019ab:	83 fa 0b             	cmp    $0xb,%edx
801019ae:	0f 86 84 00 00 00    	jbe    80101a38 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801019b4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801019b7:	83 fb 7f             	cmp    $0x7f,%ebx
801019ba:	0f 87 98 00 00 00    	ja     80101a58 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801019c0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801019c6:	8b 16                	mov    (%esi),%edx
801019c8:	85 c0                	test   %eax,%eax
801019ca:	74 54                	je     80101a20 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801019cc:	83 ec 08             	sub    $0x8,%esp
801019cf:	50                   	push   %eax
801019d0:	52                   	push   %edx
801019d1:	e8 fa e6 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801019d6:	83 c4 10             	add    $0x10,%esp
801019d9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
801019dd:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801019df:	8b 1a                	mov    (%edx),%ebx
801019e1:	85 db                	test   %ebx,%ebx
801019e3:	74 1b                	je     80101a00 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801019e5:	83 ec 0c             	sub    $0xc,%esp
801019e8:	57                   	push   %edi
801019e9:	e8 02 e8 ff ff       	call   801001f0 <brelse>
    return addr;
801019ee:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
801019f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019f4:	89 d8                	mov    %ebx,%eax
801019f6:	5b                   	pop    %ebx
801019f7:	5e                   	pop    %esi
801019f8:	5f                   	pop    %edi
801019f9:	5d                   	pop    %ebp
801019fa:	c3                   	ret    
801019fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019ff:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101a00:	8b 06                	mov    (%esi),%eax
80101a02:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101a05:	e8 96 fd ff ff       	call   801017a0 <balloc>
80101a0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101a0d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101a10:	89 c3                	mov    %eax,%ebx
80101a12:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101a14:	57                   	push   %edi
80101a15:	e8 66 1a 00 00       	call   80103480 <log_write>
80101a1a:	83 c4 10             	add    $0x10,%esp
80101a1d:	eb c6                	jmp    801019e5 <bmap+0x45>
80101a1f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101a20:	89 d0                	mov    %edx,%eax
80101a22:	e8 79 fd ff ff       	call   801017a0 <balloc>
80101a27:	8b 16                	mov    (%esi),%edx
80101a29:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101a2f:	eb 9b                	jmp    801019cc <bmap+0x2c>
80101a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101a38:	8d 3c 90             	lea    (%eax,%edx,4),%edi
80101a3b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101a3e:	85 db                	test   %ebx,%ebx
80101a40:	75 af                	jne    801019f1 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101a42:	8b 00                	mov    (%eax),%eax
80101a44:	e8 57 fd ff ff       	call   801017a0 <balloc>
80101a49:	89 47 5c             	mov    %eax,0x5c(%edi)
80101a4c:	89 c3                	mov    %eax,%ebx
}
80101a4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a51:	89 d8                	mov    %ebx,%eax
80101a53:	5b                   	pop    %ebx
80101a54:	5e                   	pop    %esi
80101a55:	5f                   	pop    %edi
80101a56:	5d                   	pop    %ebp
80101a57:	c3                   	ret    
  panic("bmap: out of range");
80101a58:	83 ec 0c             	sub    $0xc,%esp
80101a5b:	68 70 9d 10 80       	push   $0x80109d70
80101a60:	e8 2b e9 ff ff       	call   80100390 <panic>
80101a65:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a70 <readsb>:
{
80101a70:	f3 0f 1e fb          	endbr32 
80101a74:	55                   	push   %ebp
80101a75:	89 e5                	mov    %esp,%ebp
80101a77:	56                   	push   %esi
80101a78:	53                   	push   %ebx
80101a79:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101a7c:	83 ec 08             	sub    $0x8,%esp
80101a7f:	6a 01                	push   $0x1
80101a81:	ff 75 08             	pushl  0x8(%ebp)
80101a84:	e8 47 e6 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101a89:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101a8c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101a8e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101a91:	6a 1c                	push   $0x1c
80101a93:	50                   	push   %eax
80101a94:	56                   	push   %esi
80101a95:	e8 c6 43 00 00       	call   80105e60 <memmove>
  brelse(bp);
80101a9a:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a9d:	83 c4 10             	add    $0x10,%esp
}
80101aa0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101aa3:	5b                   	pop    %ebx
80101aa4:	5e                   	pop    %esi
80101aa5:	5d                   	pop    %ebp
  brelse(bp);
80101aa6:	e9 45 e7 ff ff       	jmp    801001f0 <brelse>
80101aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101aaf:	90                   	nop

80101ab0 <iinit>:
{
80101ab0:	f3 0f 1e fb          	endbr32 
80101ab4:	55                   	push   %ebp
80101ab5:	89 e5                	mov    %esp,%ebp
80101ab7:	53                   	push   %ebx
80101ab8:	bb 40 40 11 80       	mov    $0x80114040,%ebx
80101abd:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101ac0:	68 83 9d 10 80       	push   $0x80109d83
80101ac5:	68 00 40 11 80       	push   $0x80114000
80101aca:	e8 61 40 00 00       	call   80105b30 <initlock>
  for(i = 0; i < NINODE; i++) {
80101acf:	83 c4 10             	add    $0x10,%esp
80101ad2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101ad8:	83 ec 08             	sub    $0x8,%esp
80101adb:	68 8a 9d 10 80       	push   $0x80109d8a
80101ae0:	53                   	push   %ebx
80101ae1:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101ae7:	e8 e4 3d 00 00       	call   801058d0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101aec:	83 c4 10             	add    $0x10,%esp
80101aef:	81 fb 60 5c 11 80    	cmp    $0x80115c60,%ebx
80101af5:	75 e1                	jne    80101ad8 <iinit+0x28>
  readsb(dev, &sb);
80101af7:	83 ec 08             	sub    $0x8,%esp
80101afa:	68 e0 3f 11 80       	push   $0x80113fe0
80101aff:	ff 75 08             	pushl  0x8(%ebp)
80101b02:	e8 69 ff ff ff       	call   80101a70 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101b07:	ff 35 f8 3f 11 80    	pushl  0x80113ff8
80101b0d:	ff 35 f4 3f 11 80    	pushl  0x80113ff4
80101b13:	ff 35 f0 3f 11 80    	pushl  0x80113ff0
80101b19:	ff 35 ec 3f 11 80    	pushl  0x80113fec
80101b1f:	ff 35 e8 3f 11 80    	pushl  0x80113fe8
80101b25:	ff 35 e4 3f 11 80    	pushl  0x80113fe4
80101b2b:	ff 35 e0 3f 11 80    	pushl  0x80113fe0
80101b31:	68 f0 9d 10 80       	push   $0x80109df0
80101b36:	e8 85 ed ff ff       	call   801008c0 <cprintf>
}
80101b3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101b3e:	83 c4 30             	add    $0x30,%esp
80101b41:	c9                   	leave  
80101b42:	c3                   	ret    
80101b43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101b50 <ialloc>:
{
80101b50:	f3 0f 1e fb          	endbr32 
80101b54:	55                   	push   %ebp
80101b55:	89 e5                	mov    %esp,%ebp
80101b57:	57                   	push   %edi
80101b58:	56                   	push   %esi
80101b59:	53                   	push   %ebx
80101b5a:	83 ec 1c             	sub    $0x1c,%esp
80101b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101b60:	83 3d e8 3f 11 80 01 	cmpl   $0x1,0x80113fe8
{
80101b67:	8b 75 08             	mov    0x8(%ebp),%esi
80101b6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101b6d:	0f 86 8d 00 00 00    	jbe    80101c00 <ialloc+0xb0>
80101b73:	bf 01 00 00 00       	mov    $0x1,%edi
80101b78:	eb 1d                	jmp    80101b97 <ialloc+0x47>
80101b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101b80:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101b83:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101b86:	53                   	push   %ebx
80101b87:	e8 64 e6 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101b8c:	83 c4 10             	add    $0x10,%esp
80101b8f:	3b 3d e8 3f 11 80    	cmp    0x80113fe8,%edi
80101b95:	73 69                	jae    80101c00 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101b97:	89 f8                	mov    %edi,%eax
80101b99:	83 ec 08             	sub    $0x8,%esp
80101b9c:	c1 e8 03             	shr    $0x3,%eax
80101b9f:	03 05 f4 3f 11 80    	add    0x80113ff4,%eax
80101ba5:	50                   	push   %eax
80101ba6:	56                   	push   %esi
80101ba7:	e8 24 e5 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
80101bac:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
80101baf:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101bb1:	89 f8                	mov    %edi,%eax
80101bb3:	83 e0 07             	and    $0x7,%eax
80101bb6:	c1 e0 06             	shl    $0x6,%eax
80101bb9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101bbd:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101bc1:	75 bd                	jne    80101b80 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101bc3:	83 ec 04             	sub    $0x4,%esp
80101bc6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101bc9:	6a 40                	push   $0x40
80101bcb:	6a 00                	push   $0x0
80101bcd:	51                   	push   %ecx
80101bce:	e8 ed 41 00 00       	call   80105dc0 <memset>
      dip->type = type;
80101bd3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101bd7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101bda:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101bdd:	89 1c 24             	mov    %ebx,(%esp)
80101be0:	e8 9b 18 00 00       	call   80103480 <log_write>
      brelse(bp);
80101be5:	89 1c 24             	mov    %ebx,(%esp)
80101be8:	e8 03 e6 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80101bed:	83 c4 10             	add    $0x10,%esp
}
80101bf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101bf3:	89 fa                	mov    %edi,%edx
}
80101bf5:	5b                   	pop    %ebx
      return iget(dev, inum);
80101bf6:	89 f0                	mov    %esi,%eax
}
80101bf8:	5e                   	pop    %esi
80101bf9:	5f                   	pop    %edi
80101bfa:	5d                   	pop    %ebp
      return iget(dev, inum);
80101bfb:	e9 b0 fc ff ff       	jmp    801018b0 <iget>
  panic("ialloc: no inodes");
80101c00:	83 ec 0c             	sub    $0xc,%esp
80101c03:	68 90 9d 10 80       	push   $0x80109d90
80101c08:	e8 83 e7 ff ff       	call   80100390 <panic>
80101c0d:	8d 76 00             	lea    0x0(%esi),%esi

80101c10 <iupdate>:
{
80101c10:	f3 0f 1e fb          	endbr32 
80101c14:	55                   	push   %ebp
80101c15:	89 e5                	mov    %esp,%ebp
80101c17:	56                   	push   %esi
80101c18:	53                   	push   %ebx
80101c19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101c1c:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101c1f:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101c22:	83 ec 08             	sub    $0x8,%esp
80101c25:	c1 e8 03             	shr    $0x3,%eax
80101c28:	03 05 f4 3f 11 80    	add    0x80113ff4,%eax
80101c2e:	50                   	push   %eax
80101c2f:	ff 73 a4             	pushl  -0x5c(%ebx)
80101c32:	e8 99 e4 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101c37:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101c3b:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101c3e:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101c40:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101c43:	83 e0 07             	and    $0x7,%eax
80101c46:	c1 e0 06             	shl    $0x6,%eax
80101c49:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101c4d:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101c50:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101c54:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101c57:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101c5b:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101c5f:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101c63:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101c67:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101c6b:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101c6e:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101c71:	6a 34                	push   $0x34
80101c73:	53                   	push   %ebx
80101c74:	50                   	push   %eax
80101c75:	e8 e6 41 00 00       	call   80105e60 <memmove>
  log_write(bp);
80101c7a:	89 34 24             	mov    %esi,(%esp)
80101c7d:	e8 fe 17 00 00       	call   80103480 <log_write>
  brelse(bp);
80101c82:	89 75 08             	mov    %esi,0x8(%ebp)
80101c85:	83 c4 10             	add    $0x10,%esp
}
80101c88:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5d                   	pop    %ebp
  brelse(bp);
80101c8e:	e9 5d e5 ff ff       	jmp    801001f0 <brelse>
80101c93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ca0 <idup>:
{
80101ca0:	f3 0f 1e fb          	endbr32 
80101ca4:	55                   	push   %ebp
80101ca5:	89 e5                	mov    %esp,%ebp
80101ca7:	53                   	push   %ebx
80101ca8:	83 ec 10             	sub    $0x10,%esp
80101cab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101cae:	68 00 40 11 80       	push   $0x80114000
80101cb3:	e8 f8 3f 00 00       	call   80105cb0 <acquire>
  ip->ref++;
80101cb8:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101cbc:	c7 04 24 00 40 11 80 	movl   $0x80114000,(%esp)
80101cc3:	e8 a8 40 00 00       	call   80105d70 <release>
}
80101cc8:	89 d8                	mov    %ebx,%eax
80101cca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101ccd:	c9                   	leave  
80101cce:	c3                   	ret    
80101ccf:	90                   	nop

80101cd0 <ilock>:
{
80101cd0:	f3 0f 1e fb          	endbr32 
80101cd4:	55                   	push   %ebp
80101cd5:	89 e5                	mov    %esp,%ebp
80101cd7:	56                   	push   %esi
80101cd8:	53                   	push   %ebx
80101cd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101cdc:	85 db                	test   %ebx,%ebx
80101cde:	0f 84 b3 00 00 00    	je     80101d97 <ilock+0xc7>
80101ce4:	8b 53 08             	mov    0x8(%ebx),%edx
80101ce7:	85 d2                	test   %edx,%edx
80101ce9:	0f 8e a8 00 00 00    	jle    80101d97 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101cef:	83 ec 0c             	sub    $0xc,%esp
80101cf2:	8d 43 0c             	lea    0xc(%ebx),%eax
80101cf5:	50                   	push   %eax
80101cf6:	e8 15 3c 00 00       	call   80105910 <acquiresleep>
  if(ip->valid == 0){
80101cfb:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101cfe:	83 c4 10             	add    $0x10,%esp
80101d01:	85 c0                	test   %eax,%eax
80101d03:	74 0b                	je     80101d10 <ilock+0x40>
}
80101d05:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d08:	5b                   	pop    %ebx
80101d09:	5e                   	pop    %esi
80101d0a:	5d                   	pop    %ebp
80101d0b:	c3                   	ret    
80101d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101d10:	8b 43 04             	mov    0x4(%ebx),%eax
80101d13:	83 ec 08             	sub    $0x8,%esp
80101d16:	c1 e8 03             	shr    $0x3,%eax
80101d19:	03 05 f4 3f 11 80    	add    0x80113ff4,%eax
80101d1f:	50                   	push   %eax
80101d20:	ff 33                	pushl  (%ebx)
80101d22:	e8 a9 e3 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101d27:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101d2a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101d2c:	8b 43 04             	mov    0x4(%ebx),%eax
80101d2f:	83 e0 07             	and    $0x7,%eax
80101d32:	c1 e0 06             	shl    $0x6,%eax
80101d35:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101d39:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101d3c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101d3f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101d43:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101d47:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101d4b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101d4f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101d53:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101d57:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101d5b:	8b 50 fc             	mov    -0x4(%eax),%edx
80101d5e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101d61:	6a 34                	push   $0x34
80101d63:	50                   	push   %eax
80101d64:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101d67:	50                   	push   %eax
80101d68:	e8 f3 40 00 00       	call   80105e60 <memmove>
    brelse(bp);
80101d6d:	89 34 24             	mov    %esi,(%esp)
80101d70:	e8 7b e4 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101d75:	83 c4 10             	add    $0x10,%esp
80101d78:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101d7d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101d84:	0f 85 7b ff ff ff    	jne    80101d05 <ilock+0x35>
      panic("ilock: no type");
80101d8a:	83 ec 0c             	sub    $0xc,%esp
80101d8d:	68 a8 9d 10 80       	push   $0x80109da8
80101d92:	e8 f9 e5 ff ff       	call   80100390 <panic>
    panic("ilock");
80101d97:	83 ec 0c             	sub    $0xc,%esp
80101d9a:	68 a2 9d 10 80       	push   $0x80109da2
80101d9f:	e8 ec e5 ff ff       	call   80100390 <panic>
80101da4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101daf:	90                   	nop

80101db0 <iunlock>:
{
80101db0:	f3 0f 1e fb          	endbr32 
80101db4:	55                   	push   %ebp
80101db5:	89 e5                	mov    %esp,%ebp
80101db7:	56                   	push   %esi
80101db8:	53                   	push   %ebx
80101db9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101dbc:	85 db                	test   %ebx,%ebx
80101dbe:	74 28                	je     80101de8 <iunlock+0x38>
80101dc0:	83 ec 0c             	sub    $0xc,%esp
80101dc3:	8d 73 0c             	lea    0xc(%ebx),%esi
80101dc6:	56                   	push   %esi
80101dc7:	e8 e4 3b 00 00       	call   801059b0 <holdingsleep>
80101dcc:	83 c4 10             	add    $0x10,%esp
80101dcf:	85 c0                	test   %eax,%eax
80101dd1:	74 15                	je     80101de8 <iunlock+0x38>
80101dd3:	8b 43 08             	mov    0x8(%ebx),%eax
80101dd6:	85 c0                	test   %eax,%eax
80101dd8:	7e 0e                	jle    80101de8 <iunlock+0x38>
  releasesleep(&ip->lock);
80101dda:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101ddd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101de0:	5b                   	pop    %ebx
80101de1:	5e                   	pop    %esi
80101de2:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101de3:	e9 88 3b 00 00       	jmp    80105970 <releasesleep>
    panic("iunlock");
80101de8:	83 ec 0c             	sub    $0xc,%esp
80101deb:	68 b7 9d 10 80       	push   $0x80109db7
80101df0:	e8 9b e5 ff ff       	call   80100390 <panic>
80101df5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e00 <iput>:
{
80101e00:	f3 0f 1e fb          	endbr32 
80101e04:	55                   	push   %ebp
80101e05:	89 e5                	mov    %esp,%ebp
80101e07:	57                   	push   %edi
80101e08:	56                   	push   %esi
80101e09:	53                   	push   %ebx
80101e0a:	83 ec 28             	sub    $0x28,%esp
80101e0d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101e10:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101e13:	57                   	push   %edi
80101e14:	e8 f7 3a 00 00       	call   80105910 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101e19:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101e1c:	83 c4 10             	add    $0x10,%esp
80101e1f:	85 d2                	test   %edx,%edx
80101e21:	74 07                	je     80101e2a <iput+0x2a>
80101e23:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101e28:	74 36                	je     80101e60 <iput+0x60>
  releasesleep(&ip->lock);
80101e2a:	83 ec 0c             	sub    $0xc,%esp
80101e2d:	57                   	push   %edi
80101e2e:	e8 3d 3b 00 00       	call   80105970 <releasesleep>
  acquire(&icache.lock);
80101e33:	c7 04 24 00 40 11 80 	movl   $0x80114000,(%esp)
80101e3a:	e8 71 3e 00 00       	call   80105cb0 <acquire>
  ip->ref--;
80101e3f:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101e43:	83 c4 10             	add    $0x10,%esp
80101e46:	c7 45 08 00 40 11 80 	movl   $0x80114000,0x8(%ebp)
}
80101e4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e50:	5b                   	pop    %ebx
80101e51:	5e                   	pop    %esi
80101e52:	5f                   	pop    %edi
80101e53:	5d                   	pop    %ebp
  release(&icache.lock);
80101e54:	e9 17 3f 00 00       	jmp    80105d70 <release>
80101e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101e60:	83 ec 0c             	sub    $0xc,%esp
80101e63:	68 00 40 11 80       	push   $0x80114000
80101e68:	e8 43 3e 00 00       	call   80105cb0 <acquire>
    int r = ip->ref;
80101e6d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101e70:	c7 04 24 00 40 11 80 	movl   $0x80114000,(%esp)
80101e77:	e8 f4 3e 00 00       	call   80105d70 <release>
    if(r == 1){
80101e7c:	83 c4 10             	add    $0x10,%esp
80101e7f:	83 fe 01             	cmp    $0x1,%esi
80101e82:	75 a6                	jne    80101e2a <iput+0x2a>
80101e84:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101e8a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101e8d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101e90:	89 cf                	mov    %ecx,%edi
80101e92:	eb 0b                	jmp    80101e9f <iput+0x9f>
80101e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101e98:	83 c6 04             	add    $0x4,%esi
80101e9b:	39 fe                	cmp    %edi,%esi
80101e9d:	74 19                	je     80101eb8 <iput+0xb8>
    if(ip->addrs[i]){
80101e9f:	8b 16                	mov    (%esi),%edx
80101ea1:	85 d2                	test   %edx,%edx
80101ea3:	74 f3                	je     80101e98 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101ea5:	8b 03                	mov    (%ebx),%eax
80101ea7:	e8 74 f8 ff ff       	call   80101720 <bfree>
      ip->addrs[i] = 0;
80101eac:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101eb2:	eb e4                	jmp    80101e98 <iput+0x98>
80101eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101eb8:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101ebe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101ec1:	85 c0                	test   %eax,%eax
80101ec3:	75 33                	jne    80101ef8 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101ec5:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101ec8:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101ecf:	53                   	push   %ebx
80101ed0:	e8 3b fd ff ff       	call   80101c10 <iupdate>
      ip->type = 0;
80101ed5:	31 c0                	xor    %eax,%eax
80101ed7:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101edb:	89 1c 24             	mov    %ebx,(%esp)
80101ede:	e8 2d fd ff ff       	call   80101c10 <iupdate>
      ip->valid = 0;
80101ee3:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101eea:	83 c4 10             	add    $0x10,%esp
80101eed:	e9 38 ff ff ff       	jmp    80101e2a <iput+0x2a>
80101ef2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101ef8:	83 ec 08             	sub    $0x8,%esp
80101efb:	50                   	push   %eax
80101efc:	ff 33                	pushl  (%ebx)
80101efe:	e8 cd e1 ff ff       	call   801000d0 <bread>
80101f03:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101f06:	83 c4 10             	add    $0x10,%esp
80101f09:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101f0f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101f12:	8d 70 5c             	lea    0x5c(%eax),%esi
80101f15:	89 cf                	mov    %ecx,%edi
80101f17:	eb 0e                	jmp    80101f27 <iput+0x127>
80101f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f20:	83 c6 04             	add    $0x4,%esi
80101f23:	39 f7                	cmp    %esi,%edi
80101f25:	74 19                	je     80101f40 <iput+0x140>
      if(a[j])
80101f27:	8b 16                	mov    (%esi),%edx
80101f29:	85 d2                	test   %edx,%edx
80101f2b:	74 f3                	je     80101f20 <iput+0x120>
        bfree(ip->dev, a[j]);
80101f2d:	8b 03                	mov    (%ebx),%eax
80101f2f:	e8 ec f7 ff ff       	call   80101720 <bfree>
80101f34:	eb ea                	jmp    80101f20 <iput+0x120>
80101f36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f3d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101f40:	83 ec 0c             	sub    $0xc,%esp
80101f43:	ff 75 e4             	pushl  -0x1c(%ebp)
80101f46:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101f49:	e8 a2 e2 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101f4e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101f54:	8b 03                	mov    (%ebx),%eax
80101f56:	e8 c5 f7 ff ff       	call   80101720 <bfree>
    ip->addrs[NDIRECT] = 0;
80101f5b:	83 c4 10             	add    $0x10,%esp
80101f5e:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101f65:	00 00 00 
80101f68:	e9 58 ff ff ff       	jmp    80101ec5 <iput+0xc5>
80101f6d:	8d 76 00             	lea    0x0(%esi),%esi

80101f70 <iunlockput>:
{
80101f70:	f3 0f 1e fb          	endbr32 
80101f74:	55                   	push   %ebp
80101f75:	89 e5                	mov    %esp,%ebp
80101f77:	53                   	push   %ebx
80101f78:	83 ec 10             	sub    $0x10,%esp
80101f7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101f7e:	53                   	push   %ebx
80101f7f:	e8 2c fe ff ff       	call   80101db0 <iunlock>
  iput(ip);
80101f84:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101f87:	83 c4 10             	add    $0x10,%esp
}
80101f8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f8d:	c9                   	leave  
  iput(ip);
80101f8e:	e9 6d fe ff ff       	jmp    80101e00 <iput>
80101f93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101fa0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101fa0:	f3 0f 1e fb          	endbr32 
80101fa4:	55                   	push   %ebp
80101fa5:	89 e5                	mov    %esp,%ebp
80101fa7:	8b 55 08             	mov    0x8(%ebp),%edx
80101faa:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101fad:	8b 0a                	mov    (%edx),%ecx
80101faf:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101fb2:	8b 4a 04             	mov    0x4(%edx),%ecx
80101fb5:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101fb8:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101fbc:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101fbf:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101fc3:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101fc7:	8b 52 58             	mov    0x58(%edx),%edx
80101fca:	89 50 10             	mov    %edx,0x10(%eax)
}
80101fcd:	5d                   	pop    %ebp
80101fce:	c3                   	ret    
80101fcf:	90                   	nop

80101fd0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101fd0:	f3 0f 1e fb          	endbr32 
80101fd4:	55                   	push   %ebp
80101fd5:	89 e5                	mov    %esp,%ebp
80101fd7:	57                   	push   %edi
80101fd8:	56                   	push   %esi
80101fd9:	53                   	push   %ebx
80101fda:	83 ec 1c             	sub    $0x1c,%esp
80101fdd:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101fe0:	8b 45 08             	mov    0x8(%ebp),%eax
80101fe3:	8b 75 10             	mov    0x10(%ebp),%esi
80101fe6:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101fe9:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101fec:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ff1:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ff4:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ff7:	0f 84 a3 00 00 00    	je     801020a0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ffd:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102000:	8b 40 58             	mov    0x58(%eax),%eax
80102003:	39 c6                	cmp    %eax,%esi
80102005:	0f 87 b6 00 00 00    	ja     801020c1 <readi+0xf1>
8010200b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010200e:	31 c9                	xor    %ecx,%ecx
80102010:	89 da                	mov    %ebx,%edx
80102012:	01 f2                	add    %esi,%edx
80102014:	0f 92 c1             	setb   %cl
80102017:	89 cf                	mov    %ecx,%edi
80102019:	0f 82 a2 00 00 00    	jb     801020c1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
8010201f:	89 c1                	mov    %eax,%ecx
80102021:	29 f1                	sub    %esi,%ecx
80102023:	39 d0                	cmp    %edx,%eax
80102025:	0f 43 cb             	cmovae %ebx,%ecx
80102028:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010202b:	85 c9                	test   %ecx,%ecx
8010202d:	74 63                	je     80102092 <readi+0xc2>
8010202f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102030:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80102033:	89 f2                	mov    %esi,%edx
80102035:	c1 ea 09             	shr    $0x9,%edx
80102038:	89 d8                	mov    %ebx,%eax
8010203a:	e8 61 f9 ff ff       	call   801019a0 <bmap>
8010203f:	83 ec 08             	sub    $0x8,%esp
80102042:	50                   	push   %eax
80102043:	ff 33                	pushl  (%ebx)
80102045:	e8 86 e0 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010204a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010204d:	b9 00 02 00 00       	mov    $0x200,%ecx
80102052:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102055:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80102057:	89 f0                	mov    %esi,%eax
80102059:	25 ff 01 00 00       	and    $0x1ff,%eax
8010205e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80102060:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102063:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80102065:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102069:	39 d9                	cmp    %ebx,%ecx
8010206b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
8010206e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010206f:	01 df                	add    %ebx,%edi
80102071:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80102073:	50                   	push   %eax
80102074:	ff 75 e0             	pushl  -0x20(%ebp)
80102077:	e8 e4 3d 00 00       	call   80105e60 <memmove>
    brelse(bp);
8010207c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010207f:	89 14 24             	mov    %edx,(%esp)
80102082:	e8 69 e1 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102087:	01 5d e0             	add    %ebx,-0x20(%ebp)
8010208a:	83 c4 10             	add    $0x10,%esp
8010208d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80102090:	77 9e                	ja     80102030 <readi+0x60>
  }
  return n;
80102092:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80102095:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102098:	5b                   	pop    %ebx
80102099:	5e                   	pop    %esi
8010209a:	5f                   	pop    %edi
8010209b:	5d                   	pop    %ebp
8010209c:	c3                   	ret    
8010209d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801020a0:	0f bf 40 52          	movswl 0x52(%eax),%eax
801020a4:	66 83 f8 09          	cmp    $0x9,%ax
801020a8:	77 17                	ja     801020c1 <readi+0xf1>
801020aa:	8b 04 c5 80 3f 11 80 	mov    -0x7feec080(,%eax,8),%eax
801020b1:	85 c0                	test   %eax,%eax
801020b3:	74 0c                	je     801020c1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
801020b5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
801020b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020bb:	5b                   	pop    %ebx
801020bc:	5e                   	pop    %esi
801020bd:	5f                   	pop    %edi
801020be:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
801020bf:	ff e0                	jmp    *%eax
      return -1;
801020c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020c6:	eb cd                	jmp    80102095 <readi+0xc5>
801020c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020cf:	90                   	nop

801020d0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801020d0:	f3 0f 1e fb          	endbr32 
801020d4:	55                   	push   %ebp
801020d5:	89 e5                	mov    %esp,%ebp
801020d7:	57                   	push   %edi
801020d8:	56                   	push   %esi
801020d9:	53                   	push   %ebx
801020da:	83 ec 1c             	sub    $0x1c,%esp
801020dd:	8b 45 08             	mov    0x8(%ebp),%eax
801020e0:	8b 75 0c             	mov    0xc(%ebp),%esi
801020e3:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801020e6:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
801020eb:	89 75 dc             	mov    %esi,-0x24(%ebp)
801020ee:	89 45 d8             	mov    %eax,-0x28(%ebp)
801020f1:	8b 75 10             	mov    0x10(%ebp),%esi
801020f4:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
801020f7:	0f 84 b3 00 00 00    	je     801021b0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
801020fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102100:	39 70 58             	cmp    %esi,0x58(%eax)
80102103:	0f 82 e3 00 00 00    	jb     801021ec <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80102109:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010210c:	89 f8                	mov    %edi,%eax
8010210e:	01 f0                	add    %esi,%eax
80102110:	0f 82 d6 00 00 00    	jb     801021ec <writei+0x11c>
80102116:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010211b:	0f 87 cb 00 00 00    	ja     801021ec <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102121:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80102128:	85 ff                	test   %edi,%edi
8010212a:	74 75                	je     801021a1 <writei+0xd1>
8010212c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102130:	8b 7d d8             	mov    -0x28(%ebp),%edi
80102133:	89 f2                	mov    %esi,%edx
80102135:	c1 ea 09             	shr    $0x9,%edx
80102138:	89 f8                	mov    %edi,%eax
8010213a:	e8 61 f8 ff ff       	call   801019a0 <bmap>
8010213f:	83 ec 08             	sub    $0x8,%esp
80102142:	50                   	push   %eax
80102143:	ff 37                	pushl  (%edi)
80102145:	e8 86 df ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
8010214a:	b9 00 02 00 00       	mov    $0x200,%ecx
8010214f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80102152:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102155:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80102157:	89 f0                	mov    %esi,%eax
80102159:	83 c4 0c             	add    $0xc,%esp
8010215c:	25 ff 01 00 00       	and    $0x1ff,%eax
80102161:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80102163:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102167:	39 d9                	cmp    %ebx,%ecx
80102169:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
8010216c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010216d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
8010216f:	ff 75 dc             	pushl  -0x24(%ebp)
80102172:	50                   	push   %eax
80102173:	e8 e8 3c 00 00       	call   80105e60 <memmove>
    log_write(bp);
80102178:	89 3c 24             	mov    %edi,(%esp)
8010217b:	e8 00 13 00 00       	call   80103480 <log_write>
    brelse(bp);
80102180:	89 3c 24             	mov    %edi,(%esp)
80102183:	e8 68 e0 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102188:	01 5d e4             	add    %ebx,-0x1c(%ebp)
8010218b:	83 c4 10             	add    $0x10,%esp
8010218e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102191:	01 5d dc             	add    %ebx,-0x24(%ebp)
80102194:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80102197:	77 97                	ja     80102130 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80102199:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010219c:	3b 70 58             	cmp    0x58(%eax),%esi
8010219f:	77 37                	ja     801021d8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
801021a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
801021a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021a7:	5b                   	pop    %ebx
801021a8:	5e                   	pop    %esi
801021a9:	5f                   	pop    %edi
801021aa:	5d                   	pop    %ebp
801021ab:	c3                   	ret    
801021ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801021b0:	0f bf 40 52          	movswl 0x52(%eax),%eax
801021b4:	66 83 f8 09          	cmp    $0x9,%ax
801021b8:	77 32                	ja     801021ec <writei+0x11c>
801021ba:	8b 04 c5 84 3f 11 80 	mov    -0x7feec07c(,%eax,8),%eax
801021c1:	85 c0                	test   %eax,%eax
801021c3:	74 27                	je     801021ec <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
801021c5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
801021c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021cb:	5b                   	pop    %ebx
801021cc:	5e                   	pop    %esi
801021cd:	5f                   	pop    %edi
801021ce:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
801021cf:	ff e0                	jmp    *%eax
801021d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
801021d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
801021db:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
801021de:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
801021e1:	50                   	push   %eax
801021e2:	e8 29 fa ff ff       	call   80101c10 <iupdate>
801021e7:	83 c4 10             	add    $0x10,%esp
801021ea:	eb b5                	jmp    801021a1 <writei+0xd1>
      return -1;
801021ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021f1:	eb b1                	jmp    801021a4 <writei+0xd4>
801021f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102200 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102200:	f3 0f 1e fb          	endbr32 
80102204:	55                   	push   %ebp
80102205:	89 e5                	mov    %esp,%ebp
80102207:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
8010220a:	6a 0e                	push   $0xe
8010220c:	ff 75 0c             	pushl  0xc(%ebp)
8010220f:	ff 75 08             	pushl  0x8(%ebp)
80102212:	e8 b9 3c 00 00       	call   80105ed0 <strncmp>
}
80102217:	c9                   	leave  
80102218:	c3                   	ret    
80102219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102220 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102220:	f3 0f 1e fb          	endbr32 
80102224:	55                   	push   %ebp
80102225:	89 e5                	mov    %esp,%ebp
80102227:	57                   	push   %edi
80102228:	56                   	push   %esi
80102229:	53                   	push   %ebx
8010222a:	83 ec 1c             	sub    $0x1c,%esp
8010222d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102230:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102235:	0f 85 89 00 00 00    	jne    801022c4 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010223b:	8b 53 58             	mov    0x58(%ebx),%edx
8010223e:	31 ff                	xor    %edi,%edi
80102240:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102243:	85 d2                	test   %edx,%edx
80102245:	74 42                	je     80102289 <dirlookup+0x69>
80102247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010224e:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102250:	6a 10                	push   $0x10
80102252:	57                   	push   %edi
80102253:	56                   	push   %esi
80102254:	53                   	push   %ebx
80102255:	e8 76 fd ff ff       	call   80101fd0 <readi>
8010225a:	83 c4 10             	add    $0x10,%esp
8010225d:	83 f8 10             	cmp    $0x10,%eax
80102260:	75 55                	jne    801022b7 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80102262:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102267:	74 18                	je     80102281 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80102269:	83 ec 04             	sub    $0x4,%esp
8010226c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010226f:	6a 0e                	push   $0xe
80102271:	50                   	push   %eax
80102272:	ff 75 0c             	pushl  0xc(%ebp)
80102275:	e8 56 3c 00 00       	call   80105ed0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
8010227a:	83 c4 10             	add    $0x10,%esp
8010227d:	85 c0                	test   %eax,%eax
8010227f:	74 17                	je     80102298 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102281:	83 c7 10             	add    $0x10,%edi
80102284:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102287:	72 c7                	jb     80102250 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80102289:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010228c:	31 c0                	xor    %eax,%eax
}
8010228e:	5b                   	pop    %ebx
8010228f:	5e                   	pop    %esi
80102290:	5f                   	pop    %edi
80102291:	5d                   	pop    %ebp
80102292:	c3                   	ret    
80102293:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102297:	90                   	nop
      if(poff)
80102298:	8b 45 10             	mov    0x10(%ebp),%eax
8010229b:	85 c0                	test   %eax,%eax
8010229d:	74 05                	je     801022a4 <dirlookup+0x84>
        *poff = off;
8010229f:	8b 45 10             	mov    0x10(%ebp),%eax
801022a2:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
801022a4:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
801022a8:	8b 03                	mov    (%ebx),%eax
801022aa:	e8 01 f6 ff ff       	call   801018b0 <iget>
}
801022af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022b2:	5b                   	pop    %ebx
801022b3:	5e                   	pop    %esi
801022b4:	5f                   	pop    %edi
801022b5:	5d                   	pop    %ebp
801022b6:	c3                   	ret    
      panic("dirlookup read");
801022b7:	83 ec 0c             	sub    $0xc,%esp
801022ba:	68 d1 9d 10 80       	push   $0x80109dd1
801022bf:	e8 cc e0 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
801022c4:	83 ec 0c             	sub    $0xc,%esp
801022c7:	68 bf 9d 10 80       	push   $0x80109dbf
801022cc:	e8 bf e0 ff ff       	call   80100390 <panic>
801022d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022df:	90                   	nop

801022e0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	57                   	push   %edi
801022e4:	56                   	push   %esi
801022e5:	53                   	push   %ebx
801022e6:	89 c3                	mov    %eax,%ebx
801022e8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
801022eb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
801022ee:	89 55 e0             	mov    %edx,-0x20(%ebp)
801022f1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
801022f4:	0f 84 86 01 00 00    	je     80102480 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
801022fa:	e8 41 1c 00 00       	call   80103f40 <myproc>
  acquire(&icache.lock);
801022ff:	83 ec 0c             	sub    $0xc,%esp
80102302:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80102304:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102307:	68 00 40 11 80       	push   $0x80114000
8010230c:	e8 9f 39 00 00       	call   80105cb0 <acquire>
  ip->ref++;
80102311:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102315:	c7 04 24 00 40 11 80 	movl   $0x80114000,(%esp)
8010231c:	e8 4f 3a 00 00       	call   80105d70 <release>
80102321:	83 c4 10             	add    $0x10,%esp
80102324:	eb 0d                	jmp    80102333 <namex+0x53>
80102326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010232d:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80102330:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80102333:	0f b6 07             	movzbl (%edi),%eax
80102336:	3c 2f                	cmp    $0x2f,%al
80102338:	74 f6                	je     80102330 <namex+0x50>
  if(*path == 0)
8010233a:	84 c0                	test   %al,%al
8010233c:	0f 84 ee 00 00 00    	je     80102430 <namex+0x150>
  while(*path != '/' && *path != 0)
80102342:	0f b6 07             	movzbl (%edi),%eax
80102345:	84 c0                	test   %al,%al
80102347:	0f 84 fb 00 00 00    	je     80102448 <namex+0x168>
8010234d:	89 fb                	mov    %edi,%ebx
8010234f:	3c 2f                	cmp    $0x2f,%al
80102351:	0f 84 f1 00 00 00    	je     80102448 <namex+0x168>
80102357:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010235e:	66 90                	xchg   %ax,%ax
80102360:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80102364:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80102367:	3c 2f                	cmp    $0x2f,%al
80102369:	74 04                	je     8010236f <namex+0x8f>
8010236b:	84 c0                	test   %al,%al
8010236d:	75 f1                	jne    80102360 <namex+0x80>
  len = path - s;
8010236f:	89 d8                	mov    %ebx,%eax
80102371:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80102373:	83 f8 0d             	cmp    $0xd,%eax
80102376:	0f 8e 84 00 00 00    	jle    80102400 <namex+0x120>
    memmove(name, s, DIRSIZ);
8010237c:	83 ec 04             	sub    $0x4,%esp
8010237f:	6a 0e                	push   $0xe
80102381:	57                   	push   %edi
    path++;
80102382:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80102384:	ff 75 e4             	pushl  -0x1c(%ebp)
80102387:	e8 d4 3a 00 00       	call   80105e60 <memmove>
8010238c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
8010238f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80102392:	75 0c                	jne    801023a0 <namex+0xc0>
80102394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102398:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
8010239b:	80 3f 2f             	cmpb   $0x2f,(%edi)
8010239e:	74 f8                	je     80102398 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
801023a0:	83 ec 0c             	sub    $0xc,%esp
801023a3:	56                   	push   %esi
801023a4:	e8 27 f9 ff ff       	call   80101cd0 <ilock>
    if(ip->type != T_DIR){
801023a9:	83 c4 10             	add    $0x10,%esp
801023ac:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801023b1:	0f 85 a1 00 00 00    	jne    80102458 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
801023b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801023ba:	85 d2                	test   %edx,%edx
801023bc:	74 09                	je     801023c7 <namex+0xe7>
801023be:	80 3f 00             	cmpb   $0x0,(%edi)
801023c1:	0f 84 d9 00 00 00    	je     801024a0 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801023c7:	83 ec 04             	sub    $0x4,%esp
801023ca:	6a 00                	push   $0x0
801023cc:	ff 75 e4             	pushl  -0x1c(%ebp)
801023cf:	56                   	push   %esi
801023d0:	e8 4b fe ff ff       	call   80102220 <dirlookup>
801023d5:	83 c4 10             	add    $0x10,%esp
801023d8:	89 c3                	mov    %eax,%ebx
801023da:	85 c0                	test   %eax,%eax
801023dc:	74 7a                	je     80102458 <namex+0x178>
  iunlock(ip);
801023de:	83 ec 0c             	sub    $0xc,%esp
801023e1:	56                   	push   %esi
801023e2:	e8 c9 f9 ff ff       	call   80101db0 <iunlock>
  iput(ip);
801023e7:	89 34 24             	mov    %esi,(%esp)
801023ea:	89 de                	mov    %ebx,%esi
801023ec:	e8 0f fa ff ff       	call   80101e00 <iput>
801023f1:	83 c4 10             	add    $0x10,%esp
801023f4:	e9 3a ff ff ff       	jmp    80102333 <namex+0x53>
801023f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102400:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102403:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80102406:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80102409:	83 ec 04             	sub    $0x4,%esp
8010240c:	50                   	push   %eax
8010240d:	57                   	push   %edi
    name[len] = 0;
8010240e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80102410:	ff 75 e4             	pushl  -0x1c(%ebp)
80102413:	e8 48 3a 00 00       	call   80105e60 <memmove>
    name[len] = 0;
80102418:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010241b:	83 c4 10             	add    $0x10,%esp
8010241e:	c6 00 00             	movb   $0x0,(%eax)
80102421:	e9 69 ff ff ff       	jmp    8010238f <namex+0xaf>
80102426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010242d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102430:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102433:	85 c0                	test   %eax,%eax
80102435:	0f 85 85 00 00 00    	jne    801024c0 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
8010243b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010243e:	89 f0                	mov    %esi,%eax
80102440:	5b                   	pop    %ebx
80102441:	5e                   	pop    %esi
80102442:	5f                   	pop    %edi
80102443:	5d                   	pop    %ebp
80102444:	c3                   	ret    
80102445:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80102448:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010244b:	89 fb                	mov    %edi,%ebx
8010244d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102450:	31 c0                	xor    %eax,%eax
80102452:	eb b5                	jmp    80102409 <namex+0x129>
80102454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102458:	83 ec 0c             	sub    $0xc,%esp
8010245b:	56                   	push   %esi
8010245c:	e8 4f f9 ff ff       	call   80101db0 <iunlock>
  iput(ip);
80102461:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102464:	31 f6                	xor    %esi,%esi
  iput(ip);
80102466:	e8 95 f9 ff ff       	call   80101e00 <iput>
      return 0;
8010246b:	83 c4 10             	add    $0x10,%esp
}
8010246e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102471:	89 f0                	mov    %esi,%eax
80102473:	5b                   	pop    %ebx
80102474:	5e                   	pop    %esi
80102475:	5f                   	pop    %edi
80102476:	5d                   	pop    %ebp
80102477:	c3                   	ret    
80102478:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010247f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80102480:	ba 01 00 00 00       	mov    $0x1,%edx
80102485:	b8 01 00 00 00       	mov    $0x1,%eax
8010248a:	89 df                	mov    %ebx,%edi
8010248c:	e8 1f f4 ff ff       	call   801018b0 <iget>
80102491:	89 c6                	mov    %eax,%esi
80102493:	e9 9b fe ff ff       	jmp    80102333 <namex+0x53>
80102498:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010249f:	90                   	nop
      iunlock(ip);
801024a0:	83 ec 0c             	sub    $0xc,%esp
801024a3:	56                   	push   %esi
801024a4:	e8 07 f9 ff ff       	call   80101db0 <iunlock>
      return ip;
801024a9:	83 c4 10             	add    $0x10,%esp
}
801024ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024af:	89 f0                	mov    %esi,%eax
801024b1:	5b                   	pop    %ebx
801024b2:	5e                   	pop    %esi
801024b3:	5f                   	pop    %edi
801024b4:	5d                   	pop    %ebp
801024b5:	c3                   	ret    
801024b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024bd:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
801024c0:	83 ec 0c             	sub    $0xc,%esp
801024c3:	56                   	push   %esi
    return 0;
801024c4:	31 f6                	xor    %esi,%esi
    iput(ip);
801024c6:	e8 35 f9 ff ff       	call   80101e00 <iput>
    return 0;
801024cb:	83 c4 10             	add    $0x10,%esp
801024ce:	e9 68 ff ff ff       	jmp    8010243b <namex+0x15b>
801024d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801024e0 <dirlink>:
{
801024e0:	f3 0f 1e fb          	endbr32 
801024e4:	55                   	push   %ebp
801024e5:	89 e5                	mov    %esp,%ebp
801024e7:	57                   	push   %edi
801024e8:	56                   	push   %esi
801024e9:	53                   	push   %ebx
801024ea:	83 ec 20             	sub    $0x20,%esp
801024ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801024f0:	6a 00                	push   $0x0
801024f2:	ff 75 0c             	pushl  0xc(%ebp)
801024f5:	53                   	push   %ebx
801024f6:	e8 25 fd ff ff       	call   80102220 <dirlookup>
801024fb:	83 c4 10             	add    $0x10,%esp
801024fe:	85 c0                	test   %eax,%eax
80102500:	75 6b                	jne    8010256d <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102502:	8b 7b 58             	mov    0x58(%ebx),%edi
80102505:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102508:	85 ff                	test   %edi,%edi
8010250a:	74 2d                	je     80102539 <dirlink+0x59>
8010250c:	31 ff                	xor    %edi,%edi
8010250e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102511:	eb 0d                	jmp    80102520 <dirlink+0x40>
80102513:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102517:	90                   	nop
80102518:	83 c7 10             	add    $0x10,%edi
8010251b:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010251e:	73 19                	jae    80102539 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102520:	6a 10                	push   $0x10
80102522:	57                   	push   %edi
80102523:	56                   	push   %esi
80102524:	53                   	push   %ebx
80102525:	e8 a6 fa ff ff       	call   80101fd0 <readi>
8010252a:	83 c4 10             	add    $0x10,%esp
8010252d:	83 f8 10             	cmp    $0x10,%eax
80102530:	75 4e                	jne    80102580 <dirlink+0xa0>
    if(de.inum == 0)
80102532:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102537:	75 df                	jne    80102518 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80102539:	83 ec 04             	sub    $0x4,%esp
8010253c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010253f:	6a 0e                	push   $0xe
80102541:	ff 75 0c             	pushl  0xc(%ebp)
80102544:	50                   	push   %eax
80102545:	e8 d6 39 00 00       	call   80105f20 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010254a:	6a 10                	push   $0x10
  de.inum = inum;
8010254c:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010254f:	57                   	push   %edi
80102550:	56                   	push   %esi
80102551:	53                   	push   %ebx
  de.inum = inum;
80102552:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102556:	e8 75 fb ff ff       	call   801020d0 <writei>
8010255b:	83 c4 20             	add    $0x20,%esp
8010255e:	83 f8 10             	cmp    $0x10,%eax
80102561:	75 2a                	jne    8010258d <dirlink+0xad>
  return 0;
80102563:	31 c0                	xor    %eax,%eax
}
80102565:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102568:	5b                   	pop    %ebx
80102569:	5e                   	pop    %esi
8010256a:	5f                   	pop    %edi
8010256b:	5d                   	pop    %ebp
8010256c:	c3                   	ret    
    iput(ip);
8010256d:	83 ec 0c             	sub    $0xc,%esp
80102570:	50                   	push   %eax
80102571:	e8 8a f8 ff ff       	call   80101e00 <iput>
    return -1;
80102576:	83 c4 10             	add    $0x10,%esp
80102579:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010257e:	eb e5                	jmp    80102565 <dirlink+0x85>
      panic("dirlink read");
80102580:	83 ec 0c             	sub    $0xc,%esp
80102583:	68 e0 9d 10 80       	push   $0x80109de0
80102588:	e8 03 de ff ff       	call   80100390 <panic>
    panic("dirlink");
8010258d:	83 ec 0c             	sub    $0xc,%esp
80102590:	68 16 a6 10 80       	push   $0x8010a616
80102595:	e8 f6 dd ff ff       	call   80100390 <panic>
8010259a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801025a0 <namei>:

struct inode*
namei(char *path)
{
801025a0:	f3 0f 1e fb          	endbr32 
801025a4:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801025a5:	31 d2                	xor    %edx,%edx
{
801025a7:	89 e5                	mov    %esp,%ebp
801025a9:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801025ac:	8b 45 08             	mov    0x8(%ebp),%eax
801025af:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801025b2:	e8 29 fd ff ff       	call   801022e0 <namex>
}
801025b7:	c9                   	leave  
801025b8:	c3                   	ret    
801025b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801025c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801025c0:	f3 0f 1e fb          	endbr32 
801025c4:	55                   	push   %ebp
  return namex(path, 1, name);
801025c5:	ba 01 00 00 00       	mov    $0x1,%edx
{
801025ca:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801025cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801025cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
801025d2:	5d                   	pop    %ebp
  return namex(path, 1, name);
801025d3:	e9 08 fd ff ff       	jmp    801022e0 <namex>
801025d8:	66 90                	xchg   %ax,%ax
801025da:	66 90                	xchg   %ax,%ax
801025dc:	66 90                	xchg   %ax,%ax
801025de:	66 90                	xchg   %ax,%ax

801025e0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	57                   	push   %edi
801025e4:	56                   	push   %esi
801025e5:	53                   	push   %ebx
801025e6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801025e9:	85 c0                	test   %eax,%eax
801025eb:	0f 84 b4 00 00 00    	je     801026a5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801025f1:	8b 70 08             	mov    0x8(%eax),%esi
801025f4:	89 c3                	mov    %eax,%ebx
801025f6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801025fc:	0f 87 96 00 00 00    	ja     80102698 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102602:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102607:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010260e:	66 90                	xchg   %ax,%ax
80102610:	89 ca                	mov    %ecx,%edx
80102612:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102613:	83 e0 c0             	and    $0xffffffc0,%eax
80102616:	3c 40                	cmp    $0x40,%al
80102618:	75 f6                	jne    80102610 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010261a:	31 ff                	xor    %edi,%edi
8010261c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102621:	89 f8                	mov    %edi,%eax
80102623:	ee                   	out    %al,(%dx)
80102624:	b8 01 00 00 00       	mov    $0x1,%eax
80102629:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010262e:	ee                   	out    %al,(%dx)
8010262f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102634:	89 f0                	mov    %esi,%eax
80102636:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102637:	89 f0                	mov    %esi,%eax
80102639:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010263e:	c1 f8 08             	sar    $0x8,%eax
80102641:	ee                   	out    %al,(%dx)
80102642:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102647:	89 f8                	mov    %edi,%eax
80102649:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010264a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010264e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102653:	c1 e0 04             	shl    $0x4,%eax
80102656:	83 e0 10             	and    $0x10,%eax
80102659:	83 c8 e0             	or     $0xffffffe0,%eax
8010265c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010265d:	f6 03 04             	testb  $0x4,(%ebx)
80102660:	75 16                	jne    80102678 <idestart+0x98>
80102662:	b8 20 00 00 00       	mov    $0x20,%eax
80102667:	89 ca                	mov    %ecx,%edx
80102669:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010266a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010266d:	5b                   	pop    %ebx
8010266e:	5e                   	pop    %esi
8010266f:	5f                   	pop    %edi
80102670:	5d                   	pop    %ebp
80102671:	c3                   	ret    
80102672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102678:	b8 30 00 00 00       	mov    $0x30,%eax
8010267d:	89 ca                	mov    %ecx,%edx
8010267f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102680:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102685:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102688:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010268d:	fc                   	cld    
8010268e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102690:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102693:	5b                   	pop    %ebx
80102694:	5e                   	pop    %esi
80102695:	5f                   	pop    %edi
80102696:	5d                   	pop    %ebp
80102697:	c3                   	ret    
    panic("incorrect blockno");
80102698:	83 ec 0c             	sub    $0xc,%esp
8010269b:	68 4c 9e 10 80       	push   $0x80109e4c
801026a0:	e8 eb dc ff ff       	call   80100390 <panic>
    panic("idestart");
801026a5:	83 ec 0c             	sub    $0xc,%esp
801026a8:	68 43 9e 10 80       	push   $0x80109e43
801026ad:	e8 de dc ff ff       	call   80100390 <panic>
801026b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801026c0 <ideinit>:
{
801026c0:	f3 0f 1e fb          	endbr32 
801026c4:	55                   	push   %ebp
801026c5:	89 e5                	mov    %esp,%ebp
801026c7:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801026ca:	68 5e 9e 10 80       	push   $0x80109e5e
801026cf:	68 80 d5 10 80       	push   $0x8010d580
801026d4:	e8 57 34 00 00       	call   80105b30 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801026d9:	58                   	pop    %eax
801026da:	a1 40 63 11 80       	mov    0x80116340,%eax
801026df:	5a                   	pop    %edx
801026e0:	83 e8 01             	sub    $0x1,%eax
801026e3:	50                   	push   %eax
801026e4:	6a 0e                	push   $0xe
801026e6:	e8 b5 02 00 00       	call   801029a0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801026eb:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026ee:	ba f7 01 00 00       	mov    $0x1f7,%edx
801026f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026f7:	90                   	nop
801026f8:	ec                   	in     (%dx),%al
801026f9:	83 e0 c0             	and    $0xffffffc0,%eax
801026fc:	3c 40                	cmp    $0x40,%al
801026fe:	75 f8                	jne    801026f8 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102700:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102705:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010270a:	ee                   	out    %al,(%dx)
8010270b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102710:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102715:	eb 0e                	jmp    80102725 <ideinit+0x65>
80102717:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010271e:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102720:	83 e9 01             	sub    $0x1,%ecx
80102723:	74 0f                	je     80102734 <ideinit+0x74>
80102725:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102726:	84 c0                	test   %al,%al
80102728:	74 f6                	je     80102720 <ideinit+0x60>
      havedisk1 = 1;
8010272a:	c7 05 60 d5 10 80 01 	movl   $0x1,0x8010d560
80102731:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102734:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102739:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010273e:	ee                   	out    %al,(%dx)
}
8010273f:	c9                   	leave  
80102740:	c3                   	ret    
80102741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102748:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010274f:	90                   	nop

80102750 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102750:	f3 0f 1e fb          	endbr32 
80102754:	55                   	push   %ebp
80102755:	89 e5                	mov    %esp,%ebp
80102757:	57                   	push   %edi
80102758:	56                   	push   %esi
80102759:	53                   	push   %ebx
8010275a:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010275d:	68 80 d5 10 80       	push   $0x8010d580
80102762:	e8 49 35 00 00       	call   80105cb0 <acquire>

  if((b = idequeue) == 0){
80102767:	8b 1d 64 d5 10 80    	mov    0x8010d564,%ebx
8010276d:	83 c4 10             	add    $0x10,%esp
80102770:	85 db                	test   %ebx,%ebx
80102772:	74 5f                	je     801027d3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102774:	8b 43 58             	mov    0x58(%ebx),%eax
80102777:	a3 64 d5 10 80       	mov    %eax,0x8010d564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010277c:	8b 33                	mov    (%ebx),%esi
8010277e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102784:	75 2b                	jne    801027b1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102786:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010278b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010278f:	90                   	nop
80102790:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102791:	89 c1                	mov    %eax,%ecx
80102793:	83 e1 c0             	and    $0xffffffc0,%ecx
80102796:	80 f9 40             	cmp    $0x40,%cl
80102799:	75 f5                	jne    80102790 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010279b:	a8 21                	test   $0x21,%al
8010279d:	75 12                	jne    801027b1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010279f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801027a2:	b9 80 00 00 00       	mov    $0x80,%ecx
801027a7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801027ac:	fc                   	cld    
801027ad:	f3 6d                	rep insl (%dx),%es:(%edi)
801027af:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801027b1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801027b4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801027b7:	83 ce 02             	or     $0x2,%esi
801027ba:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801027bc:	53                   	push   %ebx
801027bd:	e8 1e 1f 00 00       	call   801046e0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801027c2:	a1 64 d5 10 80       	mov    0x8010d564,%eax
801027c7:	83 c4 10             	add    $0x10,%esp
801027ca:	85 c0                	test   %eax,%eax
801027cc:	74 05                	je     801027d3 <ideintr+0x83>
    idestart(idequeue);
801027ce:	e8 0d fe ff ff       	call   801025e0 <idestart>
    release(&idelock);
801027d3:	83 ec 0c             	sub    $0xc,%esp
801027d6:	68 80 d5 10 80       	push   $0x8010d580
801027db:	e8 90 35 00 00       	call   80105d70 <release>

  release(&idelock);
}
801027e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801027e3:	5b                   	pop    %ebx
801027e4:	5e                   	pop    %esi
801027e5:	5f                   	pop    %edi
801027e6:	5d                   	pop    %ebp
801027e7:	c3                   	ret    
801027e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ef:	90                   	nop

801027f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801027f0:	f3 0f 1e fb          	endbr32 
801027f4:	55                   	push   %ebp
801027f5:	89 e5                	mov    %esp,%ebp
801027f7:	53                   	push   %ebx
801027f8:	83 ec 10             	sub    $0x10,%esp
801027fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801027fe:	8d 43 0c             	lea    0xc(%ebx),%eax
80102801:	50                   	push   %eax
80102802:	e8 a9 31 00 00       	call   801059b0 <holdingsleep>
80102807:	83 c4 10             	add    $0x10,%esp
8010280a:	85 c0                	test   %eax,%eax
8010280c:	0f 84 cf 00 00 00    	je     801028e1 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102812:	8b 03                	mov    (%ebx),%eax
80102814:	83 e0 06             	and    $0x6,%eax
80102817:	83 f8 02             	cmp    $0x2,%eax
8010281a:	0f 84 b4 00 00 00    	je     801028d4 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102820:	8b 53 04             	mov    0x4(%ebx),%edx
80102823:	85 d2                	test   %edx,%edx
80102825:	74 0d                	je     80102834 <iderw+0x44>
80102827:	a1 60 d5 10 80       	mov    0x8010d560,%eax
8010282c:	85 c0                	test   %eax,%eax
8010282e:	0f 84 93 00 00 00    	je     801028c7 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102834:	83 ec 0c             	sub    $0xc,%esp
80102837:	68 80 d5 10 80       	push   $0x8010d580
8010283c:	e8 6f 34 00 00       	call   80105cb0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102841:	a1 64 d5 10 80       	mov    0x8010d564,%eax
  b->qnext = 0;
80102846:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010284d:	83 c4 10             	add    $0x10,%esp
80102850:	85 c0                	test   %eax,%eax
80102852:	74 6c                	je     801028c0 <iderw+0xd0>
80102854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102858:	89 c2                	mov    %eax,%edx
8010285a:	8b 40 58             	mov    0x58(%eax),%eax
8010285d:	85 c0                	test   %eax,%eax
8010285f:	75 f7                	jne    80102858 <iderw+0x68>
80102861:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102864:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102866:	39 1d 64 d5 10 80    	cmp    %ebx,0x8010d564
8010286c:	74 42                	je     801028b0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010286e:	8b 03                	mov    (%ebx),%eax
80102870:	83 e0 06             	and    $0x6,%eax
80102873:	83 f8 02             	cmp    $0x2,%eax
80102876:	74 23                	je     8010289b <iderw+0xab>
80102878:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010287f:	90                   	nop
    sleep(b, &idelock);
80102880:	83 ec 08             	sub    $0x8,%esp
80102883:	68 80 d5 10 80       	push   $0x8010d580
80102888:	53                   	push   %ebx
80102889:	e8 92 1c 00 00       	call   80104520 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010288e:	8b 03                	mov    (%ebx),%eax
80102890:	83 c4 10             	add    $0x10,%esp
80102893:	83 e0 06             	and    $0x6,%eax
80102896:	83 f8 02             	cmp    $0x2,%eax
80102899:	75 e5                	jne    80102880 <iderw+0x90>
  }


  release(&idelock);
8010289b:	c7 45 08 80 d5 10 80 	movl   $0x8010d580,0x8(%ebp)
}
801028a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028a5:	c9                   	leave  
  release(&idelock);
801028a6:	e9 c5 34 00 00       	jmp    80105d70 <release>
801028ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028af:	90                   	nop
    idestart(b);
801028b0:	89 d8                	mov    %ebx,%eax
801028b2:	e8 29 fd ff ff       	call   801025e0 <idestart>
801028b7:	eb b5                	jmp    8010286e <iderw+0x7e>
801028b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801028c0:	ba 64 d5 10 80       	mov    $0x8010d564,%edx
801028c5:	eb 9d                	jmp    80102864 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
801028c7:	83 ec 0c             	sub    $0xc,%esp
801028ca:	68 8d 9e 10 80       	push   $0x80109e8d
801028cf:	e8 bc da ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
801028d4:	83 ec 0c             	sub    $0xc,%esp
801028d7:	68 78 9e 10 80       	push   $0x80109e78
801028dc:	e8 af da ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801028e1:	83 ec 0c             	sub    $0xc,%esp
801028e4:	68 62 9e 10 80       	push   $0x80109e62
801028e9:	e8 a2 da ff ff       	call   80100390 <panic>
801028ee:	66 90                	xchg   %ax,%ax

801028f0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801028f0:	f3 0f 1e fb          	endbr32 
801028f4:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801028f5:	c7 05 54 5c 11 80 00 	movl   $0xfec00000,0x80115c54
801028fc:	00 c0 fe 
{
801028ff:	89 e5                	mov    %esp,%ebp
80102901:	56                   	push   %esi
80102902:	53                   	push   %ebx
  ioapic->reg = reg;
80102903:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
8010290a:	00 00 00 
  return ioapic->data;
8010290d:	8b 15 54 5c 11 80    	mov    0x80115c54,%edx
80102913:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102916:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010291c:	8b 0d 54 5c 11 80    	mov    0x80115c54,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102922:	0f b6 15 80 5d 11 80 	movzbl 0x80115d80,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102929:	c1 ee 10             	shr    $0x10,%esi
8010292c:	89 f0                	mov    %esi,%eax
8010292e:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80102931:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102934:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102937:	39 c2                	cmp    %eax,%edx
80102939:	74 16                	je     80102951 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
8010293b:	83 ec 0c             	sub    $0xc,%esp
8010293e:	68 ac 9e 10 80       	push   $0x80109eac
80102943:	e8 78 df ff ff       	call   801008c0 <cprintf>
80102948:	8b 0d 54 5c 11 80    	mov    0x80115c54,%ecx
8010294e:	83 c4 10             	add    $0x10,%esp
80102951:	83 c6 21             	add    $0x21,%esi
{
80102954:	ba 10 00 00 00       	mov    $0x10,%edx
80102959:	b8 20 00 00 00       	mov    $0x20,%eax
8010295e:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102960:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102962:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102964:	8b 0d 54 5c 11 80    	mov    0x80115c54,%ecx
8010296a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010296d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102973:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102976:	8d 5a 01             	lea    0x1(%edx),%ebx
80102979:	83 c2 02             	add    $0x2,%edx
8010297c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010297e:	8b 0d 54 5c 11 80    	mov    0x80115c54,%ecx
80102984:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010298b:	39 f0                	cmp    %esi,%eax
8010298d:	75 d1                	jne    80102960 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010298f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102992:	5b                   	pop    %ebx
80102993:	5e                   	pop    %esi
80102994:	5d                   	pop    %ebp
80102995:	c3                   	ret    
80102996:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010299d:	8d 76 00             	lea    0x0(%esi),%esi

801029a0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801029a0:	f3 0f 1e fb          	endbr32 
801029a4:	55                   	push   %ebp
  ioapic->reg = reg;
801029a5:	8b 0d 54 5c 11 80    	mov    0x80115c54,%ecx
{
801029ab:	89 e5                	mov    %esp,%ebp
801029ad:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801029b0:	8d 50 20             	lea    0x20(%eax),%edx
801029b3:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801029b7:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801029b9:	8b 0d 54 5c 11 80    	mov    0x80115c54,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801029bf:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801029c2:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801029c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801029c8:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801029ca:	a1 54 5c 11 80       	mov    0x80115c54,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801029cf:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801029d2:	89 50 10             	mov    %edx,0x10(%eax)
}
801029d5:	5d                   	pop    %ebp
801029d6:	c3                   	ret    
801029d7:	66 90                	xchg   %ax,%ax
801029d9:	66 90                	xchg   %ax,%ax
801029db:	66 90                	xchg   %ax,%ax
801029dd:	66 90                	xchg   %ax,%ax
801029df:	90                   	nop

801029e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801029e0:	f3 0f 1e fb          	endbr32 
801029e4:	55                   	push   %ebp
801029e5:	89 e5                	mov    %esp,%ebp
801029e7:	53                   	push   %ebx
801029e8:	83 ec 04             	sub    $0x4,%esp
801029eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801029ee:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801029f4:	75 7a                	jne    80102a70 <kfree+0x90>
801029f6:	81 fb 54 21 13 80    	cmp    $0x80132154,%ebx
801029fc:	72 72                	jb     80102a70 <kfree+0x90>
801029fe:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102a04:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102a09:	77 65                	ja     80102a70 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102a0b:	83 ec 04             	sub    $0x4,%esp
80102a0e:	68 00 10 00 00       	push   $0x1000
80102a13:	6a 01                	push   $0x1
80102a15:	53                   	push   %ebx
80102a16:	e8 a5 33 00 00       	call   80105dc0 <memset>

  if(kmem.use_lock)
80102a1b:	8b 15 94 5c 11 80    	mov    0x80115c94,%edx
80102a21:	83 c4 10             	add    $0x10,%esp
80102a24:	85 d2                	test   %edx,%edx
80102a26:	75 20                	jne    80102a48 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102a28:	a1 98 5c 11 80       	mov    0x80115c98,%eax
80102a2d:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102a2f:	a1 94 5c 11 80       	mov    0x80115c94,%eax
  kmem.freelist = r;
80102a34:	89 1d 98 5c 11 80    	mov    %ebx,0x80115c98
  if(kmem.use_lock)
80102a3a:	85 c0                	test   %eax,%eax
80102a3c:	75 22                	jne    80102a60 <kfree+0x80>
    release(&kmem.lock);
}
80102a3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a41:	c9                   	leave  
80102a42:	c3                   	ret    
80102a43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a47:	90                   	nop
    acquire(&kmem.lock);
80102a48:	83 ec 0c             	sub    $0xc,%esp
80102a4b:	68 60 5c 11 80       	push   $0x80115c60
80102a50:	e8 5b 32 00 00       	call   80105cb0 <acquire>
80102a55:	83 c4 10             	add    $0x10,%esp
80102a58:	eb ce                	jmp    80102a28 <kfree+0x48>
80102a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102a60:	c7 45 08 60 5c 11 80 	movl   $0x80115c60,0x8(%ebp)
}
80102a67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a6a:	c9                   	leave  
    release(&kmem.lock);
80102a6b:	e9 00 33 00 00       	jmp    80105d70 <release>
    panic("kfree");
80102a70:	83 ec 0c             	sub    $0xc,%esp
80102a73:	68 de 9e 10 80       	push   $0x80109ede
80102a78:	e8 13 d9 ff ff       	call   80100390 <panic>
80102a7d:	8d 76 00             	lea    0x0(%esi),%esi

80102a80 <freerange>:
{
80102a80:	f3 0f 1e fb          	endbr32 
80102a84:	55                   	push   %ebp
80102a85:	89 e5                	mov    %esp,%ebp
80102a87:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102a88:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102a8b:	8b 75 0c             	mov    0xc(%ebp),%esi
80102a8e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102a8f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102a95:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a9b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102aa1:	39 de                	cmp    %ebx,%esi
80102aa3:	72 1f                	jb     80102ac4 <freerange+0x44>
80102aa5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102aa8:	83 ec 0c             	sub    $0xc,%esp
80102aab:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ab1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102ab7:	50                   	push   %eax
80102ab8:	e8 23 ff ff ff       	call   801029e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102abd:	83 c4 10             	add    $0x10,%esp
80102ac0:	39 f3                	cmp    %esi,%ebx
80102ac2:	76 e4                	jbe    80102aa8 <freerange+0x28>
}
80102ac4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ac7:	5b                   	pop    %ebx
80102ac8:	5e                   	pop    %esi
80102ac9:	5d                   	pop    %ebp
80102aca:	c3                   	ret    
80102acb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102acf:	90                   	nop

80102ad0 <kinit1>:
{
80102ad0:	f3 0f 1e fb          	endbr32 
80102ad4:	55                   	push   %ebp
80102ad5:	89 e5                	mov    %esp,%ebp
80102ad7:	56                   	push   %esi
80102ad8:	53                   	push   %ebx
80102ad9:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102adc:	83 ec 08             	sub    $0x8,%esp
80102adf:	68 e4 9e 10 80       	push   $0x80109ee4
80102ae4:	68 60 5c 11 80       	push   $0x80115c60
80102ae9:	e8 42 30 00 00       	call   80105b30 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102aee:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102af1:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102af4:	c7 05 94 5c 11 80 00 	movl   $0x0,0x80115c94
80102afb:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102afe:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102b04:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b0a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102b10:	39 de                	cmp    %ebx,%esi
80102b12:	72 20                	jb     80102b34 <kinit1+0x64>
80102b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102b18:	83 ec 0c             	sub    $0xc,%esp
80102b1b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b21:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102b27:	50                   	push   %eax
80102b28:	e8 b3 fe ff ff       	call   801029e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b2d:	83 c4 10             	add    $0x10,%esp
80102b30:	39 de                	cmp    %ebx,%esi
80102b32:	73 e4                	jae    80102b18 <kinit1+0x48>
}
80102b34:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b37:	5b                   	pop    %ebx
80102b38:	5e                   	pop    %esi
80102b39:	5d                   	pop    %ebp
80102b3a:	c3                   	ret    
80102b3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b3f:	90                   	nop

80102b40 <kinit2>:
{
80102b40:	f3 0f 1e fb          	endbr32 
80102b44:	55                   	push   %ebp
80102b45:	89 e5                	mov    %esp,%ebp
80102b47:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102b48:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102b4b:	8b 75 0c             	mov    0xc(%ebp),%esi
80102b4e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102b4f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102b55:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b5b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102b61:	39 de                	cmp    %ebx,%esi
80102b63:	72 1f                	jb     80102b84 <kinit2+0x44>
80102b65:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102b68:	83 ec 0c             	sub    $0xc,%esp
80102b6b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b71:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102b77:	50                   	push   %eax
80102b78:	e8 63 fe ff ff       	call   801029e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b7d:	83 c4 10             	add    $0x10,%esp
80102b80:	39 de                	cmp    %ebx,%esi
80102b82:	73 e4                	jae    80102b68 <kinit2+0x28>
  kmem.use_lock = 1;
80102b84:	c7 05 94 5c 11 80 01 	movl   $0x1,0x80115c94
80102b8b:	00 00 00 
}
80102b8e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b91:	5b                   	pop    %ebx
80102b92:	5e                   	pop    %esi
80102b93:	5d                   	pop    %ebp
80102b94:	c3                   	ret    
80102b95:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102ba0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102ba0:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102ba4:	a1 94 5c 11 80       	mov    0x80115c94,%eax
80102ba9:	85 c0                	test   %eax,%eax
80102bab:	75 1b                	jne    80102bc8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102bad:	a1 98 5c 11 80       	mov    0x80115c98,%eax
  if(r)
80102bb2:	85 c0                	test   %eax,%eax
80102bb4:	74 0a                	je     80102bc0 <kalloc+0x20>
    kmem.freelist = r->next;
80102bb6:	8b 10                	mov    (%eax),%edx
80102bb8:	89 15 98 5c 11 80    	mov    %edx,0x80115c98
  if(kmem.use_lock)
80102bbe:	c3                   	ret    
80102bbf:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102bc0:	c3                   	ret    
80102bc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102bc8:	55                   	push   %ebp
80102bc9:	89 e5                	mov    %esp,%ebp
80102bcb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102bce:	68 60 5c 11 80       	push   $0x80115c60
80102bd3:	e8 d8 30 00 00       	call   80105cb0 <acquire>
  r = kmem.freelist;
80102bd8:	a1 98 5c 11 80       	mov    0x80115c98,%eax
  if(r)
80102bdd:	8b 15 94 5c 11 80    	mov    0x80115c94,%edx
80102be3:	83 c4 10             	add    $0x10,%esp
80102be6:	85 c0                	test   %eax,%eax
80102be8:	74 08                	je     80102bf2 <kalloc+0x52>
    kmem.freelist = r->next;
80102bea:	8b 08                	mov    (%eax),%ecx
80102bec:	89 0d 98 5c 11 80    	mov    %ecx,0x80115c98
  if(kmem.use_lock)
80102bf2:	85 d2                	test   %edx,%edx
80102bf4:	74 16                	je     80102c0c <kalloc+0x6c>
    release(&kmem.lock);
80102bf6:	83 ec 0c             	sub    $0xc,%esp
80102bf9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102bfc:	68 60 5c 11 80       	push   $0x80115c60
80102c01:	e8 6a 31 00 00       	call   80105d70 <release>
  return (char*)r;
80102c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102c09:	83 c4 10             	add    $0x10,%esp
}
80102c0c:	c9                   	leave  
80102c0d:	c3                   	ret    
80102c0e:	66 90                	xchg   %ax,%ax

80102c10 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102c10:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c14:	ba 64 00 00 00       	mov    $0x64,%edx
80102c19:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102c1a:	a8 01                	test   $0x1,%al
80102c1c:	0f 84 be 00 00 00    	je     80102ce0 <kbdgetc+0xd0>
{
80102c22:	55                   	push   %ebp
80102c23:	ba 60 00 00 00       	mov    $0x60,%edx
80102c28:	89 e5                	mov    %esp,%ebp
80102c2a:	53                   	push   %ebx
80102c2b:	ec                   	in     (%dx),%al
  return data;
80102c2c:	8b 1d b4 d5 10 80    	mov    0x8010d5b4,%ebx
    return -1;
  data = inb(KBDATAP);
80102c32:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102c35:	3c e0                	cmp    $0xe0,%al
80102c37:	74 57                	je     80102c90 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102c39:	89 d9                	mov    %ebx,%ecx
80102c3b:	83 e1 40             	and    $0x40,%ecx
80102c3e:	84 c0                	test   %al,%al
80102c40:	78 5e                	js     80102ca0 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102c42:	85 c9                	test   %ecx,%ecx
80102c44:	74 09                	je     80102c4f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102c46:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102c49:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102c4c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102c4f:	0f b6 8a 20 a0 10 80 	movzbl -0x7fef5fe0(%edx),%ecx
  shift ^= togglecode[data];
80102c56:	0f b6 82 20 9f 10 80 	movzbl -0x7fef60e0(%edx),%eax
  shift |= shiftcode[data];
80102c5d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102c5f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102c61:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102c63:	89 0d b4 d5 10 80    	mov    %ecx,0x8010d5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102c69:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102c6c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102c6f:	8b 04 85 00 9f 10 80 	mov    -0x7fef6100(,%eax,4),%eax
80102c76:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102c7a:	74 0b                	je     80102c87 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
80102c7c:	8d 50 9f             	lea    -0x61(%eax),%edx
80102c7f:	83 fa 19             	cmp    $0x19,%edx
80102c82:	77 44                	ja     80102cc8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102c84:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102c87:	5b                   	pop    %ebx
80102c88:	5d                   	pop    %ebp
80102c89:	c3                   	ret    
80102c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102c90:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102c93:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102c95:	89 1d b4 d5 10 80    	mov    %ebx,0x8010d5b4
}
80102c9b:	5b                   	pop    %ebx
80102c9c:	5d                   	pop    %ebp
80102c9d:	c3                   	ret    
80102c9e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102ca0:	83 e0 7f             	and    $0x7f,%eax
80102ca3:	85 c9                	test   %ecx,%ecx
80102ca5:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102ca8:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102caa:	0f b6 8a 20 a0 10 80 	movzbl -0x7fef5fe0(%edx),%ecx
80102cb1:	83 c9 40             	or     $0x40,%ecx
80102cb4:	0f b6 c9             	movzbl %cl,%ecx
80102cb7:	f7 d1                	not    %ecx
80102cb9:	21 d9                	and    %ebx,%ecx
}
80102cbb:	5b                   	pop    %ebx
80102cbc:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
80102cbd:	89 0d b4 d5 10 80    	mov    %ecx,0x8010d5b4
}
80102cc3:	c3                   	ret    
80102cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102cc8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102ccb:	8d 50 20             	lea    0x20(%eax),%edx
}
80102cce:	5b                   	pop    %ebx
80102ccf:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102cd0:	83 f9 1a             	cmp    $0x1a,%ecx
80102cd3:	0f 42 c2             	cmovb  %edx,%eax
}
80102cd6:	c3                   	ret    
80102cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cde:	66 90                	xchg   %ax,%ax
    return -1;
80102ce0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102ce5:	c3                   	ret    
80102ce6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ced:	8d 76 00             	lea    0x0(%esi),%esi

80102cf0 <kbdintr>:

void
kbdintr(void)
{
80102cf0:	f3 0f 1e fb          	endbr32 
80102cf4:	55                   	push   %ebp
80102cf5:	89 e5                	mov    %esp,%ebp
80102cf7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102cfa:	68 10 2c 10 80       	push   $0x80102c10
80102cff:	e8 6c dd ff ff       	call   80100a70 <consoleintr>
}
80102d04:	83 c4 10             	add    $0x10,%esp
80102d07:	c9                   	leave  
80102d08:	c3                   	ret    
80102d09:	66 90                	xchg   %ax,%ax
80102d0b:	66 90                	xchg   %ax,%ax
80102d0d:	66 90                	xchg   %ax,%ax
80102d0f:	90                   	nop

80102d10 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102d10:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80102d14:	a1 9c 5c 11 80       	mov    0x80115c9c,%eax
80102d19:	85 c0                	test   %eax,%eax
80102d1b:	0f 84 c7 00 00 00    	je     80102de8 <lapicinit+0xd8>
  lapic[index] = value;
80102d21:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102d28:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d2b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d2e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102d35:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d38:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d3b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102d42:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102d45:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d48:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102d4f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102d52:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d55:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102d5c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102d5f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d62:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102d69:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102d6c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102d6f:	8b 50 30             	mov    0x30(%eax),%edx
80102d72:	c1 ea 10             	shr    $0x10,%edx
80102d75:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102d7b:	75 73                	jne    80102df0 <lapicinit+0xe0>
  lapic[index] = value;
80102d7d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102d84:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d87:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d8a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102d91:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d94:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d97:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102d9e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102da1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102da4:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102dab:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102dae:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102db1:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102db8:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102dbb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102dbe:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102dc5:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102dc8:	8b 50 20             	mov    0x20(%eax),%edx
80102dcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102dcf:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102dd0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102dd6:	80 e6 10             	and    $0x10,%dh
80102dd9:	75 f5                	jne    80102dd0 <lapicinit+0xc0>
  lapic[index] = value;
80102ddb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102de2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102de5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102de8:	c3                   	ret    
80102de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102df0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102df7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102dfa:	8b 50 20             	mov    0x20(%eax),%edx
}
80102dfd:	e9 7b ff ff ff       	jmp    80102d7d <lapicinit+0x6d>
80102e02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e10 <lapicid>:

int
lapicid(void)
{
80102e10:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80102e14:	a1 9c 5c 11 80       	mov    0x80115c9c,%eax
80102e19:	85 c0                	test   %eax,%eax
80102e1b:	74 0b                	je     80102e28 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102e1d:	8b 40 20             	mov    0x20(%eax),%eax
80102e20:	c1 e8 18             	shr    $0x18,%eax
80102e23:	c3                   	ret    
80102e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102e28:	31 c0                	xor    %eax,%eax
}
80102e2a:	c3                   	ret    
80102e2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e2f:	90                   	nop

80102e30 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102e30:	f3 0f 1e fb          	endbr32 
  if(lapic)
80102e34:	a1 9c 5c 11 80       	mov    0x80115c9c,%eax
80102e39:	85 c0                	test   %eax,%eax
80102e3b:	74 0d                	je     80102e4a <lapiceoi+0x1a>
  lapic[index] = value;
80102e3d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102e44:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e47:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102e4a:	c3                   	ret    
80102e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e4f:	90                   	nop

80102e50 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102e50:	f3 0f 1e fb          	endbr32 
}
80102e54:	c3                   	ret    
80102e55:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102e60 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102e60:	f3 0f 1e fb          	endbr32 
80102e64:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e65:	b8 0f 00 00 00       	mov    $0xf,%eax
80102e6a:	ba 70 00 00 00       	mov    $0x70,%edx
80102e6f:	89 e5                	mov    %esp,%ebp
80102e71:	53                   	push   %ebx
80102e72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102e75:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102e78:	ee                   	out    %al,(%dx)
80102e79:	b8 0a 00 00 00       	mov    $0xa,%eax
80102e7e:	ba 71 00 00 00       	mov    $0x71,%edx
80102e83:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102e84:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102e86:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102e89:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102e8f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102e91:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102e94:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102e96:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102e99:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102e9c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102ea2:	a1 9c 5c 11 80       	mov    0x80115c9c,%eax
80102ea7:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ead:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102eb0:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102eb7:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102eba:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ebd:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102ec4:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ec7:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102eca:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ed0:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ed3:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ed9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102edc:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ee2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ee5:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
80102eeb:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
80102eec:	8b 40 20             	mov    0x20(%eax),%eax
}
80102eef:	5d                   	pop    %ebp
80102ef0:	c3                   	ret    
80102ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ef8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102eff:	90                   	nop

80102f00 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102f00:	f3 0f 1e fb          	endbr32 
80102f04:	55                   	push   %ebp
80102f05:	b8 0b 00 00 00       	mov    $0xb,%eax
80102f0a:	ba 70 00 00 00       	mov    $0x70,%edx
80102f0f:	89 e5                	mov    %esp,%ebp
80102f11:	57                   	push   %edi
80102f12:	56                   	push   %esi
80102f13:	53                   	push   %ebx
80102f14:	83 ec 4c             	sub    $0x4c,%esp
80102f17:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f18:	ba 71 00 00 00       	mov    $0x71,%edx
80102f1d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102f1e:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f21:	bb 70 00 00 00       	mov    $0x70,%ebx
80102f26:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f30:	31 c0                	xor    %eax,%eax
80102f32:	89 da                	mov    %ebx,%edx
80102f34:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f35:	b9 71 00 00 00       	mov    $0x71,%ecx
80102f3a:	89 ca                	mov    %ecx,%edx
80102f3c:	ec                   	in     (%dx),%al
80102f3d:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f40:	89 da                	mov    %ebx,%edx
80102f42:	b8 02 00 00 00       	mov    $0x2,%eax
80102f47:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f48:	89 ca                	mov    %ecx,%edx
80102f4a:	ec                   	in     (%dx),%al
80102f4b:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f4e:	89 da                	mov    %ebx,%edx
80102f50:	b8 04 00 00 00       	mov    $0x4,%eax
80102f55:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f56:	89 ca                	mov    %ecx,%edx
80102f58:	ec                   	in     (%dx),%al
80102f59:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f5c:	89 da                	mov    %ebx,%edx
80102f5e:	b8 07 00 00 00       	mov    $0x7,%eax
80102f63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f64:	89 ca                	mov    %ecx,%edx
80102f66:	ec                   	in     (%dx),%al
80102f67:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f6a:	89 da                	mov    %ebx,%edx
80102f6c:	b8 08 00 00 00       	mov    $0x8,%eax
80102f71:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f72:	89 ca                	mov    %ecx,%edx
80102f74:	ec                   	in     (%dx),%al
80102f75:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f77:	89 da                	mov    %ebx,%edx
80102f79:	b8 09 00 00 00       	mov    $0x9,%eax
80102f7e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f7f:	89 ca                	mov    %ecx,%edx
80102f81:	ec                   	in     (%dx),%al
80102f82:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f84:	89 da                	mov    %ebx,%edx
80102f86:	b8 0a 00 00 00       	mov    $0xa,%eax
80102f8b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f8c:	89 ca                	mov    %ecx,%edx
80102f8e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102f8f:	84 c0                	test   %al,%al
80102f91:	78 9d                	js     80102f30 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102f93:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102f97:	89 fa                	mov    %edi,%edx
80102f99:	0f b6 fa             	movzbl %dl,%edi
80102f9c:	89 f2                	mov    %esi,%edx
80102f9e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102fa1:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102fa5:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fa8:	89 da                	mov    %ebx,%edx
80102faa:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102fad:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102fb0:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102fb4:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102fb7:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102fba:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102fbe:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102fc1:	31 c0                	xor    %eax,%eax
80102fc3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fc4:	89 ca                	mov    %ecx,%edx
80102fc6:	ec                   	in     (%dx),%al
80102fc7:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fca:	89 da                	mov    %ebx,%edx
80102fcc:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102fcf:	b8 02 00 00 00       	mov    $0x2,%eax
80102fd4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fd5:	89 ca                	mov    %ecx,%edx
80102fd7:	ec                   	in     (%dx),%al
80102fd8:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fdb:	89 da                	mov    %ebx,%edx
80102fdd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102fe0:	b8 04 00 00 00       	mov    $0x4,%eax
80102fe5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fe6:	89 ca                	mov    %ecx,%edx
80102fe8:	ec                   	in     (%dx),%al
80102fe9:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fec:	89 da                	mov    %ebx,%edx
80102fee:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ff1:	b8 07 00 00 00       	mov    $0x7,%eax
80102ff6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ff7:	89 ca                	mov    %ecx,%edx
80102ff9:	ec                   	in     (%dx),%al
80102ffa:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ffd:	89 da                	mov    %ebx,%edx
80102fff:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103002:	b8 08 00 00 00       	mov    $0x8,%eax
80103007:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103008:	89 ca                	mov    %ecx,%edx
8010300a:	ec                   	in     (%dx),%al
8010300b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010300e:	89 da                	mov    %ebx,%edx
80103010:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103013:	b8 09 00 00 00       	mov    $0x9,%eax
80103018:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103019:	89 ca                	mov    %ecx,%edx
8010301b:	ec                   	in     (%dx),%al
8010301c:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010301f:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80103022:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103025:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103028:	6a 18                	push   $0x18
8010302a:	50                   	push   %eax
8010302b:	8d 45 b8             	lea    -0x48(%ebp),%eax
8010302e:	50                   	push   %eax
8010302f:	e8 dc 2d 00 00       	call   80105e10 <memcmp>
80103034:	83 c4 10             	add    $0x10,%esp
80103037:	85 c0                	test   %eax,%eax
80103039:	0f 85 f1 fe ff ff    	jne    80102f30 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
8010303f:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80103043:	75 78                	jne    801030bd <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103045:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103048:	89 c2                	mov    %eax,%edx
8010304a:	83 e0 0f             	and    $0xf,%eax
8010304d:	c1 ea 04             	shr    $0x4,%edx
80103050:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103053:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103056:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103059:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010305c:	89 c2                	mov    %eax,%edx
8010305e:	83 e0 0f             	and    $0xf,%eax
80103061:	c1 ea 04             	shr    $0x4,%edx
80103064:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103067:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010306a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
8010306d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103070:	89 c2                	mov    %eax,%edx
80103072:	83 e0 0f             	and    $0xf,%eax
80103075:	c1 ea 04             	shr    $0x4,%edx
80103078:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010307b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010307e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103081:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103084:	89 c2                	mov    %eax,%edx
80103086:	83 e0 0f             	and    $0xf,%eax
80103089:	c1 ea 04             	shr    $0x4,%edx
8010308c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010308f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103092:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80103095:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103098:	89 c2                	mov    %eax,%edx
8010309a:	83 e0 0f             	and    $0xf,%eax
8010309d:	c1 ea 04             	shr    $0x4,%edx
801030a0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801030a3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801030a6:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801030a9:	8b 45 cc             	mov    -0x34(%ebp),%eax
801030ac:	89 c2                	mov    %eax,%edx
801030ae:	83 e0 0f             	and    $0xf,%eax
801030b1:	c1 ea 04             	shr    $0x4,%edx
801030b4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801030b7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801030ba:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801030bd:	8b 75 08             	mov    0x8(%ebp),%esi
801030c0:	8b 45 b8             	mov    -0x48(%ebp),%eax
801030c3:	89 06                	mov    %eax,(%esi)
801030c5:	8b 45 bc             	mov    -0x44(%ebp),%eax
801030c8:	89 46 04             	mov    %eax,0x4(%esi)
801030cb:	8b 45 c0             	mov    -0x40(%ebp),%eax
801030ce:	89 46 08             	mov    %eax,0x8(%esi)
801030d1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801030d4:	89 46 0c             	mov    %eax,0xc(%esi)
801030d7:	8b 45 c8             	mov    -0x38(%ebp),%eax
801030da:	89 46 10             	mov    %eax,0x10(%esi)
801030dd:	8b 45 cc             	mov    -0x34(%ebp),%eax
801030e0:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801030e3:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801030ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030ed:	5b                   	pop    %ebx
801030ee:	5e                   	pop    %esi
801030ef:	5f                   	pop    %edi
801030f0:	5d                   	pop    %ebp
801030f1:	c3                   	ret    
801030f2:	66 90                	xchg   %ax,%ax
801030f4:	66 90                	xchg   %ax,%ax
801030f6:	66 90                	xchg   %ax,%ax
801030f8:	66 90                	xchg   %ax,%ax
801030fa:	66 90                	xchg   %ax,%ax
801030fc:	66 90                	xchg   %ax,%ax
801030fe:	66 90                	xchg   %ax,%ax

80103100 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103100:	8b 0d e8 5c 11 80    	mov    0x80115ce8,%ecx
80103106:	85 c9                	test   %ecx,%ecx
80103108:	0f 8e 8a 00 00 00    	jle    80103198 <install_trans+0x98>
{
8010310e:	55                   	push   %ebp
8010310f:	89 e5                	mov    %esp,%ebp
80103111:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103112:	31 ff                	xor    %edi,%edi
{
80103114:	56                   	push   %esi
80103115:	53                   	push   %ebx
80103116:	83 ec 0c             	sub    $0xc,%esp
80103119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103120:	a1 d4 5c 11 80       	mov    0x80115cd4,%eax
80103125:	83 ec 08             	sub    $0x8,%esp
80103128:	01 f8                	add    %edi,%eax
8010312a:	83 c0 01             	add    $0x1,%eax
8010312d:	50                   	push   %eax
8010312e:	ff 35 e4 5c 11 80    	pushl  0x80115ce4
80103134:	e8 97 cf ff ff       	call   801000d0 <bread>
80103139:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010313b:	58                   	pop    %eax
8010313c:	5a                   	pop    %edx
8010313d:	ff 34 bd ec 5c 11 80 	pushl  -0x7feea314(,%edi,4)
80103144:	ff 35 e4 5c 11 80    	pushl  0x80115ce4
  for (tail = 0; tail < log.lh.n; tail++) {
8010314a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010314d:	e8 7e cf ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103152:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103155:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103157:	8d 46 5c             	lea    0x5c(%esi),%eax
8010315a:	68 00 02 00 00       	push   $0x200
8010315f:	50                   	push   %eax
80103160:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103163:	50                   	push   %eax
80103164:	e8 f7 2c 00 00       	call   80105e60 <memmove>
    bwrite(dbuf);  // write dst to disk
80103169:	89 1c 24             	mov    %ebx,(%esp)
8010316c:	e8 3f d0 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80103171:	89 34 24             	mov    %esi,(%esp)
80103174:	e8 77 d0 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80103179:	89 1c 24             	mov    %ebx,(%esp)
8010317c:	e8 6f d0 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103181:	83 c4 10             	add    $0x10,%esp
80103184:	39 3d e8 5c 11 80    	cmp    %edi,0x80115ce8
8010318a:	7f 94                	jg     80103120 <install_trans+0x20>
  }
}
8010318c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010318f:	5b                   	pop    %ebx
80103190:	5e                   	pop    %esi
80103191:	5f                   	pop    %edi
80103192:	5d                   	pop    %ebp
80103193:	c3                   	ret    
80103194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103198:	c3                   	ret    
80103199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801031a0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801031a0:	55                   	push   %ebp
801031a1:	89 e5                	mov    %esp,%ebp
801031a3:	53                   	push   %ebx
801031a4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801031a7:	ff 35 d4 5c 11 80    	pushl  0x80115cd4
801031ad:	ff 35 e4 5c 11 80    	pushl  0x80115ce4
801031b3:	e8 18 cf ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801031b8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
801031bb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
801031bd:	a1 e8 5c 11 80       	mov    0x80115ce8,%eax
801031c2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
801031c5:	85 c0                	test   %eax,%eax
801031c7:	7e 19                	jle    801031e2 <write_head+0x42>
801031c9:	31 d2                	xor    %edx,%edx
801031cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031cf:	90                   	nop
    hb->block[i] = log.lh.block[i];
801031d0:	8b 0c 95 ec 5c 11 80 	mov    -0x7feea314(,%edx,4),%ecx
801031d7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801031db:	83 c2 01             	add    $0x1,%edx
801031de:	39 d0                	cmp    %edx,%eax
801031e0:	75 ee                	jne    801031d0 <write_head+0x30>
  }
  bwrite(buf);
801031e2:	83 ec 0c             	sub    $0xc,%esp
801031e5:	53                   	push   %ebx
801031e6:	e8 c5 cf ff ff       	call   801001b0 <bwrite>
  brelse(buf);
801031eb:	89 1c 24             	mov    %ebx,(%esp)
801031ee:	e8 fd cf ff ff       	call   801001f0 <brelse>
}
801031f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801031f6:	83 c4 10             	add    $0x10,%esp
801031f9:	c9                   	leave  
801031fa:	c3                   	ret    
801031fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031ff:	90                   	nop

80103200 <initlog>:
{
80103200:	f3 0f 1e fb          	endbr32 
80103204:	55                   	push   %ebp
80103205:	89 e5                	mov    %esp,%ebp
80103207:	53                   	push   %ebx
80103208:	83 ec 2c             	sub    $0x2c,%esp
8010320b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010320e:	68 20 a1 10 80       	push   $0x8010a120
80103213:	68 a0 5c 11 80       	push   $0x80115ca0
80103218:	e8 13 29 00 00       	call   80105b30 <initlock>
  readsb(dev, &sb);
8010321d:	58                   	pop    %eax
8010321e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103221:	5a                   	pop    %edx
80103222:	50                   	push   %eax
80103223:	53                   	push   %ebx
80103224:	e8 47 e8 ff ff       	call   80101a70 <readsb>
  log.start = sb.logstart;
80103229:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010322c:	59                   	pop    %ecx
  log.dev = dev;
8010322d:	89 1d e4 5c 11 80    	mov    %ebx,0x80115ce4
  log.size = sb.nlog;
80103233:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103236:	a3 d4 5c 11 80       	mov    %eax,0x80115cd4
  log.size = sb.nlog;
8010323b:	89 15 d8 5c 11 80    	mov    %edx,0x80115cd8
  struct buf *buf = bread(log.dev, log.start);
80103241:	5a                   	pop    %edx
80103242:	50                   	push   %eax
80103243:	53                   	push   %ebx
80103244:	e8 87 ce ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103249:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
8010324c:	8b 48 5c             	mov    0x5c(%eax),%ecx
8010324f:	89 0d e8 5c 11 80    	mov    %ecx,0x80115ce8
  for (i = 0; i < log.lh.n; i++) {
80103255:	85 c9                	test   %ecx,%ecx
80103257:	7e 19                	jle    80103272 <initlog+0x72>
80103259:	31 d2                	xor    %edx,%edx
8010325b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010325f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80103260:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80103264:	89 1c 95 ec 5c 11 80 	mov    %ebx,-0x7feea314(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010326b:	83 c2 01             	add    $0x1,%edx
8010326e:	39 d1                	cmp    %edx,%ecx
80103270:	75 ee                	jne    80103260 <initlog+0x60>
  brelse(buf);
80103272:	83 ec 0c             	sub    $0xc,%esp
80103275:	50                   	push   %eax
80103276:	e8 75 cf ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010327b:	e8 80 fe ff ff       	call   80103100 <install_trans>
  log.lh.n = 0;
80103280:	c7 05 e8 5c 11 80 00 	movl   $0x0,0x80115ce8
80103287:	00 00 00 
  write_head(); // clear the log
8010328a:	e8 11 ff ff ff       	call   801031a0 <write_head>
}
8010328f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103292:	83 c4 10             	add    $0x10,%esp
80103295:	c9                   	leave  
80103296:	c3                   	ret    
80103297:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010329e:	66 90                	xchg   %ax,%ax

801032a0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801032a0:	f3 0f 1e fb          	endbr32 
801032a4:	55                   	push   %ebp
801032a5:	89 e5                	mov    %esp,%ebp
801032a7:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801032aa:	68 a0 5c 11 80       	push   $0x80115ca0
801032af:	e8 fc 29 00 00       	call   80105cb0 <acquire>
801032b4:	83 c4 10             	add    $0x10,%esp
801032b7:	eb 1c                	jmp    801032d5 <begin_op+0x35>
801032b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801032c0:	83 ec 08             	sub    $0x8,%esp
801032c3:	68 a0 5c 11 80       	push   $0x80115ca0
801032c8:	68 a0 5c 11 80       	push   $0x80115ca0
801032cd:	e8 4e 12 00 00       	call   80104520 <sleep>
801032d2:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801032d5:	a1 e0 5c 11 80       	mov    0x80115ce0,%eax
801032da:	85 c0                	test   %eax,%eax
801032dc:	75 e2                	jne    801032c0 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801032de:	a1 dc 5c 11 80       	mov    0x80115cdc,%eax
801032e3:	8b 15 e8 5c 11 80    	mov    0x80115ce8,%edx
801032e9:	83 c0 01             	add    $0x1,%eax
801032ec:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801032ef:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801032f2:	83 fa 1e             	cmp    $0x1e,%edx
801032f5:	7f c9                	jg     801032c0 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
801032f7:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801032fa:	a3 dc 5c 11 80       	mov    %eax,0x80115cdc
      release(&log.lock);
801032ff:	68 a0 5c 11 80       	push   $0x80115ca0
80103304:	e8 67 2a 00 00       	call   80105d70 <release>
      break;
    }
  }
}
80103309:	83 c4 10             	add    $0x10,%esp
8010330c:	c9                   	leave  
8010330d:	c3                   	ret    
8010330e:	66 90                	xchg   %ax,%ax

80103310 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103310:	f3 0f 1e fb          	endbr32 
80103314:	55                   	push   %ebp
80103315:	89 e5                	mov    %esp,%ebp
80103317:	57                   	push   %edi
80103318:	56                   	push   %esi
80103319:	53                   	push   %ebx
8010331a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
8010331d:	68 a0 5c 11 80       	push   $0x80115ca0
80103322:	e8 89 29 00 00       	call   80105cb0 <acquire>
  log.outstanding -= 1;
80103327:	a1 dc 5c 11 80       	mov    0x80115cdc,%eax
  if(log.committing)
8010332c:	8b 35 e0 5c 11 80    	mov    0x80115ce0,%esi
80103332:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103335:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103338:	89 1d dc 5c 11 80    	mov    %ebx,0x80115cdc
  if(log.committing)
8010333e:	85 f6                	test   %esi,%esi
80103340:	0f 85 1e 01 00 00    	jne    80103464 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103346:	85 db                	test   %ebx,%ebx
80103348:	0f 85 f2 00 00 00    	jne    80103440 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010334e:	c7 05 e0 5c 11 80 01 	movl   $0x1,0x80115ce0
80103355:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103358:	83 ec 0c             	sub    $0xc,%esp
8010335b:	68 a0 5c 11 80       	push   $0x80115ca0
80103360:	e8 0b 2a 00 00       	call   80105d70 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103365:	8b 0d e8 5c 11 80    	mov    0x80115ce8,%ecx
8010336b:	83 c4 10             	add    $0x10,%esp
8010336e:	85 c9                	test   %ecx,%ecx
80103370:	7f 3e                	jg     801033b0 <end_op+0xa0>
    acquire(&log.lock);
80103372:	83 ec 0c             	sub    $0xc,%esp
80103375:	68 a0 5c 11 80       	push   $0x80115ca0
8010337a:	e8 31 29 00 00       	call   80105cb0 <acquire>
    wakeup(&log);
8010337f:	c7 04 24 a0 5c 11 80 	movl   $0x80115ca0,(%esp)
    log.committing = 0;
80103386:	c7 05 e0 5c 11 80 00 	movl   $0x0,0x80115ce0
8010338d:	00 00 00 
    wakeup(&log);
80103390:	e8 4b 13 00 00       	call   801046e0 <wakeup>
    release(&log.lock);
80103395:	c7 04 24 a0 5c 11 80 	movl   $0x80115ca0,(%esp)
8010339c:	e8 cf 29 00 00       	call   80105d70 <release>
801033a1:	83 c4 10             	add    $0x10,%esp
}
801033a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033a7:	5b                   	pop    %ebx
801033a8:	5e                   	pop    %esi
801033a9:	5f                   	pop    %edi
801033aa:	5d                   	pop    %ebp
801033ab:	c3                   	ret    
801033ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801033b0:	a1 d4 5c 11 80       	mov    0x80115cd4,%eax
801033b5:	83 ec 08             	sub    $0x8,%esp
801033b8:	01 d8                	add    %ebx,%eax
801033ba:	83 c0 01             	add    $0x1,%eax
801033bd:	50                   	push   %eax
801033be:	ff 35 e4 5c 11 80    	pushl  0x80115ce4
801033c4:	e8 07 cd ff ff       	call   801000d0 <bread>
801033c9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801033cb:	58                   	pop    %eax
801033cc:	5a                   	pop    %edx
801033cd:	ff 34 9d ec 5c 11 80 	pushl  -0x7feea314(,%ebx,4)
801033d4:	ff 35 e4 5c 11 80    	pushl  0x80115ce4
  for (tail = 0; tail < log.lh.n; tail++) {
801033da:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801033dd:	e8 ee cc ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
801033e2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801033e5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801033e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801033ea:	68 00 02 00 00       	push   $0x200
801033ef:	50                   	push   %eax
801033f0:	8d 46 5c             	lea    0x5c(%esi),%eax
801033f3:	50                   	push   %eax
801033f4:	e8 67 2a 00 00       	call   80105e60 <memmove>
    bwrite(to);  // write the log
801033f9:	89 34 24             	mov    %esi,(%esp)
801033fc:	e8 af cd ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103401:	89 3c 24             	mov    %edi,(%esp)
80103404:	e8 e7 cd ff ff       	call   801001f0 <brelse>
    brelse(to);
80103409:	89 34 24             	mov    %esi,(%esp)
8010340c:	e8 df cd ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103411:	83 c4 10             	add    $0x10,%esp
80103414:	3b 1d e8 5c 11 80    	cmp    0x80115ce8,%ebx
8010341a:	7c 94                	jl     801033b0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010341c:	e8 7f fd ff ff       	call   801031a0 <write_head>
    install_trans(); // Now install writes to home locations
80103421:	e8 da fc ff ff       	call   80103100 <install_trans>
    log.lh.n = 0;
80103426:	c7 05 e8 5c 11 80 00 	movl   $0x0,0x80115ce8
8010342d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103430:	e8 6b fd ff ff       	call   801031a0 <write_head>
80103435:	e9 38 ff ff ff       	jmp    80103372 <end_op+0x62>
8010343a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103440:	83 ec 0c             	sub    $0xc,%esp
80103443:	68 a0 5c 11 80       	push   $0x80115ca0
80103448:	e8 93 12 00 00       	call   801046e0 <wakeup>
  release(&log.lock);
8010344d:	c7 04 24 a0 5c 11 80 	movl   $0x80115ca0,(%esp)
80103454:	e8 17 29 00 00       	call   80105d70 <release>
80103459:	83 c4 10             	add    $0x10,%esp
}
8010345c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010345f:	5b                   	pop    %ebx
80103460:	5e                   	pop    %esi
80103461:	5f                   	pop    %edi
80103462:	5d                   	pop    %ebp
80103463:	c3                   	ret    
    panic("log.committing");
80103464:	83 ec 0c             	sub    $0xc,%esp
80103467:	68 24 a1 10 80       	push   $0x8010a124
8010346c:	e8 1f cf ff ff       	call   80100390 <panic>
80103471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103478:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010347f:	90                   	nop

80103480 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103480:	f3 0f 1e fb          	endbr32 
80103484:	55                   	push   %ebp
80103485:	89 e5                	mov    %esp,%ebp
80103487:	53                   	push   %ebx
80103488:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010348b:	8b 15 e8 5c 11 80    	mov    0x80115ce8,%edx
{
80103491:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103494:	83 fa 1d             	cmp    $0x1d,%edx
80103497:	0f 8f 91 00 00 00    	jg     8010352e <log_write+0xae>
8010349d:	a1 d8 5c 11 80       	mov    0x80115cd8,%eax
801034a2:	83 e8 01             	sub    $0x1,%eax
801034a5:	39 c2                	cmp    %eax,%edx
801034a7:	0f 8d 81 00 00 00    	jge    8010352e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
801034ad:	a1 dc 5c 11 80       	mov    0x80115cdc,%eax
801034b2:	85 c0                	test   %eax,%eax
801034b4:	0f 8e 81 00 00 00    	jle    8010353b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
801034ba:	83 ec 0c             	sub    $0xc,%esp
801034bd:	68 a0 5c 11 80       	push   $0x80115ca0
801034c2:	e8 e9 27 00 00       	call   80105cb0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801034c7:	8b 15 e8 5c 11 80    	mov    0x80115ce8,%edx
801034cd:	83 c4 10             	add    $0x10,%esp
801034d0:	85 d2                	test   %edx,%edx
801034d2:	7e 4e                	jle    80103522 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801034d4:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
801034d7:	31 c0                	xor    %eax,%eax
801034d9:	eb 0c                	jmp    801034e7 <log_write+0x67>
801034db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034df:	90                   	nop
801034e0:	83 c0 01             	add    $0x1,%eax
801034e3:	39 c2                	cmp    %eax,%edx
801034e5:	74 29                	je     80103510 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801034e7:	39 0c 85 ec 5c 11 80 	cmp    %ecx,-0x7feea314(,%eax,4)
801034ee:	75 f0                	jne    801034e0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
801034f0:	89 0c 85 ec 5c 11 80 	mov    %ecx,-0x7feea314(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801034f7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801034fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801034fd:	c7 45 08 a0 5c 11 80 	movl   $0x80115ca0,0x8(%ebp)
}
80103504:	c9                   	leave  
  release(&log.lock);
80103505:	e9 66 28 00 00       	jmp    80105d70 <release>
8010350a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103510:	89 0c 95 ec 5c 11 80 	mov    %ecx,-0x7feea314(,%edx,4)
    log.lh.n++;
80103517:	83 c2 01             	add    $0x1,%edx
8010351a:	89 15 e8 5c 11 80    	mov    %edx,0x80115ce8
80103520:	eb d5                	jmp    801034f7 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103522:	8b 43 08             	mov    0x8(%ebx),%eax
80103525:	a3 ec 5c 11 80       	mov    %eax,0x80115cec
  if (i == log.lh.n)
8010352a:	75 cb                	jne    801034f7 <log_write+0x77>
8010352c:	eb e9                	jmp    80103517 <log_write+0x97>
    panic("too big a transaction");
8010352e:	83 ec 0c             	sub    $0xc,%esp
80103531:	68 33 a1 10 80       	push   $0x8010a133
80103536:	e8 55 ce ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
8010353b:	83 ec 0c             	sub    $0xc,%esp
8010353e:	68 49 a1 10 80       	push   $0x8010a149
80103543:	e8 48 ce ff ff       	call   80100390 <panic>
80103548:	66 90                	xchg   %ax,%ax
8010354a:	66 90                	xchg   %ax,%ax
8010354c:	66 90                	xchg   %ax,%ax
8010354e:	66 90                	xchg   %ax,%ax

80103550 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103550:	55                   	push   %ebp
80103551:	89 e5                	mov    %esp,%ebp
80103553:	53                   	push   %ebx
80103554:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103557:	e8 c4 09 00 00       	call   80103f20 <cpuid>
8010355c:	89 c3                	mov    %eax,%ebx
8010355e:	e8 bd 09 00 00       	call   80103f20 <cpuid>
80103563:	83 ec 04             	sub    $0x4,%esp
80103566:	53                   	push   %ebx
80103567:	50                   	push   %eax
80103568:	68 64 a1 10 80       	push   $0x8010a164
8010356d:	e8 4e d3 ff ff       	call   801008c0 <cprintf>
  idtinit();       // load idt register
80103572:	e8 19 41 00 00       	call   80107690 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103577:	e8 34 09 00 00       	call   80103eb0 <mycpu>
8010357c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010357e:	b8 01 00 00 00       	mov    $0x1,%eax
80103583:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010358a:	e8 91 0b 00 00       	call   80104120 <scheduler>
8010358f:	90                   	nop

80103590 <mpenter>:
{
80103590:	f3 0f 1e fb          	endbr32 
80103594:	55                   	push   %ebp
80103595:	89 e5                	mov    %esp,%ebp
80103597:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010359a:	e8 91 52 00 00       	call   80108830 <switchkvm>
  seginit();
8010359f:	e8 fc 51 00 00       	call   801087a0 <seginit>
  lapicinit();
801035a4:	e8 67 f7 ff ff       	call   80102d10 <lapicinit>
  mpmain();
801035a9:	e8 a2 ff ff ff       	call   80103550 <mpmain>
801035ae:	66 90                	xchg   %ax,%ax

801035b0 <main>:
{
801035b0:	f3 0f 1e fb          	endbr32 
801035b4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801035b8:	83 e4 f0             	and    $0xfffffff0,%esp
801035bb:	ff 71 fc             	pushl  -0x4(%ecx)
801035be:	55                   	push   %ebp
801035bf:	89 e5                	mov    %esp,%ebp
801035c1:	53                   	push   %ebx
801035c2:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801035c3:	83 ec 08             	sub    $0x8,%esp
801035c6:	68 00 00 40 80       	push   $0x80400000
801035cb:	68 54 21 13 80       	push   $0x80132154
801035d0:	e8 fb f4 ff ff       	call   80102ad0 <kinit1>
  kvmalloc();      // kernel page table
801035d5:	e8 36 57 00 00       	call   80108d10 <kvmalloc>
  mpinit();        // detect other processors
801035da:	e8 91 01 00 00       	call   80103770 <mpinit>
  lapicinit();     // interrupt controller
801035df:	e8 2c f7 ff ff       	call   80102d10 <lapicinit>
  seginit();       // segment descriptors
801035e4:	e8 b7 51 00 00       	call   801087a0 <seginit>
  picinit();       // disable pic
801035e9:	e8 62 03 00 00       	call   80103950 <picinit>
  ioapicinit();    // another interrupt controller
801035ee:	e8 fd f2 ff ff       	call   801028f0 <ioapicinit>
  consoleinit();   // console hardware
801035f3:	e8 28 d9 ff ff       	call   80100f20 <consoleinit>
  uartinit();      // serial port
801035f8:	e8 63 44 00 00       	call   80107a60 <uartinit>
  pinit();         // process table
801035fd:	e8 8e 08 00 00       	call   80103e90 <pinit>
  tvinit();        // trap vectors
80103602:	e8 09 40 00 00       	call   80107610 <tvinit>
  binit();         // buffer cache
80103607:	e8 34 ca ff ff       	call   80100040 <binit>
  init_queue_test();
8010360c:	e8 9f 22 00 00       	call   801058b0 <init_queue_test>
  fileinit();      // file table
80103611:	e8 3a dd ff ff       	call   80101350 <fileinit>
  ideinit();       // disk 
80103616:	e8 a5 f0 ff ff       	call   801026c0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
8010361b:	83 c4 0c             	add    $0xc,%esp
8010361e:	68 8a 00 00 00       	push   $0x8a
80103623:	68 8c d4 10 80       	push   $0x8010d48c
80103628:	68 00 70 00 80       	push   $0x80007000
8010362d:	e8 2e 28 00 00       	call   80105e60 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103632:	83 c4 10             	add    $0x10,%esp
80103635:	69 05 40 63 11 80 b4 	imul   $0xb4,0x80116340,%eax
8010363c:	00 00 00 
8010363f:	05 a0 5d 11 80       	add    $0x80115da0,%eax
80103644:	3d a0 5d 11 80       	cmp    $0x80115da0,%eax
80103649:	76 7d                	jbe    801036c8 <main+0x118>
8010364b:	bb a0 5d 11 80       	mov    $0x80115da0,%ebx
80103650:	eb 1f                	jmp    80103671 <main+0xc1>
80103652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103658:	69 05 40 63 11 80 b4 	imul   $0xb4,0x80116340,%eax
8010365f:	00 00 00 
80103662:	81 c3 b4 00 00 00    	add    $0xb4,%ebx
80103668:	05 a0 5d 11 80       	add    $0x80115da0,%eax
8010366d:	39 c3                	cmp    %eax,%ebx
8010366f:	73 57                	jae    801036c8 <main+0x118>
    if(c == mycpu())  // We've started already.
80103671:	e8 3a 08 00 00       	call   80103eb0 <mycpu>
80103676:	39 c3                	cmp    %eax,%ebx
80103678:	74 de                	je     80103658 <main+0xa8>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
8010367a:	e8 21 f5 ff ff       	call   80102ba0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
8010367f:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
80103682:	c7 05 f8 6f 00 80 90 	movl   $0x80103590,0x80006ff8
80103689:	35 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010368c:	c7 05 f4 6f 00 80 00 	movl   $0x10c000,0x80006ff4
80103693:	c0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103696:	05 00 10 00 00       	add    $0x1000,%eax
8010369b:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801036a0:	0f b6 03             	movzbl (%ebx),%eax
801036a3:	68 00 70 00 00       	push   $0x7000
801036a8:	50                   	push   %eax
801036a9:	e8 b2 f7 ff ff       	call   80102e60 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801036ae:	83 c4 10             	add    $0x10,%esp
801036b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036b8:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801036be:	85 c0                	test   %eax,%eax
801036c0:	74 f6                	je     801036b8 <main+0x108>
801036c2:	eb 94                	jmp    80103658 <main+0xa8>
801036c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801036c8:	83 ec 08             	sub    $0x8,%esp
801036cb:	68 00 00 00 8e       	push   $0x8e000000
801036d0:	68 00 00 40 80       	push   $0x80400000
801036d5:	e8 66 f4 ff ff       	call   80102b40 <kinit2>
  userinit();      // first user process
801036da:	e8 f1 13 00 00       	call   80104ad0 <userinit>
  sharedMemoryInit();
801036df:	e8 7c 63 00 00       	call   80109a60 <sharedMemoryInit>
  mpmain();        // finish this processor's setup
801036e4:	e8 67 fe ff ff       	call   80103550 <mpmain>
801036e9:	66 90                	xchg   %ax,%ax
801036eb:	66 90                	xchg   %ax,%ax
801036ed:	66 90                	xchg   %ax,%ax
801036ef:	90                   	nop

801036f0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	57                   	push   %edi
801036f4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801036f5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801036fb:	53                   	push   %ebx
  e = addr+len;
801036fc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801036ff:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103702:	39 de                	cmp    %ebx,%esi
80103704:	72 10                	jb     80103716 <mpsearch1+0x26>
80103706:	eb 50                	jmp    80103758 <mpsearch1+0x68>
80103708:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010370f:	90                   	nop
80103710:	89 fe                	mov    %edi,%esi
80103712:	39 fb                	cmp    %edi,%ebx
80103714:	76 42                	jbe    80103758 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103716:	83 ec 04             	sub    $0x4,%esp
80103719:	8d 7e 10             	lea    0x10(%esi),%edi
8010371c:	6a 04                	push   $0x4
8010371e:	68 78 a1 10 80       	push   $0x8010a178
80103723:	56                   	push   %esi
80103724:	e8 e7 26 00 00       	call   80105e10 <memcmp>
80103729:	83 c4 10             	add    $0x10,%esp
8010372c:	85 c0                	test   %eax,%eax
8010372e:	75 e0                	jne    80103710 <mpsearch1+0x20>
80103730:	89 f2                	mov    %esi,%edx
80103732:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103738:	0f b6 0a             	movzbl (%edx),%ecx
8010373b:	83 c2 01             	add    $0x1,%edx
8010373e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103740:	39 fa                	cmp    %edi,%edx
80103742:	75 f4                	jne    80103738 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103744:	84 c0                	test   %al,%al
80103746:	75 c8                	jne    80103710 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103748:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010374b:	89 f0                	mov    %esi,%eax
8010374d:	5b                   	pop    %ebx
8010374e:	5e                   	pop    %esi
8010374f:	5f                   	pop    %edi
80103750:	5d                   	pop    %ebp
80103751:	c3                   	ret    
80103752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103758:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010375b:	31 f6                	xor    %esi,%esi
}
8010375d:	5b                   	pop    %ebx
8010375e:	89 f0                	mov    %esi,%eax
80103760:	5e                   	pop    %esi
80103761:	5f                   	pop    %edi
80103762:	5d                   	pop    %ebp
80103763:	c3                   	ret    
80103764:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010376b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010376f:	90                   	nop

80103770 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103770:	f3 0f 1e fb          	endbr32 
80103774:	55                   	push   %ebp
80103775:	89 e5                	mov    %esp,%ebp
80103777:	57                   	push   %edi
80103778:	56                   	push   %esi
80103779:	53                   	push   %ebx
8010377a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010377d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103784:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010378b:	c1 e0 08             	shl    $0x8,%eax
8010378e:	09 d0                	or     %edx,%eax
80103790:	c1 e0 04             	shl    $0x4,%eax
80103793:	75 1b                	jne    801037b0 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103795:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010379c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801037a3:	c1 e0 08             	shl    $0x8,%eax
801037a6:	09 d0                	or     %edx,%eax
801037a8:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801037ab:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801037b0:	ba 00 04 00 00       	mov    $0x400,%edx
801037b5:	e8 36 ff ff ff       	call   801036f0 <mpsearch1>
801037ba:	89 c6                	mov    %eax,%esi
801037bc:	85 c0                	test   %eax,%eax
801037be:	0f 84 4c 01 00 00    	je     80103910 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801037c4:	8b 5e 04             	mov    0x4(%esi),%ebx
801037c7:	85 db                	test   %ebx,%ebx
801037c9:	0f 84 61 01 00 00    	je     80103930 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
801037cf:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801037d2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801037d8:	6a 04                	push   $0x4
801037da:	68 7d a1 10 80       	push   $0x8010a17d
801037df:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801037e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801037e3:	e8 28 26 00 00       	call   80105e10 <memcmp>
801037e8:	83 c4 10             	add    $0x10,%esp
801037eb:	85 c0                	test   %eax,%eax
801037ed:	0f 85 3d 01 00 00    	jne    80103930 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
801037f3:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801037fa:	3c 01                	cmp    $0x1,%al
801037fc:	74 08                	je     80103806 <mpinit+0x96>
801037fe:	3c 04                	cmp    $0x4,%al
80103800:	0f 85 2a 01 00 00    	jne    80103930 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103806:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
8010380d:	66 85 d2             	test   %dx,%dx
80103810:	74 26                	je     80103838 <mpinit+0xc8>
80103812:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103815:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103817:	31 d2                	xor    %edx,%edx
80103819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103820:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103827:	83 c0 01             	add    $0x1,%eax
8010382a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010382c:	39 f8                	cmp    %edi,%eax
8010382e:	75 f0                	jne    80103820 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103830:	84 d2                	test   %dl,%dl
80103832:	0f 85 f8 00 00 00    	jne    80103930 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103838:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010383e:	a3 9c 5c 11 80       	mov    %eax,0x80115c9c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103843:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103849:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103850:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103855:	03 55 e4             	add    -0x1c(%ebp),%edx
80103858:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010385b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010385f:	90                   	nop
80103860:	39 c2                	cmp    %eax,%edx
80103862:	76 15                	jbe    80103879 <mpinit+0x109>
    switch(*p){
80103864:	0f b6 08             	movzbl (%eax),%ecx
80103867:	80 f9 02             	cmp    $0x2,%cl
8010386a:	74 5c                	je     801038c8 <mpinit+0x158>
8010386c:	77 42                	ja     801038b0 <mpinit+0x140>
8010386e:	84 c9                	test   %cl,%cl
80103870:	74 6e                	je     801038e0 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103872:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103875:	39 c2                	cmp    %eax,%edx
80103877:	77 eb                	ja     80103864 <mpinit+0xf4>
80103879:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010387c:	85 db                	test   %ebx,%ebx
8010387e:	0f 84 b9 00 00 00    	je     8010393d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103884:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103888:	74 15                	je     8010389f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010388a:	b8 70 00 00 00       	mov    $0x70,%eax
8010388f:	ba 22 00 00 00       	mov    $0x22,%edx
80103894:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103895:	ba 23 00 00 00       	mov    $0x23,%edx
8010389a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010389b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010389e:	ee                   	out    %al,(%dx)
  }
}
8010389f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038a2:	5b                   	pop    %ebx
801038a3:	5e                   	pop    %esi
801038a4:	5f                   	pop    %edi
801038a5:	5d                   	pop    %ebp
801038a6:	c3                   	ret    
801038a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038ae:	66 90                	xchg   %ax,%ax
    switch(*p){
801038b0:	83 e9 03             	sub    $0x3,%ecx
801038b3:	80 f9 01             	cmp    $0x1,%cl
801038b6:	76 ba                	jbe    80103872 <mpinit+0x102>
801038b8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801038bf:	eb 9f                	jmp    80103860 <mpinit+0xf0>
801038c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801038c8:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801038cc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801038cf:	88 0d 80 5d 11 80    	mov    %cl,0x80115d80
      continue;
801038d5:	eb 89                	jmp    80103860 <mpinit+0xf0>
801038d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038de:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
801038e0:	8b 0d 40 63 11 80    	mov    0x80116340,%ecx
801038e6:	83 f9 07             	cmp    $0x7,%ecx
801038e9:	7f 19                	jg     80103904 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801038eb:	69 f9 b4 00 00 00    	imul   $0xb4,%ecx,%edi
801038f1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801038f5:	83 c1 01             	add    $0x1,%ecx
801038f8:	89 0d 40 63 11 80    	mov    %ecx,0x80116340
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801038fe:	88 9f a0 5d 11 80    	mov    %bl,-0x7feea260(%edi)
      p += sizeof(struct mpproc);
80103904:	83 c0 14             	add    $0x14,%eax
      continue;
80103907:	e9 54 ff ff ff       	jmp    80103860 <mpinit+0xf0>
8010390c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103910:	ba 00 00 01 00       	mov    $0x10000,%edx
80103915:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010391a:	e8 d1 fd ff ff       	call   801036f0 <mpsearch1>
8010391f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103921:	85 c0                	test   %eax,%eax
80103923:	0f 85 9b fe ff ff    	jne    801037c4 <mpinit+0x54>
80103929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103930:	83 ec 0c             	sub    $0xc,%esp
80103933:	68 82 a1 10 80       	push   $0x8010a182
80103938:	e8 53 ca ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010393d:	83 ec 0c             	sub    $0xc,%esp
80103940:	68 9c a1 10 80       	push   $0x8010a19c
80103945:	e8 46 ca ff ff       	call   80100390 <panic>
8010394a:	66 90                	xchg   %ax,%ax
8010394c:	66 90                	xchg   %ax,%ax
8010394e:	66 90                	xchg   %ax,%ax

80103950 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103950:	f3 0f 1e fb          	endbr32 
80103954:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103959:	ba 21 00 00 00       	mov    $0x21,%edx
8010395e:	ee                   	out    %al,(%dx)
8010395f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103964:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103965:	c3                   	ret    
80103966:	66 90                	xchg   %ax,%ax
80103968:	66 90                	xchg   %ax,%ax
8010396a:	66 90                	xchg   %ax,%ax
8010396c:	66 90                	xchg   %ax,%ax
8010396e:	66 90                	xchg   %ax,%ax

80103970 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103970:	f3 0f 1e fb          	endbr32 
80103974:	55                   	push   %ebp
80103975:	89 e5                	mov    %esp,%ebp
80103977:	57                   	push   %edi
80103978:	56                   	push   %esi
80103979:	53                   	push   %ebx
8010397a:	83 ec 0c             	sub    $0xc,%esp
8010397d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103980:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103983:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103989:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010398f:	e8 dc d9 ff ff       	call   80101370 <filealloc>
80103994:	89 03                	mov    %eax,(%ebx)
80103996:	85 c0                	test   %eax,%eax
80103998:	0f 84 ac 00 00 00    	je     80103a4a <pipealloc+0xda>
8010399e:	e8 cd d9 ff ff       	call   80101370 <filealloc>
801039a3:	89 06                	mov    %eax,(%esi)
801039a5:	85 c0                	test   %eax,%eax
801039a7:	0f 84 8b 00 00 00    	je     80103a38 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801039ad:	e8 ee f1 ff ff       	call   80102ba0 <kalloc>
801039b2:	89 c7                	mov    %eax,%edi
801039b4:	85 c0                	test   %eax,%eax
801039b6:	0f 84 b4 00 00 00    	je     80103a70 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
801039bc:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801039c3:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801039c6:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801039c9:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801039d0:	00 00 00 
  p->nwrite = 0;
801039d3:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801039da:	00 00 00 
  p->nread = 0;
801039dd:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801039e4:	00 00 00 
  initlock(&p->lock, "pipe");
801039e7:	68 bb a1 10 80       	push   $0x8010a1bb
801039ec:	50                   	push   %eax
801039ed:	e8 3e 21 00 00       	call   80105b30 <initlock>
  (*f0)->type = FD_PIPE;
801039f2:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801039f4:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801039f7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801039fd:	8b 03                	mov    (%ebx),%eax
801039ff:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103a03:	8b 03                	mov    (%ebx),%eax
80103a05:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103a09:	8b 03                	mov    (%ebx),%eax
80103a0b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103a0e:	8b 06                	mov    (%esi),%eax
80103a10:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103a16:	8b 06                	mov    (%esi),%eax
80103a18:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103a1c:	8b 06                	mov    (%esi),%eax
80103a1e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103a22:	8b 06                	mov    (%esi),%eax
80103a24:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103a27:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103a2a:	31 c0                	xor    %eax,%eax
}
80103a2c:	5b                   	pop    %ebx
80103a2d:	5e                   	pop    %esi
80103a2e:	5f                   	pop    %edi
80103a2f:	5d                   	pop    %ebp
80103a30:	c3                   	ret    
80103a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103a38:	8b 03                	mov    (%ebx),%eax
80103a3a:	85 c0                	test   %eax,%eax
80103a3c:	74 1e                	je     80103a5c <pipealloc+0xec>
    fileclose(*f0);
80103a3e:	83 ec 0c             	sub    $0xc,%esp
80103a41:	50                   	push   %eax
80103a42:	e8 e9 d9 ff ff       	call   80101430 <fileclose>
80103a47:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103a4a:	8b 06                	mov    (%esi),%eax
80103a4c:	85 c0                	test   %eax,%eax
80103a4e:	74 0c                	je     80103a5c <pipealloc+0xec>
    fileclose(*f1);
80103a50:	83 ec 0c             	sub    $0xc,%esp
80103a53:	50                   	push   %eax
80103a54:	e8 d7 d9 ff ff       	call   80101430 <fileclose>
80103a59:	83 c4 10             	add    $0x10,%esp
}
80103a5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103a5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103a64:	5b                   	pop    %ebx
80103a65:	5e                   	pop    %esi
80103a66:	5f                   	pop    %edi
80103a67:	5d                   	pop    %ebp
80103a68:	c3                   	ret    
80103a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103a70:	8b 03                	mov    (%ebx),%eax
80103a72:	85 c0                	test   %eax,%eax
80103a74:	75 c8                	jne    80103a3e <pipealloc+0xce>
80103a76:	eb d2                	jmp    80103a4a <pipealloc+0xda>
80103a78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a7f:	90                   	nop

80103a80 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103a80:	f3 0f 1e fb          	endbr32 
80103a84:	55                   	push   %ebp
80103a85:	89 e5                	mov    %esp,%ebp
80103a87:	56                   	push   %esi
80103a88:	53                   	push   %ebx
80103a89:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103a8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103a8f:	83 ec 0c             	sub    $0xc,%esp
80103a92:	53                   	push   %ebx
80103a93:	e8 18 22 00 00       	call   80105cb0 <acquire>
  if(writable){
80103a98:	83 c4 10             	add    $0x10,%esp
80103a9b:	85 f6                	test   %esi,%esi
80103a9d:	74 41                	je     80103ae0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103a9f:	83 ec 0c             	sub    $0xc,%esp
80103aa2:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103aa8:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103aaf:	00 00 00 
    wakeup(&p->nread);
80103ab2:	50                   	push   %eax
80103ab3:	e8 28 0c 00 00       	call   801046e0 <wakeup>
80103ab8:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103abb:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103ac1:	85 d2                	test   %edx,%edx
80103ac3:	75 0a                	jne    80103acf <pipeclose+0x4f>
80103ac5:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103acb:	85 c0                	test   %eax,%eax
80103acd:	74 31                	je     80103b00 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103acf:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103ad2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ad5:	5b                   	pop    %ebx
80103ad6:	5e                   	pop    %esi
80103ad7:	5d                   	pop    %ebp
    release(&p->lock);
80103ad8:	e9 93 22 00 00       	jmp    80105d70 <release>
80103add:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103ae0:	83 ec 0c             	sub    $0xc,%esp
80103ae3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103ae9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103af0:	00 00 00 
    wakeup(&p->nwrite);
80103af3:	50                   	push   %eax
80103af4:	e8 e7 0b 00 00       	call   801046e0 <wakeup>
80103af9:	83 c4 10             	add    $0x10,%esp
80103afc:	eb bd                	jmp    80103abb <pipeclose+0x3b>
80103afe:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103b00:	83 ec 0c             	sub    $0xc,%esp
80103b03:	53                   	push   %ebx
80103b04:	e8 67 22 00 00       	call   80105d70 <release>
    kfree((char*)p);
80103b09:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103b0c:	83 c4 10             	add    $0x10,%esp
}
80103b0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b12:	5b                   	pop    %ebx
80103b13:	5e                   	pop    %esi
80103b14:	5d                   	pop    %ebp
    kfree((char*)p);
80103b15:	e9 c6 ee ff ff       	jmp    801029e0 <kfree>
80103b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b20 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103b20:	f3 0f 1e fb          	endbr32 
80103b24:	55                   	push   %ebp
80103b25:	89 e5                	mov    %esp,%ebp
80103b27:	57                   	push   %edi
80103b28:	56                   	push   %esi
80103b29:	53                   	push   %ebx
80103b2a:	83 ec 28             	sub    $0x28,%esp
80103b2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103b30:	53                   	push   %ebx
80103b31:	e8 7a 21 00 00       	call   80105cb0 <acquire>
  for(i = 0; i < n; i++){
80103b36:	8b 45 10             	mov    0x10(%ebp),%eax
80103b39:	83 c4 10             	add    $0x10,%esp
80103b3c:	85 c0                	test   %eax,%eax
80103b3e:	0f 8e bc 00 00 00    	jle    80103c00 <pipewrite+0xe0>
80103b44:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b47:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103b4d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103b53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b56:	03 45 10             	add    0x10(%ebp),%eax
80103b59:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103b5c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103b62:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103b68:	89 ca                	mov    %ecx,%edx
80103b6a:	05 00 02 00 00       	add    $0x200,%eax
80103b6f:	39 c1                	cmp    %eax,%ecx
80103b71:	74 3b                	je     80103bae <pipewrite+0x8e>
80103b73:	eb 63                	jmp    80103bd8 <pipewrite+0xb8>
80103b75:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103b78:	e8 c3 03 00 00       	call   80103f40 <myproc>
80103b7d:	8b 48 24             	mov    0x24(%eax),%ecx
80103b80:	85 c9                	test   %ecx,%ecx
80103b82:	75 34                	jne    80103bb8 <pipewrite+0x98>
      wakeup(&p->nread);
80103b84:	83 ec 0c             	sub    $0xc,%esp
80103b87:	57                   	push   %edi
80103b88:	e8 53 0b 00 00       	call   801046e0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103b8d:	58                   	pop    %eax
80103b8e:	5a                   	pop    %edx
80103b8f:	53                   	push   %ebx
80103b90:	56                   	push   %esi
80103b91:	e8 8a 09 00 00       	call   80104520 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103b96:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103b9c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103ba2:	83 c4 10             	add    $0x10,%esp
80103ba5:	05 00 02 00 00       	add    $0x200,%eax
80103baa:	39 c2                	cmp    %eax,%edx
80103bac:	75 2a                	jne    80103bd8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103bae:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103bb4:	85 c0                	test   %eax,%eax
80103bb6:	75 c0                	jne    80103b78 <pipewrite+0x58>
        release(&p->lock);
80103bb8:	83 ec 0c             	sub    $0xc,%esp
80103bbb:	53                   	push   %ebx
80103bbc:	e8 af 21 00 00       	call   80105d70 <release>
        return -1;
80103bc1:	83 c4 10             	add    $0x10,%esp
80103bc4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103bc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bcc:	5b                   	pop    %ebx
80103bcd:	5e                   	pop    %esi
80103bce:	5f                   	pop    %edi
80103bcf:	5d                   	pop    %ebp
80103bd0:	c3                   	ret    
80103bd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103bd8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103bdb:	8d 4a 01             	lea    0x1(%edx),%ecx
80103bde:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103be4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103bea:	0f b6 06             	movzbl (%esi),%eax
80103bed:	83 c6 01             	add    $0x1,%esi
80103bf0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103bf3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103bf7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103bfa:	0f 85 5c ff ff ff    	jne    80103b5c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103c00:	83 ec 0c             	sub    $0xc,%esp
80103c03:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103c09:	50                   	push   %eax
80103c0a:	e8 d1 0a 00 00       	call   801046e0 <wakeup>
  release(&p->lock);
80103c0f:	89 1c 24             	mov    %ebx,(%esp)
80103c12:	e8 59 21 00 00       	call   80105d70 <release>
  return n;
80103c17:	8b 45 10             	mov    0x10(%ebp),%eax
80103c1a:	83 c4 10             	add    $0x10,%esp
80103c1d:	eb aa                	jmp    80103bc9 <pipewrite+0xa9>
80103c1f:	90                   	nop

80103c20 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103c20:	f3 0f 1e fb          	endbr32 
80103c24:	55                   	push   %ebp
80103c25:	89 e5                	mov    %esp,%ebp
80103c27:	57                   	push   %edi
80103c28:	56                   	push   %esi
80103c29:	53                   	push   %ebx
80103c2a:	83 ec 18             	sub    $0x18,%esp
80103c2d:	8b 75 08             	mov    0x8(%ebp),%esi
80103c30:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103c33:	56                   	push   %esi
80103c34:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103c3a:	e8 71 20 00 00       	call   80105cb0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103c3f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103c45:	83 c4 10             	add    $0x10,%esp
80103c48:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103c4e:	74 33                	je     80103c83 <piperead+0x63>
80103c50:	eb 3b                	jmp    80103c8d <piperead+0x6d>
80103c52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103c58:	e8 e3 02 00 00       	call   80103f40 <myproc>
80103c5d:	8b 48 24             	mov    0x24(%eax),%ecx
80103c60:	85 c9                	test   %ecx,%ecx
80103c62:	0f 85 88 00 00 00    	jne    80103cf0 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103c68:	83 ec 08             	sub    $0x8,%esp
80103c6b:	56                   	push   %esi
80103c6c:	53                   	push   %ebx
80103c6d:	e8 ae 08 00 00       	call   80104520 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103c72:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103c78:	83 c4 10             	add    $0x10,%esp
80103c7b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103c81:	75 0a                	jne    80103c8d <piperead+0x6d>
80103c83:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103c89:	85 c0                	test   %eax,%eax
80103c8b:	75 cb                	jne    80103c58 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103c8d:	8b 55 10             	mov    0x10(%ebp),%edx
80103c90:	31 db                	xor    %ebx,%ebx
80103c92:	85 d2                	test   %edx,%edx
80103c94:	7f 28                	jg     80103cbe <piperead+0x9e>
80103c96:	eb 34                	jmp    80103ccc <piperead+0xac>
80103c98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c9f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103ca0:	8d 48 01             	lea    0x1(%eax),%ecx
80103ca3:	25 ff 01 00 00       	and    $0x1ff,%eax
80103ca8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103cae:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103cb3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103cb6:	83 c3 01             	add    $0x1,%ebx
80103cb9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103cbc:	74 0e                	je     80103ccc <piperead+0xac>
    if(p->nread == p->nwrite)
80103cbe:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103cc4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103cca:	75 d4                	jne    80103ca0 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103ccc:	83 ec 0c             	sub    $0xc,%esp
80103ccf:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103cd5:	50                   	push   %eax
80103cd6:	e8 05 0a 00 00       	call   801046e0 <wakeup>
  release(&p->lock);
80103cdb:	89 34 24             	mov    %esi,(%esp)
80103cde:	e8 8d 20 00 00       	call   80105d70 <release>
  return i;
80103ce3:	83 c4 10             	add    $0x10,%esp
}
80103ce6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ce9:	89 d8                	mov    %ebx,%eax
80103ceb:	5b                   	pop    %ebx
80103cec:	5e                   	pop    %esi
80103ced:	5f                   	pop    %edi
80103cee:	5d                   	pop    %ebp
80103cef:	c3                   	ret    
      release(&p->lock);
80103cf0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103cf3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103cf8:	56                   	push   %esi
80103cf9:	e8 72 20 00 00       	call   80105d70 <release>
      return -1;
80103cfe:	83 c4 10             	add    $0x10,%esp
}
80103d01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d04:	89 d8                	mov    %ebx,%eax
80103d06:	5b                   	pop    %ebx
80103d07:	5e                   	pop    %esi
80103d08:	5f                   	pop    %edi
80103d09:	5d                   	pop    %ebp
80103d0a:	c3                   	ret    
80103d0b:	66 90                	xchg   %ax,%ax
80103d0d:	66 90                	xchg   %ax,%ax
80103d0f:	90                   	nop

80103d10 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103d10:	55                   	push   %ebp
80103d11:	89 e5                	mov    %esp,%ebp
80103d13:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d14:	bb 94 63 11 80       	mov    $0x80116394,%ebx
{
80103d19:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103d1c:	68 60 63 11 80       	push   $0x80116360
80103d21:	e8 8a 1f 00 00       	call   80105cb0 <acquire>
80103d26:	83 c4 10             	add    $0x10,%esp
80103d29:	eb 17                	jmp    80103d42 <allocproc+0x32>
80103d2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d2f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d30:	81 c3 ac 05 00 00    	add    $0x5ac,%ebx
80103d36:	81 fb 94 ce 12 80    	cmp    $0x8012ce94,%ebx
80103d3c:	0f 84 ce 00 00 00    	je     80103e10 <allocproc+0x100>
    if(p->state == UNUSED)
80103d42:	8b 43 0c             	mov    0xc(%ebx),%eax
80103d45:	85 c0                	test   %eax,%eax
80103d47:	75 e7                	jne    80103d30 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103d49:	a1 04 d0 10 80       	mov    0x8010d004,%eax

  release(&ptable.lock);
80103d4e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103d51:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103d58:	89 43 10             	mov    %eax,0x10(%ebx)
80103d5b:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103d5e:	68 60 63 11 80       	push   $0x80116360
  p->pid = nextpid++;
80103d63:	89 15 04 d0 10 80    	mov    %edx,0x8010d004
  release(&ptable.lock);
80103d69:	e8 02 20 00 00       	call   80105d70 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103d6e:	e8 2d ee ff ff       	call   80102ba0 <kalloc>
80103d73:	83 c4 10             	add    $0x10,%esp
80103d76:	89 43 08             	mov    %eax,0x8(%ebx)
80103d79:	85 c0                	test   %eax,%eax
80103d7b:	0f 84 a8 00 00 00    	je     80103e29 <allocproc+0x119>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103d81:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103d87:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103d8a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103d8f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103d92:	c7 40 14 ff 75 10 80 	movl   $0x801075ff,0x14(%eax)
  p->context = (struct context*)sp;
80103d99:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103d9c:	6a 14                	push   $0x14
80103d9e:	6a 00                	push   $0x0
80103da0:	50                   	push   %eax
80103da1:	e8 1a 20 00 00       	call   80105dc0 <memset>
  p->context->eip = (uint)forkret;
80103da6:	8b 43 1c             	mov    0x1c(%ebx),%eax
  p->sched_info.bjf.executed_cycle = 0;
  p->sched_info.bjf.executed_cycle_ratio = 1;
  p->sched_info.bjf.process_size = p->sz;
  p->sched_info.bjf.process_size_ratio = 1;
  p->start_time = ticks;
  return p;
80103da9:	83 c4 10             	add    $0x10,%esp
  p->sched_info.bjf.priority_ratio = 1;
80103dac:	d9 e8                	fld1   
  p->context->eip = (uint)forkret;
80103dae:	c7 40 10 40 3e 10 80 	movl   $0x80103e40,0x10(%eax)
  p->sched_info.bjf.arrival_time = ticks;
80103db5:	a1 e0 d6 12 80       	mov    0x8012d6e0,%eax
  p->sched_info.bjf.priority_ratio = 1;
80103dba:	d9 93 8c 00 00 00    	fsts   0x8c(%ebx)
  p->sched_info.bjf.process_size = p->sz;
80103dc0:	8b 13                	mov    (%ebx),%edx
  p->sched_info.bjf.arrival_time_ratio = 1;
80103dc2:	d9 93 94 00 00 00    	fsts   0x94(%ebx)
  p->sched_info.bjf.executed_cycle_ratio = 1;
80103dc8:	d9 93 9c 00 00 00    	fsts   0x9c(%ebx)
  p->sched_info.bjf.arrival_time = ticks;
80103dce:	89 83 90 00 00 00    	mov    %eax,0x90(%ebx)
  p->start_time = ticks;
80103dd4:	89 43 7c             	mov    %eax,0x7c(%ebx)
}
80103dd7:	89 d8                	mov    %ebx,%eax
  p->sched_info.queue = UNSET;
80103dd9:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103de0:	00 00 00 
  p->sched_info.bjf.priority = 3;
80103de3:	c7 83 88 00 00 00 03 	movl   $0x3,0x88(%ebx)
80103dea:	00 00 00 
  p->sched_info.bjf.executed_cycle = 0;
80103ded:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
80103df4:	00 00 00 
  p->sched_info.bjf.process_size = p->sz;
80103df7:	89 93 a0 00 00 00    	mov    %edx,0xa0(%ebx)
  p->sched_info.bjf.process_size_ratio = 1;
80103dfd:	d9 9b a4 00 00 00    	fstps  0xa4(%ebx)
}
80103e03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e06:	c9                   	leave  
80103e07:	c3                   	ret    
80103e08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e0f:	90                   	nop
  release(&ptable.lock);
80103e10:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103e13:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103e15:	68 60 63 11 80       	push   $0x80116360
80103e1a:	e8 51 1f 00 00       	call   80105d70 <release>
}
80103e1f:	89 d8                	mov    %ebx,%eax
  return 0;
80103e21:	83 c4 10             	add    $0x10,%esp
}
80103e24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e27:	c9                   	leave  
80103e28:	c3                   	ret    
    p->state = UNUSED;
80103e29:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103e30:	31 db                	xor    %ebx,%ebx
}
80103e32:	89 d8                	mov    %ebx,%eax
80103e34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e37:	c9                   	leave  
80103e38:	c3                   	ret    
80103e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e40 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103e40:	f3 0f 1e fb          	endbr32 
80103e44:	55                   	push   %ebp
80103e45:	89 e5                	mov    %esp,%ebp
80103e47:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103e4a:	68 60 63 11 80       	push   $0x80116360
80103e4f:	e8 1c 1f 00 00       	call   80105d70 <release>

  if (first) {
80103e54:	a1 00 d0 10 80       	mov    0x8010d000,%eax
80103e59:	83 c4 10             	add    $0x10,%esp
80103e5c:	85 c0                	test   %eax,%eax
80103e5e:	75 08                	jne    80103e68 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103e60:	c9                   	leave  
80103e61:	c3                   	ret    
80103e62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103e68:	c7 05 00 d0 10 80 00 	movl   $0x0,0x8010d000
80103e6f:	00 00 00 
    iinit(ROOTDEV);
80103e72:	83 ec 0c             	sub    $0xc,%esp
80103e75:	6a 01                	push   $0x1
80103e77:	e8 34 dc ff ff       	call   80101ab0 <iinit>
    initlog(ROOTDEV);
80103e7c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103e83:	e8 78 f3 ff ff       	call   80103200 <initlog>
}
80103e88:	83 c4 10             	add    $0x10,%esp
80103e8b:	c9                   	leave  
80103e8c:	c3                   	ret    
80103e8d:	8d 76 00             	lea    0x0(%esi),%esi

80103e90 <pinit>:
{
80103e90:	f3 0f 1e fb          	endbr32 
80103e94:	55                   	push   %ebp
80103e95:	89 e5                	mov    %esp,%ebp
80103e97:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103e9a:	68 c0 a1 10 80       	push   $0x8010a1c0
80103e9f:	68 60 63 11 80       	push   $0x80116360
80103ea4:	e8 87 1c 00 00       	call   80105b30 <initlock>
}
80103ea9:	83 c4 10             	add    $0x10,%esp
80103eac:	c9                   	leave  
80103ead:	c3                   	ret    
80103eae:	66 90                	xchg   %ax,%ax

80103eb0 <mycpu>:
{
80103eb0:	f3 0f 1e fb          	endbr32 
80103eb4:	55                   	push   %ebp
80103eb5:	89 e5                	mov    %esp,%ebp
80103eb7:	56                   	push   %esi
80103eb8:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103eb9:	9c                   	pushf  
80103eba:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ebb:	f6 c4 02             	test   $0x2,%ah
80103ebe:	75 4a                	jne    80103f0a <mycpu+0x5a>
  apicid = lapicid();
80103ec0:	e8 4b ef ff ff       	call   80102e10 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103ec5:	8b 35 40 63 11 80    	mov    0x80116340,%esi
  apicid = lapicid();
80103ecb:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
80103ecd:	85 f6                	test   %esi,%esi
80103ecf:	7e 2c                	jle    80103efd <mycpu+0x4d>
80103ed1:	31 d2                	xor    %edx,%edx
80103ed3:	eb 0a                	jmp    80103edf <mycpu+0x2f>
80103ed5:	8d 76 00             	lea    0x0(%esi),%esi
80103ed8:	83 c2 01             	add    $0x1,%edx
80103edb:	39 f2                	cmp    %esi,%edx
80103edd:	74 1e                	je     80103efd <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
80103edf:	69 ca b4 00 00 00    	imul   $0xb4,%edx,%ecx
80103ee5:	0f b6 81 a0 5d 11 80 	movzbl -0x7feea260(%ecx),%eax
80103eec:	39 d8                	cmp    %ebx,%eax
80103eee:	75 e8                	jne    80103ed8 <mycpu+0x28>
}
80103ef0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103ef3:	8d 81 a0 5d 11 80    	lea    -0x7feea260(%ecx),%eax
}
80103ef9:	5b                   	pop    %ebx
80103efa:	5e                   	pop    %esi
80103efb:	5d                   	pop    %ebp
80103efc:	c3                   	ret    
  panic("unknown apicid\n");
80103efd:	83 ec 0c             	sub    $0xc,%esp
80103f00:	68 c7 a1 10 80       	push   $0x8010a1c7
80103f05:	e8 86 c4 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103f0a:	83 ec 0c             	sub    $0xc,%esp
80103f0d:	68 20 a3 10 80       	push   $0x8010a320
80103f12:	e8 79 c4 ff ff       	call   80100390 <panic>
80103f17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f1e:	66 90                	xchg   %ax,%ax

80103f20 <cpuid>:
cpuid() {
80103f20:	f3 0f 1e fb          	endbr32 
80103f24:	55                   	push   %ebp
80103f25:	89 e5                	mov    %esp,%ebp
80103f27:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103f2a:	e8 81 ff ff ff       	call   80103eb0 <mycpu>
}
80103f2f:	c9                   	leave  
  return mycpu()-cpus;
80103f30:	2d a0 5d 11 80       	sub    $0x80115da0,%eax
80103f35:	c1 f8 02             	sar    $0x2,%eax
80103f38:	69 c0 a5 4f fa a4    	imul   $0xa4fa4fa5,%eax,%eax
}
80103f3e:	c3                   	ret    
80103f3f:	90                   	nop

80103f40 <myproc>:
myproc(void) {
80103f40:	f3 0f 1e fb          	endbr32 
80103f44:	55                   	push   %ebp
80103f45:	89 e5                	mov    %esp,%ebp
80103f47:	53                   	push   %ebx
80103f48:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103f4b:	e8 60 1c 00 00       	call   80105bb0 <pushcli>
  c = mycpu();
80103f50:	e8 5b ff ff ff       	call   80103eb0 <mycpu>
  p = c->proc;
80103f55:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f5b:	e8 a0 1c 00 00       	call   80105c00 <popcli>
}
80103f60:	83 c4 04             	add    $0x4,%esp
80103f63:	89 d8                	mov    %ebx,%eax
80103f65:	5b                   	pop    %ebx
80103f66:	5d                   	pop    %ebp
80103f67:	c3                   	ret    
80103f68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f6f:	90                   	nop

80103f70 <growproc>:
{
80103f70:	f3 0f 1e fb          	endbr32 
80103f74:	55                   	push   %ebp
80103f75:	89 e5                	mov    %esp,%ebp
80103f77:	56                   	push   %esi
80103f78:	53                   	push   %ebx
80103f79:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103f7c:	e8 2f 1c 00 00       	call   80105bb0 <pushcli>
  c = mycpu();
80103f81:	e8 2a ff ff ff       	call   80103eb0 <mycpu>
  p = c->proc;
80103f86:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f8c:	e8 6f 1c 00 00       	call   80105c00 <popcli>
  sz = curproc->sz;
80103f91:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103f93:	85 f6                	test   %esi,%esi
80103f95:	7f 19                	jg     80103fb0 <growproc+0x40>
  } else if(n < 0){
80103f97:	75 37                	jne    80103fd0 <growproc+0x60>
  switchuvm(curproc);
80103f99:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103f9c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103f9e:	53                   	push   %ebx
80103f9f:	e8 ac 48 00 00       	call   80108850 <switchuvm>
  return 0;
80103fa4:	83 c4 10             	add    $0x10,%esp
80103fa7:	31 c0                	xor    %eax,%eax
}
80103fa9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fac:	5b                   	pop    %ebx
80103fad:	5e                   	pop    %esi
80103fae:	5d                   	pop    %ebp
80103faf:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103fb0:	83 ec 04             	sub    $0x4,%esp
80103fb3:	01 c6                	add    %eax,%esi
80103fb5:	56                   	push   %esi
80103fb6:	50                   	push   %eax
80103fb7:	ff 73 04             	pushl  0x4(%ebx)
80103fba:	e8 f1 4a 00 00       	call   80108ab0 <allocuvm>
80103fbf:	83 c4 10             	add    $0x10,%esp
80103fc2:	85 c0                	test   %eax,%eax
80103fc4:	75 d3                	jne    80103f99 <growproc+0x29>
      return -1;
80103fc6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fcb:	eb dc                	jmp    80103fa9 <growproc+0x39>
80103fcd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103fd0:	83 ec 04             	sub    $0x4,%esp
80103fd3:	01 c6                	add    %eax,%esi
80103fd5:	56                   	push   %esi
80103fd6:	50                   	push   %eax
80103fd7:	ff 73 04             	pushl  0x4(%ebx)
80103fda:	e8 01 4c 00 00       	call   80108be0 <deallocuvm>
80103fdf:	83 c4 10             	add    $0x10,%esp
80103fe2:	85 c0                	test   %eax,%eax
80103fe4:	75 b3                	jne    80103f99 <growproc+0x29>
80103fe6:	eb de                	jmp    80103fc6 <growproc+0x56>
80103fe8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fef:	90                   	nop

80103ff0 <bjfrank>:
{
80103ff0:	f3 0f 1e fb          	endbr32 
80103ff4:	55                   	push   %ebp
80103ff5:	89 e5                	mov    %esp,%ebp
80103ff7:	8b 45 08             	mov    0x8(%ebp),%eax
}
80103ffa:	5d                   	pop    %ebp
  return p->sched_info.bjf.priority * p->sched_info.bjf.priority_ratio +
80103ffb:	db 80 88 00 00 00    	fildl  0x88(%eax)
80104001:	d8 88 8c 00 00 00    	fmuls  0x8c(%eax)
         p->sched_info.bjf.arrival_time * p->sched_info.bjf.arrival_time_ratio +
80104007:	db 80 90 00 00 00    	fildl  0x90(%eax)
8010400d:	d8 88 94 00 00 00    	fmuls  0x94(%eax)
  return p->sched_info.bjf.priority * p->sched_info.bjf.priority_ratio +
80104013:	de c1                	faddp  %st,%st(1)
         p->sched_info.bjf.executed_cycle * p->sched_info.bjf.executed_cycle_ratio +
80104015:	d9 80 98 00 00 00    	flds   0x98(%eax)
8010401b:	d8 88 9c 00 00 00    	fmuls  0x9c(%eax)
         p->sched_info.bjf.arrival_time * p->sched_info.bjf.arrival_time_ratio +
80104021:	de c1                	faddp  %st,%st(1)
         p->sched_info.bjf.process_size * p->sched_info.bjf.process_size_ratio;
80104023:	db 80 a0 00 00 00    	fildl  0xa0(%eax)
80104029:	d8 88 a4 00 00 00    	fmuls  0xa4(%eax)
         p->sched_info.bjf.executed_cycle * p->sched_info.bjf.executed_cycle_ratio +
8010402f:	de c1                	faddp  %st,%st(1)
}
80104031:	c3                   	ret    
80104032:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104040 <lcfs>:
{
80104040:	f3 0f 1e fb          	endbr32 
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104044:	b8 94 63 11 80       	mov    $0x80116394,%eax
  struct proc *result = 0;
80104049:	31 d2                	xor    %edx,%edx
8010404b:	eb 1f                	jmp    8010406c <lcfs+0x2c>
8010404d:	8d 76 00             	lea    0x0(%esi),%esi
      if (result->sched_info.arrival_queue_time < p->sched_info.arrival_queue_time)
80104050:	8b 88 a8 00 00 00    	mov    0xa8(%eax),%ecx
80104056:	39 8a a8 00 00 00    	cmp    %ecx,0xa8(%edx)
8010405c:	0f 4c d0             	cmovl  %eax,%edx
8010405f:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104060:	05 ac 05 00 00       	add    $0x5ac,%eax
80104065:	3d 94 ce 12 80       	cmp    $0x8012ce94,%eax
8010406a:	74 21                	je     8010408d <lcfs+0x4d>
    if (p->state != RUNNABLE || p->sched_info.queue != LCFS)
8010406c:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104070:	75 ee                	jne    80104060 <lcfs+0x20>
80104072:	83 b8 80 00 00 00 02 	cmpl   $0x2,0x80(%eax)
80104079:	75 e5                	jne    80104060 <lcfs+0x20>
    if (result != 0)
8010407b:	85 d2                	test   %edx,%edx
8010407d:	75 d1                	jne    80104050 <lcfs+0x10>
8010407f:	89 c2                	mov    %eax,%edx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104081:	05 ac 05 00 00       	add    $0x5ac,%eax
80104086:	3d 94 ce 12 80       	cmp    $0x8012ce94,%eax
8010408b:	75 df                	jne    8010406c <lcfs+0x2c>
}
8010408d:	89 d0                	mov    %edx,%eax
8010408f:	c3                   	ret    

80104090 <bestjobfirst>:
{
80104090:	f3 0f 1e fb          	endbr32 
  float min_rank = 2e6;
80104094:	d9 05 dc a4 10 80    	flds   0x8010a4dc
  struct proc *min_p = 0;
8010409a:	31 d2                	xor    %edx,%edx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010409c:	b8 94 63 11 80       	mov    $0x80116394,%eax
801040a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (p->state != RUNNABLE || p->sched_info.queue != BJF)
801040a8:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801040ac:	75 5a                	jne    80104108 <bestjobfirst+0x78>
801040ae:	83 b8 80 00 00 00 03 	cmpl   $0x3,0x80(%eax)
801040b5:	75 51                	jne    80104108 <bestjobfirst+0x78>
  return p->sched_info.bjf.priority * p->sched_info.bjf.priority_ratio +
801040b7:	db 80 88 00 00 00    	fildl  0x88(%eax)
801040bd:	d8 88 8c 00 00 00    	fmuls  0x8c(%eax)
         p->sched_info.bjf.arrival_time * p->sched_info.bjf.arrival_time_ratio +
801040c3:	db 80 90 00 00 00    	fildl  0x90(%eax)
801040c9:	d8 88 94 00 00 00    	fmuls  0x94(%eax)
  return p->sched_info.bjf.priority * p->sched_info.bjf.priority_ratio +
801040cf:	de c1                	faddp  %st,%st(1)
         p->sched_info.bjf.executed_cycle * p->sched_info.bjf.executed_cycle_ratio +
801040d1:	d9 80 98 00 00 00    	flds   0x98(%eax)
801040d7:	d8 88 9c 00 00 00    	fmuls  0x9c(%eax)
         p->sched_info.bjf.arrival_time * p->sched_info.bjf.arrival_time_ratio +
801040dd:	de c1                	faddp  %st,%st(1)
         p->sched_info.bjf.process_size * p->sched_info.bjf.process_size_ratio;
801040df:	db 80 a0 00 00 00    	fildl  0xa0(%eax)
801040e5:	d8 88 a4 00 00 00    	fmuls  0xa4(%eax)
         p->sched_info.bjf.executed_cycle * p->sched_info.bjf.executed_cycle_ratio +
801040eb:	de c1                	faddp  %st,%st(1)
801040ed:	d9 c9                	fxch   %st(1)
    if (p_rank < min_rank)
801040ef:	db f1                	fcomi  %st(1),%st
801040f1:	76 0d                	jbe    80104100 <bestjobfirst+0x70>
801040f3:	dd d8                	fstp   %st(0)
801040f5:	89 c2                	mov    %eax,%edx
801040f7:	eb 0f                	jmp    80104108 <bestjobfirst+0x78>
801040f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104100:	dd d9                	fstp   %st(1)
80104102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104108:	05 ac 05 00 00       	add    $0x5ac,%eax
8010410d:	3d 94 ce 12 80       	cmp    $0x8012ce94,%eax
80104112:	75 94                	jne    801040a8 <bestjobfirst+0x18>
80104114:	dd d8                	fstp   %st(0)
}
80104116:	89 d0                	mov    %edx,%eax
80104118:	c3                   	ret    
80104119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104120 <scheduler>:
{
80104120:	f3 0f 1e fb          	endbr32 
80104124:	55                   	push   %ebp
80104125:	89 e5                	mov    %esp,%ebp
80104127:	57                   	push   %edi
      p = ptable.proc;
80104128:	bf 94 63 11 80       	mov    $0x80116394,%edi
{
8010412d:	56                   	push   %esi
  struct proc *last_scheduled_RR = &ptable.proc[NPROC - 1];
8010412e:	be e8 c8 12 80       	mov    $0x8012c8e8,%esi
{
80104133:	53                   	push   %ebx
80104134:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80104137:	e8 74 fd ff ff       	call   80103eb0 <mycpu>
  c->proc = 0;
8010413c:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104143:	00 00 00 
  struct cpu *c = mycpu();
80104146:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  c->proc = 0;
80104149:	83 c0 04             	add    $0x4,%eax
8010414c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010414f:	90                   	nop
  asm volatile("sti");
80104150:	fb                   	sti    
    acquire(&ptable.lock);
80104151:	83 ec 0c             	sub    $0xc,%esp
80104154:	89 f3                	mov    %esi,%ebx
80104156:	68 60 63 11 80       	push   $0x80116360
8010415b:	e8 50 1b 00 00       	call   80105cb0 <acquire>
80104160:	83 c4 10             	add    $0x10,%esp
80104163:	eb 0b                	jmp    80104170 <scheduler+0x50>
80104165:	8d 76 00             	lea    0x0(%esi),%esi
    if (p == last_scheduled)
80104168:	39 de                	cmp    %ebx,%esi
8010416a:	0f 84 90 00 00 00    	je     80104200 <scheduler+0xe0>
    p++;
80104170:	81 c3 ac 05 00 00    	add    $0x5ac,%ebx
      p = ptable.proc;
80104176:	81 fb 94 ce 12 80    	cmp    $0x8012ce94,%ebx
8010417c:	0f 43 df             	cmovae %edi,%ebx
    if (p->state == RUNNABLE && p->sched_info.queue == ROUND_ROBIN)
8010417f:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104183:	75 e3                	jne    80104168 <scheduler+0x48>
80104185:	83 bb 80 00 00 00 01 	cmpl   $0x1,0x80(%ebx)
8010418c:	75 da                	jne    80104168 <scheduler+0x48>
8010418e:	89 de                	mov    %ebx,%esi
    c->proc = p;
80104190:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    switchuvm(p);
80104193:	83 ec 0c             	sub    $0xc,%esp
    c->proc = p;
80104196:	89 98 ac 00 00 00    	mov    %ebx,0xac(%eax)
    switchuvm(p);
8010419c:	53                   	push   %ebx
8010419d:	e8 ae 46 00 00       	call   80108850 <switchuvm>
    p->sched_info.bjf.executed_cycle += 0.1f;
801041a2:	d9 05 e0 a4 10 80    	flds   0x8010a4e0
801041a8:	d8 83 98 00 00 00    	fadds  0x98(%ebx)
    p->state = RUNNING;
801041ae:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
    p->sched_info.last_run = ticks;
801041b5:	a1 e0 d6 12 80       	mov    0x8012d6e0,%eax
801041ba:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
    p->sched_info.bjf.executed_cycle += 0.1f;
801041c0:	d9 9b 98 00 00 00    	fstps  0x98(%ebx)
    swtch(&(c->scheduler), p->context);
801041c6:	58                   	pop    %eax
801041c7:	5a                   	pop    %edx
801041c8:	ff 73 1c             	pushl  0x1c(%ebx)
801041cb:	ff 75 e0             	pushl  -0x20(%ebp)
801041ce:	e8 10 1e 00 00       	call   80105fe3 <swtch>
    switchkvm();
801041d3:	e8 58 46 00 00       	call   80108830 <switchkvm>
    c->proc = 0;
801041d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801041db:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801041e2:	00 00 00 
  release(&ptable.lock);
801041e5:	c7 04 24 60 63 11 80 	movl   $0x80116360,(%esp)
801041ec:	e8 7f 1b 00 00       	call   80105d70 <release>
801041f1:	83 c4 10             	add    $0x10,%esp
801041f4:	e9 57 ff ff ff       	jmp    80104150 <scheduler+0x30>
801041f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *result = 0;
80104200:	31 db                	xor    %ebx,%ebx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104202:	b8 94 63 11 80       	mov    $0x80116394,%eax
80104207:	eb 23                	jmp    8010422c <scheduler+0x10c>
80104209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if (result->sched_info.arrival_queue_time < p->sched_info.arrival_queue_time)
80104210:	8b 90 a8 00 00 00    	mov    0xa8(%eax),%edx
80104216:	39 93 a8 00 00 00    	cmp    %edx,0xa8(%ebx)
8010421c:	0f 4c d8             	cmovl  %eax,%ebx
8010421f:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104220:	05 ac 05 00 00       	add    $0x5ac,%eax
80104225:	3d 94 ce 12 80       	cmp    $0x8012ce94,%eax
8010422a:	74 24                	je     80104250 <scheduler+0x130>
    if (p->state != RUNNABLE || p->sched_info.queue != LCFS)
8010422c:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104230:	75 ee                	jne    80104220 <scheduler+0x100>
80104232:	83 b8 80 00 00 00 02 	cmpl   $0x2,0x80(%eax)
80104239:	75 e5                	jne    80104220 <scheduler+0x100>
    if (result != 0)
8010423b:	85 db                	test   %ebx,%ebx
8010423d:	75 d1                	jne    80104210 <scheduler+0xf0>
8010423f:	89 c3                	mov    %eax,%ebx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104241:	05 ac 05 00 00       	add    $0x5ac,%eax
80104246:	3d 94 ce 12 80       	cmp    $0x8012ce94,%eax
8010424b:	75 df                	jne    8010422c <scheduler+0x10c>
8010424d:	8d 76 00             	lea    0x0(%esi),%esi
      if (!p)
80104250:	85 db                	test   %ebx,%ebx
80104252:	0f 85 38 ff ff ff    	jne    80104190 <scheduler+0x70>
        p = bestjobfirst();
80104258:	e8 33 fe ff ff       	call   80104090 <bestjobfirst>
8010425d:	89 c3                	mov    %eax,%ebx
        if (!p)
8010425f:	85 c0                	test   %eax,%eax
80104261:	0f 85 29 ff ff ff    	jne    80104190 <scheduler+0x70>
          release(&ptable.lock);
80104267:	83 ec 0c             	sub    $0xc,%esp
8010426a:	68 60 63 11 80       	push   $0x80116360
8010426f:	e8 fc 1a 00 00       	call   80105d70 <release>
          continue;
80104274:	83 c4 10             	add    $0x10,%esp
80104277:	e9 d4 fe ff ff       	jmp    80104150 <scheduler+0x30>
8010427c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104280 <roundrobin>:
{
80104280:	f3 0f 1e fb          	endbr32 
80104284:	55                   	push   %ebp
      p = ptable.proc;
80104285:	b9 94 63 11 80       	mov    $0x80116394,%ecx
{
8010428a:	89 e5                	mov    %esp,%ebp
8010428c:	8b 55 08             	mov    0x8(%ebp),%edx
  struct proc *p = last_scheduled;
8010428f:	89 d0                	mov    %edx,%eax
80104291:	eb 09                	jmp    8010429c <roundrobin+0x1c>
80104293:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104297:	90                   	nop
    if (p == last_scheduled)
80104298:	39 d0                	cmp    %edx,%eax
8010429a:	74 24                	je     801042c0 <roundrobin+0x40>
    p++;
8010429c:	05 ac 05 00 00       	add    $0x5ac,%eax
      p = ptable.proc;
801042a1:	3d 94 ce 12 80       	cmp    $0x8012ce94,%eax
801042a6:	0f 43 c1             	cmovae %ecx,%eax
    if (p->state == RUNNABLE && p->sched_info.queue == ROUND_ROBIN)
801042a9:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801042ad:	75 e9                	jne    80104298 <roundrobin+0x18>
801042af:	83 b8 80 00 00 00 01 	cmpl   $0x1,0x80(%eax)
801042b6:	75 e0                	jne    80104298 <roundrobin+0x18>
}
801042b8:	5d                   	pop    %ebp
801042b9:	c3                   	ret    
801042ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return 0;
801042c0:	31 c0                	xor    %eax,%eax
}
801042c2:	5d                   	pop    %ebp
801042c3:	c3                   	ret    
801042c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042cf:	90                   	nop

801042d0 <sched>:
{
801042d0:	f3 0f 1e fb          	endbr32 
801042d4:	55                   	push   %ebp
801042d5:	89 e5                	mov    %esp,%ebp
801042d7:	56                   	push   %esi
801042d8:	53                   	push   %ebx
  pushcli();
801042d9:	e8 d2 18 00 00       	call   80105bb0 <pushcli>
  c = mycpu();
801042de:	e8 cd fb ff ff       	call   80103eb0 <mycpu>
  p = c->proc;
801042e3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042e9:	e8 12 19 00 00       	call   80105c00 <popcli>
  if(!holding(&ptable.lock))
801042ee:	83 ec 0c             	sub    $0xc,%esp
801042f1:	68 60 63 11 80       	push   $0x80116360
801042f6:	e8 65 19 00 00       	call   80105c60 <holding>
801042fb:	83 c4 10             	add    $0x10,%esp
801042fe:	85 c0                	test   %eax,%eax
80104300:	74 4f                	je     80104351 <sched+0x81>
  if(mycpu()->ncli != 1)
80104302:	e8 a9 fb ff ff       	call   80103eb0 <mycpu>
80104307:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010430e:	75 68                	jne    80104378 <sched+0xa8>
  if(p->state == RUNNING)
80104310:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104314:	74 55                	je     8010436b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104316:	9c                   	pushf  
80104317:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104318:	f6 c4 02             	test   $0x2,%ah
8010431b:	75 41                	jne    8010435e <sched+0x8e>
  intena = mycpu()->intena;
8010431d:	e8 8e fb ff ff       	call   80103eb0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80104322:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104325:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
8010432b:	e8 80 fb ff ff       	call   80103eb0 <mycpu>
80104330:	83 ec 08             	sub    $0x8,%esp
80104333:	ff 70 04             	pushl  0x4(%eax)
80104336:	53                   	push   %ebx
80104337:	e8 a7 1c 00 00       	call   80105fe3 <swtch>
  mycpu()->intena = intena;
8010433c:	e8 6f fb ff ff       	call   80103eb0 <mycpu>
}
80104341:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104344:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
8010434a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010434d:	5b                   	pop    %ebx
8010434e:	5e                   	pop    %esi
8010434f:	5d                   	pop    %ebp
80104350:	c3                   	ret    
    panic("sched ptable.lock");
80104351:	83 ec 0c             	sub    $0xc,%esp
80104354:	68 d7 a1 10 80       	push   $0x8010a1d7
80104359:	e8 32 c0 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010435e:	83 ec 0c             	sub    $0xc,%esp
80104361:	68 03 a2 10 80       	push   $0x8010a203
80104366:	e8 25 c0 ff ff       	call   80100390 <panic>
    panic("sched running");
8010436b:	83 ec 0c             	sub    $0xc,%esp
8010436e:	68 f5 a1 10 80       	push   $0x8010a1f5
80104373:	e8 18 c0 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104378:	83 ec 0c             	sub    $0xc,%esp
8010437b:	68 e9 a1 10 80       	push   $0x8010a1e9
80104380:	e8 0b c0 ff ff       	call   80100390 <panic>
80104385:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010438c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104390 <exit>:
{
80104390:	f3 0f 1e fb          	endbr32 
80104394:	55                   	push   %ebp
80104395:	89 e5                	mov    %esp,%ebp
80104397:	57                   	push   %edi
80104398:	56                   	push   %esi
80104399:	53                   	push   %ebx
8010439a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010439d:	e8 0e 18 00 00       	call   80105bb0 <pushcli>
  c = mycpu();
801043a2:	e8 09 fb ff ff       	call   80103eb0 <mycpu>
  p = c->proc;
801043a7:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801043ad:	e8 4e 18 00 00       	call   80105c00 <popcli>
  if(curproc == initproc)
801043b2:	8d 5e 28             	lea    0x28(%esi),%ebx
801043b5:	8d 7e 68             	lea    0x68(%esi),%edi
801043b8:	39 35 1c d6 10 80    	cmp    %esi,0x8010d61c
801043be:	0f 84 fd 00 00 00    	je     801044c1 <exit+0x131>
801043c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
801043c8:	8b 03                	mov    (%ebx),%eax
801043ca:	85 c0                	test   %eax,%eax
801043cc:	74 12                	je     801043e0 <exit+0x50>
      fileclose(curproc->ofile[fd]);
801043ce:	83 ec 0c             	sub    $0xc,%esp
801043d1:	50                   	push   %eax
801043d2:	e8 59 d0 ff ff       	call   80101430 <fileclose>
      curproc->ofile[fd] = 0;
801043d7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801043dd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801043e0:	83 c3 04             	add    $0x4,%ebx
801043e3:	39 df                	cmp    %ebx,%edi
801043e5:	75 e1                	jne    801043c8 <exit+0x38>
  begin_op();
801043e7:	e8 b4 ee ff ff       	call   801032a0 <begin_op>
  iput(curproc->cwd);
801043ec:	83 ec 0c             	sub    $0xc,%esp
801043ef:	ff 76 68             	pushl  0x68(%esi)
801043f2:	e8 09 da ff ff       	call   80101e00 <iput>
  end_op();
801043f7:	e8 14 ef ff ff       	call   80103310 <end_op>
  curproc->cwd = 0;
801043fc:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80104403:	c7 04 24 60 63 11 80 	movl   $0x80116360,(%esp)
8010440a:	e8 a1 18 00 00       	call   80105cb0 <acquire>
  wakeup1(curproc->parent);
8010440f:	8b 56 14             	mov    0x14(%esi),%edx
80104412:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104415:	b8 94 63 11 80       	mov    $0x80116394,%eax
8010441a:	eb 10                	jmp    8010442c <exit+0x9c>
8010441c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104420:	05 ac 05 00 00       	add    $0x5ac,%eax
80104425:	3d 94 ce 12 80       	cmp    $0x8012ce94,%eax
8010442a:	74 1e                	je     8010444a <exit+0xba>
    if(p->state == SLEEPING && p->chan == chan)
8010442c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104430:	75 ee                	jne    80104420 <exit+0x90>
80104432:	3b 50 20             	cmp    0x20(%eax),%edx
80104435:	75 e9                	jne    80104420 <exit+0x90>
      p->state = RUNNABLE;
80104437:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010443e:	05 ac 05 00 00       	add    $0x5ac,%eax
80104443:	3d 94 ce 12 80       	cmp    $0x8012ce94,%eax
80104448:	75 e2                	jne    8010442c <exit+0x9c>
      p->parent = initproc;
8010444a:	8b 0d 1c d6 10 80    	mov    0x8010d61c,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104450:	ba 94 63 11 80       	mov    $0x80116394,%edx
80104455:	eb 17                	jmp    8010446e <exit+0xde>
80104457:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010445e:	66 90                	xchg   %ax,%ax
80104460:	81 c2 ac 05 00 00    	add    $0x5ac,%edx
80104466:	81 fa 94 ce 12 80    	cmp    $0x8012ce94,%edx
8010446c:	74 3a                	je     801044a8 <exit+0x118>
    if(p->parent == curproc){
8010446e:	39 72 14             	cmp    %esi,0x14(%edx)
80104471:	75 ed                	jne    80104460 <exit+0xd0>
      if(p->state == ZOMBIE)
80104473:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104477:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010447a:	75 e4                	jne    80104460 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010447c:	b8 94 63 11 80       	mov    $0x80116394,%eax
80104481:	eb 11                	jmp    80104494 <exit+0x104>
80104483:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104487:	90                   	nop
80104488:	05 ac 05 00 00       	add    $0x5ac,%eax
8010448d:	3d 94 ce 12 80       	cmp    $0x8012ce94,%eax
80104492:	74 cc                	je     80104460 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80104494:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104498:	75 ee                	jne    80104488 <exit+0xf8>
8010449a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010449d:	75 e9                	jne    80104488 <exit+0xf8>
      p->state = RUNNABLE;
8010449f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801044a6:	eb e0                	jmp    80104488 <exit+0xf8>
  curproc->state = ZOMBIE;
801044a8:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801044af:	e8 1c fe ff ff       	call   801042d0 <sched>
  panic("zombie exit");
801044b4:	83 ec 0c             	sub    $0xc,%esp
801044b7:	68 24 a2 10 80       	push   $0x8010a224
801044bc:	e8 cf be ff ff       	call   80100390 <panic>
    panic("init exiting");
801044c1:	83 ec 0c             	sub    $0xc,%esp
801044c4:	68 17 a2 10 80       	push   $0x8010a217
801044c9:	e8 c2 be ff ff       	call   80100390 <panic>
801044ce:	66 90                	xchg   %ax,%ax

801044d0 <yield>:
{
801044d0:	f3 0f 1e fb          	endbr32 
801044d4:	55                   	push   %ebp
801044d5:	89 e5                	mov    %esp,%ebp
801044d7:	53                   	push   %ebx
801044d8:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801044db:	68 60 63 11 80       	push   $0x80116360
801044e0:	e8 cb 17 00 00       	call   80105cb0 <acquire>
  pushcli();
801044e5:	e8 c6 16 00 00       	call   80105bb0 <pushcli>
  c = mycpu();
801044ea:	e8 c1 f9 ff ff       	call   80103eb0 <mycpu>
  p = c->proc;
801044ef:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044f5:	e8 06 17 00 00       	call   80105c00 <popcli>
  myproc()->state = RUNNABLE;
801044fa:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104501:	e8 ca fd ff ff       	call   801042d0 <sched>
  release(&ptable.lock);
80104506:	c7 04 24 60 63 11 80 	movl   $0x80116360,(%esp)
8010450d:	e8 5e 18 00 00       	call   80105d70 <release>
}
80104512:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104515:	83 c4 10             	add    $0x10,%esp
80104518:	c9                   	leave  
80104519:	c3                   	ret    
8010451a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104520 <sleep>:
{
80104520:	f3 0f 1e fb          	endbr32 
80104524:	55                   	push   %ebp
80104525:	89 e5                	mov    %esp,%ebp
80104527:	57                   	push   %edi
80104528:	56                   	push   %esi
80104529:	53                   	push   %ebx
8010452a:	83 ec 0c             	sub    $0xc,%esp
8010452d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104530:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104533:	e8 78 16 00 00       	call   80105bb0 <pushcli>
  c = mycpu();
80104538:	e8 73 f9 ff ff       	call   80103eb0 <mycpu>
  p = c->proc;
8010453d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104543:	e8 b8 16 00 00       	call   80105c00 <popcli>
  if(p == 0)
80104548:	85 db                	test   %ebx,%ebx
8010454a:	0f 84 83 00 00 00    	je     801045d3 <sleep+0xb3>
  if(lk == 0)
80104550:	85 f6                	test   %esi,%esi
80104552:	74 72                	je     801045c6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104554:	81 fe 60 63 11 80    	cmp    $0x80116360,%esi
8010455a:	74 4c                	je     801045a8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010455c:	83 ec 0c             	sub    $0xc,%esp
8010455f:	68 60 63 11 80       	push   $0x80116360
80104564:	e8 47 17 00 00       	call   80105cb0 <acquire>
    release(lk);
80104569:	89 34 24             	mov    %esi,(%esp)
8010456c:	e8 ff 17 00 00       	call   80105d70 <release>
  p->chan = chan;
80104571:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104574:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010457b:	e8 50 fd ff ff       	call   801042d0 <sched>
  p->chan = 0;
80104580:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104587:	c7 04 24 60 63 11 80 	movl   $0x80116360,(%esp)
8010458e:	e8 dd 17 00 00       	call   80105d70 <release>
    acquire(lk);
80104593:	89 75 08             	mov    %esi,0x8(%ebp)
80104596:	83 c4 10             	add    $0x10,%esp
}
80104599:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010459c:	5b                   	pop    %ebx
8010459d:	5e                   	pop    %esi
8010459e:	5f                   	pop    %edi
8010459f:	5d                   	pop    %ebp
    acquire(lk);
801045a0:	e9 0b 17 00 00       	jmp    80105cb0 <acquire>
801045a5:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
801045a8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801045ab:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801045b2:	e8 19 fd ff ff       	call   801042d0 <sched>
  p->chan = 0;
801045b7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801045be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045c1:	5b                   	pop    %ebx
801045c2:	5e                   	pop    %esi
801045c3:	5f                   	pop    %edi
801045c4:	5d                   	pop    %ebp
801045c5:	c3                   	ret    
    panic("sleep without lk");
801045c6:	83 ec 0c             	sub    $0xc,%esp
801045c9:	68 36 a2 10 80       	push   $0x8010a236
801045ce:	e8 bd bd ff ff       	call   80100390 <panic>
    panic("sleep");
801045d3:	83 ec 0c             	sub    $0xc,%esp
801045d6:	68 30 a2 10 80       	push   $0x8010a230
801045db:	e8 b0 bd ff ff       	call   80100390 <panic>

801045e0 <wait>:
{
801045e0:	f3 0f 1e fb          	endbr32 
801045e4:	55                   	push   %ebp
801045e5:	89 e5                	mov    %esp,%ebp
801045e7:	56                   	push   %esi
801045e8:	53                   	push   %ebx
  pushcli();
801045e9:	e8 c2 15 00 00       	call   80105bb0 <pushcli>
  c = mycpu();
801045ee:	e8 bd f8 ff ff       	call   80103eb0 <mycpu>
  p = c->proc;
801045f3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801045f9:	e8 02 16 00 00       	call   80105c00 <popcli>
  acquire(&ptable.lock);
801045fe:	83 ec 0c             	sub    $0xc,%esp
80104601:	68 60 63 11 80       	push   $0x80116360
80104606:	e8 a5 16 00 00       	call   80105cb0 <acquire>
8010460b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010460e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104610:	bb 94 63 11 80       	mov    $0x80116394,%ebx
80104615:	eb 17                	jmp    8010462e <wait+0x4e>
80104617:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010461e:	66 90                	xchg   %ax,%ax
80104620:	81 c3 ac 05 00 00    	add    $0x5ac,%ebx
80104626:	81 fb 94 ce 12 80    	cmp    $0x8012ce94,%ebx
8010462c:	74 1e                	je     8010464c <wait+0x6c>
      if(p->parent != curproc)
8010462e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104631:	75 ed                	jne    80104620 <wait+0x40>
      if(p->state == ZOMBIE){
80104633:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104637:	74 37                	je     80104670 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104639:	81 c3 ac 05 00 00    	add    $0x5ac,%ebx
      havekids = 1;
8010463f:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104644:	81 fb 94 ce 12 80    	cmp    $0x8012ce94,%ebx
8010464a:	75 e2                	jne    8010462e <wait+0x4e>
    if(!havekids || curproc->killed){
8010464c:	85 c0                	test   %eax,%eax
8010464e:	74 76                	je     801046c6 <wait+0xe6>
80104650:	8b 46 24             	mov    0x24(%esi),%eax
80104653:	85 c0                	test   %eax,%eax
80104655:	75 6f                	jne    801046c6 <wait+0xe6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104657:	83 ec 08             	sub    $0x8,%esp
8010465a:	68 60 63 11 80       	push   $0x80116360
8010465f:	56                   	push   %esi
80104660:	e8 bb fe ff ff       	call   80104520 <sleep>
    havekids = 0;
80104665:	83 c4 10             	add    $0x10,%esp
80104668:	eb a4                	jmp    8010460e <wait+0x2e>
8010466a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104670:	83 ec 0c             	sub    $0xc,%esp
80104673:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104676:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104679:	e8 62 e3 ff ff       	call   801029e0 <kfree>
        freevm(p->pgdir);
8010467e:	5a                   	pop    %edx
8010467f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104682:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104689:	e8 82 45 00 00       	call   80108c10 <freevm>
        release(&ptable.lock);
8010468e:	c7 04 24 60 63 11 80 	movl   $0x80116360,(%esp)
        p->pid = 0;
80104695:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010469c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801046a3:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801046a7:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801046ae:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801046b5:	e8 b6 16 00 00       	call   80105d70 <release>
        return pid;
801046ba:	83 c4 10             	add    $0x10,%esp
}
801046bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046c0:	89 f0                	mov    %esi,%eax
801046c2:	5b                   	pop    %ebx
801046c3:	5e                   	pop    %esi
801046c4:	5d                   	pop    %ebp
801046c5:	c3                   	ret    
      release(&ptable.lock);
801046c6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801046c9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801046ce:	68 60 63 11 80       	push   $0x80116360
801046d3:	e8 98 16 00 00       	call   80105d70 <release>
      return -1;
801046d8:	83 c4 10             	add    $0x10,%esp
801046db:	eb e0                	jmp    801046bd <wait+0xdd>
801046dd:	8d 76 00             	lea    0x0(%esi),%esi

801046e0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801046e0:	f3 0f 1e fb          	endbr32 
801046e4:	55                   	push   %ebp
801046e5:	89 e5                	mov    %esp,%ebp
801046e7:	53                   	push   %ebx
801046e8:	83 ec 10             	sub    $0x10,%esp
801046eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801046ee:	68 60 63 11 80       	push   $0x80116360
801046f3:	e8 b8 15 00 00       	call   80105cb0 <acquire>
801046f8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046fb:	b8 94 63 11 80       	mov    $0x80116394,%eax
80104700:	eb 12                	jmp    80104714 <wakeup+0x34>
80104702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104708:	05 ac 05 00 00       	add    $0x5ac,%eax
8010470d:	3d 94 ce 12 80       	cmp    $0x8012ce94,%eax
80104712:	74 1e                	je     80104732 <wakeup+0x52>
    if(p->state == SLEEPING && p->chan == chan)
80104714:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104718:	75 ee                	jne    80104708 <wakeup+0x28>
8010471a:	3b 58 20             	cmp    0x20(%eax),%ebx
8010471d:	75 e9                	jne    80104708 <wakeup+0x28>
      p->state = RUNNABLE;
8010471f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104726:	05 ac 05 00 00       	add    $0x5ac,%eax
8010472b:	3d 94 ce 12 80       	cmp    $0x8012ce94,%eax
80104730:	75 e2                	jne    80104714 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
80104732:	c7 45 08 60 63 11 80 	movl   $0x80116360,0x8(%ebp)
}
80104739:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010473c:	c9                   	leave  
  release(&ptable.lock);
8010473d:	e9 2e 16 00 00       	jmp    80105d70 <release>
80104742:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104750 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104750:	f3 0f 1e fb          	endbr32 
80104754:	55                   	push   %ebp
80104755:	89 e5                	mov    %esp,%ebp
80104757:	53                   	push   %ebx
80104758:	83 ec 10             	sub    $0x10,%esp
8010475b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010475e:	68 60 63 11 80       	push   $0x80116360
80104763:	e8 48 15 00 00       	call   80105cb0 <acquire>
80104768:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010476b:	b8 94 63 11 80       	mov    $0x80116394,%eax
80104770:	eb 12                	jmp    80104784 <kill+0x34>
80104772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104778:	05 ac 05 00 00       	add    $0x5ac,%eax
8010477d:	3d 94 ce 12 80       	cmp    $0x8012ce94,%eax
80104782:	74 34                	je     801047b8 <kill+0x68>
    if(p->pid == pid){
80104784:	39 58 10             	cmp    %ebx,0x10(%eax)
80104787:	75 ef                	jne    80104778 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104789:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
8010478d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104794:	75 07                	jne    8010479d <kill+0x4d>
        p->state = RUNNABLE;
80104796:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
8010479d:	83 ec 0c             	sub    $0xc,%esp
801047a0:	68 60 63 11 80       	push   $0x80116360
801047a5:	e8 c6 15 00 00       	call   80105d70 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801047aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801047ad:	83 c4 10             	add    $0x10,%esp
801047b0:	31 c0                	xor    %eax,%eax
}
801047b2:	c9                   	leave  
801047b3:	c3                   	ret    
801047b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801047b8:	83 ec 0c             	sub    $0xc,%esp
801047bb:	68 60 63 11 80       	push   $0x80116360
801047c0:	e8 ab 15 00 00       	call   80105d70 <release>
}
801047c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801047c8:	83 c4 10             	add    $0x10,%esp
801047cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801047d0:	c9                   	leave  
801047d1:	c3                   	ret    
801047d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801047e0 <get_uncle_count>:

//get_uncle_count
int get_uncle_count(int pid){
801047e0:	f3 0f 1e fb          	endbr32 
801047e4:	55                   	push   %ebp
801047e5:	89 e5                	mov    %esp,%ebp
801047e7:	53                   	push   %ebx
801047e8:	83 ec 10             	sub    $0x10,%esp
801047eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;
  struct proc *p_parent;
  struct proc *p_grandParent = 0;
  acquire(&ptable.lock);
801047ee:	68 60 63 11 80       	push   $0x80116360
801047f3:	e8 b8 14 00 00       	call   80105cb0 <acquire>
  if(pid < 0 || pid >= NPROC){
801047f8:	83 c4 10             	add    $0x10,%esp
801047fb:	83 fb 3f             	cmp    $0x3f,%ebx
801047fe:	0f 87 a8 00 00 00    	ja     801048ac <get_uncle_count+0xcc>
  struct proc *p_grandParent = 0;
80104804:	31 c9                	xor    %ecx,%ecx
      return -1;
      }
  int count = 0;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104806:	b8 94 63 11 80       	mov    $0x80116394,%eax
8010480b:	eb 0f                	jmp    8010481c <get_uncle_count+0x3c>
8010480d:	8d 76 00             	lea    0x0(%esi),%esi
80104810:	05 ac 05 00 00       	add    $0x5ac,%eax
80104815:	3d 94 ce 12 80       	cmp    $0x8012ce94,%eax
8010481a:	74 34                	je     80104850 <get_uncle_count+0x70>
    count ++;
    if((p->pid) == pid){
8010481c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010481f:	75 ef                	jne    80104810 <get_uncle_count+0x30>
      p_parent = p->parent;
80104821:	8b 50 14             	mov    0x14(%eax),%edx
      if(p_parent != 0){
80104824:	85 d2                	test   %edx,%edx
80104826:	74 68                	je     80104890 <get_uncle_count+0xb0>
        p_grandParent = p_parent->parent;
80104828:	8b 4a 14             	mov    0x14(%edx),%ecx
        if(p_grandParent == 0){
8010482b:	85 c9                	test   %ecx,%ecx
8010482d:	75 e1                	jne    80104810 <get_uncle_count+0x30>
          cprintf("grandparent is zero.");
8010482f:	83 ec 0c             	sub    $0xc,%esp
          return -1;
80104832:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
          cprintf("grandparent is zero.");
80104837:	68 47 a2 10 80       	push   $0x8010a247
8010483c:	e8 7f c0 ff ff       	call   801008c0 <cprintf>
          return -1;
80104841:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ptable.lock);
  return siblings;

}
80104844:	89 d8                	mov    %ebx,%eax
80104846:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104849:	c9                   	leave  
8010484a:	c3                   	ret    
8010484b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010484f:	90                   	nop
  for(struct proc *i = ptable.proc; i < &ptable.proc[NPROC]; i++){
80104850:	b8 94 63 11 80       	mov    $0x80116394,%eax
  int siblings = 0;
80104855:	31 db                	xor    %ebx,%ebx
80104857:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010485e:	66 90                	xchg   %ax,%ax
      siblings++;
80104860:	31 d2                	xor    %edx,%edx
80104862:	39 48 14             	cmp    %ecx,0x14(%eax)
80104865:	0f 94 c2             	sete   %dl
  for(struct proc *i = ptable.proc; i < &ptable.proc[NPROC]; i++){
80104868:	05 ac 05 00 00       	add    $0x5ac,%eax
      siblings++;
8010486d:	01 d3                	add    %edx,%ebx
  for(struct proc *i = ptable.proc; i < &ptable.proc[NPROC]; i++){
8010486f:	3d 94 ce 12 80       	cmp    $0x8012ce94,%eax
80104874:	75 ea                	jne    80104860 <get_uncle_count+0x80>
  release(&ptable.lock);
80104876:	83 ec 0c             	sub    $0xc,%esp
80104879:	68 60 63 11 80       	push   $0x80116360
8010487e:	e8 ed 14 00 00       	call   80105d70 <release>
}
80104883:	89 d8                	mov    %ebx,%eax
  return siblings;
80104885:	83 c4 10             	add    $0x10,%esp
}
80104888:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010488b:	c9                   	leave  
8010488c:	c3                   	ret    
8010488d:	8d 76 00             	lea    0x0(%esi),%esi
        cprintf("parent is zero.");
80104890:	83 ec 0c             	sub    $0xc,%esp
        return -1;
80104893:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
        cprintf("parent is zero.");
80104898:	68 4c a2 10 80       	push   $0x8010a24c
8010489d:	e8 1e c0 ff ff       	call   801008c0 <cprintf>
}
801048a2:	89 d8                	mov    %ebx,%eax
        return -1;
801048a4:	83 c4 10             	add    $0x10,%esp
}
801048a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048aa:	c9                   	leave  
801048ab:	c3                   	ret    
      return -1;
801048ac:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801048b1:	eb 91                	jmp    80104844 <get_uncle_count+0x64>
801048b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048c0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801048c0:	f3 0f 1e fb          	endbr32 
801048c4:	55                   	push   %ebp
801048c5:	89 e5                	mov    %esp,%ebp
801048c7:	57                   	push   %edi
801048c8:	56                   	push   %esi
801048c9:	8d 75 e8             	lea    -0x18(%ebp),%esi
801048cc:	53                   	push   %ebx
801048cd:	bb 00 64 11 80       	mov    $0x80116400,%ebx
801048d2:	83 ec 3c             	sub    $0x3c,%esp
801048d5:	eb 2b                	jmp    80104902 <procdump+0x42>
801048d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048de:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801048e0:	83 ec 0c             	sub    $0xc,%esp
801048e3:	68 a5 a2 10 80       	push   $0x8010a2a5
801048e8:	e8 d3 bf ff ff       	call   801008c0 <cprintf>
801048ed:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048f0:	81 c3 ac 05 00 00    	add    $0x5ac,%ebx
801048f6:	81 fb 00 cf 12 80    	cmp    $0x8012cf00,%ebx
801048fc:	0f 84 8e 00 00 00    	je     80104990 <procdump+0xd0>
    if(p->state == UNUSED)
80104902:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104905:	85 c0                	test   %eax,%eax
80104907:	74 e7                	je     801048f0 <procdump+0x30>
      state = "???";
80104909:	ba 5c a2 10 80       	mov    $0x8010a25c,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010490e:	83 f8 05             	cmp    $0x5,%eax
80104911:	77 11                	ja     80104924 <procdump+0x64>
80104913:	8b 14 85 c4 a4 10 80 	mov    -0x7fef5b3c(,%eax,4),%edx
      state = "???";
8010491a:	b8 5c a2 10 80       	mov    $0x8010a25c,%eax
8010491f:	85 d2                	test   %edx,%edx
80104921:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104924:	53                   	push   %ebx
80104925:	52                   	push   %edx
80104926:	ff 73 a4             	pushl  -0x5c(%ebx)
80104929:	68 60 a2 10 80       	push   $0x8010a260
8010492e:	e8 8d bf ff ff       	call   801008c0 <cprintf>
    if(p->state == SLEEPING){
80104933:	83 c4 10             	add    $0x10,%esp
80104936:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010493a:	75 a4                	jne    801048e0 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010493c:	83 ec 08             	sub    $0x8,%esp
8010493f:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104942:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104945:	50                   	push   %eax
80104946:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104949:	8b 40 0c             	mov    0xc(%eax),%eax
8010494c:	83 c0 08             	add    $0x8,%eax
8010494f:	50                   	push   %eax
80104950:	e8 fb 11 00 00       	call   80105b50 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104955:	83 c4 10             	add    $0x10,%esp
80104958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010495f:	90                   	nop
80104960:	8b 17                	mov    (%edi),%edx
80104962:	85 d2                	test   %edx,%edx
80104964:	0f 84 76 ff ff ff    	je     801048e0 <procdump+0x20>
        cprintf(" %p", pc[i]);
8010496a:	83 ec 08             	sub    $0x8,%esp
8010496d:	83 c7 04             	add    $0x4,%edi
80104970:	52                   	push   %edx
80104971:	68 61 9c 10 80       	push   $0x80109c61
80104976:	e8 45 bf ff ff       	call   801008c0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010497b:	83 c4 10             	add    $0x10,%esp
8010497e:	39 fe                	cmp    %edi,%esi
80104980:	75 de                	jne    80104960 <procdump+0xa0>
80104982:	e9 59 ff ff ff       	jmp    801048e0 <procdump+0x20>
80104987:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010498e:	66 90                	xchg   %ax,%ax
  }
}
80104990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104993:	5b                   	pop    %ebx
80104994:	5e                   	pop    %esi
80104995:	5f                   	pop    %edi
80104996:	5d                   	pop    %ebp
80104997:	c3                   	ret    
80104998:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010499f:	90                   	nop

801049a0 <find_digital_root>:

int 
find_digital_root(int n){
801049a0:	f3 0f 1e fb          	endbr32 
801049a4:	55                   	push   %ebp
801049a5:	89 e5                	mov    %esp,%ebp
801049a7:	57                   	push   %edi
801049a8:	56                   	push   %esi
801049a9:	53                   	push   %ebx
801049aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
  while(n>9){
801049ad:	83 fb 09             	cmp    $0x9,%ebx
801049b0:	7e 3d                	jle    801049ef <find_digital_root+0x4f>
    int sum = 0 ;
    while(n > 0){
      int digit = n%10;
801049b2:	be 67 66 66 66       	mov    $0x66666667,%esi
801049b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049be:	66 90                	xchg   %ax,%ax
find_digital_root(int n){
801049c0:	89 d9                	mov    %ebx,%ecx
    int sum = 0 ;
801049c2:	31 db                	xor    %ebx,%ebx
801049c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      int digit = n%10;
801049c8:	89 c8                	mov    %ecx,%eax
801049ca:	89 cf                	mov    %ecx,%edi
801049cc:	f7 ee                	imul   %esi
801049ce:	89 c8                	mov    %ecx,%eax
801049d0:	c1 f8 1f             	sar    $0x1f,%eax
801049d3:	c1 fa 02             	sar    $0x2,%edx
801049d6:	29 c2                	sub    %eax,%edx
801049d8:	8d 04 92             	lea    (%edx,%edx,4),%eax
801049db:	01 c0                	add    %eax,%eax
801049dd:	29 c7                	sub    %eax,%edi
801049df:	89 c8                	mov    %ecx,%eax
      sum += digit;
      n = n/10;
801049e1:	89 d1                	mov    %edx,%ecx
      sum += digit;
801049e3:	01 fb                	add    %edi,%ebx
    while(n > 0){
801049e5:	83 f8 09             	cmp    $0x9,%eax
801049e8:	7f de                	jg     801049c8 <find_digital_root+0x28>
  while(n>9){
801049ea:	83 fb 09             	cmp    $0x9,%ebx
801049ed:	7f d1                	jg     801049c0 <find_digital_root+0x20>
    }
    n = sum;
  }
  
  return n;
}
801049ef:	89 d8                	mov    %ebx,%eax
801049f1:	5b                   	pop    %ebx
801049f2:	5e                   	pop    %esi
801049f3:	5f                   	pop    %edi
801049f4:	5d                   	pop    %ebp
801049f5:	c3                   	ret    
801049f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049fd:	8d 76 00             	lea    0x0(%esi),%esi

80104a00 <get_process_lifetime>:

int
get_process_lifetime(void){
80104a00:	f3 0f 1e fb          	endbr32 
80104a04:	55                   	push   %ebp
80104a05:	89 e5                	mov    %esp,%ebp
80104a07:	56                   	push   %esi
80104a08:	53                   	push   %ebx
  return sys_uptime() - myproc()->start_time ; 
80104a09:	e8 22 28 00 00       	call   80107230 <sys_uptime>
80104a0e:	89 c3                	mov    %eax,%ebx
  pushcli();
80104a10:	e8 9b 11 00 00       	call   80105bb0 <pushcli>
  c = mycpu();
80104a15:	e8 96 f4 ff ff       	call   80103eb0 <mycpu>
  p = c->proc;
80104a1a:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104a20:	e8 db 11 00 00       	call   80105c00 <popcli>
  return sys_uptime() - myproc()->start_time ; 
80104a25:	89 d8                	mov    %ebx,%eax
}
80104a27:	5b                   	pop    %ebx
  return sys_uptime() - myproc()->start_time ; 
80104a28:	2b 46 7c             	sub    0x7c(%esi),%eax
}
80104a2b:	5e                   	pop    %esi
80104a2c:	5d                   	pop    %ebp
80104a2d:	c3                   	ret    
80104a2e:	66 90                	xchg   %ax,%ax

80104a30 <change_Q>:
  }
  release(&ptable.lock);
}

int change_Q(int pid, int new_queue)
{
80104a30:	f3 0f 1e fb          	endbr32 
80104a34:	55                   	push   %ebp
80104a35:	89 e5                	mov    %esp,%ebp
80104a37:	57                   	push   %edi
80104a38:	56                   	push   %esi
80104a39:	53                   	push   %ebx
80104a3a:	83 ec 0c             	sub    $0xc,%esp
80104a3d:	8b 75 0c             	mov    0xc(%ebp),%esi
80104a40:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;
  int old_queue = -1;

  if (new_queue == UNSET)
80104a43:	85 f6                	test   %esi,%esi
80104a45:	75 0c                	jne    80104a53 <change_Q+0x23>
  {
    if (pid == 1)
80104a47:	83 fb 01             	cmp    $0x1,%ebx
80104a4a:	74 69                	je     80104ab5 <change_Q+0x85>
      new_queue = ROUND_ROBIN;
    else if (pid > 1)
80104a4c:	7e 6e                	jle    80104abc <change_Q+0x8c>
      new_queue = LCFS;
80104a4e:	be 02 00 00 00       	mov    $0x2,%esi
    else
      return -1;
  }
  acquire(&ptable.lock);
80104a53:	83 ec 0c             	sub    $0xc,%esp
  int old_queue = -1;
80104a56:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  acquire(&ptable.lock);
80104a5b:	68 60 63 11 80       	push   $0x80116360
80104a60:	e8 4b 12 00 00       	call   80105cb0 <acquire>
    if (p->pid == pid)
    {
      old_queue = p->sched_info.queue;
      p->sched_info.queue = new_queue;

      p->sched_info.arrival_queue_time = ticks;
80104a65:	8b 15 e0 d6 12 80    	mov    0x8012d6e0,%edx
80104a6b:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a6e:	b8 94 63 11 80       	mov    $0x80116394,%eax
80104a73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a77:	90                   	nop
    if (p->pid == pid)
80104a78:	39 58 10             	cmp    %ebx,0x10(%eax)
80104a7b:	75 12                	jne    80104a8f <change_Q+0x5f>
      old_queue = p->sched_info.queue;
80104a7d:	8b b8 80 00 00 00    	mov    0x80(%eax),%edi
      p->sched_info.arrival_queue_time = ticks;
80104a83:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
      p->sched_info.queue = new_queue;
80104a89:	89 b0 80 00 00 00    	mov    %esi,0x80(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a8f:	05 ac 05 00 00       	add    $0x5ac,%eax
80104a94:	3d 94 ce 12 80       	cmp    $0x8012ce94,%eax
80104a99:	75 dd                	jne    80104a78 <change_Q+0x48>
    }
  }
  release(&ptable.lock);
80104a9b:	83 ec 0c             	sub    $0xc,%esp
80104a9e:	68 60 63 11 80       	push   $0x80116360
80104aa3:	e8 c8 12 00 00       	call   80105d70 <release>
  return old_queue;
80104aa8:	83 c4 10             	add    $0x10,%esp
}
80104aab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104aae:	89 f8                	mov    %edi,%eax
80104ab0:	5b                   	pop    %ebx
80104ab1:	5e                   	pop    %esi
80104ab2:	5f                   	pop    %edi
80104ab3:	5d                   	pop    %ebp
80104ab4:	c3                   	ret    
      new_queue = ROUND_ROBIN;
80104ab5:	be 01 00 00 00       	mov    $0x1,%esi
80104aba:	eb 97                	jmp    80104a53 <change_Q+0x23>
      return -1;
80104abc:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104ac1:	eb e8                	jmp    80104aab <change_Q+0x7b>
80104ac3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ad0 <userinit>:
{
80104ad0:	f3 0f 1e fb          	endbr32 
80104ad4:	55                   	push   %ebp
80104ad5:	89 e5                	mov    %esp,%ebp
80104ad7:	53                   	push   %ebx
80104ad8:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80104adb:	e8 30 f2 ff ff       	call   80103d10 <allocproc>
80104ae0:	89 c3                	mov    %eax,%ebx
  initproc = p;
80104ae2:	a3 1c d6 10 80       	mov    %eax,0x8010d61c
  if((p->pgdir = setupkvm()) == 0)
80104ae7:	e8 a4 41 00 00       	call   80108c90 <setupkvm>
80104aec:	89 43 04             	mov    %eax,0x4(%ebx)
80104aef:	85 c0                	test   %eax,%eax
80104af1:	0f 84 c9 00 00 00    	je     80104bc0 <userinit+0xf0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104af7:	83 ec 04             	sub    $0x4,%esp
80104afa:	68 2c 00 00 00       	push   $0x2c
80104aff:	68 60 d4 10 80       	push   $0x8010d460
80104b04:	50                   	push   %eax
80104b05:	e8 56 3e 00 00       	call   80108960 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104b0a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104b0d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80104b13:	6a 4c                	push   $0x4c
80104b15:	6a 00                	push   $0x0
80104b17:	ff 73 18             	pushl  0x18(%ebx)
80104b1a:	e8 a1 12 00 00       	call   80105dc0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104b1f:	8b 43 18             	mov    0x18(%ebx),%eax
80104b22:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104b27:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104b2a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104b2f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104b33:	8b 43 18             	mov    0x18(%ebx),%eax
80104b36:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104b3a:	8b 43 18             	mov    0x18(%ebx),%eax
80104b3d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104b41:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104b45:	8b 43 18             	mov    0x18(%ebx),%eax
80104b48:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104b4c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104b50:	8b 43 18             	mov    0x18(%ebx),%eax
80104b53:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104b5a:	8b 43 18             	mov    0x18(%ebx),%eax
80104b5d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104b64:	8b 43 18             	mov    0x18(%ebx),%eax
80104b67:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104b6e:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104b71:	6a 10                	push   $0x10
80104b73:	68 82 a2 10 80       	push   $0x8010a282
80104b78:	50                   	push   %eax
80104b79:	e8 02 14 00 00       	call   80105f80 <safestrcpy>
  p->cwd = namei("/");
80104b7e:	c7 04 24 8b a2 10 80 	movl   $0x8010a28b,(%esp)
80104b85:	e8 16 da ff ff       	call   801025a0 <namei>
80104b8a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80104b8d:	c7 04 24 60 63 11 80 	movl   $0x80116360,(%esp)
80104b94:	e8 17 11 00 00       	call   80105cb0 <acquire>
  p->state = RUNNABLE;
80104b99:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80104ba0:	c7 04 24 60 63 11 80 	movl   $0x80116360,(%esp)
80104ba7:	e8 c4 11 00 00       	call   80105d70 <release>
  change_Q(p->pid, UNSET);
80104bac:	58                   	pop    %eax
80104bad:	5a                   	pop    %edx
80104bae:	6a 00                	push   $0x0
80104bb0:	ff 73 10             	pushl  0x10(%ebx)
80104bb3:	e8 78 fe ff ff       	call   80104a30 <change_Q>
}
80104bb8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bbb:	83 c4 10             	add    $0x10,%esp
80104bbe:	c9                   	leave  
80104bbf:	c3                   	ret    
    panic("userinit: out of memory?");
80104bc0:	83 ec 0c             	sub    $0xc,%esp
80104bc3:	68 69 a2 10 80       	push   $0x8010a269
80104bc8:	e8 c3 b7 ff ff       	call   80100390 <panic>
80104bcd:	8d 76 00             	lea    0x0(%esi),%esi

80104bd0 <fork>:
{
80104bd0:	f3 0f 1e fb          	endbr32 
80104bd4:	55                   	push   %ebp
80104bd5:	89 e5                	mov    %esp,%ebp
80104bd7:	57                   	push   %edi
80104bd8:	56                   	push   %esi
80104bd9:	53                   	push   %ebx
80104bda:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104bdd:	e8 ce 0f 00 00       	call   80105bb0 <pushcli>
  c = mycpu();
80104be2:	e8 c9 f2 ff ff       	call   80103eb0 <mycpu>
  p = c->proc;
80104be7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104bed:	e8 0e 10 00 00       	call   80105c00 <popcli>
  if((np = allocproc()) == 0){
80104bf2:	e8 19 f1 ff ff       	call   80103d10 <allocproc>
80104bf7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104bfa:	85 c0                	test   %eax,%eax
80104bfc:	0f 84 c7 00 00 00    	je     80104cc9 <fork+0xf9>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80104c02:	83 ec 08             	sub    $0x8,%esp
80104c05:	ff 33                	pushl  (%ebx)
80104c07:	89 c7                	mov    %eax,%edi
80104c09:	ff 73 04             	pushl  0x4(%ebx)
80104c0c:	e8 4f 41 00 00       	call   80108d60 <copyuvm>
80104c11:	83 c4 10             	add    $0x10,%esp
80104c14:	89 47 04             	mov    %eax,0x4(%edi)
80104c17:	85 c0                	test   %eax,%eax
80104c19:	0f 84 b1 00 00 00    	je     80104cd0 <fork+0x100>
  np->sz = curproc->sz;
80104c1f:	8b 03                	mov    (%ebx),%eax
80104c21:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104c24:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104c26:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104c29:	89 c8                	mov    %ecx,%eax
80104c2b:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80104c2e:	b9 13 00 00 00       	mov    $0x13,%ecx
80104c33:	8b 73 18             	mov    0x18(%ebx),%esi
80104c36:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104c38:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104c3a:	8b 40 18             	mov    0x18(%eax),%eax
80104c3d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80104c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80104c48:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104c4c:	85 c0                	test   %eax,%eax
80104c4e:	74 13                	je     80104c63 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104c50:	83 ec 0c             	sub    $0xc,%esp
80104c53:	50                   	push   %eax
80104c54:	e8 87 c7 ff ff       	call   801013e0 <filedup>
80104c59:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104c5c:	83 c4 10             	add    $0x10,%esp
80104c5f:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104c63:	83 c6 01             	add    $0x1,%esi
80104c66:	83 fe 10             	cmp    $0x10,%esi
80104c69:	75 dd                	jne    80104c48 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80104c6b:	83 ec 0c             	sub    $0xc,%esp
80104c6e:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104c71:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104c74:	e8 27 d0 ff ff       	call   80101ca0 <idup>
80104c79:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104c7c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104c7f:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104c82:	8d 47 6c             	lea    0x6c(%edi),%eax
80104c85:	6a 10                	push   $0x10
80104c87:	53                   	push   %ebx
80104c88:	50                   	push   %eax
80104c89:	e8 f2 12 00 00       	call   80105f80 <safestrcpy>
  pid = np->pid;
80104c8e:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104c91:	c7 04 24 60 63 11 80 	movl   $0x80116360,(%esp)
80104c98:	e8 13 10 00 00       	call   80105cb0 <acquire>
  np->state = RUNNABLE;
80104c9d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80104ca4:	c7 04 24 60 63 11 80 	movl   $0x80116360,(%esp)
80104cab:	e8 c0 10 00 00       	call   80105d70 <release>
  change_Q(np->pid, UNSET);
80104cb0:	58                   	pop    %eax
80104cb1:	5a                   	pop    %edx
80104cb2:	6a 00                	push   $0x0
80104cb4:	ff 77 10             	pushl  0x10(%edi)
80104cb7:	e8 74 fd ff ff       	call   80104a30 <change_Q>
  return pid;
80104cbc:	83 c4 10             	add    $0x10,%esp
}
80104cbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104cc2:	89 d8                	mov    %ebx,%eax
80104cc4:	5b                   	pop    %ebx
80104cc5:	5e                   	pop    %esi
80104cc6:	5f                   	pop    %edi
80104cc7:	5d                   	pop    %ebp
80104cc8:	c3                   	ret    
    return -1;
80104cc9:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104cce:	eb ef                	jmp    80104cbf <fork+0xef>
    kfree(np->kstack);
80104cd0:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104cd3:	83 ec 0c             	sub    $0xc,%esp
80104cd6:	ff 73 08             	pushl  0x8(%ebx)
80104cd9:	e8 02 dd ff ff       	call   801029e0 <kfree>
    np->kstack = 0;
80104cde:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80104ce5:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80104ce8:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104cef:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104cf4:	eb c9                	jmp    80104cbf <fork+0xef>
80104cf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cfd:	8d 76 00             	lea    0x0(%esi),%esi

80104d00 <ageprocs>:
{
80104d00:	f3 0f 1e fb          	endbr32 
80104d04:	55                   	push   %ebp
80104d05:	89 e5                	mov    %esp,%ebp
80104d07:	56                   	push   %esi
80104d08:	53                   	push   %ebx
80104d09:	8b 75 08             	mov    0x8(%ebp),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d0c:	bb 94 63 11 80       	mov    $0x80116394,%ebx
  acquire(&ptable.lock);
80104d11:	83 ec 0c             	sub    $0xc,%esp
80104d14:	68 60 63 11 80       	push   $0x80116360
80104d19:	e8 92 0f 00 00       	call   80105cb0 <acquire>
80104d1e:	83 c4 10             	add    $0x10,%esp
80104d21:	eb 13                	jmp    80104d36 <ageprocs+0x36>
80104d23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d27:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d28:	81 c3 ac 05 00 00    	add    $0x5ac,%ebx
80104d2e:	81 fb 94 ce 12 80    	cmp    $0x8012ce94,%ebx
80104d34:	74 57                	je     80104d8d <ageprocs+0x8d>
    if (p->state == RUNNABLE && p->sched_info.queue != ROUND_ROBIN)
80104d36:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104d3a:	75 ec                	jne    80104d28 <ageprocs+0x28>
80104d3c:	83 bb 80 00 00 00 01 	cmpl   $0x1,0x80(%ebx)
80104d43:	74 e3                	je     80104d28 <ageprocs+0x28>
      if (os_ticks - p->sched_info.last_run > AGING_THRESHOLD)
80104d45:	89 f0                	mov    %esi,%eax
80104d47:	2b 83 84 00 00 00    	sub    0x84(%ebx),%eax
80104d4d:	3d 40 1f 00 00       	cmp    $0x1f40,%eax
80104d52:	7e d4                	jle    80104d28 <ageprocs+0x28>
        release(&ptable.lock);
80104d54:	83 ec 0c             	sub    $0xc,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d57:	81 c3 ac 05 00 00    	add    $0x5ac,%ebx
        release(&ptable.lock);
80104d5d:	68 60 63 11 80       	push   $0x80116360
80104d62:	e8 09 10 00 00       	call   80105d70 <release>
        change_Q(p->pid, ROUND_ROBIN);
80104d67:	58                   	pop    %eax
80104d68:	5a                   	pop    %edx
80104d69:	6a 01                	push   $0x1
80104d6b:	ff b3 64 fa ff ff    	pushl  -0x59c(%ebx)
80104d71:	e8 ba fc ff ff       	call   80104a30 <change_Q>
        acquire(&ptable.lock);
80104d76:	c7 04 24 60 63 11 80 	movl   $0x80116360,(%esp)
80104d7d:	e8 2e 0f 00 00       	call   80105cb0 <acquire>
80104d82:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d85:	81 fb 94 ce 12 80    	cmp    $0x8012ce94,%ebx
80104d8b:	75 a9                	jne    80104d36 <ageprocs+0x36>
  release(&ptable.lock);
80104d8d:	c7 45 08 60 63 11 80 	movl   $0x80116360,0x8(%ebp)
}
80104d94:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d97:	5b                   	pop    %ebx
80104d98:	5e                   	pop    %esi
80104d99:	5d                   	pop    %ebp
  release(&ptable.lock);
80104d9a:	e9 d1 0f 00 00       	jmp    80105d70 <release>
80104d9f:	90                   	nop

80104da0 <num_digits>:

int num_digits(int n) {
80104da0:	f3 0f 1e fb          	endbr32 
80104da4:	55                   	push   %ebp
80104da5:	89 e5                	mov    %esp,%ebp
80104da7:	56                   	push   %esi
80104da8:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104dab:	53                   	push   %ebx
  int num = 0;
80104dac:	31 db                	xor    %ebx,%ebx
  while(n!= 0) {
80104dae:	85 c9                	test   %ecx,%ecx
80104db0:	74 21                	je     80104dd3 <num_digits+0x33>
    n/=10;
80104db2:	be 67 66 66 66       	mov    $0x66666667,%esi
80104db7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dbe:	66 90                	xchg   %ax,%ax
80104dc0:	89 c8                	mov    %ecx,%eax
80104dc2:	c1 f9 1f             	sar    $0x1f,%ecx
    num += 1;
80104dc5:	83 c3 01             	add    $0x1,%ebx
    n/=10;
80104dc8:	f7 ee                	imul   %esi
80104dca:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
80104dcd:	29 ca                	sub    %ecx,%edx
80104dcf:	89 d1                	mov    %edx,%ecx
80104dd1:	75 ed                	jne    80104dc0 <num_digits+0x20>
  }
  return num;
}
80104dd3:	89 d8                	mov    %ebx,%eax
80104dd5:	5b                   	pop    %ebx
80104dd6:	5e                   	pop    %esi
80104dd7:	5d                   	pop    %ebp
80104dd8:	c3                   	ret    
80104dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104de0 <space>:

void
space(int count)
{
80104de0:	f3 0f 1e fb          	endbr32 
80104de4:	55                   	push   %ebp
80104de5:	89 e5                	mov    %esp,%ebp
80104de7:	56                   	push   %esi
80104de8:	8b 75 08             	mov    0x8(%ebp),%esi
80104deb:	53                   	push   %ebx
  for(int i = 0; i < count; ++i)
80104dec:	85 f6                	test   %esi,%esi
80104dee:	7e 1f                	jle    80104e0f <space+0x2f>
80104df0:	31 db                	xor    %ebx,%ebx
80104df2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf(" ");
80104df8:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80104dfb:	83 c3 01             	add    $0x1,%ebx
    cprintf(" ");
80104dfe:	68 1e a3 10 80       	push   $0x8010a31e
80104e03:	e8 b8 ba ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
80104e08:	83 c4 10             	add    $0x10,%esp
80104e0b:	39 de                	cmp    %ebx,%esi
80104e0d:	75 e9                	jne    80104df8 <space+0x18>
}
80104e0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e12:	5b                   	pop    %ebx
80104e13:	5e                   	pop    %esi
80104e14:	5d                   	pop    %ebp
80104e15:	c3                   	ret    
80104e16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e1d:	8d 76 00             	lea    0x0(%esi),%esi

80104e20 <set_proc_bjf_params>:

int set_proc_bjf_params(int pid, float priority_ratio, float arrival_time_ratio, float executed_cycle_ratio, float process_size_ratio)
{
80104e20:	f3 0f 1e fb          	endbr32 
80104e24:	55                   	push   %ebp
80104e25:	89 e5                	mov    %esp,%ebp
80104e27:	53                   	push   %ebx
80104e28:	83 ec 10             	sub    $0x10,%esp
80104e2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104e2e:	68 60 63 11 80       	push   $0x80116360
80104e33:	e8 78 0e 00 00       	call   80105cb0 <acquire>
80104e38:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e3b:	b8 94 63 11 80       	mov    $0x80116394,%eax
80104e40:	eb 12                	jmp    80104e54 <set_proc_bjf_params+0x34>
80104e42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e48:	05 ac 05 00 00       	add    $0x5ac,%eax
80104e4d:	3d 94 ce 12 80       	cmp    $0x8012ce94,%eax
80104e52:	74 44                	je     80104e98 <set_proc_bjf_params+0x78>
  {
    if (p->pid == pid)
80104e54:	39 58 10             	cmp    %ebx,0x10(%eax)
80104e57:	75 ef                	jne    80104e48 <set_proc_bjf_params+0x28>
    {
      p->sched_info.bjf.priority_ratio = priority_ratio;
80104e59:	d9 45 0c             	flds   0xc(%ebp)
      p->sched_info.bjf.arrival_time_ratio = arrival_time_ratio;
      p->sched_info.bjf.executed_cycle_ratio = executed_cycle_ratio;
      p->sched_info.bjf.process_size_ratio = process_size_ratio;
      release(&ptable.lock);
80104e5c:	83 ec 0c             	sub    $0xc,%esp
      p->sched_info.bjf.priority_ratio = priority_ratio;
80104e5f:	d9 98 8c 00 00 00    	fstps  0x8c(%eax)
      p->sched_info.bjf.arrival_time_ratio = arrival_time_ratio;
80104e65:	d9 45 10             	flds   0x10(%ebp)
80104e68:	d9 98 94 00 00 00    	fstps  0x94(%eax)
      p->sched_info.bjf.executed_cycle_ratio = executed_cycle_ratio;
80104e6e:	d9 45 14             	flds   0x14(%ebp)
80104e71:	d9 98 9c 00 00 00    	fstps  0x9c(%eax)
      p->sched_info.bjf.process_size_ratio = process_size_ratio;
80104e77:	d9 45 18             	flds   0x18(%ebp)
80104e7a:	d9 98 a4 00 00 00    	fstps  0xa4(%eax)
      release(&ptable.lock);
80104e80:	68 60 63 11 80       	push   $0x80116360
80104e85:	e8 e6 0e 00 00       	call   80105d70 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104e8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104e8d:	83 c4 10             	add    $0x10,%esp
80104e90:	31 c0                	xor    %eax,%eax
}
80104e92:	c9                   	leave  
80104e93:	c3                   	ret    
80104e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104e98:	83 ec 0c             	sub    $0xc,%esp
80104e9b:	68 60 63 11 80       	push   $0x80116360
80104ea0:	e8 cb 0e 00 00       	call   80105d70 <release>
}
80104ea5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104ea8:	83 c4 10             	add    $0x10,%esp
80104eab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104eb0:	c9                   	leave  
80104eb1:	c3                   	ret    
80104eb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ec0 <set_system_bjf_params>:

int set_system_bjf_params(float priority_ratio, float arrival_time_ratio, float executed_cycle_ratio, float process_size_ratio)
{
80104ec0:	f3 0f 1e fb          	endbr32 
80104ec4:	55                   	push   %ebp
80104ec5:	89 e5                	mov    %esp,%ebp
80104ec7:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104eca:	68 60 63 11 80       	push   $0x80116360
80104ecf:	e8 dc 0d 00 00       	call   80105cb0 <acquire>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ed4:	d9 45 08             	flds   0x8(%ebp)
80104ed7:	d9 45 0c             	flds   0xc(%ebp)
  acquire(&ptable.lock);
80104eda:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104edd:	d9 45 10             	flds   0x10(%ebp)
80104ee0:	d9 45 14             	flds   0x14(%ebp)
80104ee3:	d9 cb                	fxch   %st(3)
80104ee5:	b8 94 63 11 80       	mov    $0x80116394,%eax
80104eea:	eb 0a                	jmp    80104ef6 <set_system_bjf_params+0x36>
80104eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ef0:	d9 cb                	fxch   %st(3)
80104ef2:	d9 c9                	fxch   %st(1)
80104ef4:	d9 ca                	fxch   %st(2)
  {
    p->sched_info.bjf.priority_ratio = priority_ratio;
80104ef6:	d9 90 8c 00 00 00    	fsts   0x8c(%eax)
80104efc:	d9 ca                	fxch   %st(2)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104efe:	05 ac 05 00 00       	add    $0x5ac,%eax
    p->sched_info.bjf.arrival_time_ratio = arrival_time_ratio;
80104f03:	d9 90 e8 fa ff ff    	fsts   -0x518(%eax)
80104f09:	d9 c9                	fxch   %st(1)
    p->sched_info.bjf.executed_cycle_ratio = executed_cycle_ratio;
80104f0b:	d9 90 f0 fa ff ff    	fsts   -0x510(%eax)
80104f11:	d9 cb                	fxch   %st(3)
    p->sched_info.bjf.process_size_ratio = process_size_ratio;
80104f13:	d9 90 f8 fa ff ff    	fsts   -0x508(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f19:	3d 94 ce 12 80       	cmp    $0x8012ce94,%eax
80104f1e:	75 d0                	jne    80104ef0 <set_system_bjf_params+0x30>
80104f20:	dd d8                	fstp   %st(0)
80104f22:	dd d8                	fstp   %st(0)
80104f24:	dd d8                	fstp   %st(0)
80104f26:	dd d8                	fstp   %st(0)
  }
  release(&ptable.lock);
80104f28:	83 ec 0c             	sub    $0xc,%esp
80104f2b:	68 60 63 11 80       	push   $0x80116360
80104f30:	e8 3b 0e 00 00       	call   80105d70 <release>
  return 0;
}
80104f35:	31 c0                	xor    %eax,%eax
80104f37:	c9                   	leave  
80104f38:	c3                   	ret    
80104f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f40 <show_process_info>:

void show_process_info()
{
80104f40:	f3 0f 1e fb          	endbr32 
80104f44:	55                   	push   %ebp
80104f45:	89 e5                	mov    %esp,%ebp
80104f47:	57                   	push   %edi
80104f48:	56                   	push   %esi
  static int columns[] = {16, 8, 9, 8, 8, 8, 9, 8, 8, 8, 8};
  cprintf("Process_Name    PID     State    Queue   Cycle   Arrival Priority R_Prty  R_Arvl  R_Exec  R_Size  Rank\n"
          "------------------------------------------------------------------------------------------------------\n");

  struct proc *p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f49:	be 94 63 11 80       	mov    $0x80116394,%esi
{
80104f4e:	53                   	push   %ebx
    n/=10;
80104f4f:	bb 67 66 66 66       	mov    $0x66666667,%ebx
{
80104f54:	83 ec 28             	sub    $0x28,%esp
  cprintf("Process_Name    PID     State    Queue   Cycle   Arrival Priority R_Prty  R_Arvl  R_Exec  R_Size  Rank\n"
80104f57:	68 48 a3 10 80       	push   $0x8010a348
80104f5c:	e8 5f b9 ff ff       	call   801008c0 <cprintf>
80104f61:	83 c4 10             	add    $0x10,%esp
80104f64:	eb 1c                	jmp    80104f82 <show_process_info+0x42>
80104f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f6d:	8d 76 00             	lea    0x0(%esi),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f70:	81 c6 ac 05 00 00    	add    $0x5ac,%esi
80104f76:	81 fe 94 ce 12 80    	cmp    $0x8012ce94,%esi
80104f7c:	0f 84 89 06 00 00    	je     8010560b <show_process_info+0x6cb>
  {
    if (p->state == UNUSED)
80104f82:	8b 46 0c             	mov    0xc(%esi),%eax
80104f85:	85 c0                	test   %eax,%eax
80104f87:	74 e7                	je     80104f70 <show_process_info+0x30>

    const char *state;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "unknown state";
80104f89:	c7 45 e0 8d a2 10 80 	movl   $0x8010a28d,-0x20(%ebp)
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104f90:	83 f8 05             	cmp    $0x5,%eax
80104f93:	77 14                	ja     80104fa9 <show_process_info+0x69>
80104f95:	8b 3c 85 ac a4 10 80 	mov    -0x7fef5b54(,%eax,4),%edi
      state = "unknown state";
80104f9c:	b8 8d a2 10 80       	mov    $0x8010a28d,%eax
80104fa1:	85 ff                	test   %edi,%edi
80104fa3:	0f 45 c7             	cmovne %edi,%eax
80104fa6:	89 45 e0             	mov    %eax,-0x20(%ebp)

    cprintf("%s", p->name);
80104fa9:	83 ec 08             	sub    $0x8,%esp
80104fac:	8d 7e 6c             	lea    0x6c(%esi),%edi
80104faf:	57                   	push   %edi
80104fb0:	68 66 a2 10 80       	push   $0x8010a266
80104fb5:	e8 06 b9 ff ff       	call   801008c0 <cprintf>
    space(columns[0] - strlen(p->name));
80104fba:	89 3c 24             	mov    %edi,(%esp)
80104fbd:	bf 10 00 00 00       	mov    $0x10,%edi
80104fc2:	e8 f9 0f 00 00       	call   80105fc0 <strlen>
  for(int i = 0; i < count; ++i)
80104fc7:	83 c4 10             	add    $0x10,%esp
    space(columns[0] - strlen(p->name));
80104fca:	29 c7                	sub    %eax,%edi
80104fcc:	89 f8                	mov    %edi,%eax
  for(int i = 0; i < count; ++i)
80104fce:	31 ff                	xor    %edi,%edi
80104fd0:	85 c0                	test   %eax,%eax
80104fd2:	7e 26                	jle    80104ffa <show_process_info+0xba>
80104fd4:	89 75 dc             	mov    %esi,-0x24(%ebp)
80104fd7:	89 fe                	mov    %edi,%esi
80104fd9:	89 c7                	mov    %eax,%edi
80104fdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fdf:	90                   	nop
    cprintf(" ");
80104fe0:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80104fe3:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
80104fe6:	68 1e a3 10 80       	push   $0x8010a31e
80104feb:	e8 d0 b8 ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
80104ff0:	83 c4 10             	add    $0x10,%esp
80104ff3:	39 f7                	cmp    %esi,%edi
80104ff5:	75 e9                	jne    80104fe0 <show_process_info+0xa0>
80104ff7:	8b 75 dc             	mov    -0x24(%ebp),%esi

    cprintf("%d", p->pid);
80104ffa:	83 ec 08             	sub    $0x8,%esp
80104ffd:	ff 76 10             	pushl  0x10(%esi)
  int num = 0;
80105000:	31 ff                	xor    %edi,%edi
    cprintf("%d", p->pid);
80105002:	68 9b a2 10 80       	push   $0x8010a29b
80105007:	e8 b4 b8 ff ff       	call   801008c0 <cprintf>
    space(columns[1] - num_digits(p->pid));
8010500c:	8b 4e 10             	mov    0x10(%esi),%ecx
  while(n!= 0) {
8010500f:	83 c4 10             	add    $0x10,%esp
    space(columns[1] - num_digits(p->pid));
80105012:	b8 08 00 00 00       	mov    $0x8,%eax
  while(n!= 0) {
80105017:	85 c9                	test   %ecx,%ecx
80105019:	74 23                	je     8010503e <show_process_info+0xfe>
8010501b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010501f:	90                   	nop
    n/=10;
80105020:	89 c8                	mov    %ecx,%eax
80105022:	c1 f9 1f             	sar    $0x1f,%ecx
    num += 1;
80105025:	83 c7 01             	add    $0x1,%edi
    n/=10;
80105028:	f7 eb                	imul   %ebx
8010502a:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
8010502d:	29 ca                	sub    %ecx,%edx
8010502f:	89 d1                	mov    %edx,%ecx
80105031:	75 ed                	jne    80105020 <show_process_info+0xe0>
    space(columns[1] - num_digits(p->pid));
80105033:	b8 08 00 00 00       	mov    $0x8,%eax
80105038:	29 f8                	sub    %edi,%eax
  for(int i = 0; i < count; ++i)
8010503a:	85 c0                	test   %eax,%eax
8010503c:	7e 2c                	jle    8010506a <show_process_info+0x12a>
    space(columns[1] - num_digits(p->pid));
8010503e:	31 ff                	xor    %edi,%edi
80105040:	89 75 dc             	mov    %esi,-0x24(%ebp)
80105043:	89 fe                	mov    %edi,%esi
80105045:	89 c7                	mov    %eax,%edi
80105047:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010504e:	66 90                	xchg   %ax,%ax
    cprintf(" ");
80105050:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80105053:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
80105056:	68 1e a3 10 80       	push   $0x8010a31e
8010505b:	e8 60 b8 ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
80105060:	83 c4 10             	add    $0x10,%esp
80105063:	39 fe                	cmp    %edi,%esi
80105065:	7c e9                	jl     80105050 <show_process_info+0x110>
80105067:	8b 75 dc             	mov    -0x24(%ebp),%esi

    cprintf("%s", state);
8010506a:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010506d:	83 ec 08             	sub    $0x8,%esp
80105070:	57                   	push   %edi
80105071:	68 66 a2 10 80       	push   $0x8010a266
80105076:	e8 45 b8 ff ff       	call   801008c0 <cprintf>
    space(columns[2] - strlen(state));
8010507b:	89 3c 24             	mov    %edi,(%esp)
8010507e:	bf 09 00 00 00       	mov    $0x9,%edi
80105083:	e8 38 0f 00 00       	call   80105fc0 <strlen>
  for(int i = 0; i < count; ++i)
80105088:	83 c4 10             	add    $0x10,%esp
    space(columns[2] - strlen(state));
8010508b:	29 c7                	sub    %eax,%edi
8010508d:	89 f8                	mov    %edi,%eax
  for(int i = 0; i < count; ++i)
8010508f:	31 ff                	xor    %edi,%edi
80105091:	85 c0                	test   %eax,%eax
80105093:	7e 25                	jle    801050ba <show_process_info+0x17a>
80105095:	89 75 e0             	mov    %esi,-0x20(%ebp)
80105098:	89 fe                	mov    %edi,%esi
8010509a:	89 c7                	mov    %eax,%edi
8010509c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" ");
801050a0:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
801050a3:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
801050a6:	68 1e a3 10 80       	push   $0x8010a31e
801050ab:	e8 10 b8 ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
801050b0:	83 c4 10             	add    $0x10,%esp
801050b3:	39 f7                	cmp    %esi,%edi
801050b5:	75 e9                	jne    801050a0 <show_process_info+0x160>
801050b7:	8b 75 e0             	mov    -0x20(%ebp),%esi

    cprintf("%d", p->sched_info.queue);
801050ba:	83 ec 08             	sub    $0x8,%esp
801050bd:	ff b6 80 00 00 00    	pushl  0x80(%esi)
  int num = 0;
801050c3:	31 ff                	xor    %edi,%edi
    cprintf("%d", p->sched_info.queue);
801050c5:	68 9b a2 10 80       	push   $0x8010a29b
801050ca:	e8 f1 b7 ff ff       	call   801008c0 <cprintf>
    space(columns[3] - num_digits(p->sched_info.queue));
801050cf:	8b 8e 80 00 00 00    	mov    0x80(%esi),%ecx
  while(n!= 0) {
801050d5:	83 c4 10             	add    $0x10,%esp
    space(columns[3] - num_digits(p->sched_info.queue));
801050d8:	b8 08 00 00 00       	mov    $0x8,%eax
  while(n!= 0) {
801050dd:	85 c9                	test   %ecx,%ecx
801050df:	74 25                	je     80105106 <show_process_info+0x1c6>
801050e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    n/=10;
801050e8:	89 c8                	mov    %ecx,%eax
801050ea:	c1 f9 1f             	sar    $0x1f,%ecx
    num += 1;
801050ed:	83 c7 01             	add    $0x1,%edi
    n/=10;
801050f0:	f7 eb                	imul   %ebx
801050f2:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
801050f5:	29 ca                	sub    %ecx,%edx
801050f7:	89 d1                	mov    %edx,%ecx
801050f9:	75 ed                	jne    801050e8 <show_process_info+0x1a8>
    space(columns[3] - num_digits(p->sched_info.queue));
801050fb:	b8 08 00 00 00       	mov    $0x8,%eax
80105100:	29 f8                	sub    %edi,%eax
  for(int i = 0; i < count; ++i)
80105102:	85 c0                	test   %eax,%eax
80105104:	7e 24                	jle    8010512a <show_process_info+0x1ea>
    space(columns[3] - num_digits(p->sched_info.queue));
80105106:	31 ff                	xor    %edi,%edi
80105108:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010510b:	89 fe                	mov    %edi,%esi
8010510d:	89 c7                	mov    %eax,%edi
8010510f:	90                   	nop
    cprintf(" ");
80105110:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80105113:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
80105116:	68 1e a3 10 80       	push   $0x8010a31e
8010511b:	e8 a0 b7 ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
80105120:	83 c4 10             	add    $0x10,%esp
80105123:	39 f7                	cmp    %esi,%edi
80105125:	7f e9                	jg     80105110 <show_process_info+0x1d0>
80105127:	8b 75 e0             	mov    -0x20(%ebp),%esi

    cprintf("%d", (int)p->sched_info.bjf.executed_cycle);
8010512a:	d9 86 98 00 00 00    	flds   0x98(%esi)
80105130:	83 ec 08             	sub    $0x8,%esp
  int num = 0;
80105133:	31 ff                	xor    %edi,%edi
    cprintf("%d", (int)p->sched_info.bjf.executed_cycle);
80105135:	d9 7d e6             	fnstcw -0x1a(%ebp)
80105138:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
8010513c:	80 cc 0c             	or     $0xc,%ah
8010513f:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80105143:	d9 6d e4             	fldcw  -0x1c(%ebp)
80105146:	db 5d e0             	fistpl -0x20(%ebp)
80105149:	d9 6d e6             	fldcw  -0x1a(%ebp)
8010514c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010514f:	50                   	push   %eax
80105150:	68 9b a2 10 80       	push   $0x8010a29b
80105155:	e8 66 b7 ff ff       	call   801008c0 <cprintf>
    space(columns[4] - num_digits((int)p->sched_info.bjf.executed_cycle));
8010515a:	d9 86 98 00 00 00    	flds   0x98(%esi)
  while(n!= 0) {
80105160:	83 c4 10             	add    $0x10,%esp
    space(columns[4] - num_digits((int)p->sched_info.bjf.executed_cycle));
80105163:	d9 7d e6             	fnstcw -0x1a(%ebp)
80105166:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
8010516a:	80 cc 0c             	or     $0xc,%ah
8010516d:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80105171:	b8 08 00 00 00       	mov    $0x8,%eax
80105176:	d9 6d e4             	fldcw  -0x1c(%ebp)
80105179:	db 5d e0             	fistpl -0x20(%ebp)
8010517c:	d9 6d e6             	fldcw  -0x1a(%ebp)
8010517f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  while(n!= 0) {
80105182:	85 c9                	test   %ecx,%ecx
80105184:	74 28                	je     801051ae <show_process_info+0x26e>
80105186:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010518d:	8d 76 00             	lea    0x0(%esi),%esi
    n/=10;
80105190:	89 c8                	mov    %ecx,%eax
80105192:	c1 f9 1f             	sar    $0x1f,%ecx
    num += 1;
80105195:	83 c7 01             	add    $0x1,%edi
    n/=10;
80105198:	f7 eb                	imul   %ebx
8010519a:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
8010519d:	29 ca                	sub    %ecx,%edx
8010519f:	89 d1                	mov    %edx,%ecx
801051a1:	75 ed                	jne    80105190 <show_process_info+0x250>
    space(columns[4] - num_digits((int)p->sched_info.bjf.executed_cycle));
801051a3:	b8 08 00 00 00       	mov    $0x8,%eax
801051a8:	29 f8                	sub    %edi,%eax
  for(int i = 0; i < count; ++i)
801051aa:	85 c0                	test   %eax,%eax
801051ac:	7e 2c                	jle    801051da <show_process_info+0x29a>
    space(columns[4] - num_digits((int)p->sched_info.bjf.executed_cycle));
801051ae:	31 ff                	xor    %edi,%edi
801051b0:	89 75 e0             	mov    %esi,-0x20(%ebp)
801051b3:	89 fe                	mov    %edi,%esi
801051b5:	89 c7                	mov    %eax,%edi
801051b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051be:	66 90                	xchg   %ax,%ax
    cprintf(" ");
801051c0:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
801051c3:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
801051c6:	68 1e a3 10 80       	push   $0x8010a31e
801051cb:	e8 f0 b6 ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
801051d0:	83 c4 10             	add    $0x10,%esp
801051d3:	39 fe                	cmp    %edi,%esi
801051d5:	7c e9                	jl     801051c0 <show_process_info+0x280>
801051d7:	8b 75 e0             	mov    -0x20(%ebp),%esi

    cprintf("%d", p->sched_info.bjf.arrival_time);
801051da:	83 ec 08             	sub    $0x8,%esp
801051dd:	ff b6 90 00 00 00    	pushl  0x90(%esi)
  int num = 0;
801051e3:	31 ff                	xor    %edi,%edi
    cprintf("%d", p->sched_info.bjf.arrival_time);
801051e5:	68 9b a2 10 80       	push   $0x8010a29b
801051ea:	e8 d1 b6 ff ff       	call   801008c0 <cprintf>
    space(columns[5] - num_digits(p->sched_info.bjf.arrival_time));
801051ef:	8b 8e 90 00 00 00    	mov    0x90(%esi),%ecx
  while(n!= 0) {
801051f5:	83 c4 10             	add    $0x10,%esp
    space(columns[5] - num_digits(p->sched_info.bjf.arrival_time));
801051f8:	b8 08 00 00 00       	mov    $0x8,%eax
  while(n!= 0) {
801051fd:	85 c9                	test   %ecx,%ecx
801051ff:	74 25                	je     80105226 <show_process_info+0x2e6>
80105201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    n/=10;
80105208:	89 c8                	mov    %ecx,%eax
8010520a:	c1 f9 1f             	sar    $0x1f,%ecx
    num += 1;
8010520d:	83 c7 01             	add    $0x1,%edi
    n/=10;
80105210:	f7 eb                	imul   %ebx
80105212:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
80105215:	29 ca                	sub    %ecx,%edx
80105217:	89 d1                	mov    %edx,%ecx
80105219:	75 ed                	jne    80105208 <show_process_info+0x2c8>
    space(columns[5] - num_digits(p->sched_info.bjf.arrival_time));
8010521b:	b8 08 00 00 00       	mov    $0x8,%eax
80105220:	29 f8                	sub    %edi,%eax
  for(int i = 0; i < count; ++i)
80105222:	85 c0                	test   %eax,%eax
80105224:	7e 24                	jle    8010524a <show_process_info+0x30a>
    space(columns[5] - num_digits(p->sched_info.bjf.arrival_time));
80105226:	31 ff                	xor    %edi,%edi
80105228:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010522b:	89 fe                	mov    %edi,%esi
8010522d:	89 c7                	mov    %eax,%edi
8010522f:	90                   	nop
    cprintf(" ");
80105230:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80105233:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
80105236:	68 1e a3 10 80       	push   $0x8010a31e
8010523b:	e8 80 b6 ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
80105240:	83 c4 10             	add    $0x10,%esp
80105243:	39 fe                	cmp    %edi,%esi
80105245:	7c e9                	jl     80105230 <show_process_info+0x2f0>
80105247:	8b 75 e0             	mov    -0x20(%ebp),%esi

    cprintf("%d", p->sched_info.bjf.priority);
8010524a:	83 ec 08             	sub    $0x8,%esp
8010524d:	ff b6 88 00 00 00    	pushl  0x88(%esi)
  int num = 0;
80105253:	31 ff                	xor    %edi,%edi
    cprintf("%d", p->sched_info.bjf.priority);
80105255:	68 9b a2 10 80       	push   $0x8010a29b
8010525a:	e8 61 b6 ff ff       	call   801008c0 <cprintf>
    space(columns[6] - num_digits(p->sched_info.bjf.priority));
8010525f:	8b 8e 88 00 00 00    	mov    0x88(%esi),%ecx
  while(n!= 0) {
80105265:	83 c4 10             	add    $0x10,%esp
    space(columns[6] - num_digits(p->sched_info.bjf.priority));
80105268:	b8 09 00 00 00       	mov    $0x9,%eax
  while(n!= 0) {
8010526d:	85 c9                	test   %ecx,%ecx
8010526f:	74 25                	je     80105296 <show_process_info+0x356>
80105271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    n/=10;
80105278:	89 c8                	mov    %ecx,%eax
8010527a:	c1 f9 1f             	sar    $0x1f,%ecx
    num += 1;
8010527d:	83 c7 01             	add    $0x1,%edi
    n/=10;
80105280:	f7 eb                	imul   %ebx
80105282:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
80105285:	29 ca                	sub    %ecx,%edx
80105287:	89 d1                	mov    %edx,%ecx
80105289:	75 ed                	jne    80105278 <show_process_info+0x338>
    space(columns[6] - num_digits(p->sched_info.bjf.priority));
8010528b:	b8 09 00 00 00       	mov    $0x9,%eax
80105290:	29 f8                	sub    %edi,%eax
  for(int i = 0; i < count; ++i)
80105292:	85 c0                	test   %eax,%eax
80105294:	7e 24                	jle    801052ba <show_process_info+0x37a>
    space(columns[6] - num_digits(p->sched_info.bjf.priority));
80105296:	31 ff                	xor    %edi,%edi
80105298:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010529b:	89 fe                	mov    %edi,%esi
8010529d:	89 c7                	mov    %eax,%edi
8010529f:	90                   	nop
    cprintf(" ");
801052a0:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
801052a3:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
801052a6:	68 1e a3 10 80       	push   $0x8010a31e
801052ab:	e8 10 b6 ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
801052b0:	83 c4 10             	add    $0x10,%esp
801052b3:	39 fe                	cmp    %edi,%esi
801052b5:	7c e9                	jl     801052a0 <show_process_info+0x360>
801052b7:	8b 75 e0             	mov    -0x20(%ebp),%esi

    cprintf("%d", (int)p->sched_info.bjf.priority_ratio);
801052ba:	d9 86 8c 00 00 00    	flds   0x8c(%esi)
801052c0:	83 ec 08             	sub    $0x8,%esp
  int num = 0;
801052c3:	31 ff                	xor    %edi,%edi
    cprintf("%d", (int)p->sched_info.bjf.priority_ratio);
801052c5:	d9 7d e6             	fnstcw -0x1a(%ebp)
801052c8:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
801052cc:	80 cc 0c             	or     $0xc,%ah
801052cf:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
801052d3:	d9 6d e4             	fldcw  -0x1c(%ebp)
801052d6:	db 5d e0             	fistpl -0x20(%ebp)
801052d9:	d9 6d e6             	fldcw  -0x1a(%ebp)
801052dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801052df:	50                   	push   %eax
801052e0:	68 9b a2 10 80       	push   $0x8010a29b
801052e5:	e8 d6 b5 ff ff       	call   801008c0 <cprintf>
    space(columns[7] - num_digits((int)p->sched_info.bjf.priority_ratio));
801052ea:	d9 86 8c 00 00 00    	flds   0x8c(%esi)
  while(n!= 0) {
801052f0:	83 c4 10             	add    $0x10,%esp
    space(columns[7] - num_digits((int)p->sched_info.bjf.priority_ratio));
801052f3:	d9 7d e6             	fnstcw -0x1a(%ebp)
801052f6:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
801052fa:	80 cc 0c             	or     $0xc,%ah
801052fd:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80105301:	b8 08 00 00 00       	mov    $0x8,%eax
80105306:	d9 6d e4             	fldcw  -0x1c(%ebp)
80105309:	db 5d e0             	fistpl -0x20(%ebp)
8010530c:	d9 6d e6             	fldcw  -0x1a(%ebp)
8010530f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  while(n!= 0) {
80105312:	85 c9                	test   %ecx,%ecx
80105314:	74 28                	je     8010533e <show_process_info+0x3fe>
80105316:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010531d:	8d 76 00             	lea    0x0(%esi),%esi
    n/=10;
80105320:	89 c8                	mov    %ecx,%eax
80105322:	c1 f9 1f             	sar    $0x1f,%ecx
    num += 1;
80105325:	83 c7 01             	add    $0x1,%edi
    n/=10;
80105328:	f7 eb                	imul   %ebx
8010532a:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
8010532d:	29 ca                	sub    %ecx,%edx
8010532f:	89 d1                	mov    %edx,%ecx
80105331:	75 ed                	jne    80105320 <show_process_info+0x3e0>
    space(columns[7] - num_digits((int)p->sched_info.bjf.priority_ratio));
80105333:	b8 08 00 00 00       	mov    $0x8,%eax
80105338:	29 f8                	sub    %edi,%eax
  for(int i = 0; i < count; ++i)
8010533a:	85 c0                	test   %eax,%eax
8010533c:	7e 3a                	jle    80105378 <show_process_info+0x438>
    space(columns[7] - num_digits((int)p->sched_info.bjf.priority_ratio));
8010533e:	31 ff                	xor    %edi,%edi
80105340:	89 75 e0             	mov    %esi,-0x20(%ebp)
80105343:	89 fe                	mov    %edi,%esi
80105345:	89 c7                	mov    %eax,%edi
80105347:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010534e:	66 90                	xchg   %ax,%ax
    cprintf(" ");
80105350:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80105353:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
80105356:	68 1e a3 10 80       	push   $0x8010a31e
8010535b:	e8 60 b5 ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
80105360:	83 c4 10             	add    $0x10,%esp
80105363:	39 fe                	cmp    %edi,%esi
80105365:	7c e9                	jl     80105350 <show_process_info+0x410>
80105367:	d9 7d e6             	fnstcw -0x1a(%ebp)
8010536a:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010536d:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
80105371:	80 cc 0c             	or     $0xc,%ah
80105374:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)

    cprintf("%d", (int)p->sched_info.bjf.arrival_time_ratio);
80105378:	d9 86 94 00 00 00    	flds   0x94(%esi)
8010537e:	83 ec 08             	sub    $0x8,%esp
  int num = 0;
80105381:	31 ff                	xor    %edi,%edi
    cprintf("%d", (int)p->sched_info.bjf.arrival_time_ratio);
80105383:	d9 6d e4             	fldcw  -0x1c(%ebp)
80105386:	db 5d e0             	fistpl -0x20(%ebp)
80105389:	d9 6d e6             	fldcw  -0x1a(%ebp)
8010538c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010538f:	50                   	push   %eax
80105390:	68 9b a2 10 80       	push   $0x8010a29b
80105395:	e8 26 b5 ff ff       	call   801008c0 <cprintf>
    space(columns[8] - num_digits((int)p->sched_info.bjf.arrival_time_ratio));
8010539a:	d9 86 94 00 00 00    	flds   0x94(%esi)
  while(n!= 0) {
801053a0:	83 c4 10             	add    $0x10,%esp
    space(columns[8] - num_digits((int)p->sched_info.bjf.arrival_time_ratio));
801053a3:	d9 7d e6             	fnstcw -0x1a(%ebp)
801053a6:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
801053aa:	80 cc 0c             	or     $0xc,%ah
801053ad:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
801053b1:	b8 08 00 00 00       	mov    $0x8,%eax
801053b6:	d9 6d e4             	fldcw  -0x1c(%ebp)
801053b9:	db 5d e0             	fistpl -0x20(%ebp)
801053bc:	d9 6d e6             	fldcw  -0x1a(%ebp)
801053bf:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  while(n!= 0) {
801053c2:	85 c9                	test   %ecx,%ecx
801053c4:	74 28                	je     801053ee <show_process_info+0x4ae>
801053c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053cd:	8d 76 00             	lea    0x0(%esi),%esi
    n/=10;
801053d0:	89 c8                	mov    %ecx,%eax
801053d2:	c1 f9 1f             	sar    $0x1f,%ecx
    num += 1;
801053d5:	83 c7 01             	add    $0x1,%edi
    n/=10;
801053d8:	f7 eb                	imul   %ebx
801053da:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
801053dd:	29 ca                	sub    %ecx,%edx
801053df:	89 d1                	mov    %edx,%ecx
801053e1:	75 ed                	jne    801053d0 <show_process_info+0x490>
    space(columns[8] - num_digits((int)p->sched_info.bjf.arrival_time_ratio));
801053e3:	b8 08 00 00 00       	mov    $0x8,%eax
801053e8:	29 f8                	sub    %edi,%eax
  for(int i = 0; i < count; ++i)
801053ea:	85 c0                	test   %eax,%eax
801053ec:	7e 3a                	jle    80105428 <show_process_info+0x4e8>
    space(columns[8] - num_digits((int)p->sched_info.bjf.arrival_time_ratio));
801053ee:	31 ff                	xor    %edi,%edi
801053f0:	89 75 e0             	mov    %esi,-0x20(%ebp)
801053f3:	89 fe                	mov    %edi,%esi
801053f5:	89 c7                	mov    %eax,%edi
801053f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053fe:	66 90                	xchg   %ax,%ax
    cprintf(" ");
80105400:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80105403:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
80105406:	68 1e a3 10 80       	push   $0x8010a31e
8010540b:	e8 b0 b4 ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
80105410:	83 c4 10             	add    $0x10,%esp
80105413:	39 fe                	cmp    %edi,%esi
80105415:	7c e9                	jl     80105400 <show_process_info+0x4c0>
80105417:	d9 7d e6             	fnstcw -0x1a(%ebp)
8010541a:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010541d:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
80105421:	80 cc 0c             	or     $0xc,%ah
80105424:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)

    cprintf("%d", (int)p->sched_info.bjf.executed_cycle_ratio);
80105428:	d9 86 9c 00 00 00    	flds   0x9c(%esi)
8010542e:	83 ec 08             	sub    $0x8,%esp
  int num = 0;
80105431:	31 ff                	xor    %edi,%edi
    cprintf("%d", (int)p->sched_info.bjf.executed_cycle_ratio);
80105433:	d9 6d e4             	fldcw  -0x1c(%ebp)
80105436:	db 5d e0             	fistpl -0x20(%ebp)
80105439:	d9 6d e6             	fldcw  -0x1a(%ebp)
8010543c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010543f:	50                   	push   %eax
80105440:	68 9b a2 10 80       	push   $0x8010a29b
80105445:	e8 76 b4 ff ff       	call   801008c0 <cprintf>
    space(columns[9] - num_digits((int)p->sched_info.bjf.executed_cycle_ratio));
8010544a:	d9 86 9c 00 00 00    	flds   0x9c(%esi)
  while(n!= 0) {
80105450:	83 c4 10             	add    $0x10,%esp
    space(columns[9] - num_digits((int)p->sched_info.bjf.executed_cycle_ratio));
80105453:	d9 7d e6             	fnstcw -0x1a(%ebp)
80105456:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
8010545a:	80 cc 0c             	or     $0xc,%ah
8010545d:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80105461:	b8 08 00 00 00       	mov    $0x8,%eax
80105466:	d9 6d e4             	fldcw  -0x1c(%ebp)
80105469:	db 5d e0             	fistpl -0x20(%ebp)
8010546c:	d9 6d e6             	fldcw  -0x1a(%ebp)
8010546f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  while(n!= 0) {
80105472:	85 c9                	test   %ecx,%ecx
80105474:	74 28                	je     8010549e <show_process_info+0x55e>
80105476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010547d:	8d 76 00             	lea    0x0(%esi),%esi
    n/=10;
80105480:	89 c8                	mov    %ecx,%eax
80105482:	c1 f9 1f             	sar    $0x1f,%ecx
    num += 1;
80105485:	83 c7 01             	add    $0x1,%edi
    n/=10;
80105488:	f7 eb                	imul   %ebx
8010548a:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
8010548d:	29 ca                	sub    %ecx,%edx
8010548f:	89 d1                	mov    %edx,%ecx
80105491:	75 ed                	jne    80105480 <show_process_info+0x540>
    space(columns[9] - num_digits((int)p->sched_info.bjf.executed_cycle_ratio));
80105493:	b8 08 00 00 00       	mov    $0x8,%eax
80105498:	29 f8                	sub    %edi,%eax
  for(int i = 0; i < count; ++i)
8010549a:	85 c0                	test   %eax,%eax
8010549c:	7e 3a                	jle    801054d8 <show_process_info+0x598>
    space(columns[9] - num_digits((int)p->sched_info.bjf.executed_cycle_ratio));
8010549e:	31 ff                	xor    %edi,%edi
801054a0:	89 75 e0             	mov    %esi,-0x20(%ebp)
801054a3:	89 fe                	mov    %edi,%esi
801054a5:	89 c7                	mov    %eax,%edi
801054a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054ae:	66 90                	xchg   %ax,%ax
    cprintf(" ");
801054b0:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
801054b3:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
801054b6:	68 1e a3 10 80       	push   $0x8010a31e
801054bb:	e8 00 b4 ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
801054c0:	83 c4 10             	add    $0x10,%esp
801054c3:	39 fe                	cmp    %edi,%esi
801054c5:	7c e9                	jl     801054b0 <show_process_info+0x570>
801054c7:	d9 7d e6             	fnstcw -0x1a(%ebp)
801054ca:	8b 75 e0             	mov    -0x20(%ebp),%esi
801054cd:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
801054d1:	80 cc 0c             	or     $0xc,%ah
801054d4:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)

    cprintf("%d", (int)p->sched_info.bjf.process_size_ratio);
801054d8:	d9 86 a4 00 00 00    	flds   0xa4(%esi)
801054de:	83 ec 08             	sub    $0x8,%esp
  int num = 0;
801054e1:	31 ff                	xor    %edi,%edi
    cprintf("%d", (int)p->sched_info.bjf.process_size_ratio);
801054e3:	d9 6d e4             	fldcw  -0x1c(%ebp)
801054e6:	db 5d e0             	fistpl -0x20(%ebp)
801054e9:	d9 6d e6             	fldcw  -0x1a(%ebp)
801054ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
801054ef:	50                   	push   %eax
801054f0:	68 9b a2 10 80       	push   $0x8010a29b
801054f5:	e8 c6 b3 ff ff       	call   801008c0 <cprintf>
    space(columns[10] - num_digits((int)p->sched_info.bjf.process_size_ratio));
801054fa:	d9 86 a4 00 00 00    	flds   0xa4(%esi)
  while(n!= 0) {
80105500:	83 c4 10             	add    $0x10,%esp
    space(columns[10] - num_digits((int)p->sched_info.bjf.process_size_ratio));
80105503:	d9 7d e6             	fnstcw -0x1a(%ebp)
80105506:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
8010550a:	80 cc 0c             	or     $0xc,%ah
8010550d:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80105511:	b8 08 00 00 00       	mov    $0x8,%eax
80105516:	d9 6d e4             	fldcw  -0x1c(%ebp)
80105519:	db 55 e0             	fistl  -0x20(%ebp)
8010551c:	d9 6d e6             	fldcw  -0x1a(%ebp)
8010551f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  while(n!= 0) {
80105522:	85 c9                	test   %ecx,%ecx
80105524:	74 32                	je     80105558 <show_process_info+0x618>
80105526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010552d:	8d 76 00             	lea    0x0(%esi),%esi
    n/=10;
80105530:	89 c8                	mov    %ecx,%eax
80105532:	c1 f9 1f             	sar    $0x1f,%ecx
    num += 1;
80105535:	83 c7 01             	add    $0x1,%edi
    n/=10;
80105538:	f7 eb                	imul   %ebx
8010553a:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
8010553d:	29 ca                	sub    %ecx,%edx
8010553f:	89 d1                	mov    %edx,%ecx
80105541:	75 ed                	jne    80105530 <show_process_info+0x5f0>
    space(columns[10] - num_digits((int)p->sched_info.bjf.process_size_ratio));
80105543:	b8 08 00 00 00       	mov    $0x8,%eax
80105548:	29 f8                	sub    %edi,%eax
  for(int i = 0; i < count; ++i)
8010554a:	85 c0                	test   %eax,%eax
8010554c:	7e 50                	jle    8010559e <show_process_info+0x65e>
8010554e:	dd d8                	fstp   %st(0)
80105550:	eb 0e                	jmp    80105560 <show_process_info+0x620>
80105552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105558:	dd d8                	fstp   %st(0)
8010555a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    space(columns[10] - num_digits((int)p->sched_info.bjf.process_size_ratio));
80105560:	31 ff                	xor    %edi,%edi
80105562:	89 75 e0             	mov    %esi,-0x20(%ebp)
80105565:	89 fe                	mov    %edi,%esi
80105567:	89 c7                	mov    %eax,%edi
80105569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" ");
80105570:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80105573:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
80105576:	68 1e a3 10 80       	push   $0x8010a31e
8010557b:	e8 40 b3 ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
80105580:	83 c4 10             	add    $0x10,%esp
80105583:	39 fe                	cmp    %edi,%esi
80105585:	7c e9                	jl     80105570 <show_process_info+0x630>
80105587:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010558a:	d9 86 a4 00 00 00    	flds   0xa4(%esi)
80105590:	d9 7d e6             	fnstcw -0x1a(%ebp)
80105593:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
80105597:	80 cc 0c             	or     $0xc,%ah
8010559a:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
         p->sched_info.bjf.arrival_time * p->sched_info.bjf.arrival_time_ratio +
8010559e:	db 86 90 00 00 00    	fildl  0x90(%esi)
801055a4:	d8 8e 94 00 00 00    	fmuls  0x94(%esi)

    cprintf("%d", (int)bjfrank(p));
801055aa:	83 ec 08             	sub    $0x8,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801055ad:	81 c6 ac 05 00 00    	add    $0x5ac,%esi
  return p->sched_info.bjf.priority * p->sched_info.bjf.priority_ratio +
801055b3:	db 86 dc fa ff ff    	fildl  -0x524(%esi)
801055b9:	d8 8e e0 fa ff ff    	fmuls  -0x520(%esi)
801055bf:	de c1                	faddp  %st,%st(1)
         p->sched_info.bjf.executed_cycle * p->sched_info.bjf.executed_cycle_ratio +
801055c1:	d9 86 ec fa ff ff    	flds   -0x514(%esi)
801055c7:	d8 8e f0 fa ff ff    	fmuls  -0x510(%esi)
         p->sched_info.bjf.arrival_time * p->sched_info.bjf.arrival_time_ratio +
801055cd:	de c1                	faddp  %st,%st(1)
         p->sched_info.bjf.process_size * p->sched_info.bjf.process_size_ratio;
801055cf:	db 86 f4 fa ff ff    	fildl  -0x50c(%esi)
801055d5:	de ca                	fmulp  %st,%st(2)
         p->sched_info.bjf.executed_cycle * p->sched_info.bjf.executed_cycle_ratio +
801055d7:	de c1                	faddp  %st,%st(1)
    cprintf("%d", (int)bjfrank(p));
801055d9:	d9 6d e4             	fldcw  -0x1c(%ebp)
801055dc:	db 5d e0             	fistpl -0x20(%ebp)
801055df:	d9 6d e6             	fldcw  -0x1a(%ebp)
801055e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801055e5:	50                   	push   %eax
801055e6:	68 9b a2 10 80       	push   $0x8010a29b
801055eb:	e8 d0 b2 ff ff       	call   801008c0 <cprintf>
    cprintf("\n");
801055f0:	c7 04 24 a5 a2 10 80 	movl   $0x8010a2a5,(%esp)
801055f7:	e8 c4 b2 ff ff       	call   801008c0 <cprintf>
801055fc:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801055ff:	81 fe 94 ce 12 80    	cmp    $0x8012ce94,%esi
80105605:	0f 85 77 f9 ff ff    	jne    80104f82 <show_process_info+0x42>
  }
}
8010560b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010560e:	5b                   	pop    %ebx
8010560f:	5e                   	pop    %esi
80105610:	5f                   	pop    %edi
80105611:	5d                   	pop    %ebp
80105612:	c3                   	ret    
80105613:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010561a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105620 <priority_wakeup>:

void priority_wakeup(void* chan){
80105620:	f3 0f 1e fb          	endbr32 
80105624:	55                   	push   %ebp
80105625:	89 e5                	mov    %esp,%ebp
80105627:	56                   	push   %esi
80105628:	53                   	push   %ebx
80105629:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010562c:	83 ec 0c             	sub    $0xc,%esp
8010562f:	68 60 63 11 80       	push   $0x80116360
80105634:	e8 77 06 00 00       	call   80105cb0 <acquire>
80105639:	83 c4 10             	add    $0x10,%esp
  struct proc *p;
  struct proc * p_max_pid = 0 ;
  int first = 1 ; 
8010563c:	b9 01 00 00 00       	mov    $0x1,%ecx
  struct proc * p_max_pid = 0 ;
80105641:	31 d2                	xor    %edx,%edx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105643:	b8 94 63 11 80       	mov    $0x80116394,%eax
80105648:	eb 12                	jmp    8010565c <priority_wakeup+0x3c>
8010564a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105650:	05 ac 05 00 00       	add    $0x5ac,%eax
80105655:	3d 94 ce 12 80       	cmp    $0x8012ce94,%eax
8010565a:	74 24                	je     80105680 <priority_wakeup+0x60>
    if(p->state == SLEEPING && p->chan == chan){
8010565c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80105660:	75 ee                	jne    80105650 <priority_wakeup+0x30>
80105662:	39 58 20             	cmp    %ebx,0x20(%eax)
80105665:	75 e9                	jne    80105650 <priority_wakeup+0x30>
      if(first){
80105667:	85 c9                	test   %ecx,%ecx
80105669:	75 35                	jne    801056a0 <priority_wakeup+0x80>
        p_max_pid = p;
        first = 0;
      }
      else{
        if(p->pid > p_max_pid->pid){
8010566b:	8b 72 10             	mov    0x10(%edx),%esi
8010566e:	39 70 10             	cmp    %esi,0x10(%eax)
80105671:	0f 4f d0             	cmovg  %eax,%edx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105674:	05 ac 05 00 00       	add    $0x5ac,%eax
80105679:	3d 94 ce 12 80       	cmp    $0x8012ce94,%eax
8010567e:	75 dc                	jne    8010565c <priority_wakeup+0x3c>
          p_max_pid = p;
        }
      }
    }
  }
  if (p_max_pid)
80105680:	85 d2                	test   %edx,%edx
80105682:	74 07                	je     8010568b <priority_wakeup+0x6b>
  {
      p_max_pid->state = RUNNABLE;
80105684:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)

    
  }
  
  release(&ptable.lock);
8010568b:	c7 45 08 60 63 11 80 	movl   $0x80116360,0x8(%ebp)
}
80105692:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105695:	5b                   	pop    %ebx
80105696:	5e                   	pop    %esi
80105697:	5d                   	pop    %ebp
  release(&ptable.lock);
80105698:	e9 d3 06 00 00       	jmp    80105d70 <release>
8010569d:	8d 76 00             	lea    0x0(%esi),%esi
801056a0:	89 c2                	mov    %eax,%edx
        first = 0;
801056a2:	31 c9                	xor    %ecx,%ecx
801056a4:	eb aa                	jmp    80105650 <priority_wakeup+0x30>
801056a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ad:	8d 76 00             	lea    0x0(%esi),%esi

801056b0 <compare_pid>:

int compare_pid(const void *a, const void *b) {
801056b0:	f3 0f 1e fb          	endbr32 
801056b4:	55                   	push   %ebp
801056b5:	89 e5                	mov    %esp,%ebp
  struct proc *procA = (struct proc *)a;
  struct proc *procB = (struct proc *)b;
  return procA->pid - procB->pid;
801056b7:	8b 45 08             	mov    0x8(%ebp),%eax
801056ba:	8b 55 0c             	mov    0xc(%ebp),%edx
}
801056bd:	5d                   	pop    %ebp
  return procA->pid - procB->pid;
801056be:	8b 40 10             	mov    0x10(%eax),%eax
801056c1:	2b 42 10             	sub    0x10(%edx),%eax
}
801056c4:	c3                   	ret    
801056c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056d0 <make_priority_queue>:


void make_priority_queue(void * chan) {
801056d0:	f3 0f 1e fb          	endbr32 
801056d4:	55                   	push   %ebp
801056d5:	89 e5                	mov    %esp,%ebp
801056d7:	57                   	push   %edi
    // Handle the allocation failure 
    release(&ptable.lock);
    return;
  }*/

  int first = 1;
801056d8:	bf 01 00 00 00       	mov    $0x1,%edi
void make_priority_queue(void * chan) {
801056dd:	56                   	push   %esi
801056de:	53                   	push   %ebx
  int i = 0;
  cprintf("Queue: \n" );
  // Populate the queue with processes that match the channel
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801056df:	bb 94 63 11 80       	mov    $0x80116394,%ebx
void make_priority_queue(void * chan) {
801056e4:	83 ec 18             	sub    $0x18,%esp
801056e7:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&ptable.lock); // Lock the ptable before making changes
801056ea:	68 60 63 11 80       	push   $0x80116360
801056ef:	e8 bc 05 00 00       	call   80105cb0 <acquire>
  cprintf("Queue: \n" );
801056f4:	c7 04 24 9e a2 10 80 	movl   $0x8010a29e,(%esp)
801056fb:	e8 c0 b1 ff ff       	call   801008c0 <cprintf>
80105700:	83 c4 10             	add    $0x10,%esp
  struct proc *proc_queue = 0;
80105703:	31 d2                	xor    %edx,%edx
80105705:	eb 17                	jmp    8010571e <make_priority_queue+0x4e>
80105707:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010570e:	66 90                	xchg   %ax,%ax
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80105710:	81 c3 ac 05 00 00    	add    $0x5ac,%ebx
80105716:	81 fb 94 ce 12 80    	cmp    $0x8012ce94,%ebx
8010571c:	74 42                	je     80105760 <make_priority_queue+0x90>
    if (p->state == SLEEPING && p->chan == chan) {
8010571e:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80105722:	75 ec                	jne    80105710 <make_priority_queue+0x40>
80105724:	39 73 20             	cmp    %esi,0x20(%ebx)
80105727:	75 e7                	jne    80105710 <make_priority_queue+0x40>
      if(first){
80105729:	85 ff                	test   %edi,%edi
8010572b:	75 63                	jne    80105790 <make_priority_queue+0xc0>
8010572d:	8b 43 10             	mov    0x10(%ebx),%eax
        proc_queue = p ;
        first = 0;
        i ++;
        cprintf("Pid %d , Name: %s \n", p->pid , p->name );
      }
      else if(p->pid > proc_queue->pid){
80105730:	39 42 10             	cmp    %eax,0x10(%edx)
80105733:	7d db                	jge    80105710 <make_priority_queue+0x40>
        proc_queue = p ;
        i ++ ;
        cprintf("Pid %d , Name: %s \n", p->pid , p->name );
80105735:	83 ec 04             	sub    $0x4,%esp
80105738:	8d 53 6c             	lea    0x6c(%ebx),%edx
8010573b:	52                   	push   %edx
8010573c:	50                   	push   %eax
8010573d:	68 a7 a2 10 80       	push   $0x8010a2a7
80105742:	e8 79 b1 ff ff       	call   801008c0 <cprintf>
80105747:	89 da                	mov    %ebx,%edx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80105749:	81 c3 ac 05 00 00    	add    $0x5ac,%ebx
        cprintf("Pid %d , Name: %s \n", p->pid , p->name );
8010574f:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80105752:	81 fb 94 ce 12 80    	cmp    $0x8012ce94,%ebx
80105758:	75 c4                	jne    8010571e <make_priority_queue+0x4e>
8010575a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      }
    }
  }
  if(first){
80105760:	85 ff                	test   %edi,%edi
80105762:	74 4c                	je     801057b0 <make_priority_queue+0xe0>
    cprintf("Queue is empty\n");
80105764:	83 ec 0c             	sub    $0xc,%esp
80105767:	68 bb a2 10 80       	push   $0x8010a2bb
8010576c:	e8 4f b1 ff ff       	call   801008c0 <cprintf>
80105771:	83 c4 10             	add    $0x10,%esp
  // Sort the queue by pid using the comparison function
  //qsort(proc_queue, i, sizeof(struct proc), compare_pid);
  


  release(&ptable.lock); // Release the lock after modifications are done
80105774:	c7 45 08 60 63 11 80 	movl   $0x80116360,0x8(%ebp)
}
8010577b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010577e:	5b                   	pop    %ebx
8010577f:	5e                   	pop    %esi
80105780:	5f                   	pop    %edi
80105781:	5d                   	pop    %ebp
  release(&ptable.lock); // Release the lock after modifications are done
80105782:	e9 e9 05 00 00       	jmp    80105d70 <release>
80105787:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010578e:	66 90                	xchg   %ax,%ax
        cprintf("Pid %d , Name: %s \n", p->pid , p->name );
80105790:	83 ec 04             	sub    $0x4,%esp
80105793:	8d 43 6c             	lea    0x6c(%ebx),%eax
        first = 0;
80105796:	31 ff                	xor    %edi,%edi
        cprintf("Pid %d , Name: %s \n", p->pid , p->name );
80105798:	50                   	push   %eax
80105799:	ff 73 10             	pushl  0x10(%ebx)
8010579c:	68 a7 a2 10 80       	push   $0x8010a2a7
801057a1:	e8 1a b1 ff ff       	call   801008c0 <cprintf>
801057a6:	83 c4 10             	add    $0x10,%esp
801057a9:	89 da                	mov    %ebx,%edx
801057ab:	e9 60 ff ff ff       	jmp    80105710 <make_priority_queue+0x40>
    cprintf("Now it is pid %d's turn\n");
801057b0:	83 ec 0c             	sub    $0xc,%esp
801057b3:	68 cb a2 10 80       	push   $0x8010a2cb
801057b8:	e8 03 b1 ff ff       	call   801008c0 <cprintf>
801057bd:	83 c4 10             	add    $0x10,%esp
801057c0:	eb b2                	jmp    80105774 <make_priority_queue+0xa4>
801057c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801057d0 <priorityLock_test>:


void priorityLock_test(){
801057d0:	f3 0f 1e fb          	endbr32 
801057d4:	55                   	push   %ebp
801057d5:	89 e5                	mov    %esp,%ebp
801057d7:	53                   	push   %ebx
801057d8:	83 ec 14             	sub    $0x14,%esp
  pushcli();
801057db:	e8 d0 03 00 00       	call   80105bb0 <pushcli>
  c = mycpu();
801057e0:	e8 cb e6 ff ff       	call   80103eb0 <mycpu>
  p = c->proc;
801057e5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801057eb:	e8 10 04 00 00       	call   80105c00 <popcli>
  cprintf("Process pid:%d want access to critical section\n" , myproc()->pid);
801057f0:	83 ec 08             	sub    $0x8,%esp
801057f3:	ff 73 10             	pushl  0x10(%ebx)
801057f6:	68 18 a4 10 80       	push   $0x8010a418
801057fb:	e8 c0 b0 ff ff       	call   801008c0 <cprintf>
  acquirePriorityLock(&lock);
80105800:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
80105807:	e8 04 02 00 00       	call   80105a10 <acquirePriorityLock>
  pushcli();
8010580c:	e8 9f 03 00 00       	call   80105bb0 <pushcli>
  c = mycpu();
80105811:	e8 9a e6 ff ff       	call   80103eb0 <mycpu>
  p = c->proc;
80105816:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010581c:	e8 df 03 00 00       	call   80105c00 <popcli>
  cprintf("Process pid:%d acquired access to critical section\n" , myproc()->pid);
80105821:	59                   	pop    %ecx
80105822:	58                   	pop    %eax
80105823:	ff 73 10             	pushl  0x10(%ebx)
80105826:	68 48 a4 10 80       	push   $0x8010a448
8010582b:	e8 90 b0 ff ff       	call   801008c0 <cprintf>
  volatile long long temp = 0;
80105830:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80105837:	83 c4 10             	add    $0x10,%esp
8010583a:	31 c9                	xor    %ecx,%ecx
8010583c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  for (long long l = 0; l < 200000000; l++){
80105843:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105847:	90                   	nop
    temp += 5 * 7 + 1;
80105848:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010584b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010584e:	83 c0 24             	add    $0x24,%eax
80105851:	83 d2 00             	adc    $0x0,%edx
80105854:	83 c1 01             	add    $0x1,%ecx
80105857:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010585a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  for (long long l = 0; l < 200000000; l++){
8010585d:	81 f9 00 c2 eb 0b    	cmp    $0xbebc200,%ecx
80105863:	75 e3                	jne    80105848 <priorityLock_test+0x78>
  }
            
  make_priority_queue(&lock);
80105865:	83 ec 0c             	sub    $0xc,%esp
80105868:	68 e0 d5 10 80       	push   $0x8010d5e0
8010586d:	e8 5e fe ff ff       	call   801056d0 <make_priority_queue>
  releasePriorityLock(&lock);
80105872:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
80105879:	e8 f2 01 00 00       	call   80105a70 <releasePriorityLock>
  pushcli();
8010587e:	e8 2d 03 00 00       	call   80105bb0 <pushcli>
  c = mycpu();
80105883:	e8 28 e6 ff ff       	call   80103eb0 <mycpu>
  p = c->proc;
80105888:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010588e:	e8 6d 03 00 00       	call   80105c00 <popcli>
  cprintf("Process pid: %d exited from critical section\n" , myproc()->pid);
80105893:	58                   	pop    %eax
80105894:	5a                   	pop    %edx
80105895:	ff 73 10             	pushl  0x10(%ebx)
80105898:	68 7c a4 10 80       	push   $0x8010a47c
8010589d:	e8 1e b0 ff ff       	call   801008c0 <cprintf>
}
801058a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058a5:	83 c4 10             	add    $0x10,%esp
801058a8:	c9                   	leave  
801058a9:	c3                   	ret    
801058aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801058b0 <init_queue_test>:

void
init_queue_test(void){
801058b0:	f3 0f 1e fb          	endbr32 
801058b4:	55                   	push   %ebp
801058b5:	89 e5                	mov    %esp,%ebp
801058b7:	83 ec 14             	sub    $0x14,%esp
  initPriorityLock(&lock);
801058ba:	68 e0 d5 10 80       	push   $0x8010d5e0
801058bf:	e8 ec 01 00 00       	call   80105ab0 <initPriorityLock>
801058c4:	83 c4 10             	add    $0x10,%esp
801058c7:	c9                   	leave  
801058c8:	c3                   	ret    
801058c9:	66 90                	xchg   %ax,%ax
801058cb:	66 90                	xchg   %ax,%ax
801058cd:	66 90                	xchg   %ax,%ax
801058cf:	90                   	nop

801058d0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801058d0:	f3 0f 1e fb          	endbr32 
801058d4:	55                   	push   %ebp
801058d5:	89 e5                	mov    %esp,%ebp
801058d7:	53                   	push   %ebx
801058d8:	83 ec 0c             	sub    $0xc,%esp
801058db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801058de:	68 e4 a4 10 80       	push   $0x8010a4e4
801058e3:	8d 43 04             	lea    0x4(%ebx),%eax
801058e6:	50                   	push   %eax
801058e7:	e8 44 02 00 00       	call   80105b30 <initlock>
  lk->name = name;
801058ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801058ef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801058f5:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801058f8:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801058ff:	89 43 38             	mov    %eax,0x38(%ebx)
}
80105902:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105905:	c9                   	leave  
80105906:	c3                   	ret    
80105907:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010590e:	66 90                	xchg   %ax,%ax

80105910 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80105910:	f3 0f 1e fb          	endbr32 
80105914:	55                   	push   %ebp
80105915:	89 e5                	mov    %esp,%ebp
80105917:	56                   	push   %esi
80105918:	53                   	push   %ebx
80105919:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010591c:	8d 73 04             	lea    0x4(%ebx),%esi
8010591f:	83 ec 0c             	sub    $0xc,%esp
80105922:	56                   	push   %esi
80105923:	e8 88 03 00 00       	call   80105cb0 <acquire>
  while (lk->locked) {
80105928:	8b 13                	mov    (%ebx),%edx
8010592a:	83 c4 10             	add    $0x10,%esp
8010592d:	85 d2                	test   %edx,%edx
8010592f:	74 1a                	je     8010594b <acquiresleep+0x3b>
80105931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80105938:	83 ec 08             	sub    $0x8,%esp
8010593b:	56                   	push   %esi
8010593c:	53                   	push   %ebx
8010593d:	e8 de eb ff ff       	call   80104520 <sleep>
  while (lk->locked) {
80105942:	8b 03                	mov    (%ebx),%eax
80105944:	83 c4 10             	add    $0x10,%esp
80105947:	85 c0                	test   %eax,%eax
80105949:	75 ed                	jne    80105938 <acquiresleep+0x28>
  }
  lk->locked = 1;
8010594b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80105951:	e8 ea e5 ff ff       	call   80103f40 <myproc>
80105956:	8b 40 10             	mov    0x10(%eax),%eax
80105959:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
8010595c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010595f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105962:	5b                   	pop    %ebx
80105963:	5e                   	pop    %esi
80105964:	5d                   	pop    %ebp
  release(&lk->lk);
80105965:	e9 06 04 00 00       	jmp    80105d70 <release>
8010596a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105970 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105970:	f3 0f 1e fb          	endbr32 
80105974:	55                   	push   %ebp
80105975:	89 e5                	mov    %esp,%ebp
80105977:	56                   	push   %esi
80105978:	53                   	push   %ebx
80105979:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010597c:	8d 73 04             	lea    0x4(%ebx),%esi
8010597f:	83 ec 0c             	sub    $0xc,%esp
80105982:	56                   	push   %esi
80105983:	e8 28 03 00 00       	call   80105cb0 <acquire>
  lk->locked = 0;
80105988:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010598e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80105995:	89 1c 24             	mov    %ebx,(%esp)
80105998:	e8 43 ed ff ff       	call   801046e0 <wakeup>
  release(&lk->lk);
8010599d:	89 75 08             	mov    %esi,0x8(%ebp)
801059a0:	83 c4 10             	add    $0x10,%esp
}
801059a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801059a6:	5b                   	pop    %ebx
801059a7:	5e                   	pop    %esi
801059a8:	5d                   	pop    %ebp
  release(&lk->lk);
801059a9:	e9 c2 03 00 00       	jmp    80105d70 <release>
801059ae:	66 90                	xchg   %ax,%ax

801059b0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801059b0:	f3 0f 1e fb          	endbr32 
801059b4:	55                   	push   %ebp
801059b5:	89 e5                	mov    %esp,%ebp
801059b7:	57                   	push   %edi
801059b8:	31 ff                	xor    %edi,%edi
801059ba:	56                   	push   %esi
801059bb:	53                   	push   %ebx
801059bc:	83 ec 18             	sub    $0x18,%esp
801059bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801059c2:	8d 73 04             	lea    0x4(%ebx),%esi
801059c5:	56                   	push   %esi
801059c6:	e8 e5 02 00 00       	call   80105cb0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801059cb:	8b 03                	mov    (%ebx),%eax
801059cd:	83 c4 10             	add    $0x10,%esp
801059d0:	85 c0                	test   %eax,%eax
801059d2:	75 1c                	jne    801059f0 <holdingsleep+0x40>
  release(&lk->lk);
801059d4:	83 ec 0c             	sub    $0xc,%esp
801059d7:	56                   	push   %esi
801059d8:	e8 93 03 00 00       	call   80105d70 <release>
  return r;
}
801059dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059e0:	89 f8                	mov    %edi,%eax
801059e2:	5b                   	pop    %ebx
801059e3:	5e                   	pop    %esi
801059e4:	5f                   	pop    %edi
801059e5:	5d                   	pop    %ebp
801059e6:	c3                   	ret    
801059e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ee:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
801059f0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801059f3:	e8 48 e5 ff ff       	call   80103f40 <myproc>
801059f8:	39 58 10             	cmp    %ebx,0x10(%eax)
801059fb:	0f 94 c0             	sete   %al
801059fe:	0f b6 c0             	movzbl %al,%eax
80105a01:	89 c7                	mov    %eax,%edi
80105a03:	eb cf                	jmp    801059d4 <holdingsleep+0x24>
80105a05:	66 90                	xchg   %ax,%ax
80105a07:	66 90                	xchg   %ax,%ax
80105a09:	66 90                	xchg   %ax,%ax
80105a0b:	66 90                	xchg   %ax,%ax
80105a0d:	66 90                	xchg   %ax,%ax
80105a0f:	90                   	nop

80105a10 <acquirePriorityLock>:
#include "proc.h"
#include "spinlock.h"
#include "priorityLock.h"

void acquirePriorityLock(struct PriorityLock *lock)
{
80105a10:	f3 0f 1e fb          	endbr32 
80105a14:	55                   	push   %ebp
80105a15:	89 e5                	mov    %esp,%ebp
80105a17:	53                   	push   %ebx
80105a18:	83 ec 10             	sub    $0x10,%esp
80105a1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	acquire(&lock->lock);
80105a1e:	53                   	push   %ebx
80105a1f:	e8 8c 02 00 00       	call   80105cb0 <acquire>
	while(lock->is_lock){
80105a24:	8b 53 34             	mov    0x34(%ebx),%edx
80105a27:	83 c4 10             	add    $0x10,%esp
80105a2a:	85 d2                	test   %edx,%edx
80105a2c:	74 16                	je     80105a44 <acquirePriorityLock+0x34>
80105a2e:	66 90                	xchg   %ax,%ax
		sleep(lock, &lock->lock);
80105a30:	83 ec 08             	sub    $0x8,%esp
80105a33:	53                   	push   %ebx
80105a34:	53                   	push   %ebx
80105a35:	e8 e6 ea ff ff       	call   80104520 <sleep>
	while(lock->is_lock){
80105a3a:	8b 43 34             	mov    0x34(%ebx),%eax
80105a3d:	83 c4 10             	add    $0x10,%esp
80105a40:	85 c0                	test   %eax,%eax
80105a42:	75 ec                	jne    80105a30 <acquirePriorityLock+0x20>
	}
	lock->is_lock = 1;
80105a44:	c7 43 34 01 00 00 00 	movl   $0x1,0x34(%ebx)
	lock->pid = myproc()->pid;	
80105a4b:	e8 f0 e4 ff ff       	call   80103f40 <myproc>
80105a50:	8b 40 10             	mov    0x10(%eax),%eax
80105a53:	89 43 38             	mov    %eax,0x38(%ebx)
	release(&lock->lock);
80105a56:	89 5d 08             	mov    %ebx,0x8(%ebp)

}
80105a59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a5c:	c9                   	leave  
	release(&lock->lock);
80105a5d:	e9 0e 03 00 00       	jmp    80105d70 <release>
80105a62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a70 <releasePriorityLock>:


void releasePriorityLock(struct PriorityLock *lock)
{
80105a70:	f3 0f 1e fb          	endbr32 
80105a74:	55                   	push   %ebp
80105a75:	89 e5                	mov    %esp,%ebp
80105a77:	53                   	push   %ebx
80105a78:	83 ec 10             	sub    $0x10,%esp
80105a7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	acquire(&lock->lock);
80105a7e:	53                   	push   %ebx
80105a7f:	e8 2c 02 00 00       	call   80105cb0 <acquire>
	lock->is_lock = 0;
80105a84:	c7 43 34 00 00 00 00 	movl   $0x0,0x34(%ebx)
	lock->pid = 0;
80105a8b:	c7 43 38 00 00 00 00 	movl   $0x0,0x38(%ebx)
	priority_wakeup(lock);
80105a92:	89 1c 24             	mov    %ebx,(%esp)
80105a95:	e8 86 fb ff ff       	call   80105620 <priority_wakeup>
	release(&lock->lock);
80105a9a:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105a9d:	83 c4 10             	add    $0x10,%esp
}
80105aa0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105aa3:	c9                   	leave  
	release(&lock->lock);
80105aa4:	e9 c7 02 00 00       	jmp    80105d70 <release>
80105aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ab0 <initPriorityLock>:

void initPriorityLock(struct PriorityLock * lock){
80105ab0:	f3 0f 1e fb          	endbr32 
80105ab4:	55                   	push   %ebp
80105ab5:	89 e5                	mov    %esp,%ebp
80105ab7:	53                   	push   %ebx
80105ab8:	83 ec 0c             	sub    $0xc,%esp
80105abb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	initlock(&lock->lock , "priority lock");
80105abe:	68 ef a4 10 80       	push   $0x8010a4ef
80105ac3:	53                   	push   %ebx
80105ac4:	e8 67 00 00 00       	call   80105b30 <initlock>
	lock->is_lock = 0;
80105ac9:	c7 43 34 00 00 00 00 	movl   $0x0,0x34(%ebx)
	lock->pid = 0;

}
80105ad0:	83 c4 10             	add    $0x10,%esp
	lock->pid = 0;
80105ad3:	c7 43 38 00 00 00 00 	movl   $0x0,0x38(%ebx)
}
80105ada:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105add:	c9                   	leave  
80105ade:	c3                   	ret    
80105adf:	90                   	nop

80105ae0 <holdingPriorityLock>:

int
holdingPriorityLock(struct PriorityLock * lock)
{
80105ae0:	f3 0f 1e fb          	endbr32 
80105ae4:	55                   	push   %ebp
80105ae5:	89 e5                	mov    %esp,%ebp
80105ae7:	57                   	push   %edi
80105ae8:	56                   	push   %esi
80105ae9:	31 f6                	xor    %esi,%esi
80105aeb:	53                   	push   %ebx
80105aec:	83 ec 18             	sub    $0x18,%esp
80105aef:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int ret = 0;
	acquire(&lock->lock);
80105af2:	53                   	push   %ebx
80105af3:	e8 b8 01 00 00       	call   80105cb0 <acquire>
	ret = (lock->pid == myproc()->pid)&& lock->is_lock;
80105af8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105afb:	e8 40 e4 ff ff       	call   80103f40 <myproc>
80105b00:	83 c4 10             	add    $0x10,%esp
80105b03:	3b 78 10             	cmp    0x10(%eax),%edi
80105b06:	75 0c                	jne    80105b14 <holdingPriorityLock+0x34>
80105b08:	8b 53 34             	mov    0x34(%ebx),%edx
80105b0b:	31 c0                	xor    %eax,%eax
80105b0d:	85 d2                	test   %edx,%edx
80105b0f:	0f 95 c0             	setne  %al
80105b12:	89 c6                	mov    %eax,%esi
	release(&lock->lock);
80105b14:	83 ec 0c             	sub    $0xc,%esp
80105b17:	53                   	push   %ebx
80105b18:	e8 53 02 00 00       	call   80105d70 <release>
	return ret;
80105b1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b20:	89 f0                	mov    %esi,%eax
80105b22:	5b                   	pop    %ebx
80105b23:	5e                   	pop    %esi
80105b24:	5f                   	pop    %edi
80105b25:	5d                   	pop    %ebp
80105b26:	c3                   	ret    
80105b27:	66 90                	xchg   %ax,%ax
80105b29:	66 90                	xchg   %ax,%ax
80105b2b:	66 90                	xchg   %ax,%ax
80105b2d:	66 90                	xchg   %ax,%ax
80105b2f:	90                   	nop

80105b30 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105b30:	f3 0f 1e fb          	endbr32 
80105b34:	55                   	push   %ebp
80105b35:	89 e5                	mov    %esp,%ebp
80105b37:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80105b3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80105b3d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80105b43:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80105b46:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105b4d:	5d                   	pop    %ebp
80105b4e:	c3                   	ret    
80105b4f:	90                   	nop

80105b50 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105b50:	f3 0f 1e fb          	endbr32 
80105b54:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105b55:	31 d2                	xor    %edx,%edx
{
80105b57:	89 e5                	mov    %esp,%ebp
80105b59:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80105b5a:	8b 45 08             	mov    0x8(%ebp),%eax
{
80105b5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80105b60:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80105b63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b67:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105b68:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80105b6e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80105b74:	77 1a                	ja     80105b90 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105b76:	8b 58 04             	mov    0x4(%eax),%ebx
80105b79:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80105b7c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80105b7f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105b81:	83 fa 0a             	cmp    $0xa,%edx
80105b84:	75 e2                	jne    80105b68 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80105b86:	5b                   	pop    %ebx
80105b87:	5d                   	pop    %ebp
80105b88:	c3                   	ret    
80105b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80105b90:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80105b93:	8d 51 28             	lea    0x28(%ecx),%edx
80105b96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b9d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80105ba0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105ba6:	83 c0 04             	add    $0x4,%eax
80105ba9:	39 d0                	cmp    %edx,%eax
80105bab:	75 f3                	jne    80105ba0 <getcallerpcs+0x50>
}
80105bad:	5b                   	pop    %ebx
80105bae:	5d                   	pop    %ebp
80105baf:	c3                   	ret    

80105bb0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105bb0:	f3 0f 1e fb          	endbr32 
80105bb4:	55                   	push   %ebp
80105bb5:	89 e5                	mov    %esp,%ebp
80105bb7:	53                   	push   %ebx
80105bb8:	83 ec 04             	sub    $0x4,%esp
80105bbb:	9c                   	pushf  
80105bbc:	5b                   	pop    %ebx
  asm volatile("cli");
80105bbd:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80105bbe:	e8 ed e2 ff ff       	call   80103eb0 <mycpu>
80105bc3:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105bc9:	85 c0                	test   %eax,%eax
80105bcb:	74 13                	je     80105be0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80105bcd:	e8 de e2 ff ff       	call   80103eb0 <mycpu>
80105bd2:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105bd9:	83 c4 04             	add    $0x4,%esp
80105bdc:	5b                   	pop    %ebx
80105bdd:	5d                   	pop    %ebp
80105bde:	c3                   	ret    
80105bdf:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80105be0:	e8 cb e2 ff ff       	call   80103eb0 <mycpu>
80105be5:	81 e3 00 02 00 00    	and    $0x200,%ebx
80105beb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80105bf1:	eb da                	jmp    80105bcd <pushcli+0x1d>
80105bf3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105c00 <popcli>:

void
popcli(void)
{
80105c00:	f3 0f 1e fb          	endbr32 
80105c04:	55                   	push   %ebp
80105c05:	89 e5                	mov    %esp,%ebp
80105c07:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105c0a:	9c                   	pushf  
80105c0b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105c0c:	f6 c4 02             	test   $0x2,%ah
80105c0f:	75 31                	jne    80105c42 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80105c11:	e8 9a e2 ff ff       	call   80103eb0 <mycpu>
80105c16:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80105c1d:	78 30                	js     80105c4f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105c1f:	e8 8c e2 ff ff       	call   80103eb0 <mycpu>
80105c24:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105c2a:	85 d2                	test   %edx,%edx
80105c2c:	74 02                	je     80105c30 <popcli+0x30>
    sti();
}
80105c2e:	c9                   	leave  
80105c2f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105c30:	e8 7b e2 ff ff       	call   80103eb0 <mycpu>
80105c35:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80105c3b:	85 c0                	test   %eax,%eax
80105c3d:	74 ef                	je     80105c2e <popcli+0x2e>
  asm volatile("sti");
80105c3f:	fb                   	sti    
}
80105c40:	c9                   	leave  
80105c41:	c3                   	ret    
    panic("popcli - interruptible");
80105c42:	83 ec 0c             	sub    $0xc,%esp
80105c45:	68 fd a4 10 80       	push   $0x8010a4fd
80105c4a:	e8 41 a7 ff ff       	call   80100390 <panic>
    panic("popcli");
80105c4f:	83 ec 0c             	sub    $0xc,%esp
80105c52:	68 14 a5 10 80       	push   $0x8010a514
80105c57:	e8 34 a7 ff ff       	call   80100390 <panic>
80105c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c60 <holding>:
{
80105c60:	f3 0f 1e fb          	endbr32 
80105c64:	55                   	push   %ebp
80105c65:	89 e5                	mov    %esp,%ebp
80105c67:	56                   	push   %esi
80105c68:	53                   	push   %ebx
80105c69:	8b 75 08             	mov    0x8(%ebp),%esi
80105c6c:	31 db                	xor    %ebx,%ebx
  pushcli();
80105c6e:	e8 3d ff ff ff       	call   80105bb0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105c73:	8b 06                	mov    (%esi),%eax
80105c75:	85 c0                	test   %eax,%eax
80105c77:	75 0f                	jne    80105c88 <holding+0x28>
  popcli();
80105c79:	e8 82 ff ff ff       	call   80105c00 <popcli>
}
80105c7e:	89 d8                	mov    %ebx,%eax
80105c80:	5b                   	pop    %ebx
80105c81:	5e                   	pop    %esi
80105c82:	5d                   	pop    %ebp
80105c83:	c3                   	ret    
80105c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80105c88:	8b 5e 08             	mov    0x8(%esi),%ebx
80105c8b:	e8 20 e2 ff ff       	call   80103eb0 <mycpu>
80105c90:	39 c3                	cmp    %eax,%ebx
80105c92:	0f 94 c3             	sete   %bl
  popcli();
80105c95:	e8 66 ff ff ff       	call   80105c00 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80105c9a:	0f b6 db             	movzbl %bl,%ebx
}
80105c9d:	89 d8                	mov    %ebx,%eax
80105c9f:	5b                   	pop    %ebx
80105ca0:	5e                   	pop    %esi
80105ca1:	5d                   	pop    %ebp
80105ca2:	c3                   	ret    
80105ca3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105cb0 <acquire>:
{
80105cb0:	f3 0f 1e fb          	endbr32 
80105cb4:	55                   	push   %ebp
80105cb5:	89 e5                	mov    %esp,%ebp
80105cb7:	56                   	push   %esi
80105cb8:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80105cb9:	e8 f2 fe ff ff       	call   80105bb0 <pushcli>
  if(holding(lk))
80105cbe:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105cc1:	83 ec 0c             	sub    $0xc,%esp
80105cc4:	53                   	push   %ebx
80105cc5:	e8 96 ff ff ff       	call   80105c60 <holding>
80105cca:	83 c4 10             	add    $0x10,%esp
80105ccd:	85 c0                	test   %eax,%eax
80105ccf:	0f 85 7f 00 00 00    	jne    80105d54 <acquire+0xa4>
80105cd5:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80105cd7:	ba 01 00 00 00       	mov    $0x1,%edx
80105cdc:	eb 05                	jmp    80105ce3 <acquire+0x33>
80105cde:	66 90                	xchg   %ax,%ax
80105ce0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105ce3:	89 d0                	mov    %edx,%eax
80105ce5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80105ce8:	85 c0                	test   %eax,%eax
80105cea:	75 f4                	jne    80105ce0 <acquire+0x30>
  __sync_synchronize();
80105cec:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105cf1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105cf4:	e8 b7 e1 ff ff       	call   80103eb0 <mycpu>
80105cf9:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80105cfc:	89 e8                	mov    %ebp,%eax
80105cfe:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105d00:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80105d06:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80105d0c:	77 22                	ja     80105d30 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80105d0e:	8b 50 04             	mov    0x4(%eax),%edx
80105d11:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80105d15:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80105d18:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105d1a:	83 fe 0a             	cmp    $0xa,%esi
80105d1d:	75 e1                	jne    80105d00 <acquire+0x50>
}
80105d1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d22:	5b                   	pop    %ebx
80105d23:	5e                   	pop    %esi
80105d24:	5d                   	pop    %ebp
80105d25:	c3                   	ret    
80105d26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d2d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80105d30:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80105d34:	83 c3 34             	add    $0x34,%ebx
80105d37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d3e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105d40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105d46:	83 c0 04             	add    $0x4,%eax
80105d49:	39 d8                	cmp    %ebx,%eax
80105d4b:	75 f3                	jne    80105d40 <acquire+0x90>
}
80105d4d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d50:	5b                   	pop    %ebx
80105d51:	5e                   	pop    %esi
80105d52:	5d                   	pop    %ebp
80105d53:	c3                   	ret    
    panic("acquire");
80105d54:	83 ec 0c             	sub    $0xc,%esp
80105d57:	68 1b a5 10 80       	push   $0x8010a51b
80105d5c:	e8 2f a6 ff ff       	call   80100390 <panic>
80105d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d6f:	90                   	nop

80105d70 <release>:
{
80105d70:	f3 0f 1e fb          	endbr32 
80105d74:	55                   	push   %ebp
80105d75:	89 e5                	mov    %esp,%ebp
80105d77:	53                   	push   %ebx
80105d78:	83 ec 10             	sub    $0x10,%esp
80105d7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80105d7e:	53                   	push   %ebx
80105d7f:	e8 dc fe ff ff       	call   80105c60 <holding>
80105d84:	83 c4 10             	add    $0x10,%esp
80105d87:	85 c0                	test   %eax,%eax
80105d89:	74 22                	je     80105dad <release+0x3d>
  lk->pcs[0] = 0;
80105d8b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105d92:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105d99:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80105d9e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105da4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105da7:	c9                   	leave  
  popcli();
80105da8:	e9 53 fe ff ff       	jmp    80105c00 <popcli>
    panic("release");
80105dad:	83 ec 0c             	sub    $0xc,%esp
80105db0:	68 23 a5 10 80       	push   $0x8010a523
80105db5:	e8 d6 a5 ff ff       	call   80100390 <panic>
80105dba:	66 90                	xchg   %ax,%ax
80105dbc:	66 90                	xchg   %ax,%ax
80105dbe:	66 90                	xchg   %ax,%ax

80105dc0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105dc0:	f3 0f 1e fb          	endbr32 
80105dc4:	55                   	push   %ebp
80105dc5:	89 e5                	mov    %esp,%ebp
80105dc7:	57                   	push   %edi
80105dc8:	8b 55 08             	mov    0x8(%ebp),%edx
80105dcb:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105dce:	53                   	push   %ebx
80105dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80105dd2:	89 d7                	mov    %edx,%edi
80105dd4:	09 cf                	or     %ecx,%edi
80105dd6:	83 e7 03             	and    $0x3,%edi
80105dd9:	75 25                	jne    80105e00 <memset+0x40>
    c &= 0xFF;
80105ddb:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105dde:	c1 e0 18             	shl    $0x18,%eax
80105de1:	89 fb                	mov    %edi,%ebx
80105de3:	c1 e9 02             	shr    $0x2,%ecx
80105de6:	c1 e3 10             	shl    $0x10,%ebx
80105de9:	09 d8                	or     %ebx,%eax
80105deb:	09 f8                	or     %edi,%eax
80105ded:	c1 e7 08             	shl    $0x8,%edi
80105df0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105df2:	89 d7                	mov    %edx,%edi
80105df4:	fc                   	cld    
80105df5:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80105df7:	5b                   	pop    %ebx
80105df8:	89 d0                	mov    %edx,%eax
80105dfa:	5f                   	pop    %edi
80105dfb:	5d                   	pop    %ebp
80105dfc:	c3                   	ret    
80105dfd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80105e00:	89 d7                	mov    %edx,%edi
80105e02:	fc                   	cld    
80105e03:	f3 aa                	rep stos %al,%es:(%edi)
80105e05:	5b                   	pop    %ebx
80105e06:	89 d0                	mov    %edx,%eax
80105e08:	5f                   	pop    %edi
80105e09:	5d                   	pop    %ebp
80105e0a:	c3                   	ret    
80105e0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e0f:	90                   	nop

80105e10 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105e10:	f3 0f 1e fb          	endbr32 
80105e14:	55                   	push   %ebp
80105e15:	89 e5                	mov    %esp,%ebp
80105e17:	56                   	push   %esi
80105e18:	8b 75 10             	mov    0x10(%ebp),%esi
80105e1b:	8b 55 08             	mov    0x8(%ebp),%edx
80105e1e:	53                   	push   %ebx
80105e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105e22:	85 f6                	test   %esi,%esi
80105e24:	74 2a                	je     80105e50 <memcmp+0x40>
80105e26:	01 c6                	add    %eax,%esi
80105e28:	eb 10                	jmp    80105e3a <memcmp+0x2a>
80105e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80105e30:	83 c0 01             	add    $0x1,%eax
80105e33:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80105e36:	39 f0                	cmp    %esi,%eax
80105e38:	74 16                	je     80105e50 <memcmp+0x40>
    if(*s1 != *s2)
80105e3a:	0f b6 0a             	movzbl (%edx),%ecx
80105e3d:	0f b6 18             	movzbl (%eax),%ebx
80105e40:	38 d9                	cmp    %bl,%cl
80105e42:	74 ec                	je     80105e30 <memcmp+0x20>
      return *s1 - *s2;
80105e44:	0f b6 c1             	movzbl %cl,%eax
80105e47:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80105e49:	5b                   	pop    %ebx
80105e4a:	5e                   	pop    %esi
80105e4b:	5d                   	pop    %ebp
80105e4c:	c3                   	ret    
80105e4d:	8d 76 00             	lea    0x0(%esi),%esi
80105e50:	5b                   	pop    %ebx
  return 0;
80105e51:	31 c0                	xor    %eax,%eax
}
80105e53:	5e                   	pop    %esi
80105e54:	5d                   	pop    %ebp
80105e55:	c3                   	ret    
80105e56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e5d:	8d 76 00             	lea    0x0(%esi),%esi

80105e60 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105e60:	f3 0f 1e fb          	endbr32 
80105e64:	55                   	push   %ebp
80105e65:	89 e5                	mov    %esp,%ebp
80105e67:	57                   	push   %edi
80105e68:	8b 55 08             	mov    0x8(%ebp),%edx
80105e6b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105e6e:	56                   	push   %esi
80105e6f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105e72:	39 d6                	cmp    %edx,%esi
80105e74:	73 2a                	jae    80105ea0 <memmove+0x40>
80105e76:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80105e79:	39 fa                	cmp    %edi,%edx
80105e7b:	73 23                	jae    80105ea0 <memmove+0x40>
80105e7d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80105e80:	85 c9                	test   %ecx,%ecx
80105e82:	74 13                	je     80105e97 <memmove+0x37>
80105e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80105e88:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80105e8c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80105e8f:	83 e8 01             	sub    $0x1,%eax
80105e92:	83 f8 ff             	cmp    $0xffffffff,%eax
80105e95:	75 f1                	jne    80105e88 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105e97:	5e                   	pop    %esi
80105e98:	89 d0                	mov    %edx,%eax
80105e9a:	5f                   	pop    %edi
80105e9b:	5d                   	pop    %ebp
80105e9c:	c3                   	ret    
80105e9d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80105ea0:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80105ea3:	89 d7                	mov    %edx,%edi
80105ea5:	85 c9                	test   %ecx,%ecx
80105ea7:	74 ee                	je     80105e97 <memmove+0x37>
80105ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105eb0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105eb1:	39 f0                	cmp    %esi,%eax
80105eb3:	75 fb                	jne    80105eb0 <memmove+0x50>
}
80105eb5:	5e                   	pop    %esi
80105eb6:	89 d0                	mov    %edx,%eax
80105eb8:	5f                   	pop    %edi
80105eb9:	5d                   	pop    %ebp
80105eba:	c3                   	ret    
80105ebb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ebf:	90                   	nop

80105ec0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105ec0:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80105ec4:	eb 9a                	jmp    80105e60 <memmove>
80105ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ecd:	8d 76 00             	lea    0x0(%esi),%esi

80105ed0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105ed0:	f3 0f 1e fb          	endbr32 
80105ed4:	55                   	push   %ebp
80105ed5:	89 e5                	mov    %esp,%ebp
80105ed7:	56                   	push   %esi
80105ed8:	8b 75 10             	mov    0x10(%ebp),%esi
80105edb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105ede:	53                   	push   %ebx
80105edf:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80105ee2:	85 f6                	test   %esi,%esi
80105ee4:	74 32                	je     80105f18 <strncmp+0x48>
80105ee6:	01 c6                	add    %eax,%esi
80105ee8:	eb 14                	jmp    80105efe <strncmp+0x2e>
80105eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105ef0:	38 da                	cmp    %bl,%dl
80105ef2:	75 14                	jne    80105f08 <strncmp+0x38>
    n--, p++, q++;
80105ef4:	83 c0 01             	add    $0x1,%eax
80105ef7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80105efa:	39 f0                	cmp    %esi,%eax
80105efc:	74 1a                	je     80105f18 <strncmp+0x48>
80105efe:	0f b6 11             	movzbl (%ecx),%edx
80105f01:	0f b6 18             	movzbl (%eax),%ebx
80105f04:	84 d2                	test   %dl,%dl
80105f06:	75 e8                	jne    80105ef0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105f08:	0f b6 c2             	movzbl %dl,%eax
80105f0b:	29 d8                	sub    %ebx,%eax
}
80105f0d:	5b                   	pop    %ebx
80105f0e:	5e                   	pop    %esi
80105f0f:	5d                   	pop    %ebp
80105f10:	c3                   	ret    
80105f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f18:	5b                   	pop    %ebx
    return 0;
80105f19:	31 c0                	xor    %eax,%eax
}
80105f1b:	5e                   	pop    %esi
80105f1c:	5d                   	pop    %ebp
80105f1d:	c3                   	ret    
80105f1e:	66 90                	xchg   %ax,%ax

80105f20 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105f20:	f3 0f 1e fb          	endbr32 
80105f24:	55                   	push   %ebp
80105f25:	89 e5                	mov    %esp,%ebp
80105f27:	57                   	push   %edi
80105f28:	56                   	push   %esi
80105f29:	8b 75 08             	mov    0x8(%ebp),%esi
80105f2c:	53                   	push   %ebx
80105f2d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105f30:	89 f2                	mov    %esi,%edx
80105f32:	eb 1b                	jmp    80105f4f <strncpy+0x2f>
80105f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f38:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105f3c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80105f3f:	83 c2 01             	add    $0x1,%edx
80105f42:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80105f46:	89 f9                	mov    %edi,%ecx
80105f48:	88 4a ff             	mov    %cl,-0x1(%edx)
80105f4b:	84 c9                	test   %cl,%cl
80105f4d:	74 09                	je     80105f58 <strncpy+0x38>
80105f4f:	89 c3                	mov    %eax,%ebx
80105f51:	83 e8 01             	sub    $0x1,%eax
80105f54:	85 db                	test   %ebx,%ebx
80105f56:	7f e0                	jg     80105f38 <strncpy+0x18>
    ;
  while(n-- > 0)
80105f58:	89 d1                	mov    %edx,%ecx
80105f5a:	85 c0                	test   %eax,%eax
80105f5c:	7e 15                	jle    80105f73 <strncpy+0x53>
80105f5e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80105f60:	83 c1 01             	add    $0x1,%ecx
80105f63:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80105f67:	89 c8                	mov    %ecx,%eax
80105f69:	f7 d0                	not    %eax
80105f6b:	01 d0                	add    %edx,%eax
80105f6d:	01 d8                	add    %ebx,%eax
80105f6f:	85 c0                	test   %eax,%eax
80105f71:	7f ed                	jg     80105f60 <strncpy+0x40>
  return os;
}
80105f73:	5b                   	pop    %ebx
80105f74:	89 f0                	mov    %esi,%eax
80105f76:	5e                   	pop    %esi
80105f77:	5f                   	pop    %edi
80105f78:	5d                   	pop    %ebp
80105f79:	c3                   	ret    
80105f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105f80 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105f80:	f3 0f 1e fb          	endbr32 
80105f84:	55                   	push   %ebp
80105f85:	89 e5                	mov    %esp,%ebp
80105f87:	56                   	push   %esi
80105f88:	8b 55 10             	mov    0x10(%ebp),%edx
80105f8b:	8b 75 08             	mov    0x8(%ebp),%esi
80105f8e:	53                   	push   %ebx
80105f8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105f92:	85 d2                	test   %edx,%edx
80105f94:	7e 21                	jle    80105fb7 <safestrcpy+0x37>
80105f96:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80105f9a:	89 f2                	mov    %esi,%edx
80105f9c:	eb 12                	jmp    80105fb0 <safestrcpy+0x30>
80105f9e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105fa0:	0f b6 08             	movzbl (%eax),%ecx
80105fa3:	83 c0 01             	add    $0x1,%eax
80105fa6:	83 c2 01             	add    $0x1,%edx
80105fa9:	88 4a ff             	mov    %cl,-0x1(%edx)
80105fac:	84 c9                	test   %cl,%cl
80105fae:	74 04                	je     80105fb4 <safestrcpy+0x34>
80105fb0:	39 d8                	cmp    %ebx,%eax
80105fb2:	75 ec                	jne    80105fa0 <safestrcpy+0x20>
    ;
  *s = 0;
80105fb4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105fb7:	89 f0                	mov    %esi,%eax
80105fb9:	5b                   	pop    %ebx
80105fba:	5e                   	pop    %esi
80105fbb:	5d                   	pop    %ebp
80105fbc:	c3                   	ret    
80105fbd:	8d 76 00             	lea    0x0(%esi),%esi

80105fc0 <strlen>:

int
strlen(const char *s)
{
80105fc0:	f3 0f 1e fb          	endbr32 
80105fc4:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105fc5:	31 c0                	xor    %eax,%eax
{
80105fc7:	89 e5                	mov    %esp,%ebp
80105fc9:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105fcc:	80 3a 00             	cmpb   $0x0,(%edx)
80105fcf:	74 10                	je     80105fe1 <strlen+0x21>
80105fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fd8:	83 c0 01             	add    $0x1,%eax
80105fdb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105fdf:	75 f7                	jne    80105fd8 <strlen+0x18>
    ;
  return n;
}
80105fe1:	5d                   	pop    %ebp
80105fe2:	c3                   	ret    

80105fe3 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105fe3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105fe7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105feb:	55                   	push   %ebp
  pushl %ebx
80105fec:	53                   	push   %ebx
  pushl %esi
80105fed:	56                   	push   %esi
  pushl %edi
80105fee:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105fef:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105ff1:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105ff3:	5f                   	pop    %edi
  popl %esi
80105ff4:	5e                   	pop    %esi
  popl %ebx
80105ff5:	5b                   	pop    %ebx
  popl %ebp
80105ff6:	5d                   	pop    %ebp
  ret
80105ff7:	c3                   	ret    
80105ff8:	66 90                	xchg   %ax,%ax
80105ffa:	66 90                	xchg   %ax,%ax
80105ffc:	66 90                	xchg   %ax,%ax
80105ffe:	66 90                	xchg   %ax,%ax

80106000 <fetchfloat>:
#include "x86.h"
#include "syscall.h"

int
fetchfloat(uint addr, float *fp)
{
80106000:	f3 0f 1e fb          	endbr32 
80106004:	55                   	push   %ebp
80106005:	89 e5                	mov    %esp,%ebp
80106007:	53                   	push   %ebx
80106008:	83 ec 04             	sub    $0x4,%esp
8010600b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010600e:	e8 2d df ff ff       	call   80103f40 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80106013:	8b 00                	mov    (%eax),%eax
80106015:	39 d8                	cmp    %ebx,%eax
80106017:	76 17                	jbe    80106030 <fetchfloat+0x30>
80106019:	8d 53 04             	lea    0x4(%ebx),%edx
8010601c:	39 d0                	cmp    %edx,%eax
8010601e:	72 10                	jb     80106030 <fetchfloat+0x30>
    return -1;
  *fp = *(float*)(addr);
80106020:	d9 03                	flds   (%ebx)
80106022:	8b 45 0c             	mov    0xc(%ebp),%eax
80106025:	d9 18                	fstps  (%eax)
  return 0;
80106027:	31 c0                	xor    %eax,%eax
}
80106029:	83 c4 04             	add    $0x4,%esp
8010602c:	5b                   	pop    %ebx
8010602d:	5d                   	pop    %ebp
8010602e:	c3                   	ret    
8010602f:	90                   	nop
    return -1;
80106030:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106035:	eb f2                	jmp    80106029 <fetchfloat+0x29>
80106037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010603e:	66 90                	xchg   %ax,%ax

80106040 <argfloat>:


int
argfloat(int n, float *fp)
{
80106040:	f3 0f 1e fb          	endbr32 
80106044:	55                   	push   %ebp
80106045:	89 e5                	mov    %esp,%ebp
80106047:	56                   	push   %esi
80106048:	53                   	push   %ebx
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
80106049:	e8 f2 de ff ff       	call   80103f40 <myproc>
8010604e:	8b 55 08             	mov    0x8(%ebp),%edx
80106051:	8b 40 18             	mov    0x18(%eax),%eax
80106054:	8b 40 44             	mov    0x44(%eax),%eax
80106057:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
8010605a:	e8 e1 de ff ff       	call   80103f40 <myproc>
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
8010605f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80106062:	8b 00                	mov    (%eax),%eax
80106064:	39 c6                	cmp    %eax,%esi
80106066:	73 18                	jae    80106080 <argfloat+0x40>
80106068:	8d 53 08             	lea    0x8(%ebx),%edx
8010606b:	39 d0                	cmp    %edx,%eax
8010606d:	72 11                	jb     80106080 <argfloat+0x40>
  *fp = *(float*)(addr);
8010606f:	d9 43 04             	flds   0x4(%ebx)
80106072:	8b 45 0c             	mov    0xc(%ebp),%eax
80106075:	d9 18                	fstps  (%eax)
  return 0;
80106077:	31 c0                	xor    %eax,%eax
}
80106079:	5b                   	pop    %ebx
8010607a:	5e                   	pop    %esi
8010607b:	5d                   	pop    %ebp
8010607c:	c3                   	ret    
8010607d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106080:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
80106085:	eb f2                	jmp    80106079 <argfloat+0x39>
80106087:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010608e:	66 90                	xchg   %ax,%ax

80106090 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80106090:	f3 0f 1e fb          	endbr32 
80106094:	55                   	push   %ebp
80106095:	89 e5                	mov    %esp,%ebp
80106097:	53                   	push   %ebx
80106098:	83 ec 04             	sub    $0x4,%esp
8010609b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010609e:	e8 9d de ff ff       	call   80103f40 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801060a3:	8b 00                	mov    (%eax),%eax
801060a5:	39 d8                	cmp    %ebx,%eax
801060a7:	76 17                	jbe    801060c0 <fetchint+0x30>
801060a9:	8d 53 04             	lea    0x4(%ebx),%edx
801060ac:	39 d0                	cmp    %edx,%eax
801060ae:	72 10                	jb     801060c0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801060b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801060b3:	8b 13                	mov    (%ebx),%edx
801060b5:	89 10                	mov    %edx,(%eax)
  return 0;
801060b7:	31 c0                	xor    %eax,%eax
}
801060b9:	83 c4 04             	add    $0x4,%esp
801060bc:	5b                   	pop    %ebx
801060bd:	5d                   	pop    %ebp
801060be:	c3                   	ret    
801060bf:	90                   	nop
    return -1;
801060c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060c5:	eb f2                	jmp    801060b9 <fetchint+0x29>
801060c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ce:	66 90                	xchg   %ax,%ax

801060d0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801060d0:	f3 0f 1e fb          	endbr32 
801060d4:	55                   	push   %ebp
801060d5:	89 e5                	mov    %esp,%ebp
801060d7:	53                   	push   %ebx
801060d8:	83 ec 04             	sub    $0x4,%esp
801060db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801060de:	e8 5d de ff ff       	call   80103f40 <myproc>

  if(addr >= curproc->sz)
801060e3:	39 18                	cmp    %ebx,(%eax)
801060e5:	76 31                	jbe    80106118 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
801060e7:	8b 55 0c             	mov    0xc(%ebp),%edx
801060ea:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801060ec:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801060ee:	39 d3                	cmp    %edx,%ebx
801060f0:	73 26                	jae    80106118 <fetchstr+0x48>
801060f2:	89 d8                	mov    %ebx,%eax
801060f4:	eb 11                	jmp    80106107 <fetchstr+0x37>
801060f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060fd:	8d 76 00             	lea    0x0(%esi),%esi
80106100:	83 c0 01             	add    $0x1,%eax
80106103:	39 c2                	cmp    %eax,%edx
80106105:	76 11                	jbe    80106118 <fetchstr+0x48>
    if(*s == 0)
80106107:	80 38 00             	cmpb   $0x0,(%eax)
8010610a:	75 f4                	jne    80106100 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
8010610c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010610f:	29 d8                	sub    %ebx,%eax
}
80106111:	5b                   	pop    %ebx
80106112:	5d                   	pop    %ebp
80106113:	c3                   	ret    
80106114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106118:	83 c4 04             	add    $0x4,%esp
    return -1;
8010611b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106120:	5b                   	pop    %ebx
80106121:	5d                   	pop    %ebp
80106122:	c3                   	ret    
80106123:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010612a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106130 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80106130:	f3 0f 1e fb          	endbr32 
80106134:	55                   	push   %ebp
80106135:	89 e5                	mov    %esp,%ebp
80106137:	56                   	push   %esi
80106138:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80106139:	e8 02 de ff ff       	call   80103f40 <myproc>
8010613e:	8b 55 08             	mov    0x8(%ebp),%edx
80106141:	8b 40 18             	mov    0x18(%eax),%eax
80106144:	8b 40 44             	mov    0x44(%eax),%eax
80106147:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
8010614a:	e8 f1 dd ff ff       	call   80103f40 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010614f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80106152:	8b 00                	mov    (%eax),%eax
80106154:	39 c6                	cmp    %eax,%esi
80106156:	73 18                	jae    80106170 <argint+0x40>
80106158:	8d 53 08             	lea    0x8(%ebx),%edx
8010615b:	39 d0                	cmp    %edx,%eax
8010615d:	72 11                	jb     80106170 <argint+0x40>
  *ip = *(int*)(addr);
8010615f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106162:	8b 53 04             	mov    0x4(%ebx),%edx
80106165:	89 10                	mov    %edx,(%eax)
  return 0;
80106167:	31 c0                	xor    %eax,%eax
}
80106169:	5b                   	pop    %ebx
8010616a:	5e                   	pop    %esi
8010616b:	5d                   	pop    %ebp
8010616c:	c3                   	ret    
8010616d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106170:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80106175:	eb f2                	jmp    80106169 <argint+0x39>
80106177:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010617e:	66 90                	xchg   %ax,%ax

80106180 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80106180:	f3 0f 1e fb          	endbr32 
80106184:	55                   	push   %ebp
80106185:	89 e5                	mov    %esp,%ebp
80106187:	56                   	push   %esi
80106188:	53                   	push   %ebx
80106189:	83 ec 10             	sub    $0x10,%esp
8010618c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010618f:	e8 ac dd ff ff       	call   80103f40 <myproc>
 
  if(argint(n, &i) < 0)
80106194:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80106197:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80106199:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010619c:	50                   	push   %eax
8010619d:	ff 75 08             	pushl  0x8(%ebp)
801061a0:	e8 8b ff ff ff       	call   80106130 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801061a5:	83 c4 10             	add    $0x10,%esp
801061a8:	85 c0                	test   %eax,%eax
801061aa:	78 24                	js     801061d0 <argptr+0x50>
801061ac:	85 db                	test   %ebx,%ebx
801061ae:	78 20                	js     801061d0 <argptr+0x50>
801061b0:	8b 16                	mov    (%esi),%edx
801061b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061b5:	39 c2                	cmp    %eax,%edx
801061b7:	76 17                	jbe    801061d0 <argptr+0x50>
801061b9:	01 c3                	add    %eax,%ebx
801061bb:	39 da                	cmp    %ebx,%edx
801061bd:	72 11                	jb     801061d0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801061bf:	8b 55 0c             	mov    0xc(%ebp),%edx
801061c2:	89 02                	mov    %eax,(%edx)
  return 0;
801061c4:	31 c0                	xor    %eax,%eax
}
801061c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801061c9:	5b                   	pop    %ebx
801061ca:	5e                   	pop    %esi
801061cb:	5d                   	pop    %ebp
801061cc:	c3                   	ret    
801061cd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801061d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061d5:	eb ef                	jmp    801061c6 <argptr+0x46>
801061d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061de:	66 90                	xchg   %ax,%ax

801061e0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801061e0:	f3 0f 1e fb          	endbr32 
801061e4:	55                   	push   %ebp
801061e5:	89 e5                	mov    %esp,%ebp
801061e7:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801061ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
801061ed:	50                   	push   %eax
801061ee:	ff 75 08             	pushl  0x8(%ebp)
801061f1:	e8 3a ff ff ff       	call   80106130 <argint>
801061f6:	83 c4 10             	add    $0x10,%esp
801061f9:	85 c0                	test   %eax,%eax
801061fb:	78 13                	js     80106210 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801061fd:	83 ec 08             	sub    $0x8,%esp
80106200:	ff 75 0c             	pushl  0xc(%ebp)
80106203:	ff 75 f4             	pushl  -0xc(%ebp)
80106206:	e8 c5 fe ff ff       	call   801060d0 <fetchstr>
8010620b:	83 c4 10             	add    $0x10,%esp
}
8010620e:	c9                   	leave  
8010620f:	c3                   	ret    
80106210:	c9                   	leave  
    return -1;
80106211:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106216:	c3                   	ret    
80106217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010621e:	66 90                	xchg   %ax,%ax

80106220 <syscall>:

};

void
syscall(void)
{
80106220:	f3 0f 1e fb          	endbr32 
80106224:	55                   	push   %ebp
80106225:	89 e5                	mov    %esp,%ebp
80106227:	53                   	push   %ebx
80106228:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010622b:	e8 10 dd ff ff       	call   80103f40 <myproc>
80106230:	89 c3                	mov    %eax,%ebx
  num = curproc->tf->eax;
80106232:	8b 40 18             	mov    0x18(%eax),%eax
80106235:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80106238:	8d 50 ff             	lea    -0x1(%eax),%edx
8010623b:	83 fa 22             	cmp    $0x22,%edx
8010623e:	77 20                	ja     80106260 <syscall+0x40>
80106240:	8b 14 85 60 a5 10 80 	mov    -0x7fef5aa0(,%eax,4),%edx
80106247:	85 d2                	test   %edx,%edx
80106249:	74 15                	je     80106260 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
8010624b:	ff d2                	call   *%edx
8010624d:	89 c2                	mov    %eax,%edx
8010624f:	8b 43 18             	mov    0x18(%ebx),%eax
80106252:	89 50 1c             	mov    %edx,0x1c(%eax)
80106255:	eb 28                	jmp    8010627f <syscall+0x5f>
80106257:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010625e:	66 90                	xchg   %ax,%ax
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80106260:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80106261:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80106264:	50                   	push   %eax
80106265:	ff 73 10             	pushl  0x10(%ebx)
80106268:	68 2b a5 10 80       	push   $0x8010a52b
8010626d:	e8 4e a6 ff ff       	call   801008c0 <cprintf>
    curproc->tf->eax = -1;
80106272:	8b 43 18             	mov    0x18(%ebx),%eax
80106275:	83 c4 10             	add    $0x10,%esp
80106278:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }

  pushcli();
8010627f:	e8 2c f9 ff ff       	call   80105bb0 <pushcli>
  mycpu()->syscalls_count++;
80106284:	e8 27 dc ff ff       	call   80103eb0 <mycpu>
80106289:	83 80 b0 00 00 00 01 	addl   $0x1,0xb0(%eax)
  popcli();
80106290:	e8 6b f9 ff ff       	call   80105c00 <popcli>
  count_shared_syscalls++;
80106295:	83 05 c0 d5 10 80 01 	addl   $0x1,0x8010d5c0
}
8010629c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010629f:	c9                   	leave  
801062a0:	c3                   	ret    
801062a1:	66 90                	xchg   %ax,%ax
801062a3:	66 90                	xchg   %ax,%ax
801062a5:	66 90                	xchg   %ax,%ax
801062a7:	66 90                	xchg   %ax,%ax
801062a9:	66 90                	xchg   %ax,%ax
801062ab:	66 90                	xchg   %ax,%ax
801062ad:	66 90                	xchg   %ax,%ax
801062af:	90                   	nop

801062b0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801062b0:	55                   	push   %ebp
801062b1:	89 e5                	mov    %esp,%ebp
801062b3:	57                   	push   %edi
801062b4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801062b5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
801062b8:	53                   	push   %ebx
801062b9:	83 ec 34             	sub    $0x34,%esp
801062bc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801062bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801062c2:	57                   	push   %edi
801062c3:	50                   	push   %eax
{
801062c4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801062c7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801062ca:	e8 f1 c2 ff ff       	call   801025c0 <nameiparent>
801062cf:	83 c4 10             	add    $0x10,%esp
801062d2:	85 c0                	test   %eax,%eax
801062d4:	0f 84 46 01 00 00    	je     80106420 <create+0x170>
    return 0;
  ilock(dp);
801062da:	83 ec 0c             	sub    $0xc,%esp
801062dd:	89 c3                	mov    %eax,%ebx
801062df:	50                   	push   %eax
801062e0:	e8 eb b9 ff ff       	call   80101cd0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801062e5:	83 c4 0c             	add    $0xc,%esp
801062e8:	6a 00                	push   $0x0
801062ea:	57                   	push   %edi
801062eb:	53                   	push   %ebx
801062ec:	e8 2f bf ff ff       	call   80102220 <dirlookup>
801062f1:	83 c4 10             	add    $0x10,%esp
801062f4:	89 c6                	mov    %eax,%esi
801062f6:	85 c0                	test   %eax,%eax
801062f8:	74 56                	je     80106350 <create+0xa0>
    iunlockput(dp);
801062fa:	83 ec 0c             	sub    $0xc,%esp
801062fd:	53                   	push   %ebx
801062fe:	e8 6d bc ff ff       	call   80101f70 <iunlockput>
    ilock(ip);
80106303:	89 34 24             	mov    %esi,(%esp)
80106306:	e8 c5 b9 ff ff       	call   80101cd0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010630b:	83 c4 10             	add    $0x10,%esp
8010630e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80106313:	75 1b                	jne    80106330 <create+0x80>
80106315:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010631a:	75 14                	jne    80106330 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010631c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010631f:	89 f0                	mov    %esi,%eax
80106321:	5b                   	pop    %ebx
80106322:	5e                   	pop    %esi
80106323:	5f                   	pop    %edi
80106324:	5d                   	pop    %ebp
80106325:	c3                   	ret    
80106326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010632d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80106330:	83 ec 0c             	sub    $0xc,%esp
80106333:	56                   	push   %esi
    return 0;
80106334:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80106336:	e8 35 bc ff ff       	call   80101f70 <iunlockput>
    return 0;
8010633b:	83 c4 10             	add    $0x10,%esp
}
8010633e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106341:	89 f0                	mov    %esi,%eax
80106343:	5b                   	pop    %ebx
80106344:	5e                   	pop    %esi
80106345:	5f                   	pop    %edi
80106346:	5d                   	pop    %ebp
80106347:	c3                   	ret    
80106348:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010634f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80106350:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80106354:	83 ec 08             	sub    $0x8,%esp
80106357:	50                   	push   %eax
80106358:	ff 33                	pushl  (%ebx)
8010635a:	e8 f1 b7 ff ff       	call   80101b50 <ialloc>
8010635f:	83 c4 10             	add    $0x10,%esp
80106362:	89 c6                	mov    %eax,%esi
80106364:	85 c0                	test   %eax,%eax
80106366:	0f 84 cd 00 00 00    	je     80106439 <create+0x189>
  ilock(ip);
8010636c:	83 ec 0c             	sub    $0xc,%esp
8010636f:	50                   	push   %eax
80106370:	e8 5b b9 ff ff       	call   80101cd0 <ilock>
  ip->major = major;
80106375:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80106379:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010637d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80106381:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80106385:	b8 01 00 00 00       	mov    $0x1,%eax
8010638a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010638e:	89 34 24             	mov    %esi,(%esp)
80106391:	e8 7a b8 ff ff       	call   80101c10 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80106396:	83 c4 10             	add    $0x10,%esp
80106399:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010639e:	74 30                	je     801063d0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
801063a0:	83 ec 04             	sub    $0x4,%esp
801063a3:	ff 76 04             	pushl  0x4(%esi)
801063a6:	57                   	push   %edi
801063a7:	53                   	push   %ebx
801063a8:	e8 33 c1 ff ff       	call   801024e0 <dirlink>
801063ad:	83 c4 10             	add    $0x10,%esp
801063b0:	85 c0                	test   %eax,%eax
801063b2:	78 78                	js     8010642c <create+0x17c>
  iunlockput(dp);
801063b4:	83 ec 0c             	sub    $0xc,%esp
801063b7:	53                   	push   %ebx
801063b8:	e8 b3 bb ff ff       	call   80101f70 <iunlockput>
  return ip;
801063bd:	83 c4 10             	add    $0x10,%esp
}
801063c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063c3:	89 f0                	mov    %esi,%eax
801063c5:	5b                   	pop    %ebx
801063c6:	5e                   	pop    %esi
801063c7:	5f                   	pop    %edi
801063c8:	5d                   	pop    %ebp
801063c9:	c3                   	ret    
801063ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801063d0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801063d3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801063d8:	53                   	push   %ebx
801063d9:	e8 32 b8 ff ff       	call   80101c10 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801063de:	83 c4 0c             	add    $0xc,%esp
801063e1:	ff 76 04             	pushl  0x4(%esi)
801063e4:	68 0c a6 10 80       	push   $0x8010a60c
801063e9:	56                   	push   %esi
801063ea:	e8 f1 c0 ff ff       	call   801024e0 <dirlink>
801063ef:	83 c4 10             	add    $0x10,%esp
801063f2:	85 c0                	test   %eax,%eax
801063f4:	78 18                	js     8010640e <create+0x15e>
801063f6:	83 ec 04             	sub    $0x4,%esp
801063f9:	ff 73 04             	pushl  0x4(%ebx)
801063fc:	68 0b a6 10 80       	push   $0x8010a60b
80106401:	56                   	push   %esi
80106402:	e8 d9 c0 ff ff       	call   801024e0 <dirlink>
80106407:	83 c4 10             	add    $0x10,%esp
8010640a:	85 c0                	test   %eax,%eax
8010640c:	79 92                	jns    801063a0 <create+0xf0>
      panic("create dots");
8010640e:	83 ec 0c             	sub    $0xc,%esp
80106411:	68 ff a5 10 80       	push   $0x8010a5ff
80106416:	e8 75 9f ff ff       	call   80100390 <panic>
8010641b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010641f:	90                   	nop
}
80106420:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106423:	31 f6                	xor    %esi,%esi
}
80106425:	5b                   	pop    %ebx
80106426:	89 f0                	mov    %esi,%eax
80106428:	5e                   	pop    %esi
80106429:	5f                   	pop    %edi
8010642a:	5d                   	pop    %ebp
8010642b:	c3                   	ret    
    panic("create: dirlink");
8010642c:	83 ec 0c             	sub    $0xc,%esp
8010642f:	68 0e a6 10 80       	push   $0x8010a60e
80106434:	e8 57 9f ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80106439:	83 ec 0c             	sub    $0xc,%esp
8010643c:	68 f0 a5 10 80       	push   $0x8010a5f0
80106441:	e8 4a 9f ff ff       	call   80100390 <panic>
80106446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010644d:	8d 76 00             	lea    0x0(%esi),%esi

80106450 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80106450:	55                   	push   %ebp
80106451:	89 e5                	mov    %esp,%ebp
80106453:	56                   	push   %esi
80106454:	89 d6                	mov    %edx,%esi
80106456:	53                   	push   %ebx
80106457:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80106459:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010645c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010645f:	50                   	push   %eax
80106460:	6a 00                	push   $0x0
80106462:	e8 c9 fc ff ff       	call   80106130 <argint>
80106467:	83 c4 10             	add    $0x10,%esp
8010646a:	85 c0                	test   %eax,%eax
8010646c:	78 2a                	js     80106498 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010646e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80106472:	77 24                	ja     80106498 <argfd.constprop.0+0x48>
80106474:	e8 c7 da ff ff       	call   80103f40 <myproc>
80106479:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010647c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80106480:	85 c0                	test   %eax,%eax
80106482:	74 14                	je     80106498 <argfd.constprop.0+0x48>
  if(pfd)
80106484:	85 db                	test   %ebx,%ebx
80106486:	74 02                	je     8010648a <argfd.constprop.0+0x3a>
    *pfd = fd;
80106488:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010648a:	89 06                	mov    %eax,(%esi)
  return 0;
8010648c:	31 c0                	xor    %eax,%eax
}
8010648e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106491:	5b                   	pop    %ebx
80106492:	5e                   	pop    %esi
80106493:	5d                   	pop    %ebp
80106494:	c3                   	ret    
80106495:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106498:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010649d:	eb ef                	jmp    8010648e <argfd.constprop.0+0x3e>
8010649f:	90                   	nop

801064a0 <sys_dup>:
{
801064a0:	f3 0f 1e fb          	endbr32 
801064a4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801064a5:	31 c0                	xor    %eax,%eax
{
801064a7:	89 e5                	mov    %esp,%ebp
801064a9:	56                   	push   %esi
801064aa:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801064ab:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801064ae:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801064b1:	e8 9a ff ff ff       	call   80106450 <argfd.constprop.0>
801064b6:	85 c0                	test   %eax,%eax
801064b8:	78 1e                	js     801064d8 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
801064ba:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801064bd:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801064bf:	e8 7c da ff ff       	call   80103f40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801064c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801064c8:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801064cc:	85 d2                	test   %edx,%edx
801064ce:	74 20                	je     801064f0 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
801064d0:	83 c3 01             	add    $0x1,%ebx
801064d3:	83 fb 10             	cmp    $0x10,%ebx
801064d6:	75 f0                	jne    801064c8 <sys_dup+0x28>
}
801064d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801064db:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801064e0:	89 d8                	mov    %ebx,%eax
801064e2:	5b                   	pop    %ebx
801064e3:	5e                   	pop    %esi
801064e4:	5d                   	pop    %ebp
801064e5:	c3                   	ret    
801064e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064ed:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
801064f0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801064f4:	83 ec 0c             	sub    $0xc,%esp
801064f7:	ff 75 f4             	pushl  -0xc(%ebp)
801064fa:	e8 e1 ae ff ff       	call   801013e0 <filedup>
  return fd;
801064ff:	83 c4 10             	add    $0x10,%esp
}
80106502:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106505:	89 d8                	mov    %ebx,%eax
80106507:	5b                   	pop    %ebx
80106508:	5e                   	pop    %esi
80106509:	5d                   	pop    %ebp
8010650a:	c3                   	ret    
8010650b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010650f:	90                   	nop

80106510 <sys_read>:
{
80106510:	f3 0f 1e fb          	endbr32 
80106514:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106515:	31 c0                	xor    %eax,%eax
{
80106517:	89 e5                	mov    %esp,%ebp
80106519:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010651c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010651f:	e8 2c ff ff ff       	call   80106450 <argfd.constprop.0>
80106524:	85 c0                	test   %eax,%eax
80106526:	78 48                	js     80106570 <sys_read+0x60>
80106528:	83 ec 08             	sub    $0x8,%esp
8010652b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010652e:	50                   	push   %eax
8010652f:	6a 02                	push   $0x2
80106531:	e8 fa fb ff ff       	call   80106130 <argint>
80106536:	83 c4 10             	add    $0x10,%esp
80106539:	85 c0                	test   %eax,%eax
8010653b:	78 33                	js     80106570 <sys_read+0x60>
8010653d:	83 ec 04             	sub    $0x4,%esp
80106540:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106543:	ff 75 f0             	pushl  -0x10(%ebp)
80106546:	50                   	push   %eax
80106547:	6a 01                	push   $0x1
80106549:	e8 32 fc ff ff       	call   80106180 <argptr>
8010654e:	83 c4 10             	add    $0x10,%esp
80106551:	85 c0                	test   %eax,%eax
80106553:	78 1b                	js     80106570 <sys_read+0x60>
  return fileread(f, p, n);
80106555:	83 ec 04             	sub    $0x4,%esp
80106558:	ff 75 f0             	pushl  -0x10(%ebp)
8010655b:	ff 75 f4             	pushl  -0xc(%ebp)
8010655e:	ff 75 ec             	pushl  -0x14(%ebp)
80106561:	e8 fa af ff ff       	call   80101560 <fileread>
80106566:	83 c4 10             	add    $0x10,%esp
}
80106569:	c9                   	leave  
8010656a:	c3                   	ret    
8010656b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010656f:	90                   	nop
80106570:	c9                   	leave  
    return -1;
80106571:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106576:	c3                   	ret    
80106577:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010657e:	66 90                	xchg   %ax,%ax

80106580 <sys_write>:
{
80106580:	f3 0f 1e fb          	endbr32 
80106584:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80106585:	31 c0                	xor    %eax,%eax
{
80106587:	89 e5                	mov    %esp,%ebp
80106589:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010658c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010658f:	e8 bc fe ff ff       	call   80106450 <argfd.constprop.0>
80106594:	85 c0                	test   %eax,%eax
80106596:	78 48                	js     801065e0 <sys_write+0x60>
80106598:	83 ec 08             	sub    $0x8,%esp
8010659b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010659e:	50                   	push   %eax
8010659f:	6a 02                	push   $0x2
801065a1:	e8 8a fb ff ff       	call   80106130 <argint>
801065a6:	83 c4 10             	add    $0x10,%esp
801065a9:	85 c0                	test   %eax,%eax
801065ab:	78 33                	js     801065e0 <sys_write+0x60>
801065ad:	83 ec 04             	sub    $0x4,%esp
801065b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801065b3:	ff 75 f0             	pushl  -0x10(%ebp)
801065b6:	50                   	push   %eax
801065b7:	6a 01                	push   $0x1
801065b9:	e8 c2 fb ff ff       	call   80106180 <argptr>
801065be:	83 c4 10             	add    $0x10,%esp
801065c1:	85 c0                	test   %eax,%eax
801065c3:	78 1b                	js     801065e0 <sys_write+0x60>
  return filewrite(f, p, n);
801065c5:	83 ec 04             	sub    $0x4,%esp
801065c8:	ff 75 f0             	pushl  -0x10(%ebp)
801065cb:	ff 75 f4             	pushl  -0xc(%ebp)
801065ce:	ff 75 ec             	pushl  -0x14(%ebp)
801065d1:	e8 2a b0 ff ff       	call   80101600 <filewrite>
801065d6:	83 c4 10             	add    $0x10,%esp
}
801065d9:	c9                   	leave  
801065da:	c3                   	ret    
801065db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801065df:	90                   	nop
801065e0:	c9                   	leave  
    return -1;
801065e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801065e6:	c3                   	ret    
801065e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065ee:	66 90                	xchg   %ax,%ax

801065f0 <sys_close>:
{
801065f0:	f3 0f 1e fb          	endbr32 
801065f4:	55                   	push   %ebp
801065f5:	89 e5                	mov    %esp,%ebp
801065f7:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801065fa:	8d 55 f4             	lea    -0xc(%ebp),%edx
801065fd:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106600:	e8 4b fe ff ff       	call   80106450 <argfd.constprop.0>
80106605:	85 c0                	test   %eax,%eax
80106607:	78 27                	js     80106630 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80106609:	e8 32 d9 ff ff       	call   80103f40 <myproc>
8010660e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80106611:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80106614:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010661b:	00 
  fileclose(f);
8010661c:	ff 75 f4             	pushl  -0xc(%ebp)
8010661f:	e8 0c ae ff ff       	call   80101430 <fileclose>
  return 0;
80106624:	83 c4 10             	add    $0x10,%esp
80106627:	31 c0                	xor    %eax,%eax
}
80106629:	c9                   	leave  
8010662a:	c3                   	ret    
8010662b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010662f:	90                   	nop
80106630:	c9                   	leave  
    return -1;
80106631:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106636:	c3                   	ret    
80106637:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010663e:	66 90                	xchg   %ax,%ax

80106640 <sys_fstat>:
{
80106640:	f3 0f 1e fb          	endbr32 
80106644:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106645:	31 c0                	xor    %eax,%eax
{
80106647:	89 e5                	mov    %esp,%ebp
80106649:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010664c:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010664f:	e8 fc fd ff ff       	call   80106450 <argfd.constprop.0>
80106654:	85 c0                	test   %eax,%eax
80106656:	78 30                	js     80106688 <sys_fstat+0x48>
80106658:	83 ec 04             	sub    $0x4,%esp
8010665b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010665e:	6a 14                	push   $0x14
80106660:	50                   	push   %eax
80106661:	6a 01                	push   $0x1
80106663:	e8 18 fb ff ff       	call   80106180 <argptr>
80106668:	83 c4 10             	add    $0x10,%esp
8010666b:	85 c0                	test   %eax,%eax
8010666d:	78 19                	js     80106688 <sys_fstat+0x48>
  return filestat(f, st);
8010666f:	83 ec 08             	sub    $0x8,%esp
80106672:	ff 75 f4             	pushl  -0xc(%ebp)
80106675:	ff 75 f0             	pushl  -0x10(%ebp)
80106678:	e8 93 ae ff ff       	call   80101510 <filestat>
8010667d:	83 c4 10             	add    $0x10,%esp
}
80106680:	c9                   	leave  
80106681:	c3                   	ret    
80106682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106688:	c9                   	leave  
    return -1;
80106689:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010668e:	c3                   	ret    
8010668f:	90                   	nop

80106690 <sys_link>:
{
80106690:	f3 0f 1e fb          	endbr32 
80106694:	55                   	push   %ebp
80106695:	89 e5                	mov    %esp,%ebp
80106697:	57                   	push   %edi
80106698:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106699:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010669c:	53                   	push   %ebx
8010669d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801066a0:	50                   	push   %eax
801066a1:	6a 00                	push   $0x0
801066a3:	e8 38 fb ff ff       	call   801061e0 <argstr>
801066a8:	83 c4 10             	add    $0x10,%esp
801066ab:	85 c0                	test   %eax,%eax
801066ad:	0f 88 ff 00 00 00    	js     801067b2 <sys_link+0x122>
801066b3:	83 ec 08             	sub    $0x8,%esp
801066b6:	8d 45 d0             	lea    -0x30(%ebp),%eax
801066b9:	50                   	push   %eax
801066ba:	6a 01                	push   $0x1
801066bc:	e8 1f fb ff ff       	call   801061e0 <argstr>
801066c1:	83 c4 10             	add    $0x10,%esp
801066c4:	85 c0                	test   %eax,%eax
801066c6:	0f 88 e6 00 00 00    	js     801067b2 <sys_link+0x122>
  begin_op();
801066cc:	e8 cf cb ff ff       	call   801032a0 <begin_op>
  if((ip = namei(old)) == 0){
801066d1:	83 ec 0c             	sub    $0xc,%esp
801066d4:	ff 75 d4             	pushl  -0x2c(%ebp)
801066d7:	e8 c4 be ff ff       	call   801025a0 <namei>
801066dc:	83 c4 10             	add    $0x10,%esp
801066df:	89 c3                	mov    %eax,%ebx
801066e1:	85 c0                	test   %eax,%eax
801066e3:	0f 84 e8 00 00 00    	je     801067d1 <sys_link+0x141>
  ilock(ip);
801066e9:	83 ec 0c             	sub    $0xc,%esp
801066ec:	50                   	push   %eax
801066ed:	e8 de b5 ff ff       	call   80101cd0 <ilock>
  if(ip->type == T_DIR){
801066f2:	83 c4 10             	add    $0x10,%esp
801066f5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801066fa:	0f 84 b9 00 00 00    	je     801067b9 <sys_link+0x129>
  iupdate(ip);
80106700:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80106703:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80106708:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010670b:	53                   	push   %ebx
8010670c:	e8 ff b4 ff ff       	call   80101c10 <iupdate>
  iunlock(ip);
80106711:	89 1c 24             	mov    %ebx,(%esp)
80106714:	e8 97 b6 ff ff       	call   80101db0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80106719:	58                   	pop    %eax
8010671a:	5a                   	pop    %edx
8010671b:	57                   	push   %edi
8010671c:	ff 75 d0             	pushl  -0x30(%ebp)
8010671f:	e8 9c be ff ff       	call   801025c0 <nameiparent>
80106724:	83 c4 10             	add    $0x10,%esp
80106727:	89 c6                	mov    %eax,%esi
80106729:	85 c0                	test   %eax,%eax
8010672b:	74 5f                	je     8010678c <sys_link+0xfc>
  ilock(dp);
8010672d:	83 ec 0c             	sub    $0xc,%esp
80106730:	50                   	push   %eax
80106731:	e8 9a b5 ff ff       	call   80101cd0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80106736:	8b 03                	mov    (%ebx),%eax
80106738:	83 c4 10             	add    $0x10,%esp
8010673b:	39 06                	cmp    %eax,(%esi)
8010673d:	75 41                	jne    80106780 <sys_link+0xf0>
8010673f:	83 ec 04             	sub    $0x4,%esp
80106742:	ff 73 04             	pushl  0x4(%ebx)
80106745:	57                   	push   %edi
80106746:	56                   	push   %esi
80106747:	e8 94 bd ff ff       	call   801024e0 <dirlink>
8010674c:	83 c4 10             	add    $0x10,%esp
8010674f:	85 c0                	test   %eax,%eax
80106751:	78 2d                	js     80106780 <sys_link+0xf0>
  iunlockput(dp);
80106753:	83 ec 0c             	sub    $0xc,%esp
80106756:	56                   	push   %esi
80106757:	e8 14 b8 ff ff       	call   80101f70 <iunlockput>
  iput(ip);
8010675c:	89 1c 24             	mov    %ebx,(%esp)
8010675f:	e8 9c b6 ff ff       	call   80101e00 <iput>
  end_op();
80106764:	e8 a7 cb ff ff       	call   80103310 <end_op>
  return 0;
80106769:	83 c4 10             	add    $0x10,%esp
8010676c:	31 c0                	xor    %eax,%eax
}
8010676e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106771:	5b                   	pop    %ebx
80106772:	5e                   	pop    %esi
80106773:	5f                   	pop    %edi
80106774:	5d                   	pop    %ebp
80106775:	c3                   	ret    
80106776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010677d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80106780:	83 ec 0c             	sub    $0xc,%esp
80106783:	56                   	push   %esi
80106784:	e8 e7 b7 ff ff       	call   80101f70 <iunlockput>
    goto bad;
80106789:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010678c:	83 ec 0c             	sub    $0xc,%esp
8010678f:	53                   	push   %ebx
80106790:	e8 3b b5 ff ff       	call   80101cd0 <ilock>
  ip->nlink--;
80106795:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010679a:	89 1c 24             	mov    %ebx,(%esp)
8010679d:	e8 6e b4 ff ff       	call   80101c10 <iupdate>
  iunlockput(ip);
801067a2:	89 1c 24             	mov    %ebx,(%esp)
801067a5:	e8 c6 b7 ff ff       	call   80101f70 <iunlockput>
  end_op();
801067aa:	e8 61 cb ff ff       	call   80103310 <end_op>
  return -1;
801067af:	83 c4 10             	add    $0x10,%esp
801067b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067b7:	eb b5                	jmp    8010676e <sys_link+0xde>
    iunlockput(ip);
801067b9:	83 ec 0c             	sub    $0xc,%esp
801067bc:	53                   	push   %ebx
801067bd:	e8 ae b7 ff ff       	call   80101f70 <iunlockput>
    end_op();
801067c2:	e8 49 cb ff ff       	call   80103310 <end_op>
    return -1;
801067c7:	83 c4 10             	add    $0x10,%esp
801067ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067cf:	eb 9d                	jmp    8010676e <sys_link+0xde>
    end_op();
801067d1:	e8 3a cb ff ff       	call   80103310 <end_op>
    return -1;
801067d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067db:	eb 91                	jmp    8010676e <sys_link+0xde>
801067dd:	8d 76 00             	lea    0x0(%esi),%esi

801067e0 <sys_unlink>:
{
801067e0:	f3 0f 1e fb          	endbr32 
801067e4:	55                   	push   %ebp
801067e5:	89 e5                	mov    %esp,%ebp
801067e7:	57                   	push   %edi
801067e8:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801067e9:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801067ec:	53                   	push   %ebx
801067ed:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801067f0:	50                   	push   %eax
801067f1:	6a 00                	push   $0x0
801067f3:	e8 e8 f9 ff ff       	call   801061e0 <argstr>
801067f8:	83 c4 10             	add    $0x10,%esp
801067fb:	85 c0                	test   %eax,%eax
801067fd:	0f 88 7d 01 00 00    	js     80106980 <sys_unlink+0x1a0>
  begin_op();
80106803:	e8 98 ca ff ff       	call   801032a0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80106808:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010680b:	83 ec 08             	sub    $0x8,%esp
8010680e:	53                   	push   %ebx
8010680f:	ff 75 c0             	pushl  -0x40(%ebp)
80106812:	e8 a9 bd ff ff       	call   801025c0 <nameiparent>
80106817:	83 c4 10             	add    $0x10,%esp
8010681a:	89 c6                	mov    %eax,%esi
8010681c:	85 c0                	test   %eax,%eax
8010681e:	0f 84 66 01 00 00    	je     8010698a <sys_unlink+0x1aa>
  ilock(dp);
80106824:	83 ec 0c             	sub    $0xc,%esp
80106827:	50                   	push   %eax
80106828:	e8 a3 b4 ff ff       	call   80101cd0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010682d:	58                   	pop    %eax
8010682e:	5a                   	pop    %edx
8010682f:	68 0c a6 10 80       	push   $0x8010a60c
80106834:	53                   	push   %ebx
80106835:	e8 c6 b9 ff ff       	call   80102200 <namecmp>
8010683a:	83 c4 10             	add    $0x10,%esp
8010683d:	85 c0                	test   %eax,%eax
8010683f:	0f 84 03 01 00 00    	je     80106948 <sys_unlink+0x168>
80106845:	83 ec 08             	sub    $0x8,%esp
80106848:	68 0b a6 10 80       	push   $0x8010a60b
8010684d:	53                   	push   %ebx
8010684e:	e8 ad b9 ff ff       	call   80102200 <namecmp>
80106853:	83 c4 10             	add    $0x10,%esp
80106856:	85 c0                	test   %eax,%eax
80106858:	0f 84 ea 00 00 00    	je     80106948 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010685e:	83 ec 04             	sub    $0x4,%esp
80106861:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80106864:	50                   	push   %eax
80106865:	53                   	push   %ebx
80106866:	56                   	push   %esi
80106867:	e8 b4 b9 ff ff       	call   80102220 <dirlookup>
8010686c:	83 c4 10             	add    $0x10,%esp
8010686f:	89 c3                	mov    %eax,%ebx
80106871:	85 c0                	test   %eax,%eax
80106873:	0f 84 cf 00 00 00    	je     80106948 <sys_unlink+0x168>
  ilock(ip);
80106879:	83 ec 0c             	sub    $0xc,%esp
8010687c:	50                   	push   %eax
8010687d:	e8 4e b4 ff ff       	call   80101cd0 <ilock>
  if(ip->nlink < 1)
80106882:	83 c4 10             	add    $0x10,%esp
80106885:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010688a:	0f 8e 23 01 00 00    	jle    801069b3 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106890:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106895:	8d 7d d8             	lea    -0x28(%ebp),%edi
80106898:	74 66                	je     80106900 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010689a:	83 ec 04             	sub    $0x4,%esp
8010689d:	6a 10                	push   $0x10
8010689f:	6a 00                	push   $0x0
801068a1:	57                   	push   %edi
801068a2:	e8 19 f5 ff ff       	call   80105dc0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801068a7:	6a 10                	push   $0x10
801068a9:	ff 75 c4             	pushl  -0x3c(%ebp)
801068ac:	57                   	push   %edi
801068ad:	56                   	push   %esi
801068ae:	e8 1d b8 ff ff       	call   801020d0 <writei>
801068b3:	83 c4 20             	add    $0x20,%esp
801068b6:	83 f8 10             	cmp    $0x10,%eax
801068b9:	0f 85 e7 00 00 00    	jne    801069a6 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
801068bf:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801068c4:	0f 84 96 00 00 00    	je     80106960 <sys_unlink+0x180>
  iunlockput(dp);
801068ca:	83 ec 0c             	sub    $0xc,%esp
801068cd:	56                   	push   %esi
801068ce:	e8 9d b6 ff ff       	call   80101f70 <iunlockput>
  ip->nlink--;
801068d3:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801068d8:	89 1c 24             	mov    %ebx,(%esp)
801068db:	e8 30 b3 ff ff       	call   80101c10 <iupdate>
  iunlockput(ip);
801068e0:	89 1c 24             	mov    %ebx,(%esp)
801068e3:	e8 88 b6 ff ff       	call   80101f70 <iunlockput>
  end_op();
801068e8:	e8 23 ca ff ff       	call   80103310 <end_op>
  return 0;
801068ed:	83 c4 10             	add    $0x10,%esp
801068f0:	31 c0                	xor    %eax,%eax
}
801068f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068f5:	5b                   	pop    %ebx
801068f6:	5e                   	pop    %esi
801068f7:	5f                   	pop    %edi
801068f8:	5d                   	pop    %ebp
801068f9:	c3                   	ret    
801068fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106900:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80106904:	76 94                	jbe    8010689a <sys_unlink+0xba>
80106906:	ba 20 00 00 00       	mov    $0x20,%edx
8010690b:	eb 0b                	jmp    80106918 <sys_unlink+0x138>
8010690d:	8d 76 00             	lea    0x0(%esi),%esi
80106910:	83 c2 10             	add    $0x10,%edx
80106913:	39 53 58             	cmp    %edx,0x58(%ebx)
80106916:	76 82                	jbe    8010689a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106918:	6a 10                	push   $0x10
8010691a:	52                   	push   %edx
8010691b:	57                   	push   %edi
8010691c:	53                   	push   %ebx
8010691d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80106920:	e8 ab b6 ff ff       	call   80101fd0 <readi>
80106925:	83 c4 10             	add    $0x10,%esp
80106928:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010692b:	83 f8 10             	cmp    $0x10,%eax
8010692e:	75 69                	jne    80106999 <sys_unlink+0x1b9>
    if(de.inum != 0)
80106930:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80106935:	74 d9                	je     80106910 <sys_unlink+0x130>
    iunlockput(ip);
80106937:	83 ec 0c             	sub    $0xc,%esp
8010693a:	53                   	push   %ebx
8010693b:	e8 30 b6 ff ff       	call   80101f70 <iunlockput>
    goto bad;
80106940:	83 c4 10             	add    $0x10,%esp
80106943:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106947:	90                   	nop
  iunlockput(dp);
80106948:	83 ec 0c             	sub    $0xc,%esp
8010694b:	56                   	push   %esi
8010694c:	e8 1f b6 ff ff       	call   80101f70 <iunlockput>
  end_op();
80106951:	e8 ba c9 ff ff       	call   80103310 <end_op>
  return -1;
80106956:	83 c4 10             	add    $0x10,%esp
80106959:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010695e:	eb 92                	jmp    801068f2 <sys_unlink+0x112>
    iupdate(dp);
80106960:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80106963:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80106968:	56                   	push   %esi
80106969:	e8 a2 b2 ff ff       	call   80101c10 <iupdate>
8010696e:	83 c4 10             	add    $0x10,%esp
80106971:	e9 54 ff ff ff       	jmp    801068ca <sys_unlink+0xea>
80106976:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010697d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106980:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106985:	e9 68 ff ff ff       	jmp    801068f2 <sys_unlink+0x112>
    end_op();
8010698a:	e8 81 c9 ff ff       	call   80103310 <end_op>
    return -1;
8010698f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106994:	e9 59 ff ff ff       	jmp    801068f2 <sys_unlink+0x112>
      panic("isdirempty: readi");
80106999:	83 ec 0c             	sub    $0xc,%esp
8010699c:	68 30 a6 10 80       	push   $0x8010a630
801069a1:	e8 ea 99 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801069a6:	83 ec 0c             	sub    $0xc,%esp
801069a9:	68 42 a6 10 80       	push   $0x8010a642
801069ae:	e8 dd 99 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801069b3:	83 ec 0c             	sub    $0xc,%esp
801069b6:	68 1e a6 10 80       	push   $0x8010a61e
801069bb:	e8 d0 99 ff ff       	call   80100390 <panic>

801069c0 <sys_open>:

int
sys_open(void)
{
801069c0:	f3 0f 1e fb          	endbr32 
801069c4:	55                   	push   %ebp
801069c5:	89 e5                	mov    %esp,%ebp
801069c7:	57                   	push   %edi
801069c8:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801069c9:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801069cc:	53                   	push   %ebx
801069cd:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801069d0:	50                   	push   %eax
801069d1:	6a 00                	push   $0x0
801069d3:	e8 08 f8 ff ff       	call   801061e0 <argstr>
801069d8:	83 c4 10             	add    $0x10,%esp
801069db:	85 c0                	test   %eax,%eax
801069dd:	0f 88 8a 00 00 00    	js     80106a6d <sys_open+0xad>
801069e3:	83 ec 08             	sub    $0x8,%esp
801069e6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801069e9:	50                   	push   %eax
801069ea:	6a 01                	push   $0x1
801069ec:	e8 3f f7 ff ff       	call   80106130 <argint>
801069f1:	83 c4 10             	add    $0x10,%esp
801069f4:	85 c0                	test   %eax,%eax
801069f6:	78 75                	js     80106a6d <sys_open+0xad>
    return -1;

  begin_op();
801069f8:	e8 a3 c8 ff ff       	call   801032a0 <begin_op>

  if(omode & O_CREATE){
801069fd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80106a01:	75 75                	jne    80106a78 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80106a03:	83 ec 0c             	sub    $0xc,%esp
80106a06:	ff 75 e0             	pushl  -0x20(%ebp)
80106a09:	e8 92 bb ff ff       	call   801025a0 <namei>
80106a0e:	83 c4 10             	add    $0x10,%esp
80106a11:	89 c6                	mov    %eax,%esi
80106a13:	85 c0                	test   %eax,%eax
80106a15:	74 7e                	je     80106a95 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80106a17:	83 ec 0c             	sub    $0xc,%esp
80106a1a:	50                   	push   %eax
80106a1b:	e8 b0 b2 ff ff       	call   80101cd0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106a20:	83 c4 10             	add    $0x10,%esp
80106a23:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80106a28:	0f 84 c2 00 00 00    	je     80106af0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80106a2e:	e8 3d a9 ff ff       	call   80101370 <filealloc>
80106a33:	89 c7                	mov    %eax,%edi
80106a35:	85 c0                	test   %eax,%eax
80106a37:	74 23                	je     80106a5c <sys_open+0x9c>
  struct proc *curproc = myproc();
80106a39:	e8 02 d5 ff ff       	call   80103f40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106a3e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80106a40:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80106a44:	85 d2                	test   %edx,%edx
80106a46:	74 60                	je     80106aa8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80106a48:	83 c3 01             	add    $0x1,%ebx
80106a4b:	83 fb 10             	cmp    $0x10,%ebx
80106a4e:	75 f0                	jne    80106a40 <sys_open+0x80>
    if(f)
      fileclose(f);
80106a50:	83 ec 0c             	sub    $0xc,%esp
80106a53:	57                   	push   %edi
80106a54:	e8 d7 a9 ff ff       	call   80101430 <fileclose>
80106a59:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80106a5c:	83 ec 0c             	sub    $0xc,%esp
80106a5f:	56                   	push   %esi
80106a60:	e8 0b b5 ff ff       	call   80101f70 <iunlockput>
    end_op();
80106a65:	e8 a6 c8 ff ff       	call   80103310 <end_op>
    return -1;
80106a6a:	83 c4 10             	add    $0x10,%esp
80106a6d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106a72:	eb 6d                	jmp    80106ae1 <sys_open+0x121>
80106a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80106a78:	83 ec 0c             	sub    $0xc,%esp
80106a7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a7e:	31 c9                	xor    %ecx,%ecx
80106a80:	ba 02 00 00 00       	mov    $0x2,%edx
80106a85:	6a 00                	push   $0x0
80106a87:	e8 24 f8 ff ff       	call   801062b0 <create>
    if(ip == 0){
80106a8c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80106a8f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80106a91:	85 c0                	test   %eax,%eax
80106a93:	75 99                	jne    80106a2e <sys_open+0x6e>
      end_op();
80106a95:	e8 76 c8 ff ff       	call   80103310 <end_op>
      return -1;
80106a9a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106a9f:	eb 40                	jmp    80106ae1 <sys_open+0x121>
80106aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80106aa8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80106aab:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80106aaf:	56                   	push   %esi
80106ab0:	e8 fb b2 ff ff       	call   80101db0 <iunlock>
  end_op();
80106ab5:	e8 56 c8 ff ff       	call   80103310 <end_op>

  f->type = FD_INODE;
80106aba:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80106ac0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106ac3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80106ac6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80106ac9:	89 d0                	mov    %edx,%eax
  f->off = 0;
80106acb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80106ad2:	f7 d0                	not    %eax
80106ad4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106ad7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80106ada:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106add:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80106ae1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ae4:	89 d8                	mov    %ebx,%eax
80106ae6:	5b                   	pop    %ebx
80106ae7:	5e                   	pop    %esi
80106ae8:	5f                   	pop    %edi
80106ae9:	5d                   	pop    %ebp
80106aea:	c3                   	ret    
80106aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106aef:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80106af0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106af3:	85 c9                	test   %ecx,%ecx
80106af5:	0f 84 33 ff ff ff    	je     80106a2e <sys_open+0x6e>
80106afb:	e9 5c ff ff ff       	jmp    80106a5c <sys_open+0x9c>

80106b00 <sys_mkdir>:

int
sys_mkdir(void)
{
80106b00:	f3 0f 1e fb          	endbr32 
80106b04:	55                   	push   %ebp
80106b05:	89 e5                	mov    %esp,%ebp
80106b07:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106b0a:	e8 91 c7 ff ff       	call   801032a0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106b0f:	83 ec 08             	sub    $0x8,%esp
80106b12:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b15:	50                   	push   %eax
80106b16:	6a 00                	push   $0x0
80106b18:	e8 c3 f6 ff ff       	call   801061e0 <argstr>
80106b1d:	83 c4 10             	add    $0x10,%esp
80106b20:	85 c0                	test   %eax,%eax
80106b22:	78 34                	js     80106b58 <sys_mkdir+0x58>
80106b24:	83 ec 0c             	sub    $0xc,%esp
80106b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b2a:	31 c9                	xor    %ecx,%ecx
80106b2c:	ba 01 00 00 00       	mov    $0x1,%edx
80106b31:	6a 00                	push   $0x0
80106b33:	e8 78 f7 ff ff       	call   801062b0 <create>
80106b38:	83 c4 10             	add    $0x10,%esp
80106b3b:	85 c0                	test   %eax,%eax
80106b3d:	74 19                	je     80106b58 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
80106b3f:	83 ec 0c             	sub    $0xc,%esp
80106b42:	50                   	push   %eax
80106b43:	e8 28 b4 ff ff       	call   80101f70 <iunlockput>
  end_op();
80106b48:	e8 c3 c7 ff ff       	call   80103310 <end_op>
  return 0;
80106b4d:	83 c4 10             	add    $0x10,%esp
80106b50:	31 c0                	xor    %eax,%eax
}
80106b52:	c9                   	leave  
80106b53:	c3                   	ret    
80106b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80106b58:	e8 b3 c7 ff ff       	call   80103310 <end_op>
    return -1;
80106b5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b62:	c9                   	leave  
80106b63:	c3                   	ret    
80106b64:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106b6f:	90                   	nop

80106b70 <sys_mknod>:

int
sys_mknod(void)
{
80106b70:	f3 0f 1e fb          	endbr32 
80106b74:	55                   	push   %ebp
80106b75:	89 e5                	mov    %esp,%ebp
80106b77:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106b7a:	e8 21 c7 ff ff       	call   801032a0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80106b7f:	83 ec 08             	sub    $0x8,%esp
80106b82:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106b85:	50                   	push   %eax
80106b86:	6a 00                	push   $0x0
80106b88:	e8 53 f6 ff ff       	call   801061e0 <argstr>
80106b8d:	83 c4 10             	add    $0x10,%esp
80106b90:	85 c0                	test   %eax,%eax
80106b92:	78 64                	js     80106bf8 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80106b94:	83 ec 08             	sub    $0x8,%esp
80106b97:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b9a:	50                   	push   %eax
80106b9b:	6a 01                	push   $0x1
80106b9d:	e8 8e f5 ff ff       	call   80106130 <argint>
  if((argstr(0, &path)) < 0 ||
80106ba2:	83 c4 10             	add    $0x10,%esp
80106ba5:	85 c0                	test   %eax,%eax
80106ba7:	78 4f                	js     80106bf8 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80106ba9:	83 ec 08             	sub    $0x8,%esp
80106bac:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106baf:	50                   	push   %eax
80106bb0:	6a 02                	push   $0x2
80106bb2:	e8 79 f5 ff ff       	call   80106130 <argint>
     argint(1, &major) < 0 ||
80106bb7:	83 c4 10             	add    $0x10,%esp
80106bba:	85 c0                	test   %eax,%eax
80106bbc:	78 3a                	js     80106bf8 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
80106bbe:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80106bc2:	83 ec 0c             	sub    $0xc,%esp
80106bc5:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80106bc9:	ba 03 00 00 00       	mov    $0x3,%edx
80106bce:	50                   	push   %eax
80106bcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106bd2:	e8 d9 f6 ff ff       	call   801062b0 <create>
     argint(2, &minor) < 0 ||
80106bd7:	83 c4 10             	add    $0x10,%esp
80106bda:	85 c0                	test   %eax,%eax
80106bdc:	74 1a                	je     80106bf8 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
80106bde:	83 ec 0c             	sub    $0xc,%esp
80106be1:	50                   	push   %eax
80106be2:	e8 89 b3 ff ff       	call   80101f70 <iunlockput>
  end_op();
80106be7:	e8 24 c7 ff ff       	call   80103310 <end_op>
  return 0;
80106bec:	83 c4 10             	add    $0x10,%esp
80106bef:	31 c0                	xor    %eax,%eax
}
80106bf1:	c9                   	leave  
80106bf2:	c3                   	ret    
80106bf3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106bf7:	90                   	nop
    end_op();
80106bf8:	e8 13 c7 ff ff       	call   80103310 <end_op>
    return -1;
80106bfd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c02:	c9                   	leave  
80106c03:	c3                   	ret    
80106c04:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c0f:	90                   	nop

80106c10 <sys_chdir>:

int
sys_chdir(void)
{
80106c10:	f3 0f 1e fb          	endbr32 
80106c14:	55                   	push   %ebp
80106c15:	89 e5                	mov    %esp,%ebp
80106c17:	56                   	push   %esi
80106c18:	53                   	push   %ebx
80106c19:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80106c1c:	e8 1f d3 ff ff       	call   80103f40 <myproc>
80106c21:	89 c6                	mov    %eax,%esi
  
  begin_op();
80106c23:	e8 78 c6 ff ff       	call   801032a0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106c28:	83 ec 08             	sub    $0x8,%esp
80106c2b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c2e:	50                   	push   %eax
80106c2f:	6a 00                	push   $0x0
80106c31:	e8 aa f5 ff ff       	call   801061e0 <argstr>
80106c36:	83 c4 10             	add    $0x10,%esp
80106c39:	85 c0                	test   %eax,%eax
80106c3b:	78 73                	js     80106cb0 <sys_chdir+0xa0>
80106c3d:	83 ec 0c             	sub    $0xc,%esp
80106c40:	ff 75 f4             	pushl  -0xc(%ebp)
80106c43:	e8 58 b9 ff ff       	call   801025a0 <namei>
80106c48:	83 c4 10             	add    $0x10,%esp
80106c4b:	89 c3                	mov    %eax,%ebx
80106c4d:	85 c0                	test   %eax,%eax
80106c4f:	74 5f                	je     80106cb0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80106c51:	83 ec 0c             	sub    $0xc,%esp
80106c54:	50                   	push   %eax
80106c55:	e8 76 b0 ff ff       	call   80101cd0 <ilock>
  if(ip->type != T_DIR){
80106c5a:	83 c4 10             	add    $0x10,%esp
80106c5d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106c62:	75 2c                	jne    80106c90 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106c64:	83 ec 0c             	sub    $0xc,%esp
80106c67:	53                   	push   %ebx
80106c68:	e8 43 b1 ff ff       	call   80101db0 <iunlock>
  iput(curproc->cwd);
80106c6d:	58                   	pop    %eax
80106c6e:	ff 76 68             	pushl  0x68(%esi)
80106c71:	e8 8a b1 ff ff       	call   80101e00 <iput>
  end_op();
80106c76:	e8 95 c6 ff ff       	call   80103310 <end_op>
  curproc->cwd = ip;
80106c7b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80106c7e:	83 c4 10             	add    $0x10,%esp
80106c81:	31 c0                	xor    %eax,%eax
}
80106c83:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106c86:	5b                   	pop    %ebx
80106c87:	5e                   	pop    %esi
80106c88:	5d                   	pop    %ebp
80106c89:	c3                   	ret    
80106c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80106c90:	83 ec 0c             	sub    $0xc,%esp
80106c93:	53                   	push   %ebx
80106c94:	e8 d7 b2 ff ff       	call   80101f70 <iunlockput>
    end_op();
80106c99:	e8 72 c6 ff ff       	call   80103310 <end_op>
    return -1;
80106c9e:	83 c4 10             	add    $0x10,%esp
80106ca1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ca6:	eb db                	jmp    80106c83 <sys_chdir+0x73>
80106ca8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106caf:	90                   	nop
    end_op();
80106cb0:	e8 5b c6 ff ff       	call   80103310 <end_op>
    return -1;
80106cb5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cba:	eb c7                	jmp    80106c83 <sys_chdir+0x73>
80106cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106cc0 <sys_exec>:

int
sys_exec(void)
{
80106cc0:	f3 0f 1e fb          	endbr32 
80106cc4:	55                   	push   %ebp
80106cc5:	89 e5                	mov    %esp,%ebp
80106cc7:	57                   	push   %edi
80106cc8:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106cc9:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80106ccf:	53                   	push   %ebx
80106cd0:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106cd6:	50                   	push   %eax
80106cd7:	6a 00                	push   $0x0
80106cd9:	e8 02 f5 ff ff       	call   801061e0 <argstr>
80106cde:	83 c4 10             	add    $0x10,%esp
80106ce1:	85 c0                	test   %eax,%eax
80106ce3:	0f 88 8b 00 00 00    	js     80106d74 <sys_exec+0xb4>
80106ce9:	83 ec 08             	sub    $0x8,%esp
80106cec:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80106cf2:	50                   	push   %eax
80106cf3:	6a 01                	push   $0x1
80106cf5:	e8 36 f4 ff ff       	call   80106130 <argint>
80106cfa:	83 c4 10             	add    $0x10,%esp
80106cfd:	85 c0                	test   %eax,%eax
80106cff:	78 73                	js     80106d74 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80106d01:	83 ec 04             	sub    $0x4,%esp
80106d04:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80106d0a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80106d0c:	68 80 00 00 00       	push   $0x80
80106d11:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80106d17:	6a 00                	push   $0x0
80106d19:	50                   	push   %eax
80106d1a:	e8 a1 f0 ff ff       	call   80105dc0 <memset>
80106d1f:	83 c4 10             	add    $0x10,%esp
80106d22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106d28:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106d2e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80106d35:	83 ec 08             	sub    $0x8,%esp
80106d38:	57                   	push   %edi
80106d39:	01 f0                	add    %esi,%eax
80106d3b:	50                   	push   %eax
80106d3c:	e8 4f f3 ff ff       	call   80106090 <fetchint>
80106d41:	83 c4 10             	add    $0x10,%esp
80106d44:	85 c0                	test   %eax,%eax
80106d46:	78 2c                	js     80106d74 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80106d48:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80106d4e:	85 c0                	test   %eax,%eax
80106d50:	74 36                	je     80106d88 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106d52:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80106d58:	83 ec 08             	sub    $0x8,%esp
80106d5b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80106d5e:	52                   	push   %edx
80106d5f:	50                   	push   %eax
80106d60:	e8 6b f3 ff ff       	call   801060d0 <fetchstr>
80106d65:	83 c4 10             	add    $0x10,%esp
80106d68:	85 c0                	test   %eax,%eax
80106d6a:	78 08                	js     80106d74 <sys_exec+0xb4>
  for(i=0;; i++){
80106d6c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80106d6f:	83 fb 20             	cmp    $0x20,%ebx
80106d72:	75 b4                	jne    80106d28 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80106d74:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80106d77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d7c:	5b                   	pop    %ebx
80106d7d:	5e                   	pop    %esi
80106d7e:	5f                   	pop    %edi
80106d7f:	5d                   	pop    %ebp
80106d80:	c3                   	ret    
80106d81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106d88:	83 ec 08             	sub    $0x8,%esp
80106d8b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80106d91:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106d98:	00 00 00 00 
  return exec(path, argv);
80106d9c:	50                   	push   %eax
80106d9d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80106da3:	e8 c8 a1 ff ff       	call   80100f70 <exec>
80106da8:	83 c4 10             	add    $0x10,%esp
}
80106dab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106dae:	5b                   	pop    %ebx
80106daf:	5e                   	pop    %esi
80106db0:	5f                   	pop    %edi
80106db1:	5d                   	pop    %ebp
80106db2:	c3                   	ret    
80106db3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106dc0 <sys_pipe>:

int
sys_pipe(void)
{
80106dc0:	f3 0f 1e fb          	endbr32 
80106dc4:	55                   	push   %ebp
80106dc5:	89 e5                	mov    %esp,%ebp
80106dc7:	57                   	push   %edi
80106dc8:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106dc9:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106dcc:	53                   	push   %ebx
80106dcd:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106dd0:	6a 08                	push   $0x8
80106dd2:	50                   	push   %eax
80106dd3:	6a 00                	push   $0x0
80106dd5:	e8 a6 f3 ff ff       	call   80106180 <argptr>
80106dda:	83 c4 10             	add    $0x10,%esp
80106ddd:	85 c0                	test   %eax,%eax
80106ddf:	78 4e                	js     80106e2f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106de1:	83 ec 08             	sub    $0x8,%esp
80106de4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106de7:	50                   	push   %eax
80106de8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106deb:	50                   	push   %eax
80106dec:	e8 7f cb ff ff       	call   80103970 <pipealloc>
80106df1:	83 c4 10             	add    $0x10,%esp
80106df4:	85 c0                	test   %eax,%eax
80106df6:	78 37                	js     80106e2f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106df8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80106dfb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80106dfd:	e8 3e d1 ff ff       	call   80103f40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80106e08:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80106e0c:	85 f6                	test   %esi,%esi
80106e0e:	74 30                	je     80106e40 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80106e10:	83 c3 01             	add    $0x1,%ebx
80106e13:	83 fb 10             	cmp    $0x10,%ebx
80106e16:	75 f0                	jne    80106e08 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80106e18:	83 ec 0c             	sub    $0xc,%esp
80106e1b:	ff 75 e0             	pushl  -0x20(%ebp)
80106e1e:	e8 0d a6 ff ff       	call   80101430 <fileclose>
    fileclose(wf);
80106e23:	58                   	pop    %eax
80106e24:	ff 75 e4             	pushl  -0x1c(%ebp)
80106e27:	e8 04 a6 ff ff       	call   80101430 <fileclose>
    return -1;
80106e2c:	83 c4 10             	add    $0x10,%esp
80106e2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e34:	eb 5b                	jmp    80106e91 <sys_pipe+0xd1>
80106e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e3d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80106e40:	8d 73 08             	lea    0x8(%ebx),%esi
80106e43:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106e47:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80106e4a:	e8 f1 d0 ff ff       	call   80103f40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106e4f:	31 d2                	xor    %edx,%edx
80106e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80106e58:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80106e5c:	85 c9                	test   %ecx,%ecx
80106e5e:	74 20                	je     80106e80 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80106e60:	83 c2 01             	add    $0x1,%edx
80106e63:	83 fa 10             	cmp    $0x10,%edx
80106e66:	75 f0                	jne    80106e58 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80106e68:	e8 d3 d0 ff ff       	call   80103f40 <myproc>
80106e6d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106e74:	00 
80106e75:	eb a1                	jmp    80106e18 <sys_pipe+0x58>
80106e77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e7e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106e80:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80106e84:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106e87:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106e89:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106e8c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80106e8f:	31 c0                	xor    %eax,%eax
}
80106e91:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e94:	5b                   	pop    %ebx
80106e95:	5e                   	pop    %esi
80106e96:	5f                   	pop    %edi
80106e97:	5d                   	pop    %ebp
80106e98:	c3                   	ret    
80106e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ea0 <sys_copy_file>:

int 
sys_copy_file(void) {
80106ea0:	f3 0f 1e fb          	endbr32 
80106ea4:	55                   	push   %ebp
80106ea5:	89 e5                	mov    %esp,%ebp
80106ea7:	57                   	push   %edi
80106ea8:	56                   	push   %esi
  struct inode* ip_dst;
  struct inode* ip_src;
  int bytesRead;
  char buf[1024];

  if (argstr(0, &src_path) < 0 || argstr(1, &dst_path) < 0)
80106ea9:	8d 85 e0 fb ff ff    	lea    -0x420(%ebp),%eax
sys_copy_file(void) {
80106eaf:	53                   	push   %ebx
80106eb0:	81 ec 34 04 00 00    	sub    $0x434,%esp
  if (argstr(0, &src_path) < 0 || argstr(1, &dst_path) < 0)
80106eb6:	50                   	push   %eax
80106eb7:	6a 00                	push   $0x0
80106eb9:	e8 22 f3 ff ff       	call   801061e0 <argstr>
80106ebe:	83 c4 10             	add    $0x10,%esp
80106ec1:	85 c0                	test   %eax,%eax
80106ec3:	0f 88 fa 00 00 00    	js     80106fc3 <sys_copy_file+0x123>
80106ec9:	83 ec 08             	sub    $0x8,%esp
80106ecc:	8d 85 e4 fb ff ff    	lea    -0x41c(%ebp),%eax
80106ed2:	50                   	push   %eax
80106ed3:	6a 01                	push   $0x1
80106ed5:	e8 06 f3 ff ff       	call   801061e0 <argstr>
80106eda:	83 c4 10             	add    $0x10,%esp
80106edd:	85 c0                	test   %eax,%eax
80106edf:	0f 88 de 00 00 00    	js     80106fc3 <sys_copy_file+0x123>
    return -1;
  begin_op();
80106ee5:	e8 b6 c3 ff ff       	call   801032a0 <begin_op>

  if ((ip_src = namei(src_path)) == 0) { // Check if source file exists
80106eea:	83 ec 0c             	sub    $0xc,%esp
80106eed:	ff b5 e0 fb ff ff    	pushl  -0x420(%ebp)
80106ef3:	e8 a8 b6 ff ff       	call   801025a0 <namei>
80106ef8:	83 c4 10             	add    $0x10,%esp
80106efb:	89 85 d4 fb ff ff    	mov    %eax,-0x42c(%ebp)
80106f01:	85 c0                	test   %eax,%eax
80106f03:	0f 84 b5 00 00 00    	je     80106fbe <sys_copy_file+0x11e>
    end_op();
    return -1;
  }
 
  ip_dst = namei(dst_path);
80106f09:	83 ec 0c             	sub    $0xc,%esp
80106f0c:	ff b5 e4 fb ff ff    	pushl  -0x41c(%ebp)
80106f12:	e8 89 b6 ff ff       	call   801025a0 <namei>
  if (ip_dst > 0) { // Check if destination file already exists
80106f17:	83 c4 10             	add    $0x10,%esp
80106f1a:	85 c0                	test   %eax,%eax
80106f1c:	0f 85 9c 00 00 00    	jne    80106fbe <sys_copy_file+0x11e>
    end_op();
    return -1;
  }
  ip_dst = create(dst_path, T_FILE, 0, 0);
80106f22:	83 ec 0c             	sub    $0xc,%esp
80106f25:	8b 85 e4 fb ff ff    	mov    -0x41c(%ebp),%eax
80106f2b:	31 c9                	xor    %ecx,%ecx
80106f2d:	ba 02 00 00 00       	mov    $0x2,%edx
80106f32:	6a 00                	push   $0x0

  int bytesWrote = 0;
  int readOffset = 0;
  int writeOffset = 0;
80106f34:	31 f6                	xor    %esi,%esi
  int readOffset = 0;
80106f36:	31 db                	xor    %ebx,%ebx
80106f38:	8d bd e8 fb ff ff    	lea    -0x418(%ebp),%edi
  ip_dst = create(dst_path, T_FILE, 0, 0);
80106f3e:	e8 6d f3 ff ff       	call   801062b0 <create>
  ilock(ip_src);
80106f43:	5a                   	pop    %edx
80106f44:	ff b5 d4 fb ff ff    	pushl  -0x42c(%ebp)
  ip_dst = create(dst_path, T_FILE, 0, 0);
80106f4a:	89 85 d0 fb ff ff    	mov    %eax,-0x430(%ebp)
  ilock(ip_src);
80106f50:	e8 7b ad ff ff       	call   80101cd0 <ilock>
  while ((bytesRead = readi(ip_src, buf, readOffset, sizeof(buf))) > 0) {
80106f55:	83 c4 10             	add    $0x10,%esp
80106f58:	eb 1f                	jmp    80106f79 <sys_copy_file+0xd9>
80106f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    readOffset += bytesRead;
    if ((bytesWrote = writei(ip_dst , buf,writeOffset,  bytesRead)) <= 0)
80106f60:	50                   	push   %eax
    readOffset += bytesRead;
80106f61:	01 c3                	add    %eax,%ebx
    if ((bytesWrote = writei(ip_dst , buf,writeOffset,  bytesRead)) <= 0)
80106f63:	56                   	push   %esi
80106f64:	57                   	push   %edi
80106f65:	ff b5 d0 fb ff ff    	pushl  -0x430(%ebp)
80106f6b:	e8 60 b1 ff ff       	call   801020d0 <writei>
80106f70:	83 c4 10             	add    $0x10,%esp
80106f73:	85 c0                	test   %eax,%eax
80106f75:	7e 4c                	jle    80106fc3 <sys_copy_file+0x123>
      return -1;
    writeOffset += bytesWrote;
80106f77:	01 c6                	add    %eax,%esi
  while ((bytesRead = readi(ip_src, buf, readOffset, sizeof(buf))) > 0) {
80106f79:	68 00 04 00 00       	push   $0x400
80106f7e:	53                   	push   %ebx
80106f7f:	57                   	push   %edi
80106f80:	ff b5 d4 fb ff ff    	pushl  -0x42c(%ebp)
80106f86:	e8 45 b0 ff ff       	call   80101fd0 <readi>
80106f8b:	83 c4 10             	add    $0x10,%esp
80106f8e:	85 c0                	test   %eax,%eax
80106f90:	7f ce                	jg     80106f60 <sys_copy_file+0xc0>
   
}

  iunlock(ip_src);
80106f92:	83 ec 0c             	sub    $0xc,%esp
80106f95:	ff b5 d4 fb ff ff    	pushl  -0x42c(%ebp)
80106f9b:	e8 10 ae ff ff       	call   80101db0 <iunlock>
  iunlock(ip_dst);
80106fa0:	58                   	pop    %eax
80106fa1:	ff b5 d0 fb ff ff    	pushl  -0x430(%ebp)
80106fa7:	e8 04 ae ff ff       	call   80101db0 <iunlock>
  end_op();
80106fac:	e8 5f c3 ff ff       	call   80103310 <end_op>

  return 0;
80106fb1:	83 c4 10             	add    $0x10,%esp
}
80106fb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106fb7:	31 c0                	xor    %eax,%eax
}
80106fb9:	5b                   	pop    %ebx
80106fba:	5e                   	pop    %esi
80106fbb:	5f                   	pop    %edi
80106fbc:	5d                   	pop    %ebp
80106fbd:	c3                   	ret    
    end_op();
80106fbe:	e8 4d c3 ff ff       	call   80103310 <end_op>
}
80106fc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80106fc6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106fcb:	5b                   	pop    %ebx
80106fcc:	5e                   	pop    %esi
80106fcd:	5f                   	pop    %edi
80106fce:	5d                   	pop    %ebp
80106fcf:	c3                   	ret    

80106fd0 <sys_get_process_lifetime>:
    return -1;
  //cprintf("sysproc.h %d", pid);
  return get_process_lifetime(pid);
}*/

int sys_get_process_lifetime(void){
80106fd0:	f3 0f 1e fb          	endbr32 
  return get_process_lifetime();
80106fd4:	e9 27 da ff ff       	jmp    80104a00 <get_process_lifetime>
80106fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106fe0 <sys_get_uncle_count>:
}

int sys_get_uncle_count(void){
80106fe0:	f3 0f 1e fb          	endbr32 
80106fe4:	55                   	push   %ebp
80106fe5:	89 e5                	mov    %esp,%ebp
80106fe7:	83 ec 20             	sub    $0x20,%esp
  int pid;
  if(argint(0, &pid) < 0){
80106fea:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106fed:	50                   	push   %eax
80106fee:	6a 00                	push   $0x0
80106ff0:	e8 3b f1 ff ff       	call   80106130 <argint>
80106ff5:	83 c4 10             	add    $0x10,%esp
80106ff8:	85 c0                	test   %eax,%eax
80106ffa:	78 14                	js     80107010 <sys_get_uncle_count+0x30>
    return -1;
  }
  return get_uncle_count(pid);
80106ffc:	83 ec 0c             	sub    $0xc,%esp
80106fff:	ff 75 f4             	pushl  -0xc(%ebp)
80107002:	e8 d9 d7 ff ff       	call   801047e0 <get_uncle_count>
80107007:	83 c4 10             	add    $0x10,%esp
}
8010700a:	c9                   	leave  
8010700b:	c3                   	ret    
8010700c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107010:	c9                   	leave  
    return -1;
80107011:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107016:	c3                   	ret    
80107017:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010701e:	66 90                	xchg   %ax,%ax

80107020 <sys_fork>:

int
sys_fork(void)
{
80107020:	f3 0f 1e fb          	endbr32 
  return fork();
80107024:	e9 a7 db ff ff       	jmp    80104bd0 <fork>
80107029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107030 <sys_exit>:
}

int
sys_exit(void)
{
80107030:	f3 0f 1e fb          	endbr32 
80107034:	55                   	push   %ebp
80107035:	89 e5                	mov    %esp,%ebp
80107037:	83 ec 08             	sub    $0x8,%esp
  exit();
8010703a:	e8 51 d3 ff ff       	call   80104390 <exit>
  return 0;  // not reached
}
8010703f:	31 c0                	xor    %eax,%eax
80107041:	c9                   	leave  
80107042:	c3                   	ret    
80107043:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010704a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107050 <sys_wait>:

int
sys_wait(void)
{
80107050:	f3 0f 1e fb          	endbr32 
  return wait();
80107054:	e9 87 d5 ff ff       	jmp    801045e0 <wait>
80107059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107060 <sys_kill>:
}

int
sys_kill(void)
{
80107060:	f3 0f 1e fb          	endbr32 
80107064:	55                   	push   %ebp
80107065:	89 e5                	mov    %esp,%ebp
80107067:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010706a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010706d:	50                   	push   %eax
8010706e:	6a 00                	push   $0x0
80107070:	e8 bb f0 ff ff       	call   80106130 <argint>
80107075:	83 c4 10             	add    $0x10,%esp
80107078:	85 c0                	test   %eax,%eax
8010707a:	78 14                	js     80107090 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010707c:	83 ec 0c             	sub    $0xc,%esp
8010707f:	ff 75 f4             	pushl  -0xc(%ebp)
80107082:	e8 c9 d6 ff ff       	call   80104750 <kill>
80107087:	83 c4 10             	add    $0x10,%esp
}
8010708a:	c9                   	leave  
8010708b:	c3                   	ret    
8010708c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107090:	c9                   	leave  
    return -1;
80107091:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107096:	c3                   	ret    
80107097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010709e:	66 90                	xchg   %ax,%ax

801070a0 <sys_getpid>:

int
sys_getpid(void)
{
801070a0:	f3 0f 1e fb          	endbr32 
801070a4:	55                   	push   %ebp
801070a5:	89 e5                	mov    %esp,%ebp
801070a7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801070aa:	e8 91 ce ff ff       	call   80103f40 <myproc>
801070af:	8b 40 10             	mov    0x10(%eax),%eax
}
801070b2:	c9                   	leave  
801070b3:	c3                   	ret    
801070b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801070bf:	90                   	nop

801070c0 <sys_sbrk>:

int
sys_sbrk(void)
{
801070c0:	f3 0f 1e fb          	endbr32 
801070c4:	55                   	push   %ebp
801070c5:	89 e5                	mov    %esp,%ebp
801070c7:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801070c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801070cb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801070ce:	50                   	push   %eax
801070cf:	6a 00                	push   $0x0
801070d1:	e8 5a f0 ff ff       	call   80106130 <argint>
801070d6:	83 c4 10             	add    $0x10,%esp
801070d9:	85 c0                	test   %eax,%eax
801070db:	78 23                	js     80107100 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801070dd:	e8 5e ce ff ff       	call   80103f40 <myproc>
  if(growproc(n) < 0)
801070e2:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801070e5:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801070e7:	ff 75 f4             	pushl  -0xc(%ebp)
801070ea:	e8 81 ce ff ff       	call   80103f70 <growproc>
801070ef:	83 c4 10             	add    $0x10,%esp
801070f2:	85 c0                	test   %eax,%eax
801070f4:	78 0a                	js     80107100 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801070f6:	89 d8                	mov    %ebx,%eax
801070f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801070fb:	c9                   	leave  
801070fc:	c3                   	ret    
801070fd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80107100:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80107105:	eb ef                	jmp    801070f6 <sys_sbrk+0x36>
80107107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010710e:	66 90                	xchg   %ax,%ax

80107110 <sys_sleep>:

int
sys_sleep(void)
{
80107110:	f3 0f 1e fb          	endbr32 
80107114:	55                   	push   %ebp
80107115:	89 e5                	mov    %esp,%ebp
80107117:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80107118:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010711b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010711e:	50                   	push   %eax
8010711f:	6a 00                	push   $0x0
80107121:	e8 0a f0 ff ff       	call   80106130 <argint>
80107126:	83 c4 10             	add    $0x10,%esp
80107129:	85 c0                	test   %eax,%eax
8010712b:	0f 88 86 00 00 00    	js     801071b7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80107131:	83 ec 0c             	sub    $0xc,%esp
80107134:	68 a0 ce 12 80       	push   $0x8012cea0
80107139:	e8 72 eb ff ff       	call   80105cb0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010713e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80107141:	8b 1d e0 d6 12 80    	mov    0x8012d6e0,%ebx
  while(ticks - ticks0 < n){
80107147:	83 c4 10             	add    $0x10,%esp
8010714a:	85 d2                	test   %edx,%edx
8010714c:	75 23                	jne    80107171 <sys_sleep+0x61>
8010714e:	eb 50                	jmp    801071a0 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80107150:	83 ec 08             	sub    $0x8,%esp
80107153:	68 a0 ce 12 80       	push   $0x8012cea0
80107158:	68 e0 d6 12 80       	push   $0x8012d6e0
8010715d:	e8 be d3 ff ff       	call   80104520 <sleep>
  while(ticks - ticks0 < n){
80107162:	a1 e0 d6 12 80       	mov    0x8012d6e0,%eax
80107167:	83 c4 10             	add    $0x10,%esp
8010716a:	29 d8                	sub    %ebx,%eax
8010716c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010716f:	73 2f                	jae    801071a0 <sys_sleep+0x90>
    if(myproc()->killed){
80107171:	e8 ca cd ff ff       	call   80103f40 <myproc>
80107176:	8b 40 24             	mov    0x24(%eax),%eax
80107179:	85 c0                	test   %eax,%eax
8010717b:	74 d3                	je     80107150 <sys_sleep+0x40>
      release(&tickslock);
8010717d:	83 ec 0c             	sub    $0xc,%esp
80107180:	68 a0 ce 12 80       	push   $0x8012cea0
80107185:	e8 e6 eb ff ff       	call   80105d70 <release>
  }
  release(&tickslock);
  return 0;
}
8010718a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010718d:	83 c4 10             	add    $0x10,%esp
80107190:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107195:	c9                   	leave  
80107196:	c3                   	ret    
80107197:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010719e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
801071a0:	83 ec 0c             	sub    $0xc,%esp
801071a3:	68 a0 ce 12 80       	push   $0x8012cea0
801071a8:	e8 c3 eb ff ff       	call   80105d70 <release>
  return 0;
801071ad:	83 c4 10             	add    $0x10,%esp
801071b0:	31 c0                	xor    %eax,%eax
}
801071b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801071b5:	c9                   	leave  
801071b6:	c3                   	ret    
    return -1;
801071b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071bc:	eb f4                	jmp    801071b2 <sys_sleep+0xa2>
801071be:	66 90                	xchg   %ax,%ax

801071c0 <sys_change_sched_Q>:
int
sys_change_sched_Q(void)
{
801071c0:	f3 0f 1e fb          	endbr32 
801071c4:	55                   	push   %ebp
801071c5:	89 e5                	mov    %esp,%ebp
801071c7:	83 ec 20             	sub    $0x20,%esp
  int queue_number, pid;
  if(argint(0, &pid) < 0 || argint(1, &queue_number) < 0)
801071ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
801071cd:	50                   	push   %eax
801071ce:	6a 00                	push   $0x0
801071d0:	e8 5b ef ff ff       	call   80106130 <argint>
801071d5:	83 c4 10             	add    $0x10,%esp
801071d8:	85 c0                	test   %eax,%eax
801071da:	78 34                	js     80107210 <sys_change_sched_Q+0x50>
801071dc:	83 ec 08             	sub    $0x8,%esp
801071df:	8d 45 f0             	lea    -0x10(%ebp),%eax
801071e2:	50                   	push   %eax
801071e3:	6a 01                	push   $0x1
801071e5:	e8 46 ef ff ff       	call   80106130 <argint>
801071ea:	83 c4 10             	add    $0x10,%esp
801071ed:	85 c0                	test   %eax,%eax
801071ef:	78 1f                	js     80107210 <sys_change_sched_Q+0x50>
    return -1;

  if(queue_number < ROUND_ROBIN || queue_number > BJF)
801071f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801071f4:	8d 50 ff             	lea    -0x1(%eax),%edx
801071f7:	83 fa 02             	cmp    $0x2,%edx
801071fa:	77 14                	ja     80107210 <sys_change_sched_Q+0x50>
    return -1;

  return change_Q(pid, queue_number);
801071fc:	83 ec 08             	sub    $0x8,%esp
801071ff:	50                   	push   %eax
80107200:	ff 75 f4             	pushl  -0xc(%ebp)
80107203:	e8 28 d8 ff ff       	call   80104a30 <change_Q>
80107208:	83 c4 10             	add    $0x10,%esp
}
8010720b:	c9                   	leave  
8010720c:	c3                   	ret    
8010720d:	8d 76 00             	lea    0x0(%esi),%esi
80107210:	c9                   	leave  
    return -1;
80107211:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107216:	c3                   	ret    
80107217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010721e:	66 90                	xchg   %ax,%ax

80107220 <sys_show_process_info>:

void sys_show_process_info(void) {
80107220:	f3 0f 1e fb          	endbr32 
  show_process_info();
80107224:	e9 17 dd ff ff       	jmp    80104f40 <show_process_info>
80107229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107230 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80107230:	f3 0f 1e fb          	endbr32 
80107234:	55                   	push   %ebp
80107235:	89 e5                	mov    %esp,%ebp
80107237:	53                   	push   %ebx
80107238:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
8010723b:	68 a0 ce 12 80       	push   $0x8012cea0
80107240:	e8 6b ea ff ff       	call   80105cb0 <acquire>
  xticks = ticks;
80107245:	8b 1d e0 d6 12 80    	mov    0x8012d6e0,%ebx
  release(&tickslock);
8010724b:	c7 04 24 a0 ce 12 80 	movl   $0x8012cea0,(%esp)
80107252:	e8 19 eb ff ff       	call   80105d70 <release>
  return xticks;
}
80107257:	89 d8                	mov    %ebx,%eax
80107259:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010725c:	c9                   	leave  
8010725d:	c3                   	ret    
8010725e:	66 90                	xchg   %ax,%ax

80107260 <sys_find_digital_root>:

int
sys_find_digital_root(void)
{
80107260:	f3 0f 1e fb          	endbr32 
80107264:	55                   	push   %ebp
80107265:	89 e5                	mov    %esp,%ebp
80107267:	53                   	push   %ebx
80107268:	83 ec 04             	sub    $0x4,%esp
  int n = myproc()->tf->ebx;
8010726b:	e8 d0 cc ff ff       	call   80103f40 <myproc>
  cprintf("KERNEL: sys_find_digital_root(%d)\n", n);
80107270:	83 ec 08             	sub    $0x8,%esp
  int n = myproc()->tf->ebx;
80107273:	8b 40 18             	mov    0x18(%eax),%eax
80107276:	8b 58 10             	mov    0x10(%eax),%ebx
  cprintf("KERNEL: sys_find_digital_root(%d)\n", n);
80107279:	53                   	push   %ebx
8010727a:	68 54 a6 10 80       	push   $0x8010a654
8010727f:	e8 3c 96 ff ff       	call   801008c0 <cprintf>
  return find_digital_root(n);
80107284:	89 1c 24             	mov    %ebx,(%esp)
80107287:	e8 14 d7 ff ff       	call   801049a0 <find_digital_root>

}
8010728c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010728f:	c9                   	leave  
80107290:	c3                   	ret    
80107291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107298:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010729f:	90                   	nop

801072a0 <sys_priorityLock_test>:


void
sys_priorityLock_test(void){
801072a0:	f3 0f 1e fb          	endbr32 
  priorityLock_test();
801072a4:	e9 27 e5 ff ff       	jmp    801057d0 <priorityLock_test>
801072a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801072b0 <sys_set_proc_bjf_params>:
//   return 0;
// }

int
sys_set_proc_bjf_params(void)
{
801072b0:	f3 0f 1e fb          	endbr32 
801072b4:	55                   	push   %ebp
801072b5:	89 e5                	mov    %esp,%ebp
801072b7:	83 ec 30             	sub    $0x30,%esp
  int pid;
  float priority_ratio, arrival_time_ratio, executed_cycle_ratio, process_size_ratio;
  if(argint(0, &pid) < 0 ||
801072ba:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801072bd:	50                   	push   %eax
801072be:	6a 00                	push   $0x0
801072c0:	e8 6b ee ff ff       	call   80106130 <argint>
801072c5:	83 c4 10             	add    $0x10,%esp
801072c8:	85 c0                	test   %eax,%eax
801072ca:	78 74                	js     80107340 <sys_set_proc_bjf_params+0x90>
     argfloat(1, &priority_ratio) < 0 ||
801072cc:	83 ec 08             	sub    $0x8,%esp
801072cf:	8d 45 e8             	lea    -0x18(%ebp),%eax
801072d2:	50                   	push   %eax
801072d3:	6a 01                	push   $0x1
801072d5:	e8 66 ed ff ff       	call   80106040 <argfloat>
  if(argint(0, &pid) < 0 ||
801072da:	83 c4 10             	add    $0x10,%esp
801072dd:	85 c0                	test   %eax,%eax
801072df:	78 5f                	js     80107340 <sys_set_proc_bjf_params+0x90>
     argfloat(2, &arrival_time_ratio) < 0 ||
801072e1:	83 ec 08             	sub    $0x8,%esp
801072e4:	8d 45 ec             	lea    -0x14(%ebp),%eax
801072e7:	50                   	push   %eax
801072e8:	6a 02                	push   $0x2
801072ea:	e8 51 ed ff ff       	call   80106040 <argfloat>
     argfloat(1, &priority_ratio) < 0 ||
801072ef:	83 c4 10             	add    $0x10,%esp
801072f2:	85 c0                	test   %eax,%eax
801072f4:	78 4a                	js     80107340 <sys_set_proc_bjf_params+0x90>
     argfloat(3, &executed_cycle_ratio) < 0||
801072f6:	83 ec 08             	sub    $0x8,%esp
801072f9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801072fc:	50                   	push   %eax
801072fd:	6a 03                	push   $0x3
801072ff:	e8 3c ed ff ff       	call   80106040 <argfloat>
     argfloat(2, &arrival_time_ratio) < 0 ||
80107304:	83 c4 10             	add    $0x10,%esp
80107307:	85 c0                	test   %eax,%eax
80107309:	78 35                	js     80107340 <sys_set_proc_bjf_params+0x90>
     argfloat(4, &process_size_ratio)<0 ){
8010730b:	83 ec 08             	sub    $0x8,%esp
8010730e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107311:	50                   	push   %eax
80107312:	6a 04                	push   $0x4
80107314:	e8 27 ed ff ff       	call   80106040 <argfloat>
     argfloat(3, &executed_cycle_ratio) < 0||
80107319:	83 c4 10             	add    $0x10,%esp
8010731c:	85 c0                	test   %eax,%eax
8010731e:	78 20                	js     80107340 <sys_set_proc_bjf_params+0x90>
    return -1;
  }

  return set_proc_bjf_params(pid, priority_ratio, arrival_time_ratio, executed_cycle_ratio,process_size_ratio);
80107320:	83 ec 0c             	sub    $0xc,%esp
80107323:	ff 75 f4             	pushl  -0xc(%ebp)
80107326:	ff 75 f0             	pushl  -0x10(%ebp)
80107329:	ff 75 ec             	pushl  -0x14(%ebp)
8010732c:	ff 75 e8             	pushl  -0x18(%ebp)
8010732f:	ff 75 e4             	pushl  -0x1c(%ebp)
80107332:	e8 e9 da ff ff       	call   80104e20 <set_proc_bjf_params>
80107337:	83 c4 20             	add    $0x20,%esp
}
8010733a:	c9                   	leave  
8010733b:	c3                   	ret    
8010733c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107340:	c9                   	leave  
    return -1;
80107341:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107346:	c3                   	ret    
80107347:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010734e:	66 90                	xchg   %ax,%ax

80107350 <sys_set_system_bjf_params>:

int
sys_set_system_bjf_params(void)
{
80107350:	f3 0f 1e fb          	endbr32 
80107354:	55                   	push   %ebp
80107355:	89 e5                	mov    %esp,%ebp
80107357:	83 ec 20             	sub    $0x20,%esp
  float priority_ratio, arrival_time_ratio, executed_cycle_ratio,process_size_ratio;
  if(argfloat(0, &priority_ratio) < 0 ||
8010735a:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010735d:	50                   	push   %eax
8010735e:	6a 00                	push   $0x0
80107360:	e8 db ec ff ff       	call   80106040 <argfloat>
80107365:	83 c4 10             	add    $0x10,%esp
80107368:	85 c0                	test   %eax,%eax
8010736a:	78 5c                	js     801073c8 <sys_set_system_bjf_params+0x78>
     argfloat(1, &arrival_time_ratio) < 0 ||
8010736c:	83 ec 08             	sub    $0x8,%esp
8010736f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107372:	50                   	push   %eax
80107373:	6a 01                	push   $0x1
80107375:	e8 c6 ec ff ff       	call   80106040 <argfloat>
  if(argfloat(0, &priority_ratio) < 0 ||
8010737a:	83 c4 10             	add    $0x10,%esp
8010737d:	85 c0                	test   %eax,%eax
8010737f:	78 47                	js     801073c8 <sys_set_system_bjf_params+0x78>
     argfloat(2, &executed_cycle_ratio) < 0||
80107381:	83 ec 08             	sub    $0x8,%esp
80107384:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107387:	50                   	push   %eax
80107388:	6a 02                	push   $0x2
8010738a:	e8 b1 ec ff ff       	call   80106040 <argfloat>
     argfloat(1, &arrival_time_ratio) < 0 ||
8010738f:	83 c4 10             	add    $0x10,%esp
80107392:	85 c0                	test   %eax,%eax
80107394:	78 32                	js     801073c8 <sys_set_system_bjf_params+0x78>
     argfloat(3,&process_size_ratio)<0){
80107396:	83 ec 08             	sub    $0x8,%esp
80107399:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010739c:	50                   	push   %eax
8010739d:	6a 03                	push   $0x3
8010739f:	e8 9c ec ff ff       	call   80106040 <argfloat>
     argfloat(2, &executed_cycle_ratio) < 0||
801073a4:	83 c4 10             	add    $0x10,%esp
801073a7:	85 c0                	test   %eax,%eax
801073a9:	78 1d                	js     801073c8 <sys_set_system_bjf_params+0x78>
    return -1;
  }

  set_system_bjf_params(priority_ratio, arrival_time_ratio, executed_cycle_ratio,process_size_ratio);
801073ab:	ff 75 f4             	pushl  -0xc(%ebp)
801073ae:	ff 75 f0             	pushl  -0x10(%ebp)
801073b1:	ff 75 ec             	pushl  -0x14(%ebp)
801073b4:	ff 75 e8             	pushl  -0x18(%ebp)
801073b7:	e8 04 db ff ff       	call   80104ec0 <set_system_bjf_params>
  return 0;
801073bc:	83 c4 10             	add    $0x10,%esp
801073bf:	31 c0                	xor    %eax,%eax
}
801073c1:	c9                   	leave  
801073c2:	c3                   	ret    
801073c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801073c7:	90                   	nop
801073c8:	c9                   	leave  
    return -1;
801073c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801073ce:	c3                   	ret    
801073cf:	90                   	nop

801073d0 <sys_init_queue_test>:

int sys_init_queue_test(void) {
801073d0:	f3 0f 1e fb          	endbr32 
801073d4:	55                   	push   %ebp
801073d5:	89 e5                	mov    %esp,%ebp
801073d7:	83 ec 08             	sub    $0x8,%esp
  init_queue_test();
801073da:	e8 d1 e4 ff ff       	call   801058b0 <init_queue_test>
  return 0;
}
801073df:	31 c0                	xor    %eax,%eax
801073e1:	c9                   	leave  
801073e2:	c3                   	ret    
801073e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801073f0 <sys_syscalls_count>:

int sys_syscalls_count(void) {
801073f0:	f3 0f 1e fb          	endbr32 
801073f4:	55                   	push   %ebp
801073f5:	89 e5                	mov    %esp,%ebp
801073f7:	57                   	push   %edi
801073f8:	56                   	push   %esi
801073f9:	53                   	push   %ebx
801073fa:	83 ec 0c             	sub    $0xc,%esp
  int total_syscalls_count = 0;
  for(int i = 0 ; i < ncpu ; ++i) {
801073fd:	8b 0d 40 63 11 80    	mov    0x80116340,%ecx
80107403:	85 c9                	test   %ecx,%ecx
80107405:	7e 61                	jle    80107468 <sys_syscalls_count+0x78>
80107407:	be 50 5e 11 80       	mov    $0x80115e50,%esi
8010740c:	31 db                	xor    %ebx,%ebx
  int total_syscalls_count = 0;
8010740e:	31 ff                	xor    %edi,%edi
    int syscalls_count = 0;
    syscalls_count += cpus[i].syscalls_count;
80107410:	8b 06                	mov    (%esi),%eax
    total_syscalls_count += syscalls_count;
    cprintf("cpus[%d].syscalls_count = %d\n", i, syscalls_count);
80107412:	83 ec 04             	sub    $0x4,%esp
80107415:	81 c6 b4 00 00 00    	add    $0xb4,%esi
8010741b:	50                   	push   %eax
    total_syscalls_count += syscalls_count;
8010741c:	01 c7                	add    %eax,%edi
    cprintf("cpus[%d].syscalls_count = %d\n", i, syscalls_count);
8010741e:	53                   	push   %ebx
  for(int i = 0 ; i < ncpu ; ++i) {
8010741f:	83 c3 01             	add    $0x1,%ebx
    cprintf("cpus[%d].syscalls_count = %d\n", i, syscalls_count);
80107422:	68 77 a6 10 80       	push   $0x8010a677
80107427:	e8 94 94 ff ff       	call   801008c0 <cprintf>
  for(int i = 0 ; i < ncpu ; ++i) {
8010742c:	83 c4 10             	add    $0x10,%esp
8010742f:	39 1d 40 63 11 80    	cmp    %ebx,0x80116340
80107435:	7f d9                	jg     80107410 <sys_syscalls_count+0x20>
  }
  cprintf("total_syscalls_count = %d\n", total_syscalls_count);
80107437:	83 ec 08             	sub    $0x8,%esp
8010743a:	57                   	push   %edi
8010743b:	68 95 a6 10 80       	push   $0x8010a695
80107440:	e8 7b 94 ff ff       	call   801008c0 <cprintf>
  cprintf("Shared syscalls count = %d\n", count_shared_syscalls);
80107445:	58                   	pop    %eax
80107446:	5a                   	pop    %edx
80107447:	ff 35 c0 d5 10 80    	pushl  0x8010d5c0
8010744d:	68 b0 a6 10 80       	push   $0x8010a6b0
80107452:	e8 69 94 ff ff       	call   801008c0 <cprintf>
  return total_syscalls_count;
}
80107457:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010745a:	89 f8                	mov    %edi,%eax
8010745c:	5b                   	pop    %ebx
8010745d:	5e                   	pop    %esi
8010745e:	5f                   	pop    %edi
8010745f:	5d                   	pop    %ebp
80107460:	c3                   	ret    
80107461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int total_syscalls_count = 0;
80107468:	31 ff                	xor    %edi,%edi
8010746a:	eb cb                	jmp    80107437 <sys_syscalls_count+0x47>
8010746c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107470 <sys_shmget>:
extern int shmctl(int, int, void*);

// system call handler for shmget
int
sys_shmget(void)
{
80107470:	f3 0f 1e fb          	endbr32 
80107474:	55                   	push   %ebp
80107475:	89 e5                	mov    %esp,%ebp
80107477:	83 ec 20             	sub    $0x20,%esp
  int key, size, shmflag;
  // check for valid arguments
  if(argint(0, &key) < 0)
8010747a:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010747d:	50                   	push   %eax
8010747e:	6a 00                	push   $0x0
80107480:	e8 ab ec ff ff       	call   80106130 <argint>
80107485:	83 c4 10             	add    $0x10,%esp
80107488:	85 c0                	test   %eax,%eax
8010748a:	78 44                	js     801074d0 <sys_shmget+0x60>
    return -1;
  if(argint(1, &size) < 0)
8010748c:	83 ec 08             	sub    $0x8,%esp
8010748f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107492:	50                   	push   %eax
80107493:	6a 01                	push   $0x1
80107495:	e8 96 ec ff ff       	call   80106130 <argint>
8010749a:	83 c4 10             	add    $0x10,%esp
8010749d:	85 c0                	test   %eax,%eax
8010749f:	78 2f                	js     801074d0 <sys_shmget+0x60>
    return -1;
  if(argint(2, &shmflag) < 0)
801074a1:	83 ec 08             	sub    $0x8,%esp
801074a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801074a7:	50                   	push   %eax
801074a8:	6a 02                	push   $0x2
801074aa:	e8 81 ec ff ff       	call   80106130 <argint>
801074af:	83 c4 10             	add    $0x10,%esp
801074b2:	85 c0                	test   %eax,%eax
801074b4:	78 1a                	js     801074d0 <sys_shmget+0x60>
    return -1;
  return shmget((uint)key, (uint)size, shmflag);
801074b6:	83 ec 04             	sub    $0x4,%esp
801074b9:	ff 75 f4             	pushl  -0xc(%ebp)
801074bc:	ff 75 f0             	pushl  -0x10(%ebp)
801074bf:	ff 75 ec             	pushl  -0x14(%ebp)
801074c2:	e8 59 1a 00 00       	call   80108f20 <shmget>
801074c7:	83 c4 10             	add    $0x10,%esp
}
801074ca:	c9                   	leave  
801074cb:	c3                   	ret    
801074cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801074d0:	c9                   	leave  
    return -1;
801074d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801074d6:	c3                   	ret    
801074d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074de:	66 90                	xchg   %ax,%ax

801074e0 <sys_shmdt>:

// system call handler for shmdt
int sys_shmdt(void)
{
801074e0:	f3 0f 1e fb          	endbr32 
801074e4:	55                   	push   %ebp
801074e5:	89 e5                	mov    %esp,%ebp
801074e7:	83 ec 20             	sub    $0x20,%esp
  int i;
  // check for valid argument
  if(argint(0,&i)<0)
801074ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
801074ed:	50                   	push   %eax
801074ee:	6a 00                	push   $0x0
801074f0:	e8 3b ec ff ff       	call   80106130 <argint>
801074f5:	83 c4 10             	add    $0x10,%esp
801074f8:	89 c2                	mov    %eax,%edx
801074fa:	31 c0                	xor    %eax,%eax
801074fc:	85 d2                	test   %edx,%edx
801074fe:	78 0e                	js     8010750e <sys_shmdt+0x2e>
    return 0;
  return shmdt((void*)i);
80107500:	83 ec 0c             	sub    $0xc,%esp
80107503:	ff 75 f4             	pushl  -0xc(%ebp)
80107506:	e8 e5 1c 00 00       	call   801091f0 <shmdt>
8010750b:	83 c4 10             	add    $0x10,%esp
}
8010750e:	c9                   	leave  
8010750f:	c3                   	ret    

80107510 <sys_shmat>:

// system call handler for shmat
void*
sys_shmat(void)
{
80107510:	f3 0f 1e fb          	endbr32 
80107514:	55                   	push   %ebp
80107515:	89 e5                	mov    %esp,%ebp
80107517:	83 ec 20             	sub    $0x20,%esp
  int shmid, shmflag;
  int i;
  // check for valid arguments
  if(argint(0, &shmid) < 0)
8010751a:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010751d:	50                   	push   %eax
8010751e:	6a 00                	push   $0x0
80107520:	e8 0b ec ff ff       	call   80106130 <argint>
80107525:	83 c4 10             	add    $0x10,%esp
80107528:	85 c0                	test   %eax,%eax
8010752a:	78 44                	js     80107570 <sys_shmat+0x60>
    return (void*)0;
  if(argint(1,&i)<0)
8010752c:	83 ec 08             	sub    $0x8,%esp
8010752f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107532:	50                   	push   %eax
80107533:	6a 01                	push   $0x1
80107535:	e8 f6 eb ff ff       	call   80106130 <argint>
8010753a:	83 c4 10             	add    $0x10,%esp
8010753d:	85 c0                	test   %eax,%eax
8010753f:	78 2f                	js     80107570 <sys_shmat+0x60>
    return (void*)0;
  if(argint(2, &shmflag) < 0)
80107541:	83 ec 08             	sub    $0x8,%esp
80107544:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107547:	50                   	push   %eax
80107548:	6a 02                	push   $0x2
8010754a:	e8 e1 eb ff ff       	call   80106130 <argint>
8010754f:	83 c4 10             	add    $0x10,%esp
80107552:	85 c0                	test   %eax,%eax
80107554:	78 1a                	js     80107570 <sys_shmat+0x60>
    return (void*)0;
  return shmat(shmid, shmflag);
80107556:	83 ec 08             	sub    $0x8,%esp
80107559:	ff 75 f0             	pushl  -0x10(%ebp)
8010755c:	ff 75 ec             	pushl  -0x14(%ebp)
8010755f:	e8 ac 1e 00 00       	call   80109410 <shmat>
80107564:	83 c4 10             	add    $0x10,%esp
}
80107567:	c9                   	leave  
80107568:	c3                   	ret    
80107569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107570:	c9                   	leave  
    return (void*)0;
80107571:	31 c0                	xor    %eax,%eax
}
80107573:	c3                   	ret    
80107574:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010757b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010757f:	90                   	nop

80107580 <sys_shmctl>:

// system call handler for shmctl
int
sys_shmctl(void)
{
80107580:	f3 0f 1e fb          	endbr32 
80107584:	55                   	push   %ebp
80107585:	89 e5                	mov    %esp,%ebp
80107587:	83 ec 20             	sub    $0x20,%esp
  int shmid, cmd, buf;
  // check for valid arguments
  if(argint(0, &shmid) < 0)
8010758a:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010758d:	50                   	push   %eax
8010758e:	6a 00                	push   $0x0
80107590:	e8 9b eb ff ff       	call   80106130 <argint>
80107595:	83 c4 10             	add    $0x10,%esp
80107598:	85 c0                	test   %eax,%eax
8010759a:	78 44                	js     801075e0 <sys_shmctl+0x60>
    return -1;
  if(argint(1, &cmd) < 0)
8010759c:	83 ec 08             	sub    $0x8,%esp
8010759f:	8d 45 f0             	lea    -0x10(%ebp),%eax
801075a2:	50                   	push   %eax
801075a3:	6a 01                	push   $0x1
801075a5:	e8 86 eb ff ff       	call   80106130 <argint>
801075aa:	83 c4 10             	add    $0x10,%esp
801075ad:	85 c0                	test   %eax,%eax
801075af:	78 2f                	js     801075e0 <sys_shmctl+0x60>
    return -1;
  if(argint(2, &buf) < 0)
801075b1:	83 ec 08             	sub    $0x8,%esp
801075b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801075b7:	50                   	push   %eax
801075b8:	6a 02                	push   $0x2
801075ba:	e8 71 eb ff ff       	call   80106130 <argint>
801075bf:	83 c4 10             	add    $0x10,%esp
801075c2:	85 c0                	test   %eax,%eax
801075c4:	78 1a                	js     801075e0 <sys_shmctl+0x60>
    return -1;
  return shmctl(shmid, cmd, (void*)buf);
801075c6:	83 ec 04             	sub    $0x4,%esp
801075c9:	ff 75 f4             	pushl  -0xc(%ebp)
801075cc:	ff 75 f0             	pushl  -0x10(%ebp)
801075cf:	ff 75 ec             	pushl  -0x14(%ebp)
801075d2:	e8 69 22 00 00       	call   80109840 <shmctl>
801075d7:	83 c4 10             	add    $0x10,%esp
}
801075da:	c9                   	leave  
801075db:	c3                   	ret    
801075dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801075e0:	c9                   	leave  
    return -1;
801075e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801075e6:	c3                   	ret    

801075e7 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801075e7:	1e                   	push   %ds
  pushl %es
801075e8:	06                   	push   %es
  pushl %fs
801075e9:	0f a0                	push   %fs
  pushl %gs
801075eb:	0f a8                	push   %gs
  pushal
801075ed:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801075ee:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801075f2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801075f4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801075f6:	54                   	push   %esp
  call trap
801075f7:	e8 c4 00 00 00       	call   801076c0 <trap>
  addl $4, %esp
801075fc:	83 c4 04             	add    $0x4,%esp

801075ff <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801075ff:	61                   	popa   
  popl %gs
80107600:	0f a9                	pop    %gs
  popl %fs
80107602:	0f a1                	pop    %fs
  popl %es
80107604:	07                   	pop    %es
  popl %ds
80107605:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80107606:	83 c4 08             	add    $0x8,%esp
  iret
80107609:	cf                   	iret   
8010760a:	66 90                	xchg   %ax,%ax
8010760c:	66 90                	xchg   %ax,%ax
8010760e:	66 90                	xchg   %ax,%ax

80107610 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80107610:	f3 0f 1e fb          	endbr32 
80107614:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80107615:	31 c0                	xor    %eax,%eax
{
80107617:	89 e5                	mov    %esp,%ebp
80107619:	83 ec 08             	sub    $0x8,%esp
8010761c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80107620:	8b 14 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%edx
80107627:	c7 04 c5 e2 ce 12 80 	movl   $0x8e000008,-0x7fed311e(,%eax,8)
8010762e:	08 00 00 8e 
80107632:	66 89 14 c5 e0 ce 12 	mov    %dx,-0x7fed3120(,%eax,8)
80107639:	80 
8010763a:	c1 ea 10             	shr    $0x10,%edx
8010763d:	66 89 14 c5 e6 ce 12 	mov    %dx,-0x7fed311a(,%eax,8)
80107644:	80 
  for(i = 0; i < 256; i++)
80107645:	83 c0 01             	add    $0x1,%eax
80107648:	3d 00 01 00 00       	cmp    $0x100,%eax
8010764d:	75 d1                	jne    80107620 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010764f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80107652:	a1 08 d1 10 80       	mov    0x8010d108,%eax
80107657:	c7 05 e2 d0 12 80 08 	movl   $0xef000008,0x8012d0e2
8010765e:	00 00 ef 
  initlock(&tickslock, "time");
80107661:	68 cc a6 10 80       	push   $0x8010a6cc
80107666:	68 a0 ce 12 80       	push   $0x8012cea0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010766b:	66 a3 e0 d0 12 80    	mov    %ax,0x8012d0e0
80107671:	c1 e8 10             	shr    $0x10,%eax
80107674:	66 a3 e6 d0 12 80    	mov    %ax,0x8012d0e6
  initlock(&tickslock, "time");
8010767a:	e8 b1 e4 ff ff       	call   80105b30 <initlock>
}
8010767f:	83 c4 10             	add    $0x10,%esp
80107682:	c9                   	leave  
80107683:	c3                   	ret    
80107684:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010768b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010768f:	90                   	nop

80107690 <idtinit>:

void
idtinit(void)
{
80107690:	f3 0f 1e fb          	endbr32 
80107694:	55                   	push   %ebp
  pd[0] = size-1;
80107695:	b8 ff 07 00 00       	mov    $0x7ff,%eax
8010769a:	89 e5                	mov    %esp,%ebp
8010769c:	83 ec 10             	sub    $0x10,%esp
8010769f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801076a3:	b8 e0 ce 12 80       	mov    $0x8012cee0,%eax
801076a8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801076ac:	c1 e8 10             	shr    $0x10,%eax
801076af:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801076b3:	8d 45 fa             	lea    -0x6(%ebp),%eax
801076b6:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801076b9:	c9                   	leave  
801076ba:	c3                   	ret    
801076bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801076bf:	90                   	nop

801076c0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801076c0:	f3 0f 1e fb          	endbr32 
801076c4:	55                   	push   %ebp
801076c5:	89 e5                	mov    %esp,%ebp
801076c7:	57                   	push   %edi
801076c8:	56                   	push   %esi
801076c9:	53                   	push   %ebx
801076ca:	83 ec 1c             	sub    $0x1c,%esp
801076cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801076d0:	8b 43 30             	mov    0x30(%ebx),%eax
801076d3:	83 f8 40             	cmp    $0x40,%eax
801076d6:	0f 84 5c 02 00 00    	je     80107938 <trap+0x278>
      exit();
    return;
  }

  int os_tick;
  switch(tf->trapno){
801076dc:	83 e8 0e             	sub    $0xe,%eax
801076df:	83 f8 31             	cmp    $0x31,%eax
801076e2:	77 08                	ja     801076ec <trap+0x2c>
801076e4:	3e ff 24 85 ac a7 10 	notrack jmp *-0x7fef5854(,%eax,4)
801076eb:	80 
    myproc()->killed = 1;
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801076ec:	e8 4f c8 ff ff       	call   80103f40 <myproc>
801076f1:	85 c0                	test   %eax,%eax
801076f3:	0f 84 a6 02 00 00    	je     8010799f <trap+0x2df>
801076f9:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801076fd:	0f 84 9c 02 00 00    	je     8010799f <trap+0x2df>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107703:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107706:	8b 53 38             	mov    0x38(%ebx),%edx
80107709:	89 4d d8             	mov    %ecx,-0x28(%ebp)
8010770c:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010770f:	e8 0c c8 ff ff       	call   80103f20 <cpuid>
80107714:	8b 73 30             	mov    0x30(%ebx),%esi
80107717:	89 c7                	mov    %eax,%edi
80107719:	8b 43 34             	mov    0x34(%ebx),%eax
8010771c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010771f:	e8 1c c8 ff ff       	call   80103f40 <myproc>
80107724:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107727:	e8 14 c8 ff ff       	call   80103f40 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010772c:	8b 4d d8             	mov    -0x28(%ebp),%ecx
8010772f:	8b 55 dc             	mov    -0x24(%ebp),%edx
80107732:	51                   	push   %ecx
80107733:	52                   	push   %edx
80107734:	57                   	push   %edi
80107735:	ff 75 e4             	pushl  -0x1c(%ebp)
80107738:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80107739:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010773c:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010773f:	56                   	push   %esi
80107740:	ff 70 10             	pushl  0x10(%eax)
80107743:	68 3c a7 10 80       	push   $0x8010a73c
80107748:	e8 73 91 ff ff       	call   801008c0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010774d:	83 c4 20             	add    $0x20,%esp
80107750:	e8 eb c7 ff ff       	call   80103f40 <myproc>
80107755:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010775c:	e8 df c7 ff ff       	call   80103f40 <myproc>
80107761:	85 c0                	test   %eax,%eax
80107763:	74 1d                	je     80107782 <trap+0xc2>
80107765:	e8 d6 c7 ff ff       	call   80103f40 <myproc>
8010776a:	8b 50 24             	mov    0x24(%eax),%edx
8010776d:	85 d2                	test   %edx,%edx
8010776f:	74 11                	je     80107782 <trap+0xc2>
80107771:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80107775:	83 e0 03             	and    $0x3,%eax
80107778:	66 83 f8 03          	cmp    $0x3,%ax
8010777c:	0f 84 06 02 00 00    	je     80107988 <trap+0x2c8>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80107782:	e8 b9 c7 ff ff       	call   80103f40 <myproc>
80107787:	85 c0                	test   %eax,%eax
80107789:	74 0f                	je     8010779a <trap+0xda>
8010778b:	e8 b0 c7 ff ff       	call   80103f40 <myproc>
80107790:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80107794:	0f 84 86 01 00 00    	je     80107920 <trap+0x260>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010779a:	e8 a1 c7 ff ff       	call   80103f40 <myproc>
8010779f:	85 c0                	test   %eax,%eax
801077a1:	74 1d                	je     801077c0 <trap+0x100>
801077a3:	e8 98 c7 ff ff       	call   80103f40 <myproc>
801077a8:	8b 40 24             	mov    0x24(%eax),%eax
801077ab:	85 c0                	test   %eax,%eax
801077ad:	74 11                	je     801077c0 <trap+0x100>
801077af:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801077b3:	83 e0 03             	and    $0x3,%eax
801077b6:	66 83 f8 03          	cmp    $0x3,%ax
801077ba:	0f 84 a1 01 00 00    	je     80107961 <trap+0x2a1>
    exit();
}
801077c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077c3:	5b                   	pop    %ebx
801077c4:	5e                   	pop    %esi
801077c5:	5f                   	pop    %edi
801077c6:	5d                   	pop    %ebp
801077c7:	c3                   	ret    
    ideintr();
801077c8:	e8 83 af ff ff       	call   80102750 <ideintr>
    lapiceoi();
801077cd:	e8 5e b6 ff ff       	call   80102e30 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801077d2:	e8 69 c7 ff ff       	call   80103f40 <myproc>
801077d7:	85 c0                	test   %eax,%eax
801077d9:	75 8a                	jne    80107765 <trap+0xa5>
801077db:	eb a5                	jmp    80107782 <trap+0xc2>
    if(strncmp(myproc()->name, "testShared", strlen(myproc()->name)) != 0) {
801077dd:	e8 5e c7 ff ff       	call   80103f40 <myproc>
801077e2:	83 ec 0c             	sub    $0xc,%esp
801077e5:	83 c0 6c             	add    $0x6c,%eax
801077e8:	50                   	push   %eax
801077e9:	e8 d2 e7 ff ff       	call   80105fc0 <strlen>
801077ee:	89 c6                	mov    %eax,%esi
801077f0:	e8 4b c7 ff ff       	call   80103f40 <myproc>
801077f5:	83 c4 0c             	add    $0xc,%esp
801077f8:	83 c0 6c             	add    $0x6c,%eax
801077fb:	56                   	push   %esi
801077fc:	68 d1 a6 10 80       	push   $0x8010a6d1
80107801:	50                   	push   %eax
80107802:	e8 c9 e6 ff ff       	call   80105ed0 <strncmp>
80107807:	83 c4 10             	add    $0x10,%esp
8010780a:	85 c0                	test   %eax,%eax
8010780c:	0f 84 5e 01 00 00    	je     80107970 <trap+0x2b0>
      if(myproc() == 0 || (tf->cs&3) == 0){
80107812:	e8 29 c7 ff ff       	call   80103f40 <myproc>
80107817:	8b 7b 38             	mov    0x38(%ebx),%edi
8010781a:	85 c0                	test   %eax,%eax
8010781c:	0f 84 a8 01 00 00    	je     801079ca <trap+0x30a>
80107822:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80107826:	0f 84 9e 01 00 00    	je     801079ca <trap+0x30a>
8010782c:	0f 20 d1             	mov    %cr2,%ecx
8010782f:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("pid %d %s: trap %d err %d on cpu %d "
80107832:	e8 e9 c6 ff ff       	call   80103f20 <cpuid>
80107837:	8b 73 30             	mov    0x30(%ebx),%esi
8010783a:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010783d:	8b 43 34             	mov    0x34(%ebx),%eax
80107840:	89 45 e4             	mov    %eax,-0x1c(%ebp)
              myproc()->pid, myproc()->name, tf->trapno,
80107843:	e8 f8 c6 ff ff       	call   80103f40 <myproc>
80107848:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010784b:	e8 f0 c6 ff ff       	call   80103f40 <myproc>
      cprintf("pid %d %s: trap %d err %d on cpu %d "
80107850:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80107853:	8b 55 dc             	mov    -0x24(%ebp),%edx
80107856:	51                   	push   %ecx
80107857:	57                   	push   %edi
80107858:	52                   	push   %edx
80107859:	e9 d7 fe ff ff       	jmp    80107735 <trap+0x75>
    if(cpuid() == 0){
8010785e:	e8 bd c6 ff ff       	call   80103f20 <cpuid>
80107863:	85 c0                	test   %eax,%eax
80107865:	0f 85 62 ff ff ff    	jne    801077cd <trap+0x10d>
      acquire(&tickslock);
8010786b:	83 ec 0c             	sub    $0xc,%esp
8010786e:	68 a0 ce 12 80       	push   $0x8012cea0
80107873:	e8 38 e4 ff ff       	call   80105cb0 <acquire>
      ticks++;
80107878:	a1 e0 d6 12 80       	mov    0x8012d6e0,%eax
      wakeup(&ticks);
8010787d:	c7 04 24 e0 d6 12 80 	movl   $0x8012d6e0,(%esp)
      ticks++;
80107884:	8d 70 01             	lea    0x1(%eax),%esi
80107887:	89 35 e0 d6 12 80    	mov    %esi,0x8012d6e0
      wakeup(&ticks);
8010788d:	e8 4e ce ff ff       	call   801046e0 <wakeup>
      release(&tickslock);
80107892:	c7 04 24 a0 ce 12 80 	movl   $0x8012cea0,(%esp)
80107899:	e8 d2 e4 ff ff       	call   80105d70 <release>
      ageprocs(os_tick);
8010789e:	89 34 24             	mov    %esi,(%esp)
801078a1:	e8 5a d4 ff ff       	call   80104d00 <ageprocs>
801078a6:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801078a9:	e9 1f ff ff ff       	jmp    801077cd <trap+0x10d>
    uartintr();
801078ae:	e8 9d 02 00 00       	call   80107b50 <uartintr>
    lapiceoi();
801078b3:	e8 78 b5 ff ff       	call   80102e30 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801078b8:	e8 83 c6 ff ff       	call   80103f40 <myproc>
801078bd:	85 c0                	test   %eax,%eax
801078bf:	0f 85 a0 fe ff ff    	jne    80107765 <trap+0xa5>
801078c5:	e9 b8 fe ff ff       	jmp    80107782 <trap+0xc2>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801078ca:	8b 7b 38             	mov    0x38(%ebx),%edi
801078cd:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801078d1:	e8 4a c6 ff ff       	call   80103f20 <cpuid>
801078d6:	57                   	push   %edi
801078d7:	56                   	push   %esi
801078d8:	50                   	push   %eax
801078d9:	68 e4 a6 10 80       	push   $0x8010a6e4
801078de:	e8 dd 8f ff ff       	call   801008c0 <cprintf>
    lapiceoi();
801078e3:	e8 48 b5 ff ff       	call   80102e30 <lapiceoi>
    break;
801078e8:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801078eb:	e8 50 c6 ff ff       	call   80103f40 <myproc>
801078f0:	85 c0                	test   %eax,%eax
801078f2:	0f 85 6d fe ff ff    	jne    80107765 <trap+0xa5>
801078f8:	e9 85 fe ff ff       	jmp    80107782 <trap+0xc2>
    kbdintr();
801078fd:	e8 ee b3 ff ff       	call   80102cf0 <kbdintr>
    lapiceoi();
80107902:	e8 29 b5 ff ff       	call   80102e30 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80107907:	e8 34 c6 ff ff       	call   80103f40 <myproc>
8010790c:	85 c0                	test   %eax,%eax
8010790e:	0f 85 51 fe ff ff    	jne    80107765 <trap+0xa5>
80107914:	e9 69 fe ff ff       	jmp    80107782 <trap+0xc2>
80107919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
80107920:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80107924:	0f 85 70 fe ff ff    	jne    8010779a <trap+0xda>
    yield();
8010792a:	e8 a1 cb ff ff       	call   801044d0 <yield>
8010792f:	e9 66 fe ff ff       	jmp    8010779a <trap+0xda>
80107934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80107938:	e8 03 c6 ff ff       	call   80103f40 <myproc>
8010793d:	8b 70 24             	mov    0x24(%eax),%esi
80107940:	85 f6                	test   %esi,%esi
80107942:	75 54                	jne    80107998 <trap+0x2d8>
    myproc()->tf = tf;
80107944:	e8 f7 c5 ff ff       	call   80103f40 <myproc>
80107949:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010794c:	e8 cf e8 ff ff       	call   80106220 <syscall>
    if(myproc()->killed)
80107951:	e8 ea c5 ff ff       	call   80103f40 <myproc>
80107956:	8b 48 24             	mov    0x24(%eax),%ecx
80107959:	85 c9                	test   %ecx,%ecx
8010795b:	0f 84 5f fe ff ff    	je     801077c0 <trap+0x100>
}
80107961:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107964:	5b                   	pop    %ebx
80107965:	5e                   	pop    %esi
80107966:	5f                   	pop    %edi
80107967:	5d                   	pop    %ebp
      exit();
80107968:	e9 23 ca ff ff       	jmp    80104390 <exit>
8010796d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("Segmentation fault (Core dumped) - Trap 14\n");
80107970:	83 ec 0c             	sub    $0xc,%esp
80107973:	68 80 a7 10 80       	push   $0x8010a780
80107978:	e8 43 8f ff ff       	call   801008c0 <cprintf>
8010797d:	83 c4 10             	add    $0x10,%esp
    myproc()->killed = 1;
80107980:	e9 cb fd ff ff       	jmp    80107750 <trap+0x90>
80107985:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80107988:	e8 03 ca ff ff       	call   80104390 <exit>
8010798d:	e9 f0 fd ff ff       	jmp    80107782 <trap+0xc2>
80107992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80107998:	e8 f3 c9 ff ff       	call   80104390 <exit>
8010799d:	eb a5                	jmp    80107944 <trap+0x284>
8010799f:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801079a2:	8b 73 38             	mov    0x38(%ebx),%esi
801079a5:	e8 76 c5 ff ff       	call   80103f20 <cpuid>
801079aa:	83 ec 0c             	sub    $0xc,%esp
801079ad:	57                   	push   %edi
801079ae:	56                   	push   %esi
801079af:	50                   	push   %eax
801079b0:	ff 73 30             	pushl  0x30(%ebx)
801079b3:	68 08 a7 10 80       	push   $0x8010a708
801079b8:	e8 03 8f ff ff       	call   801008c0 <cprintf>
      panic("trap");
801079bd:	83 c4 14             	add    $0x14,%esp
801079c0:	68 dc a6 10 80       	push   $0x8010a6dc
801079c5:	e8 c6 89 ff ff       	call   80100390 <panic>
801079ca:	0f 20 d6             	mov    %cr2,%esi
        cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801079cd:	e8 4e c5 ff ff       	call   80103f20 <cpuid>
801079d2:	83 ec 0c             	sub    $0xc,%esp
801079d5:	56                   	push   %esi
801079d6:	57                   	push   %edi
801079d7:	eb d6                	jmp    801079af <trap+0x2ef>
801079d9:	66 90                	xchg   %ax,%ax
801079db:	66 90                	xchg   %ax,%ax
801079dd:	66 90                	xchg   %ax,%ax
801079df:	90                   	nop

801079e0 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801079e0:	f3 0f 1e fb          	endbr32 
  if(!uart)
801079e4:	a1 20 d6 10 80       	mov    0x8010d620,%eax
801079e9:	85 c0                	test   %eax,%eax
801079eb:	74 1b                	je     80107a08 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801079ed:	ba fd 03 00 00       	mov    $0x3fd,%edx
801079f2:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801079f3:	a8 01                	test   $0x1,%al
801079f5:	74 11                	je     80107a08 <uartgetc+0x28>
801079f7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801079fc:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801079fd:	0f b6 c0             	movzbl %al,%eax
80107a00:	c3                   	ret    
80107a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80107a08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107a0d:	c3                   	ret    
80107a0e:	66 90                	xchg   %ax,%ax

80107a10 <uartputc.part.0>:
uartputc(int c)
80107a10:	55                   	push   %ebp
80107a11:	89 e5                	mov    %esp,%ebp
80107a13:	57                   	push   %edi
80107a14:	89 c7                	mov    %eax,%edi
80107a16:	56                   	push   %esi
80107a17:	be fd 03 00 00       	mov    $0x3fd,%esi
80107a1c:	53                   	push   %ebx
80107a1d:	bb 80 00 00 00       	mov    $0x80,%ebx
80107a22:	83 ec 0c             	sub    $0xc,%esp
80107a25:	eb 1b                	jmp    80107a42 <uartputc.part.0+0x32>
80107a27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a2e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80107a30:	83 ec 0c             	sub    $0xc,%esp
80107a33:	6a 0a                	push   $0xa
80107a35:	e8 16 b4 ff ff       	call   80102e50 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107a3a:	83 c4 10             	add    $0x10,%esp
80107a3d:	83 eb 01             	sub    $0x1,%ebx
80107a40:	74 07                	je     80107a49 <uartputc.part.0+0x39>
80107a42:	89 f2                	mov    %esi,%edx
80107a44:	ec                   	in     (%dx),%al
80107a45:	a8 20                	test   $0x20,%al
80107a47:	74 e7                	je     80107a30 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107a49:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107a4e:	89 f8                	mov    %edi,%eax
80107a50:	ee                   	out    %al,(%dx)
}
80107a51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a54:	5b                   	pop    %ebx
80107a55:	5e                   	pop    %esi
80107a56:	5f                   	pop    %edi
80107a57:	5d                   	pop    %ebp
80107a58:	c3                   	ret    
80107a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107a60 <uartinit>:
{
80107a60:	f3 0f 1e fb          	endbr32 
80107a64:	55                   	push   %ebp
80107a65:	31 c9                	xor    %ecx,%ecx
80107a67:	89 c8                	mov    %ecx,%eax
80107a69:	89 e5                	mov    %esp,%ebp
80107a6b:	57                   	push   %edi
80107a6c:	56                   	push   %esi
80107a6d:	53                   	push   %ebx
80107a6e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80107a73:	89 da                	mov    %ebx,%edx
80107a75:	83 ec 0c             	sub    $0xc,%esp
80107a78:	ee                   	out    %al,(%dx)
80107a79:	bf fb 03 00 00       	mov    $0x3fb,%edi
80107a7e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80107a83:	89 fa                	mov    %edi,%edx
80107a85:	ee                   	out    %al,(%dx)
80107a86:	b8 0c 00 00 00       	mov    $0xc,%eax
80107a8b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107a90:	ee                   	out    %al,(%dx)
80107a91:	be f9 03 00 00       	mov    $0x3f9,%esi
80107a96:	89 c8                	mov    %ecx,%eax
80107a98:	89 f2                	mov    %esi,%edx
80107a9a:	ee                   	out    %al,(%dx)
80107a9b:	b8 03 00 00 00       	mov    $0x3,%eax
80107aa0:	89 fa                	mov    %edi,%edx
80107aa2:	ee                   	out    %al,(%dx)
80107aa3:	ba fc 03 00 00       	mov    $0x3fc,%edx
80107aa8:	89 c8                	mov    %ecx,%eax
80107aaa:	ee                   	out    %al,(%dx)
80107aab:	b8 01 00 00 00       	mov    $0x1,%eax
80107ab0:	89 f2                	mov    %esi,%edx
80107ab2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107ab3:	ba fd 03 00 00       	mov    $0x3fd,%edx
80107ab8:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80107ab9:	3c ff                	cmp    $0xff,%al
80107abb:	74 52                	je     80107b0f <uartinit+0xaf>
  uart = 1;
80107abd:	c7 05 20 d6 10 80 01 	movl   $0x1,0x8010d620
80107ac4:	00 00 00 
80107ac7:	89 da                	mov    %ebx,%edx
80107ac9:	ec                   	in     (%dx),%al
80107aca:	ba f8 03 00 00       	mov    $0x3f8,%edx
80107acf:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80107ad0:	83 ec 08             	sub    $0x8,%esp
80107ad3:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80107ad8:	bb 74 a8 10 80       	mov    $0x8010a874,%ebx
  ioapicenable(IRQ_COM1, 0);
80107add:	6a 00                	push   $0x0
80107adf:	6a 04                	push   $0x4
80107ae1:	e8 ba ae ff ff       	call   801029a0 <ioapicenable>
80107ae6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80107ae9:	b8 78 00 00 00       	mov    $0x78,%eax
80107aee:	eb 04                	jmp    80107af4 <uartinit+0x94>
80107af0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80107af4:	8b 15 20 d6 10 80    	mov    0x8010d620,%edx
80107afa:	85 d2                	test   %edx,%edx
80107afc:	74 08                	je     80107b06 <uartinit+0xa6>
    uartputc(*p);
80107afe:	0f be c0             	movsbl %al,%eax
80107b01:	e8 0a ff ff ff       	call   80107a10 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80107b06:	89 f0                	mov    %esi,%eax
80107b08:	83 c3 01             	add    $0x1,%ebx
80107b0b:	84 c0                	test   %al,%al
80107b0d:	75 e1                	jne    80107af0 <uartinit+0x90>
}
80107b0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b12:	5b                   	pop    %ebx
80107b13:	5e                   	pop    %esi
80107b14:	5f                   	pop    %edi
80107b15:	5d                   	pop    %ebp
80107b16:	c3                   	ret    
80107b17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b1e:	66 90                	xchg   %ax,%ax

80107b20 <uartputc>:
{
80107b20:	f3 0f 1e fb          	endbr32 
80107b24:	55                   	push   %ebp
  if(!uart)
80107b25:	8b 15 20 d6 10 80    	mov    0x8010d620,%edx
{
80107b2b:	89 e5                	mov    %esp,%ebp
80107b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80107b30:	85 d2                	test   %edx,%edx
80107b32:	74 0c                	je     80107b40 <uartputc+0x20>
}
80107b34:	5d                   	pop    %ebp
80107b35:	e9 d6 fe ff ff       	jmp    80107a10 <uartputc.part.0>
80107b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107b40:	5d                   	pop    %ebp
80107b41:	c3                   	ret    
80107b42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107b50 <uartintr>:

void
uartintr(void)
{
80107b50:	f3 0f 1e fb          	endbr32 
80107b54:	55                   	push   %ebp
80107b55:	89 e5                	mov    %esp,%ebp
80107b57:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80107b5a:	68 e0 79 10 80       	push   $0x801079e0
80107b5f:	e8 0c 8f ff ff       	call   80100a70 <consoleintr>
}
80107b64:	83 c4 10             	add    $0x10,%esp
80107b67:	c9                   	leave  
80107b68:	c3                   	ret    

80107b69 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107b69:	6a 00                	push   $0x0
  pushl $0
80107b6b:	6a 00                	push   $0x0
  jmp alltraps
80107b6d:	e9 75 fa ff ff       	jmp    801075e7 <alltraps>

80107b72 <vector1>:
.globl vector1
vector1:
  pushl $0
80107b72:	6a 00                	push   $0x0
  pushl $1
80107b74:	6a 01                	push   $0x1
  jmp alltraps
80107b76:	e9 6c fa ff ff       	jmp    801075e7 <alltraps>

80107b7b <vector2>:
.globl vector2
vector2:
  pushl $0
80107b7b:	6a 00                	push   $0x0
  pushl $2
80107b7d:	6a 02                	push   $0x2
  jmp alltraps
80107b7f:	e9 63 fa ff ff       	jmp    801075e7 <alltraps>

80107b84 <vector3>:
.globl vector3
vector3:
  pushl $0
80107b84:	6a 00                	push   $0x0
  pushl $3
80107b86:	6a 03                	push   $0x3
  jmp alltraps
80107b88:	e9 5a fa ff ff       	jmp    801075e7 <alltraps>

80107b8d <vector4>:
.globl vector4
vector4:
  pushl $0
80107b8d:	6a 00                	push   $0x0
  pushl $4
80107b8f:	6a 04                	push   $0x4
  jmp alltraps
80107b91:	e9 51 fa ff ff       	jmp    801075e7 <alltraps>

80107b96 <vector5>:
.globl vector5
vector5:
  pushl $0
80107b96:	6a 00                	push   $0x0
  pushl $5
80107b98:	6a 05                	push   $0x5
  jmp alltraps
80107b9a:	e9 48 fa ff ff       	jmp    801075e7 <alltraps>

80107b9f <vector6>:
.globl vector6
vector6:
  pushl $0
80107b9f:	6a 00                	push   $0x0
  pushl $6
80107ba1:	6a 06                	push   $0x6
  jmp alltraps
80107ba3:	e9 3f fa ff ff       	jmp    801075e7 <alltraps>

80107ba8 <vector7>:
.globl vector7
vector7:
  pushl $0
80107ba8:	6a 00                	push   $0x0
  pushl $7
80107baa:	6a 07                	push   $0x7
  jmp alltraps
80107bac:	e9 36 fa ff ff       	jmp    801075e7 <alltraps>

80107bb1 <vector8>:
.globl vector8
vector8:
  pushl $8
80107bb1:	6a 08                	push   $0x8
  jmp alltraps
80107bb3:	e9 2f fa ff ff       	jmp    801075e7 <alltraps>

80107bb8 <vector9>:
.globl vector9
vector9:
  pushl $0
80107bb8:	6a 00                	push   $0x0
  pushl $9
80107bba:	6a 09                	push   $0x9
  jmp alltraps
80107bbc:	e9 26 fa ff ff       	jmp    801075e7 <alltraps>

80107bc1 <vector10>:
.globl vector10
vector10:
  pushl $10
80107bc1:	6a 0a                	push   $0xa
  jmp alltraps
80107bc3:	e9 1f fa ff ff       	jmp    801075e7 <alltraps>

80107bc8 <vector11>:
.globl vector11
vector11:
  pushl $11
80107bc8:	6a 0b                	push   $0xb
  jmp alltraps
80107bca:	e9 18 fa ff ff       	jmp    801075e7 <alltraps>

80107bcf <vector12>:
.globl vector12
vector12:
  pushl $12
80107bcf:	6a 0c                	push   $0xc
  jmp alltraps
80107bd1:	e9 11 fa ff ff       	jmp    801075e7 <alltraps>

80107bd6 <vector13>:
.globl vector13
vector13:
  pushl $13
80107bd6:	6a 0d                	push   $0xd
  jmp alltraps
80107bd8:	e9 0a fa ff ff       	jmp    801075e7 <alltraps>

80107bdd <vector14>:
.globl vector14
vector14:
  pushl $14
80107bdd:	6a 0e                	push   $0xe
  jmp alltraps
80107bdf:	e9 03 fa ff ff       	jmp    801075e7 <alltraps>

80107be4 <vector15>:
.globl vector15
vector15:
  pushl $0
80107be4:	6a 00                	push   $0x0
  pushl $15
80107be6:	6a 0f                	push   $0xf
  jmp alltraps
80107be8:	e9 fa f9 ff ff       	jmp    801075e7 <alltraps>

80107bed <vector16>:
.globl vector16
vector16:
  pushl $0
80107bed:	6a 00                	push   $0x0
  pushl $16
80107bef:	6a 10                	push   $0x10
  jmp alltraps
80107bf1:	e9 f1 f9 ff ff       	jmp    801075e7 <alltraps>

80107bf6 <vector17>:
.globl vector17
vector17:
  pushl $17
80107bf6:	6a 11                	push   $0x11
  jmp alltraps
80107bf8:	e9 ea f9 ff ff       	jmp    801075e7 <alltraps>

80107bfd <vector18>:
.globl vector18
vector18:
  pushl $0
80107bfd:	6a 00                	push   $0x0
  pushl $18
80107bff:	6a 12                	push   $0x12
  jmp alltraps
80107c01:	e9 e1 f9 ff ff       	jmp    801075e7 <alltraps>

80107c06 <vector19>:
.globl vector19
vector19:
  pushl $0
80107c06:	6a 00                	push   $0x0
  pushl $19
80107c08:	6a 13                	push   $0x13
  jmp alltraps
80107c0a:	e9 d8 f9 ff ff       	jmp    801075e7 <alltraps>

80107c0f <vector20>:
.globl vector20
vector20:
  pushl $0
80107c0f:	6a 00                	push   $0x0
  pushl $20
80107c11:	6a 14                	push   $0x14
  jmp alltraps
80107c13:	e9 cf f9 ff ff       	jmp    801075e7 <alltraps>

80107c18 <vector21>:
.globl vector21
vector21:
  pushl $0
80107c18:	6a 00                	push   $0x0
  pushl $21
80107c1a:	6a 15                	push   $0x15
  jmp alltraps
80107c1c:	e9 c6 f9 ff ff       	jmp    801075e7 <alltraps>

80107c21 <vector22>:
.globl vector22
vector22:
  pushl $0
80107c21:	6a 00                	push   $0x0
  pushl $22
80107c23:	6a 16                	push   $0x16
  jmp alltraps
80107c25:	e9 bd f9 ff ff       	jmp    801075e7 <alltraps>

80107c2a <vector23>:
.globl vector23
vector23:
  pushl $0
80107c2a:	6a 00                	push   $0x0
  pushl $23
80107c2c:	6a 17                	push   $0x17
  jmp alltraps
80107c2e:	e9 b4 f9 ff ff       	jmp    801075e7 <alltraps>

80107c33 <vector24>:
.globl vector24
vector24:
  pushl $0
80107c33:	6a 00                	push   $0x0
  pushl $24
80107c35:	6a 18                	push   $0x18
  jmp alltraps
80107c37:	e9 ab f9 ff ff       	jmp    801075e7 <alltraps>

80107c3c <vector25>:
.globl vector25
vector25:
  pushl $0
80107c3c:	6a 00                	push   $0x0
  pushl $25
80107c3e:	6a 19                	push   $0x19
  jmp alltraps
80107c40:	e9 a2 f9 ff ff       	jmp    801075e7 <alltraps>

80107c45 <vector26>:
.globl vector26
vector26:
  pushl $0
80107c45:	6a 00                	push   $0x0
  pushl $26
80107c47:	6a 1a                	push   $0x1a
  jmp alltraps
80107c49:	e9 99 f9 ff ff       	jmp    801075e7 <alltraps>

80107c4e <vector27>:
.globl vector27
vector27:
  pushl $0
80107c4e:	6a 00                	push   $0x0
  pushl $27
80107c50:	6a 1b                	push   $0x1b
  jmp alltraps
80107c52:	e9 90 f9 ff ff       	jmp    801075e7 <alltraps>

80107c57 <vector28>:
.globl vector28
vector28:
  pushl $0
80107c57:	6a 00                	push   $0x0
  pushl $28
80107c59:	6a 1c                	push   $0x1c
  jmp alltraps
80107c5b:	e9 87 f9 ff ff       	jmp    801075e7 <alltraps>

80107c60 <vector29>:
.globl vector29
vector29:
  pushl $0
80107c60:	6a 00                	push   $0x0
  pushl $29
80107c62:	6a 1d                	push   $0x1d
  jmp alltraps
80107c64:	e9 7e f9 ff ff       	jmp    801075e7 <alltraps>

80107c69 <vector30>:
.globl vector30
vector30:
  pushl $0
80107c69:	6a 00                	push   $0x0
  pushl $30
80107c6b:	6a 1e                	push   $0x1e
  jmp alltraps
80107c6d:	e9 75 f9 ff ff       	jmp    801075e7 <alltraps>

80107c72 <vector31>:
.globl vector31
vector31:
  pushl $0
80107c72:	6a 00                	push   $0x0
  pushl $31
80107c74:	6a 1f                	push   $0x1f
  jmp alltraps
80107c76:	e9 6c f9 ff ff       	jmp    801075e7 <alltraps>

80107c7b <vector32>:
.globl vector32
vector32:
  pushl $0
80107c7b:	6a 00                	push   $0x0
  pushl $32
80107c7d:	6a 20                	push   $0x20
  jmp alltraps
80107c7f:	e9 63 f9 ff ff       	jmp    801075e7 <alltraps>

80107c84 <vector33>:
.globl vector33
vector33:
  pushl $0
80107c84:	6a 00                	push   $0x0
  pushl $33
80107c86:	6a 21                	push   $0x21
  jmp alltraps
80107c88:	e9 5a f9 ff ff       	jmp    801075e7 <alltraps>

80107c8d <vector34>:
.globl vector34
vector34:
  pushl $0
80107c8d:	6a 00                	push   $0x0
  pushl $34
80107c8f:	6a 22                	push   $0x22
  jmp alltraps
80107c91:	e9 51 f9 ff ff       	jmp    801075e7 <alltraps>

80107c96 <vector35>:
.globl vector35
vector35:
  pushl $0
80107c96:	6a 00                	push   $0x0
  pushl $35
80107c98:	6a 23                	push   $0x23
  jmp alltraps
80107c9a:	e9 48 f9 ff ff       	jmp    801075e7 <alltraps>

80107c9f <vector36>:
.globl vector36
vector36:
  pushl $0
80107c9f:	6a 00                	push   $0x0
  pushl $36
80107ca1:	6a 24                	push   $0x24
  jmp alltraps
80107ca3:	e9 3f f9 ff ff       	jmp    801075e7 <alltraps>

80107ca8 <vector37>:
.globl vector37
vector37:
  pushl $0
80107ca8:	6a 00                	push   $0x0
  pushl $37
80107caa:	6a 25                	push   $0x25
  jmp alltraps
80107cac:	e9 36 f9 ff ff       	jmp    801075e7 <alltraps>

80107cb1 <vector38>:
.globl vector38
vector38:
  pushl $0
80107cb1:	6a 00                	push   $0x0
  pushl $38
80107cb3:	6a 26                	push   $0x26
  jmp alltraps
80107cb5:	e9 2d f9 ff ff       	jmp    801075e7 <alltraps>

80107cba <vector39>:
.globl vector39
vector39:
  pushl $0
80107cba:	6a 00                	push   $0x0
  pushl $39
80107cbc:	6a 27                	push   $0x27
  jmp alltraps
80107cbe:	e9 24 f9 ff ff       	jmp    801075e7 <alltraps>

80107cc3 <vector40>:
.globl vector40
vector40:
  pushl $0
80107cc3:	6a 00                	push   $0x0
  pushl $40
80107cc5:	6a 28                	push   $0x28
  jmp alltraps
80107cc7:	e9 1b f9 ff ff       	jmp    801075e7 <alltraps>

80107ccc <vector41>:
.globl vector41
vector41:
  pushl $0
80107ccc:	6a 00                	push   $0x0
  pushl $41
80107cce:	6a 29                	push   $0x29
  jmp alltraps
80107cd0:	e9 12 f9 ff ff       	jmp    801075e7 <alltraps>

80107cd5 <vector42>:
.globl vector42
vector42:
  pushl $0
80107cd5:	6a 00                	push   $0x0
  pushl $42
80107cd7:	6a 2a                	push   $0x2a
  jmp alltraps
80107cd9:	e9 09 f9 ff ff       	jmp    801075e7 <alltraps>

80107cde <vector43>:
.globl vector43
vector43:
  pushl $0
80107cde:	6a 00                	push   $0x0
  pushl $43
80107ce0:	6a 2b                	push   $0x2b
  jmp alltraps
80107ce2:	e9 00 f9 ff ff       	jmp    801075e7 <alltraps>

80107ce7 <vector44>:
.globl vector44
vector44:
  pushl $0
80107ce7:	6a 00                	push   $0x0
  pushl $44
80107ce9:	6a 2c                	push   $0x2c
  jmp alltraps
80107ceb:	e9 f7 f8 ff ff       	jmp    801075e7 <alltraps>

80107cf0 <vector45>:
.globl vector45
vector45:
  pushl $0
80107cf0:	6a 00                	push   $0x0
  pushl $45
80107cf2:	6a 2d                	push   $0x2d
  jmp alltraps
80107cf4:	e9 ee f8 ff ff       	jmp    801075e7 <alltraps>

80107cf9 <vector46>:
.globl vector46
vector46:
  pushl $0
80107cf9:	6a 00                	push   $0x0
  pushl $46
80107cfb:	6a 2e                	push   $0x2e
  jmp alltraps
80107cfd:	e9 e5 f8 ff ff       	jmp    801075e7 <alltraps>

80107d02 <vector47>:
.globl vector47
vector47:
  pushl $0
80107d02:	6a 00                	push   $0x0
  pushl $47
80107d04:	6a 2f                	push   $0x2f
  jmp alltraps
80107d06:	e9 dc f8 ff ff       	jmp    801075e7 <alltraps>

80107d0b <vector48>:
.globl vector48
vector48:
  pushl $0
80107d0b:	6a 00                	push   $0x0
  pushl $48
80107d0d:	6a 30                	push   $0x30
  jmp alltraps
80107d0f:	e9 d3 f8 ff ff       	jmp    801075e7 <alltraps>

80107d14 <vector49>:
.globl vector49
vector49:
  pushl $0
80107d14:	6a 00                	push   $0x0
  pushl $49
80107d16:	6a 31                	push   $0x31
  jmp alltraps
80107d18:	e9 ca f8 ff ff       	jmp    801075e7 <alltraps>

80107d1d <vector50>:
.globl vector50
vector50:
  pushl $0
80107d1d:	6a 00                	push   $0x0
  pushl $50
80107d1f:	6a 32                	push   $0x32
  jmp alltraps
80107d21:	e9 c1 f8 ff ff       	jmp    801075e7 <alltraps>

80107d26 <vector51>:
.globl vector51
vector51:
  pushl $0
80107d26:	6a 00                	push   $0x0
  pushl $51
80107d28:	6a 33                	push   $0x33
  jmp alltraps
80107d2a:	e9 b8 f8 ff ff       	jmp    801075e7 <alltraps>

80107d2f <vector52>:
.globl vector52
vector52:
  pushl $0
80107d2f:	6a 00                	push   $0x0
  pushl $52
80107d31:	6a 34                	push   $0x34
  jmp alltraps
80107d33:	e9 af f8 ff ff       	jmp    801075e7 <alltraps>

80107d38 <vector53>:
.globl vector53
vector53:
  pushl $0
80107d38:	6a 00                	push   $0x0
  pushl $53
80107d3a:	6a 35                	push   $0x35
  jmp alltraps
80107d3c:	e9 a6 f8 ff ff       	jmp    801075e7 <alltraps>

80107d41 <vector54>:
.globl vector54
vector54:
  pushl $0
80107d41:	6a 00                	push   $0x0
  pushl $54
80107d43:	6a 36                	push   $0x36
  jmp alltraps
80107d45:	e9 9d f8 ff ff       	jmp    801075e7 <alltraps>

80107d4a <vector55>:
.globl vector55
vector55:
  pushl $0
80107d4a:	6a 00                	push   $0x0
  pushl $55
80107d4c:	6a 37                	push   $0x37
  jmp alltraps
80107d4e:	e9 94 f8 ff ff       	jmp    801075e7 <alltraps>

80107d53 <vector56>:
.globl vector56
vector56:
  pushl $0
80107d53:	6a 00                	push   $0x0
  pushl $56
80107d55:	6a 38                	push   $0x38
  jmp alltraps
80107d57:	e9 8b f8 ff ff       	jmp    801075e7 <alltraps>

80107d5c <vector57>:
.globl vector57
vector57:
  pushl $0
80107d5c:	6a 00                	push   $0x0
  pushl $57
80107d5e:	6a 39                	push   $0x39
  jmp alltraps
80107d60:	e9 82 f8 ff ff       	jmp    801075e7 <alltraps>

80107d65 <vector58>:
.globl vector58
vector58:
  pushl $0
80107d65:	6a 00                	push   $0x0
  pushl $58
80107d67:	6a 3a                	push   $0x3a
  jmp alltraps
80107d69:	e9 79 f8 ff ff       	jmp    801075e7 <alltraps>

80107d6e <vector59>:
.globl vector59
vector59:
  pushl $0
80107d6e:	6a 00                	push   $0x0
  pushl $59
80107d70:	6a 3b                	push   $0x3b
  jmp alltraps
80107d72:	e9 70 f8 ff ff       	jmp    801075e7 <alltraps>

80107d77 <vector60>:
.globl vector60
vector60:
  pushl $0
80107d77:	6a 00                	push   $0x0
  pushl $60
80107d79:	6a 3c                	push   $0x3c
  jmp alltraps
80107d7b:	e9 67 f8 ff ff       	jmp    801075e7 <alltraps>

80107d80 <vector61>:
.globl vector61
vector61:
  pushl $0
80107d80:	6a 00                	push   $0x0
  pushl $61
80107d82:	6a 3d                	push   $0x3d
  jmp alltraps
80107d84:	e9 5e f8 ff ff       	jmp    801075e7 <alltraps>

80107d89 <vector62>:
.globl vector62
vector62:
  pushl $0
80107d89:	6a 00                	push   $0x0
  pushl $62
80107d8b:	6a 3e                	push   $0x3e
  jmp alltraps
80107d8d:	e9 55 f8 ff ff       	jmp    801075e7 <alltraps>

80107d92 <vector63>:
.globl vector63
vector63:
  pushl $0
80107d92:	6a 00                	push   $0x0
  pushl $63
80107d94:	6a 3f                	push   $0x3f
  jmp alltraps
80107d96:	e9 4c f8 ff ff       	jmp    801075e7 <alltraps>

80107d9b <vector64>:
.globl vector64
vector64:
  pushl $0
80107d9b:	6a 00                	push   $0x0
  pushl $64
80107d9d:	6a 40                	push   $0x40
  jmp alltraps
80107d9f:	e9 43 f8 ff ff       	jmp    801075e7 <alltraps>

80107da4 <vector65>:
.globl vector65
vector65:
  pushl $0
80107da4:	6a 00                	push   $0x0
  pushl $65
80107da6:	6a 41                	push   $0x41
  jmp alltraps
80107da8:	e9 3a f8 ff ff       	jmp    801075e7 <alltraps>

80107dad <vector66>:
.globl vector66
vector66:
  pushl $0
80107dad:	6a 00                	push   $0x0
  pushl $66
80107daf:	6a 42                	push   $0x42
  jmp alltraps
80107db1:	e9 31 f8 ff ff       	jmp    801075e7 <alltraps>

80107db6 <vector67>:
.globl vector67
vector67:
  pushl $0
80107db6:	6a 00                	push   $0x0
  pushl $67
80107db8:	6a 43                	push   $0x43
  jmp alltraps
80107dba:	e9 28 f8 ff ff       	jmp    801075e7 <alltraps>

80107dbf <vector68>:
.globl vector68
vector68:
  pushl $0
80107dbf:	6a 00                	push   $0x0
  pushl $68
80107dc1:	6a 44                	push   $0x44
  jmp alltraps
80107dc3:	e9 1f f8 ff ff       	jmp    801075e7 <alltraps>

80107dc8 <vector69>:
.globl vector69
vector69:
  pushl $0
80107dc8:	6a 00                	push   $0x0
  pushl $69
80107dca:	6a 45                	push   $0x45
  jmp alltraps
80107dcc:	e9 16 f8 ff ff       	jmp    801075e7 <alltraps>

80107dd1 <vector70>:
.globl vector70
vector70:
  pushl $0
80107dd1:	6a 00                	push   $0x0
  pushl $70
80107dd3:	6a 46                	push   $0x46
  jmp alltraps
80107dd5:	e9 0d f8 ff ff       	jmp    801075e7 <alltraps>

80107dda <vector71>:
.globl vector71
vector71:
  pushl $0
80107dda:	6a 00                	push   $0x0
  pushl $71
80107ddc:	6a 47                	push   $0x47
  jmp alltraps
80107dde:	e9 04 f8 ff ff       	jmp    801075e7 <alltraps>

80107de3 <vector72>:
.globl vector72
vector72:
  pushl $0
80107de3:	6a 00                	push   $0x0
  pushl $72
80107de5:	6a 48                	push   $0x48
  jmp alltraps
80107de7:	e9 fb f7 ff ff       	jmp    801075e7 <alltraps>

80107dec <vector73>:
.globl vector73
vector73:
  pushl $0
80107dec:	6a 00                	push   $0x0
  pushl $73
80107dee:	6a 49                	push   $0x49
  jmp alltraps
80107df0:	e9 f2 f7 ff ff       	jmp    801075e7 <alltraps>

80107df5 <vector74>:
.globl vector74
vector74:
  pushl $0
80107df5:	6a 00                	push   $0x0
  pushl $74
80107df7:	6a 4a                	push   $0x4a
  jmp alltraps
80107df9:	e9 e9 f7 ff ff       	jmp    801075e7 <alltraps>

80107dfe <vector75>:
.globl vector75
vector75:
  pushl $0
80107dfe:	6a 00                	push   $0x0
  pushl $75
80107e00:	6a 4b                	push   $0x4b
  jmp alltraps
80107e02:	e9 e0 f7 ff ff       	jmp    801075e7 <alltraps>

80107e07 <vector76>:
.globl vector76
vector76:
  pushl $0
80107e07:	6a 00                	push   $0x0
  pushl $76
80107e09:	6a 4c                	push   $0x4c
  jmp alltraps
80107e0b:	e9 d7 f7 ff ff       	jmp    801075e7 <alltraps>

80107e10 <vector77>:
.globl vector77
vector77:
  pushl $0
80107e10:	6a 00                	push   $0x0
  pushl $77
80107e12:	6a 4d                	push   $0x4d
  jmp alltraps
80107e14:	e9 ce f7 ff ff       	jmp    801075e7 <alltraps>

80107e19 <vector78>:
.globl vector78
vector78:
  pushl $0
80107e19:	6a 00                	push   $0x0
  pushl $78
80107e1b:	6a 4e                	push   $0x4e
  jmp alltraps
80107e1d:	e9 c5 f7 ff ff       	jmp    801075e7 <alltraps>

80107e22 <vector79>:
.globl vector79
vector79:
  pushl $0
80107e22:	6a 00                	push   $0x0
  pushl $79
80107e24:	6a 4f                	push   $0x4f
  jmp alltraps
80107e26:	e9 bc f7 ff ff       	jmp    801075e7 <alltraps>

80107e2b <vector80>:
.globl vector80
vector80:
  pushl $0
80107e2b:	6a 00                	push   $0x0
  pushl $80
80107e2d:	6a 50                	push   $0x50
  jmp alltraps
80107e2f:	e9 b3 f7 ff ff       	jmp    801075e7 <alltraps>

80107e34 <vector81>:
.globl vector81
vector81:
  pushl $0
80107e34:	6a 00                	push   $0x0
  pushl $81
80107e36:	6a 51                	push   $0x51
  jmp alltraps
80107e38:	e9 aa f7 ff ff       	jmp    801075e7 <alltraps>

80107e3d <vector82>:
.globl vector82
vector82:
  pushl $0
80107e3d:	6a 00                	push   $0x0
  pushl $82
80107e3f:	6a 52                	push   $0x52
  jmp alltraps
80107e41:	e9 a1 f7 ff ff       	jmp    801075e7 <alltraps>

80107e46 <vector83>:
.globl vector83
vector83:
  pushl $0
80107e46:	6a 00                	push   $0x0
  pushl $83
80107e48:	6a 53                	push   $0x53
  jmp alltraps
80107e4a:	e9 98 f7 ff ff       	jmp    801075e7 <alltraps>

80107e4f <vector84>:
.globl vector84
vector84:
  pushl $0
80107e4f:	6a 00                	push   $0x0
  pushl $84
80107e51:	6a 54                	push   $0x54
  jmp alltraps
80107e53:	e9 8f f7 ff ff       	jmp    801075e7 <alltraps>

80107e58 <vector85>:
.globl vector85
vector85:
  pushl $0
80107e58:	6a 00                	push   $0x0
  pushl $85
80107e5a:	6a 55                	push   $0x55
  jmp alltraps
80107e5c:	e9 86 f7 ff ff       	jmp    801075e7 <alltraps>

80107e61 <vector86>:
.globl vector86
vector86:
  pushl $0
80107e61:	6a 00                	push   $0x0
  pushl $86
80107e63:	6a 56                	push   $0x56
  jmp alltraps
80107e65:	e9 7d f7 ff ff       	jmp    801075e7 <alltraps>

80107e6a <vector87>:
.globl vector87
vector87:
  pushl $0
80107e6a:	6a 00                	push   $0x0
  pushl $87
80107e6c:	6a 57                	push   $0x57
  jmp alltraps
80107e6e:	e9 74 f7 ff ff       	jmp    801075e7 <alltraps>

80107e73 <vector88>:
.globl vector88
vector88:
  pushl $0
80107e73:	6a 00                	push   $0x0
  pushl $88
80107e75:	6a 58                	push   $0x58
  jmp alltraps
80107e77:	e9 6b f7 ff ff       	jmp    801075e7 <alltraps>

80107e7c <vector89>:
.globl vector89
vector89:
  pushl $0
80107e7c:	6a 00                	push   $0x0
  pushl $89
80107e7e:	6a 59                	push   $0x59
  jmp alltraps
80107e80:	e9 62 f7 ff ff       	jmp    801075e7 <alltraps>

80107e85 <vector90>:
.globl vector90
vector90:
  pushl $0
80107e85:	6a 00                	push   $0x0
  pushl $90
80107e87:	6a 5a                	push   $0x5a
  jmp alltraps
80107e89:	e9 59 f7 ff ff       	jmp    801075e7 <alltraps>

80107e8e <vector91>:
.globl vector91
vector91:
  pushl $0
80107e8e:	6a 00                	push   $0x0
  pushl $91
80107e90:	6a 5b                	push   $0x5b
  jmp alltraps
80107e92:	e9 50 f7 ff ff       	jmp    801075e7 <alltraps>

80107e97 <vector92>:
.globl vector92
vector92:
  pushl $0
80107e97:	6a 00                	push   $0x0
  pushl $92
80107e99:	6a 5c                	push   $0x5c
  jmp alltraps
80107e9b:	e9 47 f7 ff ff       	jmp    801075e7 <alltraps>

80107ea0 <vector93>:
.globl vector93
vector93:
  pushl $0
80107ea0:	6a 00                	push   $0x0
  pushl $93
80107ea2:	6a 5d                	push   $0x5d
  jmp alltraps
80107ea4:	e9 3e f7 ff ff       	jmp    801075e7 <alltraps>

80107ea9 <vector94>:
.globl vector94
vector94:
  pushl $0
80107ea9:	6a 00                	push   $0x0
  pushl $94
80107eab:	6a 5e                	push   $0x5e
  jmp alltraps
80107ead:	e9 35 f7 ff ff       	jmp    801075e7 <alltraps>

80107eb2 <vector95>:
.globl vector95
vector95:
  pushl $0
80107eb2:	6a 00                	push   $0x0
  pushl $95
80107eb4:	6a 5f                	push   $0x5f
  jmp alltraps
80107eb6:	e9 2c f7 ff ff       	jmp    801075e7 <alltraps>

80107ebb <vector96>:
.globl vector96
vector96:
  pushl $0
80107ebb:	6a 00                	push   $0x0
  pushl $96
80107ebd:	6a 60                	push   $0x60
  jmp alltraps
80107ebf:	e9 23 f7 ff ff       	jmp    801075e7 <alltraps>

80107ec4 <vector97>:
.globl vector97
vector97:
  pushl $0
80107ec4:	6a 00                	push   $0x0
  pushl $97
80107ec6:	6a 61                	push   $0x61
  jmp alltraps
80107ec8:	e9 1a f7 ff ff       	jmp    801075e7 <alltraps>

80107ecd <vector98>:
.globl vector98
vector98:
  pushl $0
80107ecd:	6a 00                	push   $0x0
  pushl $98
80107ecf:	6a 62                	push   $0x62
  jmp alltraps
80107ed1:	e9 11 f7 ff ff       	jmp    801075e7 <alltraps>

80107ed6 <vector99>:
.globl vector99
vector99:
  pushl $0
80107ed6:	6a 00                	push   $0x0
  pushl $99
80107ed8:	6a 63                	push   $0x63
  jmp alltraps
80107eda:	e9 08 f7 ff ff       	jmp    801075e7 <alltraps>

80107edf <vector100>:
.globl vector100
vector100:
  pushl $0
80107edf:	6a 00                	push   $0x0
  pushl $100
80107ee1:	6a 64                	push   $0x64
  jmp alltraps
80107ee3:	e9 ff f6 ff ff       	jmp    801075e7 <alltraps>

80107ee8 <vector101>:
.globl vector101
vector101:
  pushl $0
80107ee8:	6a 00                	push   $0x0
  pushl $101
80107eea:	6a 65                	push   $0x65
  jmp alltraps
80107eec:	e9 f6 f6 ff ff       	jmp    801075e7 <alltraps>

80107ef1 <vector102>:
.globl vector102
vector102:
  pushl $0
80107ef1:	6a 00                	push   $0x0
  pushl $102
80107ef3:	6a 66                	push   $0x66
  jmp alltraps
80107ef5:	e9 ed f6 ff ff       	jmp    801075e7 <alltraps>

80107efa <vector103>:
.globl vector103
vector103:
  pushl $0
80107efa:	6a 00                	push   $0x0
  pushl $103
80107efc:	6a 67                	push   $0x67
  jmp alltraps
80107efe:	e9 e4 f6 ff ff       	jmp    801075e7 <alltraps>

80107f03 <vector104>:
.globl vector104
vector104:
  pushl $0
80107f03:	6a 00                	push   $0x0
  pushl $104
80107f05:	6a 68                	push   $0x68
  jmp alltraps
80107f07:	e9 db f6 ff ff       	jmp    801075e7 <alltraps>

80107f0c <vector105>:
.globl vector105
vector105:
  pushl $0
80107f0c:	6a 00                	push   $0x0
  pushl $105
80107f0e:	6a 69                	push   $0x69
  jmp alltraps
80107f10:	e9 d2 f6 ff ff       	jmp    801075e7 <alltraps>

80107f15 <vector106>:
.globl vector106
vector106:
  pushl $0
80107f15:	6a 00                	push   $0x0
  pushl $106
80107f17:	6a 6a                	push   $0x6a
  jmp alltraps
80107f19:	e9 c9 f6 ff ff       	jmp    801075e7 <alltraps>

80107f1e <vector107>:
.globl vector107
vector107:
  pushl $0
80107f1e:	6a 00                	push   $0x0
  pushl $107
80107f20:	6a 6b                	push   $0x6b
  jmp alltraps
80107f22:	e9 c0 f6 ff ff       	jmp    801075e7 <alltraps>

80107f27 <vector108>:
.globl vector108
vector108:
  pushl $0
80107f27:	6a 00                	push   $0x0
  pushl $108
80107f29:	6a 6c                	push   $0x6c
  jmp alltraps
80107f2b:	e9 b7 f6 ff ff       	jmp    801075e7 <alltraps>

80107f30 <vector109>:
.globl vector109
vector109:
  pushl $0
80107f30:	6a 00                	push   $0x0
  pushl $109
80107f32:	6a 6d                	push   $0x6d
  jmp alltraps
80107f34:	e9 ae f6 ff ff       	jmp    801075e7 <alltraps>

80107f39 <vector110>:
.globl vector110
vector110:
  pushl $0
80107f39:	6a 00                	push   $0x0
  pushl $110
80107f3b:	6a 6e                	push   $0x6e
  jmp alltraps
80107f3d:	e9 a5 f6 ff ff       	jmp    801075e7 <alltraps>

80107f42 <vector111>:
.globl vector111
vector111:
  pushl $0
80107f42:	6a 00                	push   $0x0
  pushl $111
80107f44:	6a 6f                	push   $0x6f
  jmp alltraps
80107f46:	e9 9c f6 ff ff       	jmp    801075e7 <alltraps>

80107f4b <vector112>:
.globl vector112
vector112:
  pushl $0
80107f4b:	6a 00                	push   $0x0
  pushl $112
80107f4d:	6a 70                	push   $0x70
  jmp alltraps
80107f4f:	e9 93 f6 ff ff       	jmp    801075e7 <alltraps>

80107f54 <vector113>:
.globl vector113
vector113:
  pushl $0
80107f54:	6a 00                	push   $0x0
  pushl $113
80107f56:	6a 71                	push   $0x71
  jmp alltraps
80107f58:	e9 8a f6 ff ff       	jmp    801075e7 <alltraps>

80107f5d <vector114>:
.globl vector114
vector114:
  pushl $0
80107f5d:	6a 00                	push   $0x0
  pushl $114
80107f5f:	6a 72                	push   $0x72
  jmp alltraps
80107f61:	e9 81 f6 ff ff       	jmp    801075e7 <alltraps>

80107f66 <vector115>:
.globl vector115
vector115:
  pushl $0
80107f66:	6a 00                	push   $0x0
  pushl $115
80107f68:	6a 73                	push   $0x73
  jmp alltraps
80107f6a:	e9 78 f6 ff ff       	jmp    801075e7 <alltraps>

80107f6f <vector116>:
.globl vector116
vector116:
  pushl $0
80107f6f:	6a 00                	push   $0x0
  pushl $116
80107f71:	6a 74                	push   $0x74
  jmp alltraps
80107f73:	e9 6f f6 ff ff       	jmp    801075e7 <alltraps>

80107f78 <vector117>:
.globl vector117
vector117:
  pushl $0
80107f78:	6a 00                	push   $0x0
  pushl $117
80107f7a:	6a 75                	push   $0x75
  jmp alltraps
80107f7c:	e9 66 f6 ff ff       	jmp    801075e7 <alltraps>

80107f81 <vector118>:
.globl vector118
vector118:
  pushl $0
80107f81:	6a 00                	push   $0x0
  pushl $118
80107f83:	6a 76                	push   $0x76
  jmp alltraps
80107f85:	e9 5d f6 ff ff       	jmp    801075e7 <alltraps>

80107f8a <vector119>:
.globl vector119
vector119:
  pushl $0
80107f8a:	6a 00                	push   $0x0
  pushl $119
80107f8c:	6a 77                	push   $0x77
  jmp alltraps
80107f8e:	e9 54 f6 ff ff       	jmp    801075e7 <alltraps>

80107f93 <vector120>:
.globl vector120
vector120:
  pushl $0
80107f93:	6a 00                	push   $0x0
  pushl $120
80107f95:	6a 78                	push   $0x78
  jmp alltraps
80107f97:	e9 4b f6 ff ff       	jmp    801075e7 <alltraps>

80107f9c <vector121>:
.globl vector121
vector121:
  pushl $0
80107f9c:	6a 00                	push   $0x0
  pushl $121
80107f9e:	6a 79                	push   $0x79
  jmp alltraps
80107fa0:	e9 42 f6 ff ff       	jmp    801075e7 <alltraps>

80107fa5 <vector122>:
.globl vector122
vector122:
  pushl $0
80107fa5:	6a 00                	push   $0x0
  pushl $122
80107fa7:	6a 7a                	push   $0x7a
  jmp alltraps
80107fa9:	e9 39 f6 ff ff       	jmp    801075e7 <alltraps>

80107fae <vector123>:
.globl vector123
vector123:
  pushl $0
80107fae:	6a 00                	push   $0x0
  pushl $123
80107fb0:	6a 7b                	push   $0x7b
  jmp alltraps
80107fb2:	e9 30 f6 ff ff       	jmp    801075e7 <alltraps>

80107fb7 <vector124>:
.globl vector124
vector124:
  pushl $0
80107fb7:	6a 00                	push   $0x0
  pushl $124
80107fb9:	6a 7c                	push   $0x7c
  jmp alltraps
80107fbb:	e9 27 f6 ff ff       	jmp    801075e7 <alltraps>

80107fc0 <vector125>:
.globl vector125
vector125:
  pushl $0
80107fc0:	6a 00                	push   $0x0
  pushl $125
80107fc2:	6a 7d                	push   $0x7d
  jmp alltraps
80107fc4:	e9 1e f6 ff ff       	jmp    801075e7 <alltraps>

80107fc9 <vector126>:
.globl vector126
vector126:
  pushl $0
80107fc9:	6a 00                	push   $0x0
  pushl $126
80107fcb:	6a 7e                	push   $0x7e
  jmp alltraps
80107fcd:	e9 15 f6 ff ff       	jmp    801075e7 <alltraps>

80107fd2 <vector127>:
.globl vector127
vector127:
  pushl $0
80107fd2:	6a 00                	push   $0x0
  pushl $127
80107fd4:	6a 7f                	push   $0x7f
  jmp alltraps
80107fd6:	e9 0c f6 ff ff       	jmp    801075e7 <alltraps>

80107fdb <vector128>:
.globl vector128
vector128:
  pushl $0
80107fdb:	6a 00                	push   $0x0
  pushl $128
80107fdd:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107fe2:	e9 00 f6 ff ff       	jmp    801075e7 <alltraps>

80107fe7 <vector129>:
.globl vector129
vector129:
  pushl $0
80107fe7:	6a 00                	push   $0x0
  pushl $129
80107fe9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107fee:	e9 f4 f5 ff ff       	jmp    801075e7 <alltraps>

80107ff3 <vector130>:
.globl vector130
vector130:
  pushl $0
80107ff3:	6a 00                	push   $0x0
  pushl $130
80107ff5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107ffa:	e9 e8 f5 ff ff       	jmp    801075e7 <alltraps>

80107fff <vector131>:
.globl vector131
vector131:
  pushl $0
80107fff:	6a 00                	push   $0x0
  pushl $131
80108001:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80108006:	e9 dc f5 ff ff       	jmp    801075e7 <alltraps>

8010800b <vector132>:
.globl vector132
vector132:
  pushl $0
8010800b:	6a 00                	push   $0x0
  pushl $132
8010800d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80108012:	e9 d0 f5 ff ff       	jmp    801075e7 <alltraps>

80108017 <vector133>:
.globl vector133
vector133:
  pushl $0
80108017:	6a 00                	push   $0x0
  pushl $133
80108019:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010801e:	e9 c4 f5 ff ff       	jmp    801075e7 <alltraps>

80108023 <vector134>:
.globl vector134
vector134:
  pushl $0
80108023:	6a 00                	push   $0x0
  pushl $134
80108025:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010802a:	e9 b8 f5 ff ff       	jmp    801075e7 <alltraps>

8010802f <vector135>:
.globl vector135
vector135:
  pushl $0
8010802f:	6a 00                	push   $0x0
  pushl $135
80108031:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80108036:	e9 ac f5 ff ff       	jmp    801075e7 <alltraps>

8010803b <vector136>:
.globl vector136
vector136:
  pushl $0
8010803b:	6a 00                	push   $0x0
  pushl $136
8010803d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80108042:	e9 a0 f5 ff ff       	jmp    801075e7 <alltraps>

80108047 <vector137>:
.globl vector137
vector137:
  pushl $0
80108047:	6a 00                	push   $0x0
  pushl $137
80108049:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010804e:	e9 94 f5 ff ff       	jmp    801075e7 <alltraps>

80108053 <vector138>:
.globl vector138
vector138:
  pushl $0
80108053:	6a 00                	push   $0x0
  pushl $138
80108055:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010805a:	e9 88 f5 ff ff       	jmp    801075e7 <alltraps>

8010805f <vector139>:
.globl vector139
vector139:
  pushl $0
8010805f:	6a 00                	push   $0x0
  pushl $139
80108061:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80108066:	e9 7c f5 ff ff       	jmp    801075e7 <alltraps>

8010806b <vector140>:
.globl vector140
vector140:
  pushl $0
8010806b:	6a 00                	push   $0x0
  pushl $140
8010806d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80108072:	e9 70 f5 ff ff       	jmp    801075e7 <alltraps>

80108077 <vector141>:
.globl vector141
vector141:
  pushl $0
80108077:	6a 00                	push   $0x0
  pushl $141
80108079:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010807e:	e9 64 f5 ff ff       	jmp    801075e7 <alltraps>

80108083 <vector142>:
.globl vector142
vector142:
  pushl $0
80108083:	6a 00                	push   $0x0
  pushl $142
80108085:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010808a:	e9 58 f5 ff ff       	jmp    801075e7 <alltraps>

8010808f <vector143>:
.globl vector143
vector143:
  pushl $0
8010808f:	6a 00                	push   $0x0
  pushl $143
80108091:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80108096:	e9 4c f5 ff ff       	jmp    801075e7 <alltraps>

8010809b <vector144>:
.globl vector144
vector144:
  pushl $0
8010809b:	6a 00                	push   $0x0
  pushl $144
8010809d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801080a2:	e9 40 f5 ff ff       	jmp    801075e7 <alltraps>

801080a7 <vector145>:
.globl vector145
vector145:
  pushl $0
801080a7:	6a 00                	push   $0x0
  pushl $145
801080a9:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801080ae:	e9 34 f5 ff ff       	jmp    801075e7 <alltraps>

801080b3 <vector146>:
.globl vector146
vector146:
  pushl $0
801080b3:	6a 00                	push   $0x0
  pushl $146
801080b5:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801080ba:	e9 28 f5 ff ff       	jmp    801075e7 <alltraps>

801080bf <vector147>:
.globl vector147
vector147:
  pushl $0
801080bf:	6a 00                	push   $0x0
  pushl $147
801080c1:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801080c6:	e9 1c f5 ff ff       	jmp    801075e7 <alltraps>

801080cb <vector148>:
.globl vector148
vector148:
  pushl $0
801080cb:	6a 00                	push   $0x0
  pushl $148
801080cd:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801080d2:	e9 10 f5 ff ff       	jmp    801075e7 <alltraps>

801080d7 <vector149>:
.globl vector149
vector149:
  pushl $0
801080d7:	6a 00                	push   $0x0
  pushl $149
801080d9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801080de:	e9 04 f5 ff ff       	jmp    801075e7 <alltraps>

801080e3 <vector150>:
.globl vector150
vector150:
  pushl $0
801080e3:	6a 00                	push   $0x0
  pushl $150
801080e5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801080ea:	e9 f8 f4 ff ff       	jmp    801075e7 <alltraps>

801080ef <vector151>:
.globl vector151
vector151:
  pushl $0
801080ef:	6a 00                	push   $0x0
  pushl $151
801080f1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801080f6:	e9 ec f4 ff ff       	jmp    801075e7 <alltraps>

801080fb <vector152>:
.globl vector152
vector152:
  pushl $0
801080fb:	6a 00                	push   $0x0
  pushl $152
801080fd:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80108102:	e9 e0 f4 ff ff       	jmp    801075e7 <alltraps>

80108107 <vector153>:
.globl vector153
vector153:
  pushl $0
80108107:	6a 00                	push   $0x0
  pushl $153
80108109:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010810e:	e9 d4 f4 ff ff       	jmp    801075e7 <alltraps>

80108113 <vector154>:
.globl vector154
vector154:
  pushl $0
80108113:	6a 00                	push   $0x0
  pushl $154
80108115:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010811a:	e9 c8 f4 ff ff       	jmp    801075e7 <alltraps>

8010811f <vector155>:
.globl vector155
vector155:
  pushl $0
8010811f:	6a 00                	push   $0x0
  pushl $155
80108121:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80108126:	e9 bc f4 ff ff       	jmp    801075e7 <alltraps>

8010812b <vector156>:
.globl vector156
vector156:
  pushl $0
8010812b:	6a 00                	push   $0x0
  pushl $156
8010812d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80108132:	e9 b0 f4 ff ff       	jmp    801075e7 <alltraps>

80108137 <vector157>:
.globl vector157
vector157:
  pushl $0
80108137:	6a 00                	push   $0x0
  pushl $157
80108139:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010813e:	e9 a4 f4 ff ff       	jmp    801075e7 <alltraps>

80108143 <vector158>:
.globl vector158
vector158:
  pushl $0
80108143:	6a 00                	push   $0x0
  pushl $158
80108145:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010814a:	e9 98 f4 ff ff       	jmp    801075e7 <alltraps>

8010814f <vector159>:
.globl vector159
vector159:
  pushl $0
8010814f:	6a 00                	push   $0x0
  pushl $159
80108151:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80108156:	e9 8c f4 ff ff       	jmp    801075e7 <alltraps>

8010815b <vector160>:
.globl vector160
vector160:
  pushl $0
8010815b:	6a 00                	push   $0x0
  pushl $160
8010815d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80108162:	e9 80 f4 ff ff       	jmp    801075e7 <alltraps>

80108167 <vector161>:
.globl vector161
vector161:
  pushl $0
80108167:	6a 00                	push   $0x0
  pushl $161
80108169:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010816e:	e9 74 f4 ff ff       	jmp    801075e7 <alltraps>

80108173 <vector162>:
.globl vector162
vector162:
  pushl $0
80108173:	6a 00                	push   $0x0
  pushl $162
80108175:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010817a:	e9 68 f4 ff ff       	jmp    801075e7 <alltraps>

8010817f <vector163>:
.globl vector163
vector163:
  pushl $0
8010817f:	6a 00                	push   $0x0
  pushl $163
80108181:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80108186:	e9 5c f4 ff ff       	jmp    801075e7 <alltraps>

8010818b <vector164>:
.globl vector164
vector164:
  pushl $0
8010818b:	6a 00                	push   $0x0
  pushl $164
8010818d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80108192:	e9 50 f4 ff ff       	jmp    801075e7 <alltraps>

80108197 <vector165>:
.globl vector165
vector165:
  pushl $0
80108197:	6a 00                	push   $0x0
  pushl $165
80108199:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010819e:	e9 44 f4 ff ff       	jmp    801075e7 <alltraps>

801081a3 <vector166>:
.globl vector166
vector166:
  pushl $0
801081a3:	6a 00                	push   $0x0
  pushl $166
801081a5:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801081aa:	e9 38 f4 ff ff       	jmp    801075e7 <alltraps>

801081af <vector167>:
.globl vector167
vector167:
  pushl $0
801081af:	6a 00                	push   $0x0
  pushl $167
801081b1:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801081b6:	e9 2c f4 ff ff       	jmp    801075e7 <alltraps>

801081bb <vector168>:
.globl vector168
vector168:
  pushl $0
801081bb:	6a 00                	push   $0x0
  pushl $168
801081bd:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801081c2:	e9 20 f4 ff ff       	jmp    801075e7 <alltraps>

801081c7 <vector169>:
.globl vector169
vector169:
  pushl $0
801081c7:	6a 00                	push   $0x0
  pushl $169
801081c9:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801081ce:	e9 14 f4 ff ff       	jmp    801075e7 <alltraps>

801081d3 <vector170>:
.globl vector170
vector170:
  pushl $0
801081d3:	6a 00                	push   $0x0
  pushl $170
801081d5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801081da:	e9 08 f4 ff ff       	jmp    801075e7 <alltraps>

801081df <vector171>:
.globl vector171
vector171:
  pushl $0
801081df:	6a 00                	push   $0x0
  pushl $171
801081e1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801081e6:	e9 fc f3 ff ff       	jmp    801075e7 <alltraps>

801081eb <vector172>:
.globl vector172
vector172:
  pushl $0
801081eb:	6a 00                	push   $0x0
  pushl $172
801081ed:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801081f2:	e9 f0 f3 ff ff       	jmp    801075e7 <alltraps>

801081f7 <vector173>:
.globl vector173
vector173:
  pushl $0
801081f7:	6a 00                	push   $0x0
  pushl $173
801081f9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801081fe:	e9 e4 f3 ff ff       	jmp    801075e7 <alltraps>

80108203 <vector174>:
.globl vector174
vector174:
  pushl $0
80108203:	6a 00                	push   $0x0
  pushl $174
80108205:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010820a:	e9 d8 f3 ff ff       	jmp    801075e7 <alltraps>

8010820f <vector175>:
.globl vector175
vector175:
  pushl $0
8010820f:	6a 00                	push   $0x0
  pushl $175
80108211:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80108216:	e9 cc f3 ff ff       	jmp    801075e7 <alltraps>

8010821b <vector176>:
.globl vector176
vector176:
  pushl $0
8010821b:	6a 00                	push   $0x0
  pushl $176
8010821d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80108222:	e9 c0 f3 ff ff       	jmp    801075e7 <alltraps>

80108227 <vector177>:
.globl vector177
vector177:
  pushl $0
80108227:	6a 00                	push   $0x0
  pushl $177
80108229:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010822e:	e9 b4 f3 ff ff       	jmp    801075e7 <alltraps>

80108233 <vector178>:
.globl vector178
vector178:
  pushl $0
80108233:	6a 00                	push   $0x0
  pushl $178
80108235:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010823a:	e9 a8 f3 ff ff       	jmp    801075e7 <alltraps>

8010823f <vector179>:
.globl vector179
vector179:
  pushl $0
8010823f:	6a 00                	push   $0x0
  pushl $179
80108241:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80108246:	e9 9c f3 ff ff       	jmp    801075e7 <alltraps>

8010824b <vector180>:
.globl vector180
vector180:
  pushl $0
8010824b:	6a 00                	push   $0x0
  pushl $180
8010824d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80108252:	e9 90 f3 ff ff       	jmp    801075e7 <alltraps>

80108257 <vector181>:
.globl vector181
vector181:
  pushl $0
80108257:	6a 00                	push   $0x0
  pushl $181
80108259:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010825e:	e9 84 f3 ff ff       	jmp    801075e7 <alltraps>

80108263 <vector182>:
.globl vector182
vector182:
  pushl $0
80108263:	6a 00                	push   $0x0
  pushl $182
80108265:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010826a:	e9 78 f3 ff ff       	jmp    801075e7 <alltraps>

8010826f <vector183>:
.globl vector183
vector183:
  pushl $0
8010826f:	6a 00                	push   $0x0
  pushl $183
80108271:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80108276:	e9 6c f3 ff ff       	jmp    801075e7 <alltraps>

8010827b <vector184>:
.globl vector184
vector184:
  pushl $0
8010827b:	6a 00                	push   $0x0
  pushl $184
8010827d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80108282:	e9 60 f3 ff ff       	jmp    801075e7 <alltraps>

80108287 <vector185>:
.globl vector185
vector185:
  pushl $0
80108287:	6a 00                	push   $0x0
  pushl $185
80108289:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010828e:	e9 54 f3 ff ff       	jmp    801075e7 <alltraps>

80108293 <vector186>:
.globl vector186
vector186:
  pushl $0
80108293:	6a 00                	push   $0x0
  pushl $186
80108295:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010829a:	e9 48 f3 ff ff       	jmp    801075e7 <alltraps>

8010829f <vector187>:
.globl vector187
vector187:
  pushl $0
8010829f:	6a 00                	push   $0x0
  pushl $187
801082a1:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801082a6:	e9 3c f3 ff ff       	jmp    801075e7 <alltraps>

801082ab <vector188>:
.globl vector188
vector188:
  pushl $0
801082ab:	6a 00                	push   $0x0
  pushl $188
801082ad:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801082b2:	e9 30 f3 ff ff       	jmp    801075e7 <alltraps>

801082b7 <vector189>:
.globl vector189
vector189:
  pushl $0
801082b7:	6a 00                	push   $0x0
  pushl $189
801082b9:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801082be:	e9 24 f3 ff ff       	jmp    801075e7 <alltraps>

801082c3 <vector190>:
.globl vector190
vector190:
  pushl $0
801082c3:	6a 00                	push   $0x0
  pushl $190
801082c5:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801082ca:	e9 18 f3 ff ff       	jmp    801075e7 <alltraps>

801082cf <vector191>:
.globl vector191
vector191:
  pushl $0
801082cf:	6a 00                	push   $0x0
  pushl $191
801082d1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801082d6:	e9 0c f3 ff ff       	jmp    801075e7 <alltraps>

801082db <vector192>:
.globl vector192
vector192:
  pushl $0
801082db:	6a 00                	push   $0x0
  pushl $192
801082dd:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801082e2:	e9 00 f3 ff ff       	jmp    801075e7 <alltraps>

801082e7 <vector193>:
.globl vector193
vector193:
  pushl $0
801082e7:	6a 00                	push   $0x0
  pushl $193
801082e9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801082ee:	e9 f4 f2 ff ff       	jmp    801075e7 <alltraps>

801082f3 <vector194>:
.globl vector194
vector194:
  pushl $0
801082f3:	6a 00                	push   $0x0
  pushl $194
801082f5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801082fa:	e9 e8 f2 ff ff       	jmp    801075e7 <alltraps>

801082ff <vector195>:
.globl vector195
vector195:
  pushl $0
801082ff:	6a 00                	push   $0x0
  pushl $195
80108301:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80108306:	e9 dc f2 ff ff       	jmp    801075e7 <alltraps>

8010830b <vector196>:
.globl vector196
vector196:
  pushl $0
8010830b:	6a 00                	push   $0x0
  pushl $196
8010830d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80108312:	e9 d0 f2 ff ff       	jmp    801075e7 <alltraps>

80108317 <vector197>:
.globl vector197
vector197:
  pushl $0
80108317:	6a 00                	push   $0x0
  pushl $197
80108319:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010831e:	e9 c4 f2 ff ff       	jmp    801075e7 <alltraps>

80108323 <vector198>:
.globl vector198
vector198:
  pushl $0
80108323:	6a 00                	push   $0x0
  pushl $198
80108325:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010832a:	e9 b8 f2 ff ff       	jmp    801075e7 <alltraps>

8010832f <vector199>:
.globl vector199
vector199:
  pushl $0
8010832f:	6a 00                	push   $0x0
  pushl $199
80108331:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80108336:	e9 ac f2 ff ff       	jmp    801075e7 <alltraps>

8010833b <vector200>:
.globl vector200
vector200:
  pushl $0
8010833b:	6a 00                	push   $0x0
  pushl $200
8010833d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80108342:	e9 a0 f2 ff ff       	jmp    801075e7 <alltraps>

80108347 <vector201>:
.globl vector201
vector201:
  pushl $0
80108347:	6a 00                	push   $0x0
  pushl $201
80108349:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010834e:	e9 94 f2 ff ff       	jmp    801075e7 <alltraps>

80108353 <vector202>:
.globl vector202
vector202:
  pushl $0
80108353:	6a 00                	push   $0x0
  pushl $202
80108355:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010835a:	e9 88 f2 ff ff       	jmp    801075e7 <alltraps>

8010835f <vector203>:
.globl vector203
vector203:
  pushl $0
8010835f:	6a 00                	push   $0x0
  pushl $203
80108361:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80108366:	e9 7c f2 ff ff       	jmp    801075e7 <alltraps>

8010836b <vector204>:
.globl vector204
vector204:
  pushl $0
8010836b:	6a 00                	push   $0x0
  pushl $204
8010836d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80108372:	e9 70 f2 ff ff       	jmp    801075e7 <alltraps>

80108377 <vector205>:
.globl vector205
vector205:
  pushl $0
80108377:	6a 00                	push   $0x0
  pushl $205
80108379:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010837e:	e9 64 f2 ff ff       	jmp    801075e7 <alltraps>

80108383 <vector206>:
.globl vector206
vector206:
  pushl $0
80108383:	6a 00                	push   $0x0
  pushl $206
80108385:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010838a:	e9 58 f2 ff ff       	jmp    801075e7 <alltraps>

8010838f <vector207>:
.globl vector207
vector207:
  pushl $0
8010838f:	6a 00                	push   $0x0
  pushl $207
80108391:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80108396:	e9 4c f2 ff ff       	jmp    801075e7 <alltraps>

8010839b <vector208>:
.globl vector208
vector208:
  pushl $0
8010839b:	6a 00                	push   $0x0
  pushl $208
8010839d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801083a2:	e9 40 f2 ff ff       	jmp    801075e7 <alltraps>

801083a7 <vector209>:
.globl vector209
vector209:
  pushl $0
801083a7:	6a 00                	push   $0x0
  pushl $209
801083a9:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801083ae:	e9 34 f2 ff ff       	jmp    801075e7 <alltraps>

801083b3 <vector210>:
.globl vector210
vector210:
  pushl $0
801083b3:	6a 00                	push   $0x0
  pushl $210
801083b5:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801083ba:	e9 28 f2 ff ff       	jmp    801075e7 <alltraps>

801083bf <vector211>:
.globl vector211
vector211:
  pushl $0
801083bf:	6a 00                	push   $0x0
  pushl $211
801083c1:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801083c6:	e9 1c f2 ff ff       	jmp    801075e7 <alltraps>

801083cb <vector212>:
.globl vector212
vector212:
  pushl $0
801083cb:	6a 00                	push   $0x0
  pushl $212
801083cd:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801083d2:	e9 10 f2 ff ff       	jmp    801075e7 <alltraps>

801083d7 <vector213>:
.globl vector213
vector213:
  pushl $0
801083d7:	6a 00                	push   $0x0
  pushl $213
801083d9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801083de:	e9 04 f2 ff ff       	jmp    801075e7 <alltraps>

801083e3 <vector214>:
.globl vector214
vector214:
  pushl $0
801083e3:	6a 00                	push   $0x0
  pushl $214
801083e5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801083ea:	e9 f8 f1 ff ff       	jmp    801075e7 <alltraps>

801083ef <vector215>:
.globl vector215
vector215:
  pushl $0
801083ef:	6a 00                	push   $0x0
  pushl $215
801083f1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801083f6:	e9 ec f1 ff ff       	jmp    801075e7 <alltraps>

801083fb <vector216>:
.globl vector216
vector216:
  pushl $0
801083fb:	6a 00                	push   $0x0
  pushl $216
801083fd:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80108402:	e9 e0 f1 ff ff       	jmp    801075e7 <alltraps>

80108407 <vector217>:
.globl vector217
vector217:
  pushl $0
80108407:	6a 00                	push   $0x0
  pushl $217
80108409:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010840e:	e9 d4 f1 ff ff       	jmp    801075e7 <alltraps>

80108413 <vector218>:
.globl vector218
vector218:
  pushl $0
80108413:	6a 00                	push   $0x0
  pushl $218
80108415:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010841a:	e9 c8 f1 ff ff       	jmp    801075e7 <alltraps>

8010841f <vector219>:
.globl vector219
vector219:
  pushl $0
8010841f:	6a 00                	push   $0x0
  pushl $219
80108421:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80108426:	e9 bc f1 ff ff       	jmp    801075e7 <alltraps>

8010842b <vector220>:
.globl vector220
vector220:
  pushl $0
8010842b:	6a 00                	push   $0x0
  pushl $220
8010842d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80108432:	e9 b0 f1 ff ff       	jmp    801075e7 <alltraps>

80108437 <vector221>:
.globl vector221
vector221:
  pushl $0
80108437:	6a 00                	push   $0x0
  pushl $221
80108439:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010843e:	e9 a4 f1 ff ff       	jmp    801075e7 <alltraps>

80108443 <vector222>:
.globl vector222
vector222:
  pushl $0
80108443:	6a 00                	push   $0x0
  pushl $222
80108445:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010844a:	e9 98 f1 ff ff       	jmp    801075e7 <alltraps>

8010844f <vector223>:
.globl vector223
vector223:
  pushl $0
8010844f:	6a 00                	push   $0x0
  pushl $223
80108451:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80108456:	e9 8c f1 ff ff       	jmp    801075e7 <alltraps>

8010845b <vector224>:
.globl vector224
vector224:
  pushl $0
8010845b:	6a 00                	push   $0x0
  pushl $224
8010845d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80108462:	e9 80 f1 ff ff       	jmp    801075e7 <alltraps>

80108467 <vector225>:
.globl vector225
vector225:
  pushl $0
80108467:	6a 00                	push   $0x0
  pushl $225
80108469:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010846e:	e9 74 f1 ff ff       	jmp    801075e7 <alltraps>

80108473 <vector226>:
.globl vector226
vector226:
  pushl $0
80108473:	6a 00                	push   $0x0
  pushl $226
80108475:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010847a:	e9 68 f1 ff ff       	jmp    801075e7 <alltraps>

8010847f <vector227>:
.globl vector227
vector227:
  pushl $0
8010847f:	6a 00                	push   $0x0
  pushl $227
80108481:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80108486:	e9 5c f1 ff ff       	jmp    801075e7 <alltraps>

8010848b <vector228>:
.globl vector228
vector228:
  pushl $0
8010848b:	6a 00                	push   $0x0
  pushl $228
8010848d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80108492:	e9 50 f1 ff ff       	jmp    801075e7 <alltraps>

80108497 <vector229>:
.globl vector229
vector229:
  pushl $0
80108497:	6a 00                	push   $0x0
  pushl $229
80108499:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010849e:	e9 44 f1 ff ff       	jmp    801075e7 <alltraps>

801084a3 <vector230>:
.globl vector230
vector230:
  pushl $0
801084a3:	6a 00                	push   $0x0
  pushl $230
801084a5:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801084aa:	e9 38 f1 ff ff       	jmp    801075e7 <alltraps>

801084af <vector231>:
.globl vector231
vector231:
  pushl $0
801084af:	6a 00                	push   $0x0
  pushl $231
801084b1:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801084b6:	e9 2c f1 ff ff       	jmp    801075e7 <alltraps>

801084bb <vector232>:
.globl vector232
vector232:
  pushl $0
801084bb:	6a 00                	push   $0x0
  pushl $232
801084bd:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801084c2:	e9 20 f1 ff ff       	jmp    801075e7 <alltraps>

801084c7 <vector233>:
.globl vector233
vector233:
  pushl $0
801084c7:	6a 00                	push   $0x0
  pushl $233
801084c9:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801084ce:	e9 14 f1 ff ff       	jmp    801075e7 <alltraps>

801084d3 <vector234>:
.globl vector234
vector234:
  pushl $0
801084d3:	6a 00                	push   $0x0
  pushl $234
801084d5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801084da:	e9 08 f1 ff ff       	jmp    801075e7 <alltraps>

801084df <vector235>:
.globl vector235
vector235:
  pushl $0
801084df:	6a 00                	push   $0x0
  pushl $235
801084e1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801084e6:	e9 fc f0 ff ff       	jmp    801075e7 <alltraps>

801084eb <vector236>:
.globl vector236
vector236:
  pushl $0
801084eb:	6a 00                	push   $0x0
  pushl $236
801084ed:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801084f2:	e9 f0 f0 ff ff       	jmp    801075e7 <alltraps>

801084f7 <vector237>:
.globl vector237
vector237:
  pushl $0
801084f7:	6a 00                	push   $0x0
  pushl $237
801084f9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801084fe:	e9 e4 f0 ff ff       	jmp    801075e7 <alltraps>

80108503 <vector238>:
.globl vector238
vector238:
  pushl $0
80108503:	6a 00                	push   $0x0
  pushl $238
80108505:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010850a:	e9 d8 f0 ff ff       	jmp    801075e7 <alltraps>

8010850f <vector239>:
.globl vector239
vector239:
  pushl $0
8010850f:	6a 00                	push   $0x0
  pushl $239
80108511:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80108516:	e9 cc f0 ff ff       	jmp    801075e7 <alltraps>

8010851b <vector240>:
.globl vector240
vector240:
  pushl $0
8010851b:	6a 00                	push   $0x0
  pushl $240
8010851d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80108522:	e9 c0 f0 ff ff       	jmp    801075e7 <alltraps>

80108527 <vector241>:
.globl vector241
vector241:
  pushl $0
80108527:	6a 00                	push   $0x0
  pushl $241
80108529:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010852e:	e9 b4 f0 ff ff       	jmp    801075e7 <alltraps>

80108533 <vector242>:
.globl vector242
vector242:
  pushl $0
80108533:	6a 00                	push   $0x0
  pushl $242
80108535:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010853a:	e9 a8 f0 ff ff       	jmp    801075e7 <alltraps>

8010853f <vector243>:
.globl vector243
vector243:
  pushl $0
8010853f:	6a 00                	push   $0x0
  pushl $243
80108541:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80108546:	e9 9c f0 ff ff       	jmp    801075e7 <alltraps>

8010854b <vector244>:
.globl vector244
vector244:
  pushl $0
8010854b:	6a 00                	push   $0x0
  pushl $244
8010854d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80108552:	e9 90 f0 ff ff       	jmp    801075e7 <alltraps>

80108557 <vector245>:
.globl vector245
vector245:
  pushl $0
80108557:	6a 00                	push   $0x0
  pushl $245
80108559:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010855e:	e9 84 f0 ff ff       	jmp    801075e7 <alltraps>

80108563 <vector246>:
.globl vector246
vector246:
  pushl $0
80108563:	6a 00                	push   $0x0
  pushl $246
80108565:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010856a:	e9 78 f0 ff ff       	jmp    801075e7 <alltraps>

8010856f <vector247>:
.globl vector247
vector247:
  pushl $0
8010856f:	6a 00                	push   $0x0
  pushl $247
80108571:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80108576:	e9 6c f0 ff ff       	jmp    801075e7 <alltraps>

8010857b <vector248>:
.globl vector248
vector248:
  pushl $0
8010857b:	6a 00                	push   $0x0
  pushl $248
8010857d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80108582:	e9 60 f0 ff ff       	jmp    801075e7 <alltraps>

80108587 <vector249>:
.globl vector249
vector249:
  pushl $0
80108587:	6a 00                	push   $0x0
  pushl $249
80108589:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010858e:	e9 54 f0 ff ff       	jmp    801075e7 <alltraps>

80108593 <vector250>:
.globl vector250
vector250:
  pushl $0
80108593:	6a 00                	push   $0x0
  pushl $250
80108595:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010859a:	e9 48 f0 ff ff       	jmp    801075e7 <alltraps>

8010859f <vector251>:
.globl vector251
vector251:
  pushl $0
8010859f:	6a 00                	push   $0x0
  pushl $251
801085a1:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801085a6:	e9 3c f0 ff ff       	jmp    801075e7 <alltraps>

801085ab <vector252>:
.globl vector252
vector252:
  pushl $0
801085ab:	6a 00                	push   $0x0
  pushl $252
801085ad:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801085b2:	e9 30 f0 ff ff       	jmp    801075e7 <alltraps>

801085b7 <vector253>:
.globl vector253
vector253:
  pushl $0
801085b7:	6a 00                	push   $0x0
  pushl $253
801085b9:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801085be:	e9 24 f0 ff ff       	jmp    801075e7 <alltraps>

801085c3 <vector254>:
.globl vector254
vector254:
  pushl $0
801085c3:	6a 00                	push   $0x0
  pushl $254
801085c5:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801085ca:	e9 18 f0 ff ff       	jmp    801075e7 <alltraps>

801085cf <vector255>:
.globl vector255
vector255:
  pushl $0
801085cf:	6a 00                	push   $0x0
  pushl $255
801085d1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801085d6:	e9 0c f0 ff ff       	jmp    801075e7 <alltraps>
801085db:	66 90                	xchg   %ax,%ax
801085dd:	66 90                	xchg   %ax,%ax
801085df:	90                   	nop

801085e0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801085e0:	55                   	push   %ebp
801085e1:	89 e5                	mov    %esp,%ebp
801085e3:	57                   	push   %edi
801085e4:	56                   	push   %esi
801085e5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801085e7:	c1 ea 16             	shr    $0x16,%edx
{
801085ea:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
801085eb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
801085ee:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801085f1:	8b 1f                	mov    (%edi),%ebx
801085f3:	f6 c3 01             	test   $0x1,%bl
801085f6:	74 28                	je     80108620 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801085f8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801085fe:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80108604:	89 f0                	mov    %esi,%eax
}
80108606:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80108609:	c1 e8 0a             	shr    $0xa,%eax
8010860c:	25 fc 0f 00 00       	and    $0xffc,%eax
80108611:	01 d8                	add    %ebx,%eax
}
80108613:	5b                   	pop    %ebx
80108614:	5e                   	pop    %esi
80108615:	5f                   	pop    %edi
80108616:	5d                   	pop    %ebp
80108617:	c3                   	ret    
80108618:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010861f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80108620:	85 c9                	test   %ecx,%ecx
80108622:	74 2c                	je     80108650 <walkpgdir+0x70>
80108624:	e8 77 a5 ff ff       	call   80102ba0 <kalloc>
80108629:	89 c3                	mov    %eax,%ebx
8010862b:	85 c0                	test   %eax,%eax
8010862d:	74 21                	je     80108650 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010862f:	83 ec 04             	sub    $0x4,%esp
80108632:	68 00 10 00 00       	push   $0x1000
80108637:	6a 00                	push   $0x0
80108639:	50                   	push   %eax
8010863a:	e8 81 d7 ff ff       	call   80105dc0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010863f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80108645:	83 c4 10             	add    $0x10,%esp
80108648:	83 c8 07             	or     $0x7,%eax
8010864b:	89 07                	mov    %eax,(%edi)
8010864d:	eb b5                	jmp    80108604 <walkpgdir+0x24>
8010864f:	90                   	nop
}
80108650:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80108653:	31 c0                	xor    %eax,%eax
}
80108655:	5b                   	pop    %ebx
80108656:	5e                   	pop    %esi
80108657:	5f                   	pop    %edi
80108658:	5d                   	pop    %ebp
80108659:	c3                   	ret    
8010865a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108660 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80108660:	55                   	push   %ebp
80108661:	89 e5                	mov    %esp,%ebp
80108663:	57                   	push   %edi
80108664:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108666:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
8010866a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010866b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80108670:	89 d6                	mov    %edx,%esi
{
80108672:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80108673:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80108679:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010867c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010867f:	8b 45 08             	mov    0x8(%ebp),%eax
80108682:	29 f0                	sub    %esi,%eax
80108684:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108687:	eb 1f                	jmp    801086a8 <mappages+0x48>
80108689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80108690:	f6 00 01             	testb  $0x1,(%eax)
80108693:	75 45                	jne    801086da <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80108695:	0b 5d 0c             	or     0xc(%ebp),%ebx
80108698:	83 cb 01             	or     $0x1,%ebx
8010869b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010869d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801086a0:	74 2e                	je     801086d0 <mappages+0x70>
      break;
    a += PGSIZE;
801086a2:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
801086a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801086ab:	b9 01 00 00 00       	mov    $0x1,%ecx
801086b0:	89 f2                	mov    %esi,%edx
801086b2:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
801086b5:	89 f8                	mov    %edi,%eax
801086b7:	e8 24 ff ff ff       	call   801085e0 <walkpgdir>
801086bc:	85 c0                	test   %eax,%eax
801086be:	75 d0                	jne    80108690 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801086c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801086c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801086c8:	5b                   	pop    %ebx
801086c9:	5e                   	pop    %esi
801086ca:	5f                   	pop    %edi
801086cb:	5d                   	pop    %ebp
801086cc:	c3                   	ret    
801086cd:	8d 76 00             	lea    0x0(%esi),%esi
801086d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801086d3:	31 c0                	xor    %eax,%eax
}
801086d5:	5b                   	pop    %ebx
801086d6:	5e                   	pop    %esi
801086d7:	5f                   	pop    %edi
801086d8:	5d                   	pop    %ebp
801086d9:	c3                   	ret    
      panic("remap");
801086da:	83 ec 0c             	sub    $0xc,%esp
801086dd:	68 7c a8 10 80       	push   $0x8010a87c
801086e2:	e8 a9 7c ff ff       	call   80100390 <panic>
801086e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801086ee:	66 90                	xchg   %ax,%ax

801086f0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801086f0:	55                   	push   %ebp
801086f1:	89 e5                	mov    %esp,%ebp
801086f3:	57                   	push   %edi
801086f4:	56                   	push   %esi
801086f5:	89 c6                	mov    %eax,%esi
801086f7:	53                   	push   %ebx
801086f8:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801086fa:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80108700:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80108706:	83 ec 1c             	sub    $0x1c,%esp
80108709:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010870c:	39 da                	cmp    %ebx,%edx
8010870e:	73 5b                	jae    8010876b <deallocuvm.part.0+0x7b>
80108710:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80108713:	89 d7                	mov    %edx,%edi
80108715:	eb 14                	jmp    8010872b <deallocuvm.part.0+0x3b>
80108717:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010871e:	66 90                	xchg   %ax,%ax
80108720:	81 c7 00 10 00 00    	add    $0x1000,%edi
80108726:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80108729:	76 40                	jbe    8010876b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010872b:	31 c9                	xor    %ecx,%ecx
8010872d:	89 fa                	mov    %edi,%edx
8010872f:	89 f0                	mov    %esi,%eax
80108731:	e8 aa fe ff ff       	call   801085e0 <walkpgdir>
80108736:	89 c3                	mov    %eax,%ebx
    if(!pte)
80108738:	85 c0                	test   %eax,%eax
8010873a:	74 44                	je     80108780 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
8010873c:	8b 00                	mov    (%eax),%eax
8010873e:	a8 01                	test   $0x1,%al
80108740:	74 de                	je     80108720 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80108742:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108747:	74 47                	je     80108790 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80108749:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010874c:	05 00 00 00 80       	add    $0x80000000,%eax
80108751:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80108757:	50                   	push   %eax
80108758:	e8 83 a2 ff ff       	call   801029e0 <kfree>
      *pte = 0;
8010875d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80108763:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80108766:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80108769:	77 c0                	ja     8010872b <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
8010876b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010876e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108771:	5b                   	pop    %ebx
80108772:	5e                   	pop    %esi
80108773:	5f                   	pop    %edi
80108774:	5d                   	pop    %ebp
80108775:	c3                   	ret    
80108776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010877d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80108780:	89 fa                	mov    %edi,%edx
80108782:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80108788:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
8010878e:	eb 96                	jmp    80108726 <deallocuvm.part.0+0x36>
        panic("kfree");
80108790:	83 ec 0c             	sub    $0xc,%esp
80108793:	68 de 9e 10 80       	push   $0x80109ede
80108798:	e8 f3 7b ff ff       	call   80100390 <panic>
8010879d:	8d 76 00             	lea    0x0(%esi),%esi

801087a0 <seginit>:
{
801087a0:	f3 0f 1e fb          	endbr32 
801087a4:	55                   	push   %ebp
801087a5:	89 e5                	mov    %esp,%ebp
801087a7:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801087aa:	e8 71 b7 ff ff       	call   80103f20 <cpuid>
  pd[0] = size-1;
801087af:	ba 2f 00 00 00       	mov    $0x2f,%edx
801087b4:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
801087ba:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801087be:	c7 80 18 5e 11 80 ff 	movl   $0xffff,-0x7feea1e8(%eax)
801087c5:	ff 00 00 
801087c8:	c7 80 1c 5e 11 80 00 	movl   $0xcf9a00,-0x7feea1e4(%eax)
801087cf:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801087d2:	c7 80 20 5e 11 80 ff 	movl   $0xffff,-0x7feea1e0(%eax)
801087d9:	ff 00 00 
801087dc:	c7 80 24 5e 11 80 00 	movl   $0xcf9200,-0x7feea1dc(%eax)
801087e3:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801087e6:	c7 80 28 5e 11 80 ff 	movl   $0xffff,-0x7feea1d8(%eax)
801087ed:	ff 00 00 
801087f0:	c7 80 2c 5e 11 80 00 	movl   $0xcffa00,-0x7feea1d4(%eax)
801087f7:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801087fa:	c7 80 30 5e 11 80 ff 	movl   $0xffff,-0x7feea1d0(%eax)
80108801:	ff 00 00 
80108804:	c7 80 34 5e 11 80 00 	movl   $0xcff200,-0x7feea1cc(%eax)
8010880b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010880e:	05 10 5e 11 80       	add    $0x80115e10,%eax
  pd[1] = (uint)p;
80108813:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80108817:	c1 e8 10             	shr    $0x10,%eax
8010881a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010881e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80108821:	0f 01 10             	lgdtl  (%eax)
}
80108824:	c9                   	leave  
80108825:	c3                   	ret    
80108826:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010882d:	8d 76 00             	lea    0x0(%esi),%esi

80108830 <switchkvm>:
{
80108830:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108834:	a1 00 d7 12 80       	mov    0x8012d700,%eax
80108839:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010883e:	0f 22 d8             	mov    %eax,%cr3
}
80108841:	c3                   	ret    
80108842:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108850 <switchuvm>:
{
80108850:	f3 0f 1e fb          	endbr32 
80108854:	55                   	push   %ebp
80108855:	89 e5                	mov    %esp,%ebp
80108857:	57                   	push   %edi
80108858:	56                   	push   %esi
80108859:	53                   	push   %ebx
8010885a:	83 ec 1c             	sub    $0x1c,%esp
8010885d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80108860:	85 f6                	test   %esi,%esi
80108862:	0f 84 cb 00 00 00    	je     80108933 <switchuvm+0xe3>
  if(p->kstack == 0)
80108868:	8b 46 08             	mov    0x8(%esi),%eax
8010886b:	85 c0                	test   %eax,%eax
8010886d:	0f 84 da 00 00 00    	je     8010894d <switchuvm+0xfd>
  if(p->pgdir == 0)
80108873:	8b 46 04             	mov    0x4(%esi),%eax
80108876:	85 c0                	test   %eax,%eax
80108878:	0f 84 c2 00 00 00    	je     80108940 <switchuvm+0xf0>
  pushcli();
8010887e:	e8 2d d3 ff ff       	call   80105bb0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80108883:	e8 28 b6 ff ff       	call   80103eb0 <mycpu>
80108888:	89 c3                	mov    %eax,%ebx
8010888a:	e8 21 b6 ff ff       	call   80103eb0 <mycpu>
8010888f:	89 c7                	mov    %eax,%edi
80108891:	e8 1a b6 ff ff       	call   80103eb0 <mycpu>
80108896:	83 c7 08             	add    $0x8,%edi
80108899:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010889c:	e8 0f b6 ff ff       	call   80103eb0 <mycpu>
801088a1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801088a4:	ba 67 00 00 00       	mov    $0x67,%edx
801088a9:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801088b0:	83 c0 08             	add    $0x8,%eax
801088b3:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801088ba:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801088bf:	83 c1 08             	add    $0x8,%ecx
801088c2:	c1 e8 18             	shr    $0x18,%eax
801088c5:	c1 e9 10             	shr    $0x10,%ecx
801088c8:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801088ce:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801088d4:	b9 99 40 00 00       	mov    $0x4099,%ecx
801088d9:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801088e0:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801088e5:	e8 c6 b5 ff ff       	call   80103eb0 <mycpu>
801088ea:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801088f1:	e8 ba b5 ff ff       	call   80103eb0 <mycpu>
801088f6:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801088fa:	8b 5e 08             	mov    0x8(%esi),%ebx
801088fd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108903:	e8 a8 b5 ff ff       	call   80103eb0 <mycpu>
80108908:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010890b:	e8 a0 b5 ff ff       	call   80103eb0 <mycpu>
80108910:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80108914:	b8 28 00 00 00       	mov    $0x28,%eax
80108919:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010891c:	8b 46 04             	mov    0x4(%esi),%eax
8010891f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108924:	0f 22 d8             	mov    %eax,%cr3
}
80108927:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010892a:	5b                   	pop    %ebx
8010892b:	5e                   	pop    %esi
8010892c:	5f                   	pop    %edi
8010892d:	5d                   	pop    %ebp
  popcli();
8010892e:	e9 cd d2 ff ff       	jmp    80105c00 <popcli>
    panic("switchuvm: no process");
80108933:	83 ec 0c             	sub    $0xc,%esp
80108936:	68 82 a8 10 80       	push   $0x8010a882
8010893b:	e8 50 7a ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80108940:	83 ec 0c             	sub    $0xc,%esp
80108943:	68 ad a8 10 80       	push   $0x8010a8ad
80108948:	e8 43 7a ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
8010894d:	83 ec 0c             	sub    $0xc,%esp
80108950:	68 98 a8 10 80       	push   $0x8010a898
80108955:	e8 36 7a ff ff       	call   80100390 <panic>
8010895a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108960 <inituvm>:
{
80108960:	f3 0f 1e fb          	endbr32 
80108964:	55                   	push   %ebp
80108965:	89 e5                	mov    %esp,%ebp
80108967:	57                   	push   %edi
80108968:	56                   	push   %esi
80108969:	53                   	push   %ebx
8010896a:	83 ec 1c             	sub    $0x1c,%esp
8010896d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108970:	8b 75 10             	mov    0x10(%ebp),%esi
80108973:	8b 7d 08             	mov    0x8(%ebp),%edi
80108976:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80108979:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010897f:	77 4b                	ja     801089cc <inituvm+0x6c>
  mem = kalloc();
80108981:	e8 1a a2 ff ff       	call   80102ba0 <kalloc>
  memset(mem, 0, PGSIZE);
80108986:	83 ec 04             	sub    $0x4,%esp
80108989:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010898e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80108990:	6a 00                	push   $0x0
80108992:	50                   	push   %eax
80108993:	e8 28 d4 ff ff       	call   80105dc0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80108998:	58                   	pop    %eax
80108999:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010899f:	5a                   	pop    %edx
801089a0:	6a 06                	push   $0x6
801089a2:	b9 00 10 00 00       	mov    $0x1000,%ecx
801089a7:	31 d2                	xor    %edx,%edx
801089a9:	50                   	push   %eax
801089aa:	89 f8                	mov    %edi,%eax
801089ac:	e8 af fc ff ff       	call   80108660 <mappages>
  memmove(mem, init, sz);
801089b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801089b4:	89 75 10             	mov    %esi,0x10(%ebp)
801089b7:	83 c4 10             	add    $0x10,%esp
801089ba:	89 5d 08             	mov    %ebx,0x8(%ebp)
801089bd:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801089c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801089c3:	5b                   	pop    %ebx
801089c4:	5e                   	pop    %esi
801089c5:	5f                   	pop    %edi
801089c6:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801089c7:	e9 94 d4 ff ff       	jmp    80105e60 <memmove>
    panic("inituvm: more than a page");
801089cc:	83 ec 0c             	sub    $0xc,%esp
801089cf:	68 c1 a8 10 80       	push   $0x8010a8c1
801089d4:	e8 b7 79 ff ff       	call   80100390 <panic>
801089d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801089e0 <loaduvm>:
{
801089e0:	f3 0f 1e fb          	endbr32 
801089e4:	55                   	push   %ebp
801089e5:	89 e5                	mov    %esp,%ebp
801089e7:	57                   	push   %edi
801089e8:	56                   	push   %esi
801089e9:	53                   	push   %ebx
801089ea:	83 ec 1c             	sub    $0x1c,%esp
801089ed:	8b 45 0c             	mov    0xc(%ebp),%eax
801089f0:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
801089f3:	a9 ff 0f 00 00       	test   $0xfff,%eax
801089f8:	0f 85 99 00 00 00    	jne    80108a97 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
801089fe:	01 f0                	add    %esi,%eax
80108a00:	89 f3                	mov    %esi,%ebx
80108a02:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108a05:	8b 45 14             	mov    0x14(%ebp),%eax
80108a08:	01 f0                	add    %esi,%eax
80108a0a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80108a0d:	85 f6                	test   %esi,%esi
80108a0f:	75 15                	jne    80108a26 <loaduvm+0x46>
80108a11:	eb 6d                	jmp    80108a80 <loaduvm+0xa0>
80108a13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108a17:	90                   	nop
80108a18:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80108a1e:	89 f0                	mov    %esi,%eax
80108a20:	29 d8                	sub    %ebx,%eax
80108a22:	39 c6                	cmp    %eax,%esi
80108a24:	76 5a                	jbe    80108a80 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108a26:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108a29:	8b 45 08             	mov    0x8(%ebp),%eax
80108a2c:	31 c9                	xor    %ecx,%ecx
80108a2e:	29 da                	sub    %ebx,%edx
80108a30:	e8 ab fb ff ff       	call   801085e0 <walkpgdir>
80108a35:	85 c0                	test   %eax,%eax
80108a37:	74 51                	je     80108a8a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80108a39:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108a3b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80108a3e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80108a43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80108a48:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80108a4e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108a51:	29 d9                	sub    %ebx,%ecx
80108a53:	05 00 00 00 80       	add    $0x80000000,%eax
80108a58:	57                   	push   %edi
80108a59:	51                   	push   %ecx
80108a5a:	50                   	push   %eax
80108a5b:	ff 75 10             	pushl  0x10(%ebp)
80108a5e:	e8 6d 95 ff ff       	call   80101fd0 <readi>
80108a63:	83 c4 10             	add    $0x10,%esp
80108a66:	39 f8                	cmp    %edi,%eax
80108a68:	74 ae                	je     80108a18 <loaduvm+0x38>
}
80108a6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108a6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108a72:	5b                   	pop    %ebx
80108a73:	5e                   	pop    %esi
80108a74:	5f                   	pop    %edi
80108a75:	5d                   	pop    %ebp
80108a76:	c3                   	ret    
80108a77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108a7e:	66 90                	xchg   %ax,%ax
80108a80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108a83:	31 c0                	xor    %eax,%eax
}
80108a85:	5b                   	pop    %ebx
80108a86:	5e                   	pop    %esi
80108a87:	5f                   	pop    %edi
80108a88:	5d                   	pop    %ebp
80108a89:	c3                   	ret    
      panic("loaduvm: address should exist");
80108a8a:	83 ec 0c             	sub    $0xc,%esp
80108a8d:	68 db a8 10 80       	push   $0x8010a8db
80108a92:	e8 f9 78 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80108a97:	83 ec 0c             	sub    $0xc,%esp
80108a9a:	68 8c a9 10 80       	push   $0x8010a98c
80108a9f:	e8 ec 78 ff ff       	call   80100390 <panic>
80108aa4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108aab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108aaf:	90                   	nop

80108ab0 <allocuvm>:
{
80108ab0:	f3 0f 1e fb          	endbr32 
80108ab4:	55                   	push   %ebp
80108ab5:	89 e5                	mov    %esp,%ebp
80108ab7:	57                   	push   %edi
80108ab8:	56                   	push   %esi
80108ab9:	53                   	push   %ebx
80108aba:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= HEAPLIMIT) // prev value: KERBASE
80108abd:	81 7d 10 ff ff ff 7e 	cmpl   $0x7effffff,0x10(%ebp)
{
80108ac4:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= HEAPLIMIT) // prev value: KERBASE
80108ac7:	0f 87 b3 00 00 00    	ja     80108b80 <allocuvm+0xd0>
  if(newsz < oldsz)
80108acd:	8b 45 0c             	mov    0xc(%ebp),%eax
80108ad0:	39 45 10             	cmp    %eax,0x10(%ebp)
80108ad3:	0f 82 a9 00 00 00    	jb     80108b82 <allocuvm+0xd2>
  a = PGROUNDUP(oldsz);
80108ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
80108adc:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80108ae2:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80108ae8:	39 75 10             	cmp    %esi,0x10(%ebp)
80108aeb:	0f 86 9f 00 00 00    	jbe    80108b90 <allocuvm+0xe0>
80108af1:	8b 45 10             	mov    0x10(%ebp),%eax
80108af4:	83 e8 01             	sub    $0x1,%eax
80108af7:	29 f0                	sub    %esi,%eax
80108af9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108afe:	8d 84 06 00 10 00 00 	lea    0x1000(%esi,%eax,1),%eax
80108b05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108b08:	eb 41                	jmp    80108b4b <allocuvm+0x9b>
80108b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80108b10:	83 ec 04             	sub    $0x4,%esp
80108b13:	68 00 10 00 00       	push   $0x1000
80108b18:	6a 00                	push   $0x0
80108b1a:	50                   	push   %eax
80108b1b:	e8 a0 d2 ff ff       	call   80105dc0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80108b20:	58                   	pop    %eax
80108b21:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80108b27:	5a                   	pop    %edx
80108b28:	6a 06                	push   $0x6
80108b2a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108b2f:	89 f2                	mov    %esi,%edx
80108b31:	50                   	push   %eax
80108b32:	89 f8                	mov    %edi,%eax
80108b34:	e8 27 fb ff ff       	call   80108660 <mappages>
80108b39:	83 c4 10             	add    $0x10,%esp
80108b3c:	85 c0                	test   %eax,%eax
80108b3e:	78 60                	js     80108ba0 <allocuvm+0xf0>
  for(; a < newsz; a += PGSIZE){
80108b40:	81 c6 00 10 00 00    	add    $0x1000,%esi
80108b46:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
80108b49:	74 45                	je     80108b90 <allocuvm+0xe0>
    mem = kalloc();
80108b4b:	e8 50 a0 ff ff       	call   80102ba0 <kalloc>
80108b50:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80108b52:	85 c0                	test   %eax,%eax
80108b54:	75 ba                	jne    80108b10 <allocuvm+0x60>
      cprintf("allocuvm out of memory\n");
80108b56:	83 ec 0c             	sub    $0xc,%esp
80108b59:	68 f9 a8 10 80       	push   $0x8010a8f9
80108b5e:	e8 5d 7d ff ff       	call   801008c0 <cprintf>
  if(newsz >= oldsz)
80108b63:	8b 45 0c             	mov    0xc(%ebp),%eax
80108b66:	83 c4 10             	add    $0x10,%esp
80108b69:	39 45 10             	cmp    %eax,0x10(%ebp)
80108b6c:	74 12                	je     80108b80 <allocuvm+0xd0>
80108b6e:	8b 55 10             	mov    0x10(%ebp),%edx
80108b71:	89 c1                	mov    %eax,%ecx
80108b73:	89 f8                	mov    %edi,%eax
80108b75:	e8 76 fb ff ff       	call   801086f0 <deallocuvm.part.0>
80108b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return 0;
80108b80:	31 c0                	xor    %eax,%eax
}
80108b82:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108b85:	5b                   	pop    %ebx
80108b86:	5e                   	pop    %esi
80108b87:	5f                   	pop    %edi
80108b88:	5d                   	pop    %ebp
80108b89:	c3                   	ret    
80108b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return newsz;
80108b90:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108b93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108b96:	5b                   	pop    %ebx
80108b97:	5e                   	pop    %esi
80108b98:	5f                   	pop    %edi
80108b99:	5d                   	pop    %ebp
80108b9a:	c3                   	ret    
80108b9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108b9f:	90                   	nop
      cprintf("allocuvm out of memory (2)\n");
80108ba0:	83 ec 0c             	sub    $0xc,%esp
80108ba3:	68 11 a9 10 80       	push   $0x8010a911
80108ba8:	e8 13 7d ff ff       	call   801008c0 <cprintf>
  if(newsz >= oldsz)
80108bad:	8b 45 0c             	mov    0xc(%ebp),%eax
80108bb0:	83 c4 10             	add    $0x10,%esp
80108bb3:	39 45 10             	cmp    %eax,0x10(%ebp)
80108bb6:	74 0c                	je     80108bc4 <allocuvm+0x114>
80108bb8:	8b 55 10             	mov    0x10(%ebp),%edx
80108bbb:	89 c1                	mov    %eax,%ecx
80108bbd:	89 f8                	mov    %edi,%eax
80108bbf:	e8 2c fb ff ff       	call   801086f0 <deallocuvm.part.0>
      kfree(mem);
80108bc4:	83 ec 0c             	sub    $0xc,%esp
80108bc7:	53                   	push   %ebx
80108bc8:	e8 13 9e ff ff       	call   801029e0 <kfree>
      return 0;
80108bcd:	83 c4 10             	add    $0x10,%esp
}
80108bd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80108bd3:	31 c0                	xor    %eax,%eax
}
80108bd5:	5b                   	pop    %ebx
80108bd6:	5e                   	pop    %esi
80108bd7:	5f                   	pop    %edi
80108bd8:	5d                   	pop    %ebp
80108bd9:	c3                   	ret    
80108bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108be0 <deallocuvm>:
{
80108be0:	f3 0f 1e fb          	endbr32 
80108be4:	55                   	push   %ebp
80108be5:	89 e5                	mov    %esp,%ebp
80108be7:	8b 55 0c             	mov    0xc(%ebp),%edx
80108bea:	8b 4d 10             	mov    0x10(%ebp),%ecx
80108bed:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80108bf0:	39 d1                	cmp    %edx,%ecx
80108bf2:	73 0c                	jae    80108c00 <deallocuvm+0x20>
}
80108bf4:	5d                   	pop    %ebp
80108bf5:	e9 f6 fa ff ff       	jmp    801086f0 <deallocuvm.part.0>
80108bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108c00:	89 d0                	mov    %edx,%eax
80108c02:	5d                   	pop    %ebp
80108c03:	c3                   	ret    
80108c04:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108c0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108c0f:	90                   	nop

80108c10 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108c10:	f3 0f 1e fb          	endbr32 
80108c14:	55                   	push   %ebp
80108c15:	89 e5                	mov    %esp,%ebp
80108c17:	57                   	push   %edi
80108c18:	56                   	push   %esi
80108c19:	53                   	push   %ebx
80108c1a:	83 ec 0c             	sub    $0xc,%esp
80108c1d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80108c20:	85 f6                	test   %esi,%esi
80108c22:	74 55                	je     80108c79 <freevm+0x69>
  if(newsz >= oldsz)
80108c24:	31 c9                	xor    %ecx,%ecx
80108c26:	ba 00 00 00 7f       	mov    $0x7f000000,%edx
80108c2b:	89 f0                	mov    %esi,%eax
80108c2d:	89 f3                	mov    %esi,%ebx
80108c2f:	e8 bc fa ff ff       	call   801086f0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  // deallocuvm(pgdir, KERNBASE, 0);
  deallocuvm(pgdir, HEAPLIMIT, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108c34:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80108c3a:	eb 0b                	jmp    80108c47 <freevm+0x37>
80108c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108c40:	83 c3 04             	add    $0x4,%ebx
80108c43:	39 df                	cmp    %ebx,%edi
80108c45:	74 23                	je     80108c6a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80108c47:	8b 03                	mov    (%ebx),%eax
80108c49:	a8 01                	test   $0x1,%al
80108c4b:	74 f3                	je     80108c40 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108c4d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80108c52:	83 ec 0c             	sub    $0xc,%esp
80108c55:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108c58:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80108c5d:	50                   	push   %eax
80108c5e:	e8 7d 9d ff ff       	call   801029e0 <kfree>
80108c63:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108c66:	39 df                	cmp    %ebx,%edi
80108c68:	75 dd                	jne    80108c47 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80108c6a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80108c6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108c70:	5b                   	pop    %ebx
80108c71:	5e                   	pop    %esi
80108c72:	5f                   	pop    %edi
80108c73:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80108c74:	e9 67 9d ff ff       	jmp    801029e0 <kfree>
    panic("freevm: no pgdir");
80108c79:	83 ec 0c             	sub    $0xc,%esp
80108c7c:	68 2d a9 10 80       	push   $0x8010a92d
80108c81:	e8 0a 77 ff ff       	call   80100390 <panic>
80108c86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108c8d:	8d 76 00             	lea    0x0(%esi),%esi

80108c90 <setupkvm>:
{
80108c90:	f3 0f 1e fb          	endbr32 
80108c94:	55                   	push   %ebp
80108c95:	89 e5                	mov    %esp,%ebp
80108c97:	56                   	push   %esi
80108c98:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80108c99:	e8 02 9f ff ff       	call   80102ba0 <kalloc>
80108c9e:	89 c6                	mov    %eax,%esi
80108ca0:	85 c0                	test   %eax,%eax
80108ca2:	74 42                	je     80108ce6 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80108ca4:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108ca7:	bb 20 d4 10 80       	mov    $0x8010d420,%ebx
  memset(pgdir, 0, PGSIZE);
80108cac:	68 00 10 00 00       	push   $0x1000
80108cb1:	6a 00                	push   $0x0
80108cb3:	50                   	push   %eax
80108cb4:	e8 07 d1 ff ff       	call   80105dc0 <memset>
80108cb9:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80108cbc:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80108cbf:	83 ec 08             	sub    $0x8,%esp
80108cc2:	8b 4b 08             	mov    0x8(%ebx),%ecx
80108cc5:	ff 73 0c             	pushl  0xc(%ebx)
80108cc8:	8b 13                	mov    (%ebx),%edx
80108cca:	50                   	push   %eax
80108ccb:	29 c1                	sub    %eax,%ecx
80108ccd:	89 f0                	mov    %esi,%eax
80108ccf:	e8 8c f9 ff ff       	call   80108660 <mappages>
80108cd4:	83 c4 10             	add    $0x10,%esp
80108cd7:	85 c0                	test   %eax,%eax
80108cd9:	78 15                	js     80108cf0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108cdb:	83 c3 10             	add    $0x10,%ebx
80108cde:	81 fb 60 d4 10 80    	cmp    $0x8010d460,%ebx
80108ce4:	75 d6                	jne    80108cbc <setupkvm+0x2c>
}
80108ce6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108ce9:	89 f0                	mov    %esi,%eax
80108ceb:	5b                   	pop    %ebx
80108cec:	5e                   	pop    %esi
80108ced:	5d                   	pop    %ebp
80108cee:	c3                   	ret    
80108cef:	90                   	nop
      freevm(pgdir);
80108cf0:	83 ec 0c             	sub    $0xc,%esp
80108cf3:	56                   	push   %esi
      return 0;
80108cf4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80108cf6:	e8 15 ff ff ff       	call   80108c10 <freevm>
      return 0;
80108cfb:	83 c4 10             	add    $0x10,%esp
}
80108cfe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108d01:	89 f0                	mov    %esi,%eax
80108d03:	5b                   	pop    %ebx
80108d04:	5e                   	pop    %esi
80108d05:	5d                   	pop    %ebp
80108d06:	c3                   	ret    
80108d07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108d0e:	66 90                	xchg   %ax,%ax

80108d10 <kvmalloc>:
{
80108d10:	f3 0f 1e fb          	endbr32 
80108d14:	55                   	push   %ebp
80108d15:	89 e5                	mov    %esp,%ebp
80108d17:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108d1a:	e8 71 ff ff ff       	call   80108c90 <setupkvm>
80108d1f:	a3 00 d7 12 80       	mov    %eax,0x8012d700
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108d24:	05 00 00 00 80       	add    $0x80000000,%eax
80108d29:	0f 22 d8             	mov    %eax,%cr3
}
80108d2c:	c9                   	leave  
80108d2d:	c3                   	ret    
80108d2e:	66 90                	xchg   %ax,%ax

80108d30 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108d30:	f3 0f 1e fb          	endbr32 
80108d34:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108d35:	31 c9                	xor    %ecx,%ecx
{
80108d37:	89 e5                	mov    %esp,%ebp
80108d39:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80108d3c:	8b 55 0c             	mov    0xc(%ebp),%edx
80108d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80108d42:	e8 99 f8 ff ff       	call   801085e0 <walkpgdir>
  if(pte == 0)
80108d47:	85 c0                	test   %eax,%eax
80108d49:	74 05                	je     80108d50 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
80108d4b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80108d4e:	c9                   	leave  
80108d4f:	c3                   	ret    
    panic("clearpteu");
80108d50:	83 ec 0c             	sub    $0xc,%esp
80108d53:	68 3e a9 10 80       	push   $0x8010a93e
80108d58:	e8 33 76 ff ff       	call   80100390 <panic>
80108d5d:	8d 76 00             	lea    0x0(%esi),%esi

80108d60 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108d60:	f3 0f 1e fb          	endbr32 
80108d64:	55                   	push   %ebp
80108d65:	89 e5                	mov    %esp,%ebp
80108d67:	57                   	push   %edi
80108d68:	56                   	push   %esi
80108d69:	53                   	push   %ebx
80108d6a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108d6d:	e8 1e ff ff ff       	call   80108c90 <setupkvm>
80108d72:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108d75:	85 c0                	test   %eax,%eax
80108d77:	0f 84 9b 00 00 00    	je     80108e18 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108d7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80108d80:	85 c9                	test   %ecx,%ecx
80108d82:	0f 84 90 00 00 00    	je     80108e18 <copyuvm+0xb8>
80108d88:	31 f6                	xor    %esi,%esi
80108d8a:	eb 46                	jmp    80108dd2 <copyuvm+0x72>
80108d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108d90:	83 ec 04             	sub    $0x4,%esp
80108d93:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80108d99:	68 00 10 00 00       	push   $0x1000
80108d9e:	57                   	push   %edi
80108d9f:	50                   	push   %eax
80108da0:	e8 bb d0 ff ff       	call   80105e60 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108da5:	58                   	pop    %eax
80108da6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80108dac:	5a                   	pop    %edx
80108dad:	ff 75 e4             	pushl  -0x1c(%ebp)
80108db0:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108db5:	89 f2                	mov    %esi,%edx
80108db7:	50                   	push   %eax
80108db8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108dbb:	e8 a0 f8 ff ff       	call   80108660 <mappages>
80108dc0:	83 c4 10             	add    $0x10,%esp
80108dc3:	85 c0                	test   %eax,%eax
80108dc5:	78 61                	js     80108e28 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80108dc7:	81 c6 00 10 00 00    	add    $0x1000,%esi
80108dcd:	39 75 0c             	cmp    %esi,0xc(%ebp)
80108dd0:	76 46                	jbe    80108e18 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108dd2:	8b 45 08             	mov    0x8(%ebp),%eax
80108dd5:	31 c9                	xor    %ecx,%ecx
80108dd7:	89 f2                	mov    %esi,%edx
80108dd9:	e8 02 f8 ff ff       	call   801085e0 <walkpgdir>
80108dde:	85 c0                	test   %eax,%eax
80108de0:	74 61                	je     80108e43 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80108de2:	8b 00                	mov    (%eax),%eax
80108de4:	a8 01                	test   $0x1,%al
80108de6:	74 4e                	je     80108e36 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80108de8:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80108dea:	25 ff 0f 00 00       	and    $0xfff,%eax
80108def:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80108df2:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80108df8:	e8 a3 9d ff ff       	call   80102ba0 <kalloc>
80108dfd:	89 c3                	mov    %eax,%ebx
80108dff:	85 c0                	test   %eax,%eax
80108e01:	75 8d                	jne    80108d90 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80108e03:	83 ec 0c             	sub    $0xc,%esp
80108e06:	ff 75 e0             	pushl  -0x20(%ebp)
80108e09:	e8 02 fe ff ff       	call   80108c10 <freevm>
  return 0;
80108e0e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108e15:	83 c4 10             	add    $0x10,%esp
}
80108e18:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108e1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108e1e:	5b                   	pop    %ebx
80108e1f:	5e                   	pop    %esi
80108e20:	5f                   	pop    %edi
80108e21:	5d                   	pop    %ebp
80108e22:	c3                   	ret    
80108e23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108e27:	90                   	nop
      kfree(mem);
80108e28:	83 ec 0c             	sub    $0xc,%esp
80108e2b:	53                   	push   %ebx
80108e2c:	e8 af 9b ff ff       	call   801029e0 <kfree>
      goto bad;
80108e31:	83 c4 10             	add    $0x10,%esp
80108e34:	eb cd                	jmp    80108e03 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80108e36:	83 ec 0c             	sub    $0xc,%esp
80108e39:	68 62 a9 10 80       	push   $0x8010a962
80108e3e:	e8 4d 75 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80108e43:	83 ec 0c             	sub    $0xc,%esp
80108e46:	68 48 a9 10 80       	push   $0x8010a948
80108e4b:	e8 40 75 ff ff       	call   80100390 <panic>

80108e50 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108e50:	f3 0f 1e fb          	endbr32 
80108e54:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108e55:	31 c9                	xor    %ecx,%ecx
{
80108e57:	89 e5                	mov    %esp,%ebp
80108e59:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80108e5c:	8b 55 0c             	mov    0xc(%ebp),%edx
80108e5f:	8b 45 08             	mov    0x8(%ebp),%eax
80108e62:	e8 79 f7 ff ff       	call   801085e0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80108e67:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80108e69:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80108e6a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108e6c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80108e71:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108e74:	05 00 00 00 80       	add    $0x80000000,%eax
80108e79:	83 fa 05             	cmp    $0x5,%edx
80108e7c:	ba 00 00 00 00       	mov    $0x0,%edx
80108e81:	0f 45 c2             	cmovne %edx,%eax
}
80108e84:	c3                   	ret    
80108e85:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108e90 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108e90:	f3 0f 1e fb          	endbr32 
80108e94:	55                   	push   %ebp
80108e95:	89 e5                	mov    %esp,%ebp
80108e97:	57                   	push   %edi
80108e98:	56                   	push   %esi
80108e99:	53                   	push   %ebx
80108e9a:	83 ec 0c             	sub    $0xc,%esp
80108e9d:	8b 75 14             	mov    0x14(%ebp),%esi
80108ea0:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108ea3:	85 f6                	test   %esi,%esi
80108ea5:	75 3c                	jne    80108ee3 <copyout+0x53>
80108ea7:	eb 67                	jmp    80108f10 <copyout+0x80>
80108ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80108eb0:	8b 55 0c             	mov    0xc(%ebp),%edx
80108eb3:	89 fb                	mov    %edi,%ebx
80108eb5:	29 d3                	sub    %edx,%ebx
80108eb7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80108ebd:	39 f3                	cmp    %esi,%ebx
80108ebf:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80108ec2:	29 fa                	sub    %edi,%edx
80108ec4:	83 ec 04             	sub    $0x4,%esp
80108ec7:	01 c2                	add    %eax,%edx
80108ec9:	53                   	push   %ebx
80108eca:	ff 75 10             	pushl  0x10(%ebp)
80108ecd:	52                   	push   %edx
80108ece:	e8 8d cf ff ff       	call   80105e60 <memmove>
    len -= n;
    buf += n;
80108ed3:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80108ed6:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80108edc:	83 c4 10             	add    $0x10,%esp
80108edf:	29 de                	sub    %ebx,%esi
80108ee1:	74 2d                	je     80108f10 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80108ee3:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80108ee5:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80108ee8:	89 55 0c             	mov    %edx,0xc(%ebp)
80108eeb:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80108ef1:	57                   	push   %edi
80108ef2:	ff 75 08             	pushl  0x8(%ebp)
80108ef5:	e8 56 ff ff ff       	call   80108e50 <uva2ka>
    if(pa0 == 0)
80108efa:	83 c4 10             	add    $0x10,%esp
80108efd:	85 c0                	test   %eax,%eax
80108eff:	75 af                	jne    80108eb0 <copyout+0x20>
  }
  return 0;
}
80108f01:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108f04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108f09:	5b                   	pop    %ebx
80108f0a:	5e                   	pop    %esi
80108f0b:	5f                   	pop    %edi
80108f0c:	5d                   	pop    %ebp
80108f0d:	c3                   	ret    
80108f0e:	66 90                	xchg   %ax,%ax
80108f10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108f13:	31 c0                	xor    %eax,%eax
}
80108f15:	5b                   	pop    %ebx
80108f16:	5e                   	pop    %esi
80108f17:	5f                   	pop    %edi
80108f18:	5d                   	pop    %ebp
80108f19:	c3                   	ret    
80108f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108f20 <shmget>:
/*
  Creates a shared memory region with given key,
  and size depending upon flag provided
*/
int
shmget(uint key, uint size, int shmflag) {
80108f20:	f3 0f 1e fb          	endbr32 
80108f24:	55                   	push   %ebp
80108f25:	89 e5                	mov    %esp,%ebp
80108f27:	57                   	push   %edi
80108f28:	56                   	push   %esi
80108f29:	53                   	push   %ebx
80108f2a:	83 ec 28             	sub    $0x28,%esp
80108f2d:	8b 75 10             	mov    0x10(%ebp),%esi
80108f30:	8b 5d 08             	mov    0x8(%ebp),%ebx
  // as Xv6 has only single user, else lower 9 bits would be considered
  int lowerBits = shmflag & 7, permission = -1;

  acquire(&shmTable.lock);
80108f33:	68 20 d7 12 80       	push   $0x8012d720
  int lowerBits = shmflag & 7, permission = -1;
80108f38:	89 f0                	mov    %esi,%eax
80108f3a:	83 e0 07             	and    $0x7,%eax
80108f3d:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108f40:	89 c7                	mov    %eax,%edi
  acquire(&shmTable.lock);
80108f42:	e8 69 cd ff ff       	call   80105cb0 <acquire>
  
  // separate correct permissions and shmflag
  if(lowerBits == (int)READ_SHM) {
    permission = READ_SHM;
    shmflag ^= READ_SHM;
80108f47:	89 f2                	mov    %esi,%edx
  if(lowerBits == (int)READ_SHM) {
80108f49:	83 c4 10             	add    $0x10,%esp
    shmflag ^= READ_SHM;
80108f4c:	83 f2 04             	xor    $0x4,%edx
  if(lowerBits == (int)READ_SHM) {
80108f4f:	83 ff 04             	cmp    $0x4,%edi
80108f52:	74 24                	je     80108f78 <shmget+0x58>
  }
  else if(lowerBits == (int)RW_SHM) {
    permission = RW_SHM;
    shmflag ^= RW_SHM;
80108f54:	89 f2                	mov    %esi,%edx
80108f56:	83 f2 06             	xor    $0x6,%edx
  else if(lowerBits == (int)RW_SHM) {
80108f59:	83 7d e0 06          	cmpl   $0x6,-0x20(%ebp)
80108f5d:	74 19                	je     80108f78 <shmget+0x58>
  } else {
    if(!((shmflag == 0) && (key != IPC_PRIVATE))) {
80108f5f:	85 f6                	test   %esi,%esi
80108f61:	0f 85 d6 01 00 00    	jne    8010913d <shmget+0x21d>
80108f67:	85 db                	test   %ebx,%ebx
80108f69:	0f 84 ce 01 00 00    	je     8010913d <shmget+0x21d>
  int lowerBits = shmflag & 7, permission = -1;
80108f6f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
80108f76:	31 d2                	xor    %edx,%edx
      release(&shmTable.lock);
      return -1;
    }
  }
  // check for requested size
  if(size <= 0) {
80108f78:	8b 45 0c             	mov    0xc(%ebp),%eax
80108f7b:	85 c0                	test   %eax,%eax
80108f7d:	0f 84 ba 01 00 00    	je     8010913d <shmget+0x21d>
    release(&shmTable.lock);
    return -1;
  }
  // calculate no of requested pages, from entered size
  int noOfPages = (size / PGSIZE) + 1;
80108f83:	8b 7d 0c             	mov    0xc(%ebp),%edi
80108f86:	c1 ef 0c             	shr    $0xc,%edi
80108f89:	8d 47 01             	lea    0x1(%edi),%eax
80108f8c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  // check if no of pages is more than decided limit
  if(noOfPages > SHAREDREGIONS) {
80108f8f:	83 f8 40             	cmp    $0x40,%eax
80108f92:	0f 87 a5 01 00 00    	ja     8010913d <shmget+0x21d>
80108f98:	b8 54 d7 12 80       	mov    $0x8012d754,%eax
    release(&shmTable.lock);
    return -1;
  }
  int index = -1;
  // check if key already exists
  for(int i = 0; i < SHAREDREGIONS; i++) {
80108f9d:	31 f6                	xor    %esi,%esi
  if(noOfPages > SHAREDREGIONS) {
80108f9f:	89 c1                	mov    %eax,%ecx
80108fa1:	eb 17                	jmp    80108fba <shmget+0x9a>
80108fa3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108fa7:	90                   	nop
  for(int i = 0; i < SHAREDREGIONS; i++) {
80108fa8:	83 c6 01             	add    $0x1,%esi
80108fab:	81 c1 28 01 00 00    	add    $0x128,%ecx
80108fb1:	83 fe 40             	cmp    $0x40,%esi
80108fb4:	0f 84 7e 00 00 00    	je     80109038 <shmget+0x118>
    if(shmTable.allRegions[i].key == key) {
80108fba:	39 19                	cmp    %ebx,(%ecx)
80108fbc:	75 ea                	jne    80108fa8 <shmget+0x88>
      // if wrong size is requested with existing region
      if(shmTable.allRegions[i].size != noOfPages) {
80108fbe:	69 c6 28 01 00 00    	imul   $0x128,%esi,%eax
80108fc4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80108fc7:	8d b8 20 d7 12 80    	lea    -0x7fed28e0(%eax),%edi
80108fcd:	3b 88 58 d7 12 80    	cmp    -0x7fed28a8(%eax),%ecx
80108fd3:	0f 85 64 01 00 00    	jne    8010913d <shmget+0x21d>
        release(&shmTable.lock);
        return -1;
      }
      // IPC_CREAT | IPC_EXCL, for region that exists
      if(shmflag == (IPC_CREAT | IPC_EXCL)) {
80108fd9:	81 fa 00 06 00 00    	cmp    $0x600,%edx
80108fdf:	0f 84 58 01 00 00    	je     8010913d <shmget+0x21d>
        release(&shmTable.lock);
        return -1;
      }
      // get region permissions
      int checkPerm = shmTable.allRegions[i].buffer.shm_perm.mode;
      if(checkPerm == READ_SHM || checkPerm == RW_SHM) {
80108fe5:	8b 80 68 d8 12 80    	mov    -0x7fed2798(%eax),%eax
80108feb:	83 e0 fd             	and    $0xfffffffd,%eax
80108fee:	83 f8 04             	cmp    $0x4,%eax
80108ff1:	0f 85 46 01 00 00    	jne    8010913d <shmget+0x21d>
        // condition for IPC_PRIVATE, with existing region
        if((shmflag == 0) && (key != IPC_PRIVATE)) {
80108ff7:	85 d2                	test   %edx,%edx
80108ff9:	75 08                	jne    80109003 <shmget+0xe3>
80108ffb:	85 db                	test   %ebx,%ebx
80108ffd:	0f 85 1d 01 00 00    	jne    80109120 <shmget+0x200>
          release(&shmTable.lock);
          return shmTable.allRegions[i].shmid;
        }
        if(shmflag == IPC_CREAT) {
80109003:	81 fa 00 02 00 00    	cmp    $0x200,%edx
80109009:	0f 85 2e 01 00 00    	jne    8010913d <shmget+0x21d>
          release(&shmTable.lock);
8010900f:	83 ec 0c             	sub    $0xc,%esp
          return shmTable.allRegions[i].shmid;
80109012:	69 f6 28 01 00 00    	imul   $0x128,%esi,%esi
          release(&shmTable.lock);
80109018:	68 20 d7 12 80       	push   $0x8012d720
8010901d:	e8 4e cd ff ff       	call   80105d70 <release>
          return shmTable.allRegions[i].shmid;
80109022:	8b be 5c d7 12 80    	mov    -0x7fed28a4(%esi),%edi
80109028:	83 c4 10             	add    $0x10,%esp
    return index; // valid shmid
  } else {
    release(&shmTable.lock);
    return -1;
  }  
}
8010902b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010902e:	89 f8                	mov    %edi,%eax
80109030:	5b                   	pop    %ebx
80109031:	5e                   	pop    %esi
80109032:	5f                   	pop    %edi
80109033:	5d                   	pop    %ebp
80109034:	c3                   	ret    
80109035:	8d 76 00             	lea    0x0(%esi),%esi
  for(int i = 0; i < SHAREDREGIONS; i++) {
80109038:	31 ff                	xor    %edi,%edi
8010903a:	eb 15                	jmp    80109051 <shmget+0x131>
8010903c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80109040:	83 c7 01             	add    $0x1,%edi
80109043:	05 28 01 00 00       	add    $0x128,%eax
80109048:	83 ff 40             	cmp    $0x40,%edi
8010904b:	0f 84 ec 00 00 00    	je     8010913d <shmget+0x21d>
    if(shmTable.allRegions[i].key == -1) {
80109051:	83 38 ff             	cmpl   $0xffffffff,(%eax)
80109054:	75 ea                	jne    80109040 <shmget+0x120>
  if((key == IPC_PRIVATE) || (shmflag == IPC_CREAT) || (shmflag == (IPC_CREAT | IPC_EXCL))) {
80109056:	80 e6 fb             	and    $0xfb,%dh
80109059:	81 fa 00 02 00 00    	cmp    $0x200,%edx
8010905f:	74 08                	je     80109069 <shmget+0x149>
80109061:	85 db                	test   %ebx,%ebx
80109063:	0f 85 d4 00 00 00    	jne    8010913d <shmget+0x21d>
80109069:	69 c7 28 01 00 00    	imul   $0x128,%edi,%eax
  int noOfPages = (size / PGSIZE) + 1;
8010906f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80109072:	31 f6                	xor    %esi,%esi
80109074:	89 7d dc             	mov    %edi,-0x24(%ebp)
80109077:	89 c7                	mov    %eax,%edi
80109079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      char *newPage = kalloc();
80109080:	e8 1b 9b ff ff       	call   80102ba0 <kalloc>
80109085:	89 c3                	mov    %eax,%ebx
      if(newPage == 0){
80109087:	85 c0                	test   %eax,%eax
80109089:	0f 84 c8 00 00 00    	je     80109157 <shmget+0x237>
      memset(newPage, 0, PGSIZE);
8010908f:	83 ec 04             	sub    $0x4,%esp
80109092:	68 00 10 00 00       	push   $0x1000
80109097:	6a 00                	push   $0x0
80109099:	50                   	push   %eax
8010909a:	e8 21 cd ff ff       	call   80105dc0 <memset>
      shmTable.allRegions[index].physicalAddr[i] = (void *)V2P(newPage);
8010909f:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
    for(int i = 0; i < noOfPages; i++) {
801090a5:	83 c4 10             	add    $0x10,%esp
      shmTable.allRegions[index].physicalAddr[i] = (void *)V2P(newPage);
801090a8:	89 94 b7 64 d7 12 80 	mov    %edx,-0x7fed289c(%edi,%esi,4)
    for(int i = 0; i < noOfPages; i++) {
801090af:	83 c6 01             	add    $0x1,%esi
801090b2:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801090b5:	75 c9                	jne    80109080 <shmget+0x160>
801090b7:	8b 7d dc             	mov    -0x24(%ebp),%edi
    shmTable.allRegions[index].size = noOfPages;
801090ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801090bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
801090c0:	69 f7 28 01 00 00    	imul   $0x128,%edi,%esi
801090c6:	89 86 58 d7 12 80    	mov    %eax,-0x7fed28a8(%esi)
    shmTable.allRegions[index].buffer.shm_segsz = size;
801090cc:	8b 45 0c             	mov    0xc(%ebp),%eax
    shmTable.allRegions[index].key = key;
801090cf:	89 9e 54 d7 12 80    	mov    %ebx,-0x7fed28ac(%esi)
    shmTable.allRegions[index].buffer.shm_segsz = size;
801090d5:	89 86 6c d8 12 80    	mov    %eax,-0x7fed2794(%esi)
    shmTable.allRegions[index].buffer.shm_perm.mode = permission;
801090db:	8b 45 e0             	mov    -0x20(%ebp),%eax
    shmTable.allRegions[index].buffer.shm_perm.__key = key;
801090de:	89 9e 64 d8 12 80    	mov    %ebx,-0x7fed279c(%esi)
    shmTable.allRegions[index].buffer.shm_perm.mode = permission;
801090e4:	89 86 68 d8 12 80    	mov    %eax,-0x7fed2798(%esi)
    shmTable.allRegions[index].buffer.shm_cpid = myproc()->pid;
801090ea:	e8 51 ae ff ff       	call   80103f40 <myproc>
    release(&shmTable.lock);
801090ef:	83 ec 0c             	sub    $0xc,%esp
    shmTable.allRegions[index].buffer.shm_cpid = myproc()->pid;
801090f2:	8b 40 10             	mov    0x10(%eax),%eax
    release(&shmTable.lock);
801090f5:	68 20 d7 12 80       	push   $0x8012d720
    shmTable.allRegions[index].shmid = index;
801090fa:	89 be 5c d7 12 80    	mov    %edi,-0x7fed28a4(%esi)
    shmTable.allRegions[index].buffer.shm_cpid = myproc()->pid;
80109100:	89 86 74 d8 12 80    	mov    %eax,-0x7fed278c(%esi)
    release(&shmTable.lock);
80109106:	e8 65 cc ff ff       	call   80105d70 <release>
    return index; // valid shmid
8010910b:	83 c4 10             	add    $0x10,%esp
}
8010910e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80109111:	89 f8                	mov    %edi,%eax
80109113:	5b                   	pop    %ebx
80109114:	5e                   	pop    %esi
80109115:	5f                   	pop    %edi
80109116:	5d                   	pop    %ebp
80109117:	c3                   	ret    
80109118:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010911f:	90                   	nop
          release(&shmTable.lock);
80109120:	83 ec 0c             	sub    $0xc,%esp
80109123:	68 20 d7 12 80       	push   $0x8012d720
80109128:	e8 43 cc ff ff       	call   80105d70 <release>
          return shmTable.allRegions[i].shmid;
8010912d:	8b 7f 3c             	mov    0x3c(%edi),%edi
80109130:	83 c4 10             	add    $0x10,%esp
}
80109133:	8d 65 f4             	lea    -0xc(%ebp),%esp
80109136:	5b                   	pop    %ebx
80109137:	5e                   	pop    %esi
80109138:	89 f8                	mov    %edi,%eax
8010913a:	5f                   	pop    %edi
8010913b:	5d                   	pop    %ebp
8010913c:	c3                   	ret    
      release(&shmTable.lock);
8010913d:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80109140:	bf ff ff ff ff       	mov    $0xffffffff,%edi
      release(&shmTable.lock);
80109145:	68 20 d7 12 80       	push   $0x8012d720
8010914a:	e8 21 cc ff ff       	call   80105d70 <release>
      return -1;
8010914f:	83 c4 10             	add    $0x10,%esp
80109152:	e9 d4 fe ff ff       	jmp    8010902b <shmget+0x10b>
        cprintf("shmget: failed to allocate a page (out of memory)\n");
80109157:	83 ec 0c             	sub    $0xc,%esp
        return -1;
8010915a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
        cprintf("shmget: failed to allocate a page (out of memory)\n");
8010915f:	68 b0 a9 10 80       	push   $0x8010a9b0
80109164:	e8 57 77 ff ff       	call   801008c0 <cprintf>
        release(&shmTable.lock);
80109169:	c7 04 24 20 d7 12 80 	movl   $0x8012d720,(%esp)
80109170:	e8 fb cb ff ff       	call   80105d70 <release>
        return -1;
80109175:	83 c4 10             	add    $0x10,%esp
}
80109178:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010917b:	89 f8                	mov    %edi,%eax
8010917d:	5b                   	pop    %ebx
8010917e:	5e                   	pop    %esi
8010917f:	5f                   	pop    %edi
80109180:	5d                   	pop    %ebp
80109181:	c3                   	ret    
80109182:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80109189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80109190 <getLeastvaidx>:

// finds the least starting address of a segment greater than curr_va which is attached 
// to the virtual address space of the current process. Returns the index from the pages  
// array corresponding to this address if found; -1 otherwise
int 
getLeastvaidx(void* curr_va, struct proc *process) {
80109190:	f3 0f 1e fb          	endbr32 
80109194:	55                   	push   %ebp
  
  //maximum virtual address available in range
  void* leastva = (void*)(KERNBASE - 1);

  int idx = -1;
  for(int i = 0; i < SHAREDREGIONS; i++) {
80109195:	31 d2                	xor    %edx,%edx
getLeastvaidx(void* curr_va, struct proc *process) {
80109197:	89 e5                	mov    %esp,%ebp
80109199:	57                   	push   %edi
  int idx = -1;
8010919a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
8010919f:	8b 45 0c             	mov    0xc(%ebp),%eax
getLeastvaidx(void* curr_va, struct proc *process) {
801091a2:	56                   	push   %esi
  void* leastva = (void*)(KERNBASE - 1);
801091a3:	be ff ff ff 7f       	mov    $0x7fffffff,%esi
getLeastvaidx(void* curr_va, struct proc *process) {
801091a8:	53                   	push   %ebx
801091a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801091ac:	05 ac 00 00 00       	add    $0xac,%eax
801091b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(process->pages[i].key != -1 && (uint)process->pages[i].virtualAddr >= (uint)curr_va && (uint)leastva >= (uint)process->pages[i].virtualAddr) {  
801091b8:	83 38 ff             	cmpl   $0xffffffff,(%eax)
801091bb:	74 13                	je     801091d0 <getLeastvaidx+0x40>
801091bd:	8b 48 10             	mov    0x10(%eax),%ecx
801091c0:	39 cb                	cmp    %ecx,%ebx
801091c2:	77 0c                	ja     801091d0 <getLeastvaidx+0x40>
801091c4:	39 ce                	cmp    %ecx,%esi
801091c6:	72 08                	jb     801091d0 <getLeastvaidx+0x40>
801091c8:	89 d7                	mov    %edx,%edi
      // store address if greater than curr_va and smaller than the existing least_va.
      leastva = process->pages[i].virtualAddr;
801091ca:	89 ce                	mov    %ecx,%esi
801091cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(int i = 0; i < SHAREDREGIONS; i++) {
801091d0:	83 c2 01             	add    $0x1,%edx
801091d3:	83 c0 14             	add    $0x14,%eax
801091d6:	83 fa 40             	cmp    $0x40,%edx
801091d9:	75 dd                	jne    801091b8 <getLeastvaidx+0x28>

      idx = i;
    }
  }  
  return idx;
}
801091db:	5b                   	pop    %ebx
801091dc:	89 f8                	mov    %edi,%eax
801091de:	5e                   	pop    %esi
801091df:	5f                   	pop    %edi
801091e0:	5d                   	pop    %ebp
801091e1:	c3                   	ret    
801091e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801091e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801091f0 <shmdt>:

// detaches the shared memory segment starting at shmaddr from virtual address space of the process
// returns 0 if successful and -1 in case of a failure
int 
shmdt(void* shmaddr) {
801091f0:	f3 0f 1e fb          	endbr32 
801091f4:	55                   	push   %ebp
801091f5:	89 e5                	mov    %esp,%ebp
801091f7:	57                   	push   %edi
801091f8:	56                   	push   %esi
801091f9:	53                   	push   %ebx
  acquire(&shmTable.lock);
  struct proc *process = myproc();
  void* va = (void*)0;
  uint size;
  int index,shmid;
  for(int i = 0; i < SHAREDREGIONS; i++) {
801091fa:	31 db                	xor    %ebx,%ebx
shmdt(void* shmaddr) {
801091fc:	83 ec 28             	sub    $0x28,%esp
801091ff:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&shmTable.lock);
80109202:	68 20 d7 12 80       	push   $0x8012d720
80109207:	e8 a4 ca ff ff       	call   80105cb0 <acquire>
  struct proc *process = myproc();
8010920c:	e8 2f ad ff ff       	call   80103f40 <myproc>
80109211:	83 c4 10             	add    $0x10,%esp
80109214:	89 c7                	mov    %eax,%edi
  for(int i = 0; i < SHAREDREGIONS; i++) {
80109216:	8d 80 ac 00 00 00    	lea    0xac(%eax),%eax
8010921c:	eb 0d                	jmp    8010922b <shmdt+0x3b>
8010921e:	66 90                	xchg   %ax,%ax
80109220:	83 c3 01             	add    $0x1,%ebx
80109223:	83 c0 14             	add    $0x14,%eax
80109226:	83 fb 40             	cmp    $0x40,%ebx
80109229:	74 59                	je     80109284 <shmdt+0x94>
    // find the index from pages array which is attached at the provided shmaddr
    if(process->pages[i].key != -1 && process->pages[i].virtualAddr == shmaddr) {
8010922b:	83 38 ff             	cmpl   $0xffffffff,(%eax)
8010922e:	74 f0                	je     80109220 <shmdt+0x30>
80109230:	39 70 10             	cmp    %esi,0x10(%eax)
80109233:	75 eb                	jne    80109220 <shmdt+0x30>
        va =  process->pages[i].virtualAddr;
        index = i;
        shmid = process->pages[i].shmid;
80109235:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
80109238:	8d 04 87             	lea    (%edi,%eax,4),%eax
8010923b:	8b 88 b4 00 00 00    	mov    0xb4(%eax),%ecx
        size = process->pages[index].size;
80109241:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
        shmid = process->pages[i].shmid;
80109247:	89 4d e0             	mov    %ecx,-0x20(%ebp)
        size = process->pages[index].size;
8010924a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        break;
    }
  }
  if(va) {
8010924d:	85 f6                	test   %esi,%esi
8010924f:	74 33                	je     80109284 <shmdt+0x94>
    for(int i = 0; i < size; i++) {
80109251:	89 f2                	mov    %esi,%edx
80109253:	31 f6                	xor    %esi,%esi
80109255:	85 c0                	test   %eax,%eax
80109257:	74 52                	je     801092ab <shmdt+0xbb>
80109259:	89 5d dc             	mov    %ebx,-0x24(%ebp)
8010925c:	89 d3                	mov    %edx,%ebx
8010925e:	eb 14                	jmp    80109274 <shmdt+0x84>
      pte_t* pte = walkpgdir(process->pgdir, (void*)((uint)va + i*PGSIZE), 0);
      if(pte == 0) {
        release(&shmTable.lock);
        return -1;
      }
		  *pte = 0;
80109260:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for(int i = 0; i < size; i++) {
80109266:	83 c6 01             	add    $0x1,%esi
80109269:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010926f:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
80109272:	74 34                	je     801092a8 <shmdt+0xb8>
      pte_t* pte = walkpgdir(process->pgdir, (void*)((uint)va + i*PGSIZE), 0);
80109274:	8b 47 04             	mov    0x4(%edi),%eax
80109277:	31 c9                	xor    %ecx,%ecx
80109279:	89 da                	mov    %ebx,%edx
8010927b:	e8 60 f3 ff ff       	call   801085e0 <walkpgdir>
      if(pte == 0) {
80109280:	85 c0                	test   %eax,%eax
80109282:	75 dc                	jne    80109260 <shmdt+0x70>
        release(&shmTable.lock);
80109284:	83 ec 0c             	sub    $0xc,%esp
80109287:	68 20 d7 12 80       	push   $0x8012d720
8010928c:	e8 df ca ff ff       	call   80105d70 <release>
        return -1;
80109291:	83 c4 10             	add    $0x10,%esp
  } else {
    release(&shmTable.lock);
    return -1;
  }
  
}
80109294:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80109297:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010929c:	5b                   	pop    %ebx
8010929d:	5e                   	pop    %esi
8010929e:	5f                   	pop    %edi
8010929f:	5d                   	pop    %ebp
801092a0:	c3                   	ret    
801092a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801092a8:	8b 5d dc             	mov    -0x24(%ebp),%ebx
    if(shmTable.allRegions[shmid].buffer.shm_nattch > 0) {
801092ab:	69 55 e0 28 01 00 00 	imul   $0x128,-0x20(%ebp),%edx
    process->pages[index].shmid = -1;  
801092b2:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
801092b5:	8d 04 87             	lea    (%edi,%eax,4),%eax
801092b8:	c7 80 b4 00 00 00 ff 	movl   $0xffffffff,0xb4(%eax)
801092bf:	ff ff ff 
    process->pages[index].key = -1;
801092c2:	c7 80 ac 00 00 00 ff 	movl   $0xffffffff,0xac(%eax)
801092c9:	ff ff ff 
    if(shmTable.allRegions[shmid].buffer.shm_nattch > 0) {
801092cc:	81 c2 20 d7 12 80    	add    $0x8012d720,%edx
    process->pages[index].size =  0;
801092d2:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801092d9:	00 00 00 
    process->pages[index].virtualAddr = (void*)0;
801092dc:	c7 80 bc 00 00 00 00 	movl   $0x0,0xbc(%eax)
801092e3:	00 00 00 
    if(shmTable.allRegions[shmid].buffer.shm_nattch > 0) {
801092e6:	8b 82 50 01 00 00    	mov    0x150(%edx),%eax
801092ec:	85 c0                	test   %eax,%eax
801092ee:	7e 09                	jle    801092f9 <shmdt+0x109>
      shmTable.allRegions[shmid].buffer.shm_nattch -= 1;
801092f0:	83 e8 01             	sub    $0x1,%eax
801092f3:	89 82 50 01 00 00    	mov    %eax,0x150(%edx)
    if(shmTable.allRegions[shmid].buffer.shm_nattch == 0 && shmTable.allRegions[shmid].toBeDeleted == 1) {
801092f9:	85 c0                	test   %eax,%eax
801092fb:	74 33                	je     80109330 <shmdt+0x140>
    release(&shmTable.lock);
801092fd:	83 ec 0c             	sub    $0xc,%esp
    shmTable.allRegions[shmid].buffer.shm_lpid = process->pid;
80109300:	69 45 e0 28 01 00 00 	imul   $0x128,-0x20(%ebp),%eax
80109307:	8b 57 10             	mov    0x10(%edi),%edx
    release(&shmTable.lock);
8010930a:	68 20 d7 12 80       	push   $0x8012d720
    shmTable.allRegions[shmid].buffer.shm_lpid = process->pid;
8010930f:	89 90 78 d8 12 80    	mov    %edx,-0x7fed2788(%eax)
    release(&shmTable.lock);
80109315:	e8 56 ca ff ff       	call   80105d70 <release>
    return 0;
8010931a:	83 c4 10             	add    $0x10,%esp
}
8010931d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80109320:	31 c0                	xor    %eax,%eax
}
80109322:	5b                   	pop    %ebx
80109323:	5e                   	pop    %esi
80109324:	5f                   	pop    %edi
80109325:	5d                   	pop    %ebp
80109326:	c3                   	ret    
80109327:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010932e:	66 90                	xchg   %ax,%ax
    if(shmTable.allRegions[shmid].buffer.shm_nattch == 0 && shmTable.allRegions[shmid].toBeDeleted == 1) {
80109330:	69 55 e0 28 01 00 00 	imul   $0x128,-0x20(%ebp),%edx
80109337:	83 ba 60 d7 12 80 01 	cmpl   $0x1,-0x7fed28a0(%edx)
8010933e:	75 bd                	jne    801092fd <shmdt+0x10d>
      for(int i = 0; i < shmTable.allRegions[index].size; i++) {
80109340:	69 f3 28 01 00 00    	imul   $0x128,%ebx,%esi
80109346:	8d 96 20 d7 12 80    	lea    -0x7fed28e0(%esi),%edx
8010934c:	89 d1                	mov    %edx,%ecx
8010934e:	8b 96 58 d7 12 80    	mov    -0x7fed28a8(%esi),%edx
80109354:	85 d2                	test   %edx,%edx
80109356:	74 42                	je     8010939a <shmdt+0x1aa>
80109358:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010935b:	89 f7                	mov    %esi,%edi
8010935d:	89 ce                	mov    %ecx,%esi
8010935f:	89 5d dc             	mov    %ebx,-0x24(%ebp)
80109362:	89 c3                	mov    %eax,%ebx
80109364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        char *addr = (char *)P2V(shmTable.allRegions[index].physicalAddr[i]);
80109368:	8b 84 9f 64 d7 12 80 	mov    -0x7fed289c(%edi,%ebx,4),%eax
        kfree(addr);
8010936f:	83 ec 0c             	sub    $0xc,%esp
        char *addr = (char *)P2V(shmTable.allRegions[index].physicalAddr[i]);
80109372:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
        kfree(addr);
80109378:	52                   	push   %edx
80109379:	e8 62 96 ff ff       	call   801029e0 <kfree>
      for(int i = 0; i < shmTable.allRegions[index].size; i++) {
8010937e:	83 c4 10             	add    $0x10,%esp
        shmTable.allRegions[index].physicalAddr[i] = (void *)0;
80109381:	c7 84 9f 64 d7 12 80 	movl   $0x0,-0x7fed289c(%edi,%ebx,4)
80109388:	00 00 00 00 
      for(int i = 0; i < shmTable.allRegions[index].size; i++) {
8010938c:	83 c3 01             	add    $0x1,%ebx
8010938f:	39 5e 38             	cmp    %ebx,0x38(%esi)
80109392:	77 d4                	ja     80109368 <shmdt+0x178>
80109394:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80109397:	8b 5d dc             	mov    -0x24(%ebp),%ebx
      shmTable.allRegions[index].size = 0;
8010939a:	69 c3 28 01 00 00    	imul   $0x128,%ebx,%eax
801093a0:	c7 80 58 d7 12 80 00 	movl   $0x0,-0x7fed28a8(%eax)
801093a7:	00 00 00 
      shmTable.allRegions[index].key = shmTable.allRegions[index].shmid = -1;
801093aa:	c7 80 5c d7 12 80 ff 	movl   $0xffffffff,-0x7fed28a4(%eax)
801093b1:	ff ff ff 
801093b4:	c7 80 54 d7 12 80 ff 	movl   $0xffffffff,-0x7fed28ac(%eax)
801093bb:	ff ff ff 
      shmTable.allRegions[index].toBeDeleted = 0;
801093be:	c7 80 60 d7 12 80 00 	movl   $0x0,-0x7fed28a0(%eax)
801093c5:	00 00 00 
      shmTable.allRegions[index].buffer.shm_nattch = 0;
801093c8:	c7 80 70 d8 12 80 00 	movl   $0x0,-0x7fed2790(%eax)
801093cf:	00 00 00 
      shmTable.allRegions[index].buffer.shm_segsz = 0;
801093d2:	c7 80 6c d8 12 80 00 	movl   $0x0,-0x7fed2794(%eax)
801093d9:	00 00 00 
      shmTable.allRegions[index].buffer.shm_perm.__key = -1;
801093dc:	c7 80 64 d8 12 80 ff 	movl   $0xffffffff,-0x7fed279c(%eax)
801093e3:	ff ff ff 
      shmTable.allRegions[index].buffer.shm_perm.mode = 0;
801093e6:	c7 80 68 d8 12 80 00 	movl   $0x0,-0x7fed2798(%eax)
801093ed:	00 00 00 
      shmTable.allRegions[index].buffer.shm_cpid = -1;
801093f0:	c7 80 74 d8 12 80 ff 	movl   $0xffffffff,-0x7fed278c(%eax)
801093f7:	ff ff ff 
      shmTable.allRegions[index].buffer.shm_lpid = -1;
801093fa:	c7 80 78 d8 12 80 ff 	movl   $0xffffffff,-0x7fed2788(%eax)
80109401:	ff ff ff 
80109404:	e9 f4 fe ff ff       	jmp    801092fd <shmdt+0x10d>
80109409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80109410 <shmat>:

// attaches shared memory segment identified by shmid to the virtual address shmaddr 
// if provided; otherwise attach at the first fitting address 
void*
shmat(int shmid, void* shmaddr, int shmflag) {
80109410:	f3 0f 1e fb          	endbr32 
80109414:	55                   	push   %ebp
80109415:	89 e5                	mov    %esp,%ebp
80109417:	57                   	push   %edi
80109418:	56                   	push   %esi
80109419:	53                   	push   %ebx
8010941a:	83 ec 2c             	sub    $0x2c,%esp
  if(shmid < 0 || shmid > 64) {
8010941d:	83 7d 08 40          	cmpl   $0x40,0x8(%ebp)
shmat(int shmid, void* shmaddr, int shmflag) {
80109421:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(shmid < 0 || shmid > 64) {
80109424:	76 0f                	jbe    80109435 <shmat+0x25>
    return (void*)-1;
80109426:	bf ff ff ff ff       	mov    $0xffffffff,%edi
    release(&shmTable.lock);
    return (void*)-1; // all page regions exhausted
  }
  release(&shmTable.lock);
  return va;
}
8010942b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010942e:	89 f8                	mov    %edi,%eax
80109430:	5b                   	pop    %ebx
80109431:	5e                   	pop    %esi
80109432:	5f                   	pop    %edi
80109433:	5d                   	pop    %ebp
80109434:	c3                   	ret    
  acquire(&shmTable.lock);
80109435:	83 ec 0c             	sub    $0xc,%esp
80109438:	68 20 d7 12 80       	push   $0x8012d720
8010943d:	e8 6e c8 ff ff       	call   80105cb0 <acquire>
  struct proc *process = myproc();
80109442:	e8 f9 aa ff ff       	call   80103f40 <myproc>
  if(index == -1) {
80109447:	83 c4 10             	add    $0x10,%esp
  struct proc *process = myproc();
8010944a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  index = shmTable.allRegions[shmid].shmid;
8010944d:	69 45 08 28 01 00 00 	imul   $0x128,0x8(%ebp),%eax
80109454:	8b 80 5c d7 12 80    	mov    -0x7fed28a4(%eax),%eax
8010945a:	89 45 cc             	mov    %eax,-0x34(%ebp)
  if(index == -1) {
8010945d:	83 f8 ff             	cmp    $0xffffffff,%eax
80109460:	0f 84 19 02 00 00    	je     8010967f <shmat+0x26f>
  if(shmaddr) {
80109466:	85 db                	test   %ebx,%ebx
80109468:	0f 84 70 02 00 00    	je     801096de <shmat+0x2ce>
    if((uint)shmaddr >= KERNBASE || (uint)shmaddr < HEAPLIMIT) {
8010946e:	0f 88 0b 02 00 00    	js     8010967f <shmat+0x26f>
80109474:	81 fb ff ff ff 7e    	cmp    $0x7effffff,%ebx
8010947a:	0f 86 ff 01 00 00    	jbe    8010967f <shmat+0x26f>
    uint rounded = ((uint)shmaddr & ~(SHMLBA-1));  
80109480:	69 45 cc 28 01 00 00 	imul   $0x128,-0x34(%ebp),%eax
80109487:	89 de                	mov    %ebx,%esi
80109489:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
8010948f:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    if(shmflag & SHM_RND) {
80109492:	8b b8 58 d7 12 80    	mov    -0x7fed28a8(%eax),%edi
80109498:	89 f8                	mov    %edi,%eax
8010949a:	c1 e0 0c             	shl    $0xc,%eax
8010949d:	f7 45 10 00 20 00 00 	testl  $0x2000,0x10(%ebp)
801094a4:	0f 85 f4 01 00 00    	jne    8010969e <shmat+0x28e>
      if(rounded == (uint)shmaddr) {  
801094aa:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801094ad:	0f 84 7b 03 00 00    	je     8010982e <shmat+0x41e>
801094b3:	05 00 00 00 7f       	add    $0x7f000000,%eax
801094b8:	c7 45 e4 00 00 00 7f 	movl   $0x7f000000,-0x1c(%ebp)
  void *va = (void*)HEAPLIMIT, *least_va;
801094bf:	bf 00 00 00 7f       	mov    $0x7f000000,%edi
801094c4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if((uint)va + shmTable.allRegions[index].size*PGSIZE >= KERNBASE) {
801094c7:	8b 55 dc             	mov    -0x24(%ebp),%edx
801094ca:	85 d2                	test   %edx,%edx
801094cc:	0f 88 ad 01 00 00    	js     8010967f <shmat+0x26f>
801094d2:	8b 75 e0             	mov    -0x20(%ebp),%esi
801094d5:	89 7d d4             	mov    %edi,-0x2c(%ebp)
801094d8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801094db:	8d 86 ac 00 00 00    	lea    0xac(%esi),%eax
801094e1:	8d 8e ac 05 00 00    	lea    0x5ac(%esi),%ecx
801094e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
801094ea:	eb 0f                	jmp    801094fb <shmat+0xeb>
801094ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(int i = 0; i < SHAREDREGIONS; i++) {
801094f0:	83 c0 14             	add    $0x14,%eax
801094f3:	39 c1                	cmp    %eax,%ecx
801094f5:	0f 84 af 01 00 00    	je     801096aa <shmat+0x29a>
    if(process->pages[i].key != -1 && (uint)process->pages[i].virtualAddr + process->pages[i].size*PGSIZE > (uint)va && (uint)va >= (uint)process->pages[i].virtualAddr)  {
801094fb:	83 38 ff             	cmpl   $0xffffffff,(%eax)
801094fe:	74 f0                	je     801094f0 <shmat+0xe0>
80109500:	8b 58 04             	mov    0x4(%eax),%ebx
80109503:	8b 70 10             	mov    0x10(%eax),%esi
80109506:	89 da                	mov    %ebx,%edx
80109508:	c1 e2 0c             	shl    $0xc,%edx
8010950b:	01 f2                	add    %esi,%edx
8010950d:	39 fa                	cmp    %edi,%edx
8010950f:	76 df                	jbe    801094f0 <shmat+0xe0>
80109511:	39 fe                	cmp    %edi,%esi
80109513:	77 db                	ja     801094f0 <shmat+0xe0>
80109515:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    if(shmflag & SHM_REMAP) {
80109518:	f7 45 10 00 40 00 00 	testl  $0x4000,0x10(%ebp)
8010951f:	0f 84 5a 01 00 00    	je     8010967f <shmat+0x26f>
      while(segment < (uint)va + shmTable.allRegions[index].size*PGSIZE) { 
80109525:	3b 75 dc             	cmp    -0x24(%ebp),%esi
80109528:	0f 83 7f 01 00 00    	jae    801096ad <shmat+0x29d>
8010952e:	69 45 cc 28 01 00 00 	imul   $0x128,-0x34(%ebp),%eax
80109535:	89 7d d0             	mov    %edi,-0x30(%ebp)
80109538:	05 20 d7 12 80       	add    $0x8012d720,%eax
8010953d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        release(&shmTable.lock);
80109540:	83 ec 0c             	sub    $0xc,%esp
80109543:	68 20 d7 12 80       	push   $0x8012d720
80109548:	e8 23 c8 ff ff       	call   80105d70 <release>
        if(shmdt((void*)segment) == -1) {
8010954d:	89 34 24             	mov    %esi,(%esp)
80109550:	e8 9b fc ff ff       	call   801091f0 <shmdt>
80109555:	83 c4 10             	add    $0x10,%esp
80109558:	83 f8 ff             	cmp    $0xffffffff,%eax
8010955b:	0f 84 c5 fe ff ff    	je     80109426 <shmat+0x16>
        acquire(&shmTable.lock);        
80109561:	83 ec 0c             	sub    $0xc,%esp
        idx = getLeastvaidx((void*)(segment + size*PGSIZE),process);
80109564:	c1 e3 0c             	shl    $0xc,%ebx
  int idx = -1;
80109567:	bf ff ff ff ff       	mov    $0xffffffff,%edi
        acquire(&shmTable.lock);        
8010956c:	68 20 d7 12 80       	push   $0x8012d720
        idx = getLeastvaidx((void*)(segment + size*PGSIZE),process);
80109571:	01 f3                	add    %esi,%ebx
  void* leastva = (void*)(KERNBASE - 1);
80109573:	be ff ff ff 7f       	mov    $0x7fffffff,%esi
        acquire(&shmTable.lock);        
80109578:	e8 33 c7 ff ff       	call   80105cb0 <acquire>
        idx = getLeastvaidx((void*)(segment + size*PGSIZE),process);
8010957d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80109580:	83 c4 10             	add    $0x10,%esp
  for(int i = 0; i < SHAREDREGIONS; i++) {
80109583:	31 d2                	xor    %edx,%edx
80109585:	8d 76 00             	lea    0x0(%esi),%esi
    if(process->pages[i].key != -1 && (uint)process->pages[i].virtualAddr >= (uint)curr_va && (uint)leastva >= (uint)process->pages[i].virtualAddr) {  
80109588:	83 38 ff             	cmpl   $0xffffffff,(%eax)
8010958b:	74 13                	je     801095a0 <shmat+0x190>
8010958d:	8b 48 10             	mov    0x10(%eax),%ecx
80109590:	39 cb                	cmp    %ecx,%ebx
80109592:	77 0c                	ja     801095a0 <shmat+0x190>
80109594:	39 ce                	cmp    %ecx,%esi
80109596:	72 08                	jb     801095a0 <shmat+0x190>
80109598:	89 d7                	mov    %edx,%edi
      leastva = process->pages[i].virtualAddr;
8010959a:	89 ce                	mov    %ecx,%esi
8010959c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(int i = 0; i < SHAREDREGIONS; i++) {
801095a0:	83 c2 01             	add    $0x1,%edx
801095a3:	83 c0 14             	add    $0x14,%eax
801095a6:	83 fa 40             	cmp    $0x40,%edx
801095a9:	75 dd                	jne    80109588 <shmat+0x178>
        if(idx == -1)
801095ab:	83 ff ff             	cmp    $0xffffffff,%edi
801095ae:	0f 84 d8 01 00 00    	je     8010978c <shmat+0x37c>
        segment = (uint)process->pages[idx].virtualAddr;
801095b4:	8b 75 e0             	mov    -0x20(%ebp),%esi
801095b7:	8d 04 bf             	lea    (%edi,%edi,4),%eax
801095ba:	8d 14 86             	lea    (%esi,%eax,4),%edx
      while(segment < (uint)va + shmTable.allRegions[index].size*PGSIZE) { 
801095bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        segment = (uint)process->pages[idx].virtualAddr;
801095c0:	8b b2 bc 00 00 00    	mov    0xbc(%edx),%esi
      while(segment < (uint)va + shmTable.allRegions[index].size*PGSIZE) { 
801095c6:	8b 40 38             	mov    0x38(%eax),%eax
801095c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
801095cc:	c1 e0 0c             	shl    $0xc,%eax
801095cf:	03 45 e4             	add    -0x1c(%ebp),%eax
801095d2:	39 f0                	cmp    %esi,%eax
801095d4:	0f 86 b2 01 00 00    	jbe    8010978c <shmat+0x37c>
801095da:	8b 9a b0 00 00 00    	mov    0xb0(%edx),%ebx
801095e0:	e9 5b ff ff ff       	jmp    80109540 <shmat+0x130>
    permflag = PTE_U;
801095e5:	c7 45 dc 04 00 00 00 	movl   $0x4,-0x24(%ebp)
  for (int k = 0; k < shmTable.allRegions[index].size; k++) {
801095ec:	69 4d cc 28 01 00 00 	imul   $0x128,-0x34(%ebp),%ecx
801095f3:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801095f6:	31 db                	xor    %ebx,%ebx
801095f8:	8d 81 20 d7 12 80    	lea    -0x7fed28e0(%ecx),%eax
801095fe:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
80109601:	89 45 d0             	mov    %eax,-0x30(%ebp)
80109604:	8b 81 58 d7 12 80    	mov    -0x7fed28a8(%ecx),%eax
8010960a:	85 c0                	test   %eax,%eax
8010960c:	0f 84 8d 01 00 00    	je     8010979f <shmat+0x38f>
80109612:	89 7d c8             	mov    %edi,-0x38(%ebp)
80109615:	8b 7d e0             	mov    -0x20(%ebp),%edi
80109618:	eb 1b                	jmp    80109635 <shmat+0x225>
8010961a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80109620:	8b 45 d0             	mov    -0x30(%ebp),%eax
80109623:	83 c3 01             	add    $0x1,%ebx
80109626:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010962c:	39 58 38             	cmp    %ebx,0x38(%eax)
8010962f:	0f 86 67 01 00 00    	jbe    8010979c <shmat+0x38c>
		if(mappages(process->pgdir, (void*)((uint)va + (k*PGSIZE)), PGSIZE, (uint)shmTable.allRegions[index].physicalAddr[k], permflag) < 0) {
80109635:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80109638:	83 ec 08             	sub    $0x8,%esp
8010963b:	8b 47 04             	mov    0x4(%edi),%eax
8010963e:	ff 75 dc             	pushl  -0x24(%ebp)
80109641:	89 f2                	mov    %esi,%edx
80109643:	ff b4 99 64 d7 12 80 	pushl  -0x7fed289c(%ecx,%ebx,4)
8010964a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010964f:	e8 0c f0 ff ff       	call   80108660 <mappages>
80109654:	83 c4 10             	add    $0x10,%esp
80109657:	85 c0                	test   %eax,%eax
80109659:	79 c5                	jns    80109620 <shmat+0x210>
      deallocuvm(process->pgdir,(uint)va,(uint)(va + shmTable.allRegions[index].size));
8010965b:	69 45 cc 28 01 00 00 	imul   $0x128,-0x34(%ebp),%eax
  if(newsz >= oldsz)
80109662:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80109665:	8b 7d c8             	mov    -0x38(%ebp),%edi
      deallocuvm(process->pgdir,(uint)va,(uint)(va + shmTable.allRegions[index].size));
80109668:	03 b8 58 d7 12 80    	add    -0x7fed28a8(%eax),%edi
8010966e:	89 f9                	mov    %edi,%ecx
  if(newsz >= oldsz)
80109670:	39 d7                	cmp    %edx,%edi
80109672:	73 0b                	jae    8010967f <shmat+0x26f>
80109674:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109677:	8b 40 04             	mov    0x4(%eax),%eax
8010967a:	e8 71 f0 ff ff       	call   801086f0 <deallocuvm.part.0>
    release(&shmTable.lock);
8010967f:	83 ec 0c             	sub    $0xc,%esp
    return (void*)-1;
80109682:	bf ff ff ff ff       	mov    $0xffffffff,%edi
    release(&shmTable.lock);
80109687:	68 20 d7 12 80       	push   $0x8012d720
8010968c:	e8 df c6 ff ff       	call   80105d70 <release>
    return (void*)-1;
80109691:	83 c4 10             	add    $0x10,%esp
}
80109694:	8d 65 f4             	lea    -0xc(%ebp),%esp
80109697:	89 f8                	mov    %edi,%eax
80109699:	5b                   	pop    %ebx
8010969a:	5e                   	pop    %esi
8010969b:	5f                   	pop    %edi
8010969c:	5d                   	pop    %ebp
8010969d:	c3                   	ret    
      va = (void*)rounded;
8010969e:	01 f0                	add    %esi,%eax
801096a0:	89 f7                	mov    %esi,%edi
801096a2:	89 45 dc             	mov    %eax,-0x24(%ebp)
801096a5:	e9 1d fe ff ff       	jmp    801094c7 <shmat+0xb7>
801096aa:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  if((shmflag & SHM_RDONLY) || (shmTable.allRegions[index].buffer.shm_perm.mode == READ_SHM)){
801096ad:	f7 45 10 00 10 00 00 	testl  $0x1000,0x10(%ebp)
801096b4:	0f 85 2b ff ff ff    	jne    801095e5 <shmat+0x1d5>
801096ba:	69 45 cc 28 01 00 00 	imul   $0x128,-0x34(%ebp),%eax
801096c1:	8b 80 68 d8 12 80    	mov    -0x7fed2798(%eax),%eax
801096c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801096ca:	83 f8 04             	cmp    $0x4,%eax
801096cd:	0f 84 19 ff ff ff    	je     801095ec <shmat+0x1dc>
  else if (shmTable.allRegions[index].buffer.shm_perm.mode == RW_SHM) {
801096d3:	83 f8 06             	cmp    $0x6,%eax
801096d6:	0f 84 10 ff ff ff    	je     801095ec <shmat+0x1dc>
801096dc:	eb a1                	jmp    8010967f <shmat+0x26f>
801096de:	69 45 cc 28 01 00 00 	imul   $0x128,-0x34(%ebp),%eax
  if(shmaddr) {
801096e5:	c7 45 d4 40 00 00 00 	movl   $0x40,-0x2c(%ebp)
  void *va = (void*)HEAPLIMIT, *least_va;
801096ec:	bf 00 00 00 7f       	mov    $0x7f000000,%edi
801096f1:	8b 80 58 d7 12 80    	mov    -0x7fed28a8(%eax),%eax
801096f7:	c1 e0 0c             	shl    $0xc,%eax
801096fa:	89 45 dc             	mov    %eax,-0x24(%ebp)
801096fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80109700:	05 ac 00 00 00       	add    $0xac,%eax
80109705:	89 45 d8             	mov    %eax,-0x28(%ebp)
80109708:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010970f:	90                   	nop
  for(int i = 0; i < SHAREDREGIONS; i++) {
80109710:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80109713:	8b 45 d8             	mov    -0x28(%ebp),%eax
  int idx = -1;
80109716:	be ff ff ff ff       	mov    $0xffffffff,%esi
  void* leastva = (void*)(KERNBASE - 1);
8010971b:	bb ff ff ff 7f       	mov    $0x7fffffff,%ebx
  for(int i = 0; i < SHAREDREGIONS; i++) {
80109720:	31 d2                	xor    %edx,%edx
80109722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(process->pages[i].key != -1 && (uint)process->pages[i].virtualAddr >= (uint)curr_va && (uint)leastva >= (uint)process->pages[i].virtualAddr) {  
80109728:	83 38 ff             	cmpl   $0xffffffff,(%eax)
8010972b:	74 13                	je     80109740 <shmat+0x330>
8010972d:	8b 48 10             	mov    0x10(%eax),%ecx
80109730:	39 f9                	cmp    %edi,%ecx
80109732:	72 0c                	jb     80109740 <shmat+0x330>
80109734:	39 cb                	cmp    %ecx,%ebx
80109736:	72 08                	jb     80109740 <shmat+0x330>
80109738:	89 d6                	mov    %edx,%esi
      leastva = process->pages[i].virtualAddr;
8010973a:	89 cb                	mov    %ecx,%ebx
8010973c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(int i = 0; i < SHAREDREGIONS; i++) {
80109740:	83 c2 01             	add    $0x1,%edx
80109743:	83 c0 14             	add    $0x14,%eax
80109746:	83 fa 40             	cmp    $0x40,%edx
80109749:	75 dd                	jne    80109728 <shmat+0x318>
      if(idx != -1) {
8010974b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010974e:	8d 14 07             	lea    (%edi,%eax,1),%edx
80109751:	83 fe ff             	cmp    $0xffffffff,%esi
80109754:	74 3e                	je     80109794 <shmat+0x384>
        least_va = process->pages[idx].virtualAddr;
80109756:	8d 04 b6             	lea    (%esi,%esi,4),%eax
80109759:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010975c:	8d 0c 86             	lea    (%esi,%eax,4),%ecx
        if((uint)va + shmTable.allRegions[index].size*PGSIZE <=  (uint)least_va)        
8010975f:	8b 81 bc 00 00 00    	mov    0xbc(%ecx),%eax
80109765:	39 d0                	cmp    %edx,%eax
80109767:	73 2b                	jae    80109794 <shmat+0x384>
          va = (void*)((uint)least_va + process->pages[idx].size*PGSIZE);
80109769:	8b 91 b0 00 00 00    	mov    0xb0(%ecx),%edx
8010976f:	c1 e2 0c             	shl    $0xc,%edx
80109772:	01 d0                	add    %edx,%eax
    for(int i = 0; i < SHAREDREGIONS; i++) {
80109774:	83 6d d4 01          	subl   $0x1,-0x2c(%ebp)
          va = (void*)((uint)least_va + process->pages[idx].size*PGSIZE);
80109778:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010977b:	89 c7                	mov    %eax,%edi
    for(int i = 0; i < SHAREDREGIONS; i++) {
8010977d:	75 91                	jne    80109710 <shmat+0x300>
8010977f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80109782:	01 f8                	add    %edi,%eax
80109784:	89 45 dc             	mov    %eax,-0x24(%ebp)
80109787:	e9 3b fd ff ff       	jmp    801094c7 <shmat+0xb7>
8010978c:	8b 7d d0             	mov    -0x30(%ebp),%edi
8010978f:	e9 19 ff ff ff       	jmp    801096ad <shmat+0x29d>
80109794:	89 55 dc             	mov    %edx,-0x24(%ebp)
80109797:	e9 2b fd ff ff       	jmp    801094c7 <shmat+0xb7>
8010979c:	8b 7d c8             	mov    -0x38(%ebp),%edi
8010979f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  for(int i = 0; i < SHAREDREGIONS; i++) {
801097a2:	31 c0                	xor    %eax,%eax
801097a4:	eb 19                	jmp    801097bf <shmat+0x3af>
801097a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801097ad:	8d 76 00             	lea    0x0(%esi),%esi
801097b0:	83 c0 01             	add    $0x1,%eax
801097b3:	83 c2 14             	add    $0x14,%edx
801097b6:	83 f8 40             	cmp    $0x40,%eax
801097b9:	0f 84 c0 fe ff ff    	je     8010967f <shmat+0x26f>
    if(process->pages[i].key == -1) {
801097bf:	83 3a ff             	cmpl   $0xffffffff,(%edx)
801097c2:	75 ec                	jne    801097b0 <shmat+0x3a0>
    process->pages[idx].shmid = shmid;  
801097c4:	8b 75 e0             	mov    -0x20(%ebp),%esi
801097c7:	8d 04 80             	lea    (%eax,%eax,4),%eax
    process->pages[idx].perm = permflag;
801097ca:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  release(&shmTable.lock);
801097cd:	83 ec 0c             	sub    $0xc,%esp
    process->pages[idx].shmid = shmid;  
801097d0:	8d 14 86             	lea    (%esi,%eax,4),%edx
801097d3:	8b 45 08             	mov    0x8(%ebp),%eax
    process->pages[idx].virtualAddr = va;
801097d6:	89 ba bc 00 00 00    	mov    %edi,0xbc(%edx)
    process->pages[idx].shmid = shmid;  
801097dc:	89 82 b4 00 00 00    	mov    %eax,0xb4(%edx)
    process->pages[idx].key = shmTable.allRegions[index].key;
801097e2:	69 45 cc 28 01 00 00 	imul   $0x128,-0x34(%ebp),%eax
801097e9:	8b 88 54 d7 12 80    	mov    -0x7fed28ac(%eax),%ecx
801097ef:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
    process->pages[idx].size = shmTable.allRegions[index].size;
801097f5:	8b 88 58 d7 12 80    	mov    -0x7fed28a8(%eax),%ecx
    process->pages[idx].key = shmTable.allRegions[index].key;
801097fb:	05 20 d7 12 80       	add    $0x8012d720,%eax
    process->pages[idx].perm = permflag;
80109800:	89 9a b8 00 00 00    	mov    %ebx,0xb8(%edx)
    process->pages[idx].size = shmTable.allRegions[index].size;
80109806:	89 8a b0 00 00 00    	mov    %ecx,0xb0(%edx)
    shmTable.allRegions[index].buffer.shm_nattch += 1;
8010980c:	83 80 50 01 00 00 01 	addl   $0x1,0x150(%eax)
    shmTable.allRegions[index].buffer.shm_lpid = process->pid;
80109813:	8b 56 10             	mov    0x10(%esi),%edx
80109816:	89 90 58 01 00 00    	mov    %edx,0x158(%eax)
  release(&shmTable.lock);
8010981c:	68 20 d7 12 80       	push   $0x8012d720
80109821:	e8 4a c5 ff ff       	call   80105d70 <release>
  return va;
80109826:	83 c4 10             	add    $0x10,%esp
80109829:	e9 fd fb ff ff       	jmp    8010942b <shmat+0x1b>
        va = shmaddr;    
8010982e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80109831:	01 f8                	add    %edi,%eax
80109833:	89 45 dc             	mov    %eax,-0x24(%ebp)
80109836:	e9 8c fc ff ff       	jmp    801094c7 <shmat+0xb7>
8010983b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010983f:	90                   	nop

80109840 <shmctl>:
  Controls the shared memory regions corresponding to shmid,
  depending upon the cmd (command) provided and buf parameter,
  which is user equivalent of shmid_ds data structure
*/
int
shmctl(int shmid, int cmd, void *buf) {
80109840:	f3 0f 1e fb          	endbr32 
80109844:	55                   	push   %ebp
80109845:	89 e5                	mov    %esp,%ebp
80109847:	57                   	push   %edi
80109848:	56                   	push   %esi
80109849:	53                   	push   %ebx
8010984a:	83 ec 1c             	sub    $0x1c,%esp
8010984d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80109850:	8b 7d 0c             	mov    0xc(%ebp),%edi
80109853:	8b 75 10             	mov    0x10(%ebp),%esi
  // check shmid bound
  if(shmid < 0 || shmid > 64){
80109856:	83 fb 40             	cmp    $0x40,%ebx
80109859:	0f 87 e9 01 00 00    	ja     80109a48 <shmctl+0x208>
    return -1;
  }

  acquire(&shmTable.lock);
8010985f:	83 ec 0c             	sub    $0xc,%esp

  struct shmid_ds *buffer = (struct shmid_ds *)buf;

  int index = -1;
  index = shmTable.allRegions[shmid].shmid;
80109862:	69 db 28 01 00 00    	imul   $0x128,%ebx,%ebx
  acquire(&shmTable.lock);
80109868:	68 20 d7 12 80       	push   $0x8012d720
8010986d:	e8 3e c4 ff ff       	call   80105cb0 <acquire>
  index = shmTable.allRegions[shmid].shmid;
80109872:	8b 9b 5c d7 12 80    	mov    -0x7fed28a4(%ebx),%ebx
  // check for valid shmid
  if(index == -1) {
80109878:	83 c4 10             	add    $0x10,%esp
8010987b:	83 fb ff             	cmp    $0xffffffff,%ebx
8010987e:	0f 84 6c 01 00 00    	je     801099f0 <shmctl+0x1b0>
    release(&shmTable.lock);
    return -1;
  } else {
    // get permissions on region with provided shmid
    int checkPerm = shmTable.allRegions[index].buffer.shm_perm.mode;
    switch(cmd) {
80109884:	83 ff 01             	cmp    $0x1,%edi
80109887:	0f 84 83 01 00 00    	je     80109a10 <shmctl+0x1d0>
8010988d:	0f 8e 85 00 00 00    	jle    80109918 <shmctl+0xd8>
80109893:	83 ff 02             	cmp    $0x2,%edi
80109896:	74 09                	je     801098a1 <shmctl+0x61>
80109898:	83 ff 0d             	cmp    $0xd,%edi
8010989b:	0f 85 4f 01 00 00    	jne    801099f0 <shmctl+0x1b0>
        both will have same check on xv6 as there is only a single user
      */
      case SHM_STAT:
      case IPC_STAT:
        // check valid permissions
        if(buffer && (checkPerm == READ_SHM || checkPerm == RW_SHM)) {
801098a1:	85 f6                	test   %esi,%esi
801098a3:	0f 84 47 01 00 00    	je     801099f0 <shmctl+0x1b0>
    int checkPerm = shmTable.allRegions[index].buffer.shm_perm.mode;
801098a9:	69 db 28 01 00 00    	imul   $0x128,%ebx,%ebx
801098af:	8b 83 68 d8 12 80    	mov    -0x7fed2798(%ebx),%eax
801098b5:	81 c3 20 d7 12 80    	add    $0x8012d720,%ebx
        if(buffer && (checkPerm == READ_SHM || checkPerm == RW_SHM)) {
801098bb:	89 c2                	mov    %eax,%edx
801098bd:	83 e2 fd             	and    $0xfffffffd,%edx
801098c0:	83 fa 04             	cmp    $0x4,%edx
801098c3:	0f 85 27 01 00 00    	jne    801099f0 <shmctl+0x1b0>
          buffer->shm_nattch = shmTable.allRegions[index].buffer.shm_nattch;
801098c9:	8b 93 50 01 00 00    	mov    0x150(%ebx),%edx
801098cf:	89 56 0c             	mov    %edx,0xc(%esi)
          buffer->shm_segsz = shmTable.allRegions[index].buffer.shm_segsz;
801098d2:	8b 93 4c 01 00 00    	mov    0x14c(%ebx),%edx
801098d8:	89 56 08             	mov    %edx,0x8(%esi)
          buffer->shm_perm.__key = shmTable.allRegions[index].buffer.shm_perm.__key;
801098db:	8b 93 44 01 00 00    	mov    0x144(%ebx),%edx
          buffer->shm_perm.mode = checkPerm;
801098e1:	89 46 04             	mov    %eax,0x4(%esi)
          buffer->shm_perm.__key = shmTable.allRegions[index].buffer.shm_perm.__key;
801098e4:	89 16                	mov    %edx,(%esi)
          buffer->shm_cpid = shmTable.allRegions[index].buffer.shm_cpid;
801098e6:	8b 83 54 01 00 00    	mov    0x154(%ebx),%eax
801098ec:	89 46 10             	mov    %eax,0x10(%esi)
          buffer->shm_lpid = shmTable.allRegions[index].buffer.shm_lpid;
801098ef:	8b 83 58 01 00 00    	mov    0x158(%ebx),%eax
801098f5:	89 46 14             	mov    %eax,0x14(%esi)
          shmTable.allRegions[index].buffer.shm_lpid = -1;
        } else {
          // mark the segment to be destroyed
          shmTable.allRegions[index].toBeDeleted = 1;
        }
        release(&shmTable.lock);
801098f8:	83 ec 0c             	sub    $0xc,%esp
801098fb:	68 20 d7 12 80       	push   $0x8012d720
80109900:	e8 6b c4 ff ff       	call   80105d70 <release>
        return 0;
80109905:	83 c4 10             	add    $0x10,%esp
80109908:	31 c0                	xor    %eax,%eax
        release(&shmTable.lock);
        return -1;
        break;
    }
  } 
}
8010990a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010990d:	5b                   	pop    %ebx
8010990e:	5e                   	pop    %esi
8010990f:	5f                   	pop    %edi
80109910:	5d                   	pop    %ebp
80109911:	c3                   	ret    
80109912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(cmd) {
80109918:	85 ff                	test   %edi,%edi
8010991a:	0f 85 d0 00 00 00    	jne    801099f0 <shmctl+0x1b0>
        if(shmTable.allRegions[index].buffer.shm_nattch == 0) {
80109920:	69 d3 28 01 00 00    	imul   $0x128,%ebx,%edx
80109926:	8d ba 20 d7 12 80    	lea    -0x7fed28e0(%edx),%edi
8010992c:	8b b7 50 01 00 00    	mov    0x150(%edi),%esi
80109932:	85 f6                	test   %esi,%esi
80109934:	0f 85 fe 00 00 00    	jne    80109a38 <shmctl+0x1f8>
          for(int i = 0; i < shmTable.allRegions[index].size; i++) {
8010993a:	8b 47 38             	mov    0x38(%edi),%eax
8010993d:	85 c0                	test   %eax,%eax
8010993f:	74 38                	je     80109979 <shmctl+0x139>
80109941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            char *addr = (char *)P2V(shmTable.allRegions[index].physicalAddr[i]);
80109948:	8b 84 b2 64 d7 12 80 	mov    -0x7fed289c(%edx,%esi,4),%eax
            kfree(addr);
8010994f:	83 ec 0c             	sub    $0xc,%esp
            char *addr = (char *)P2V(shmTable.allRegions[index].physicalAddr[i]);
80109952:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80109955:	05 00 00 00 80       	add    $0x80000000,%eax
            kfree(addr);
8010995a:	50                   	push   %eax
8010995b:	e8 80 90 ff ff       	call   801029e0 <kfree>
            shmTable.allRegions[index].physicalAddr[i] = (void *)0;
80109960:	8b 55 e4             	mov    -0x1c(%ebp),%edx
          for(int i = 0; i < shmTable.allRegions[index].size; i++) {
80109963:	83 c4 10             	add    $0x10,%esp
            shmTable.allRegions[index].physicalAddr[i] = (void *)0;
80109966:	c7 84 b2 64 d7 12 80 	movl   $0x0,-0x7fed289c(%edx,%esi,4)
8010996d:	00 00 00 00 
          for(int i = 0; i < shmTable.allRegions[index].size; i++) {
80109971:	83 c6 01             	add    $0x1,%esi
80109974:	39 77 38             	cmp    %esi,0x38(%edi)
80109977:	77 cf                	ja     80109948 <shmctl+0x108>
          shmTable.allRegions[index].size = 0;
80109979:	69 db 28 01 00 00    	imul   $0x128,%ebx,%ebx
8010997f:	c7 83 58 d7 12 80 00 	movl   $0x0,-0x7fed28a8(%ebx)
80109986:	00 00 00 
          shmTable.allRegions[index].key = shmTable.allRegions[index].shmid = -1;
80109989:	c7 83 5c d7 12 80 ff 	movl   $0xffffffff,-0x7fed28a4(%ebx)
80109990:	ff ff ff 
80109993:	c7 83 54 d7 12 80 ff 	movl   $0xffffffff,-0x7fed28ac(%ebx)
8010999a:	ff ff ff 
          shmTable.allRegions[index].toBeDeleted = 0;
8010999d:	c7 83 60 d7 12 80 00 	movl   $0x0,-0x7fed28a0(%ebx)
801099a4:	00 00 00 
          shmTable.allRegions[index].buffer.shm_nattch = 0;
801099a7:	c7 83 70 d8 12 80 00 	movl   $0x0,-0x7fed2790(%ebx)
801099ae:	00 00 00 
          shmTable.allRegions[index].buffer.shm_segsz = 0;
801099b1:	c7 83 6c d8 12 80 00 	movl   $0x0,-0x7fed2794(%ebx)
801099b8:	00 00 00 
          shmTable.allRegions[index].buffer.shm_perm.__key = -1;
801099bb:	c7 83 64 d8 12 80 ff 	movl   $0xffffffff,-0x7fed279c(%ebx)
801099c2:	ff ff ff 
          shmTable.allRegions[index].buffer.shm_perm.mode = 0;
801099c5:	c7 83 68 d8 12 80 00 	movl   $0x0,-0x7fed2798(%ebx)
801099cc:	00 00 00 
          shmTable.allRegions[index].buffer.shm_cpid = -1;
801099cf:	c7 83 74 d8 12 80 ff 	movl   $0xffffffff,-0x7fed278c(%ebx)
801099d6:	ff ff ff 
          shmTable.allRegions[index].buffer.shm_lpid = -1;
801099d9:	c7 83 78 d8 12 80 ff 	movl   $0xffffffff,-0x7fed2788(%ebx)
801099e0:	ff ff ff 
801099e3:	e9 10 ff ff ff       	jmp    801098f8 <shmctl+0xb8>
801099e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801099ef:	90                   	nop
        release(&shmTable.lock);
801099f0:	83 ec 0c             	sub    $0xc,%esp
801099f3:	68 20 d7 12 80       	push   $0x8012d720
801099f8:	e8 73 c3 ff ff       	call   80105d70 <release>
        return -1;
801099fd:	83 c4 10             	add    $0x10,%esp
}
80109a00:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80109a03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80109a08:	5b                   	pop    %ebx
80109a09:	5e                   	pop    %esi
80109a0a:	5f                   	pop    %edi
80109a0b:	5d                   	pop    %ebp
80109a0c:	c3                   	ret    
80109a0d:	8d 76 00             	lea    0x0(%esi),%esi
        if(buffer) {
80109a10:	85 f6                	test   %esi,%esi
80109a12:	74 dc                	je     801099f0 <shmctl+0x1b0>
          if((buffer->shm_perm.mode == READ_SHM) || (buffer->shm_perm.mode == RW_SHM)) {
80109a14:	8b 46 04             	mov    0x4(%esi),%eax
80109a17:	89 c2                	mov    %eax,%edx
80109a19:	83 e2 fd             	and    $0xfffffffd,%edx
80109a1c:	83 fa 04             	cmp    $0x4,%edx
80109a1f:	75 cf                	jne    801099f0 <shmctl+0x1b0>
            shmTable.allRegions[index].buffer.shm_perm.mode = buffer->shm_perm.mode;
80109a21:	69 db 28 01 00 00    	imul   $0x128,%ebx,%ebx
80109a27:	89 83 68 d8 12 80    	mov    %eax,-0x7fed2798(%ebx)
            release(&shmTable.lock);
80109a2d:	e9 c6 fe ff ff       	jmp    801098f8 <shmctl+0xb8>
80109a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          shmTable.allRegions[index].toBeDeleted = 1;
80109a38:	c7 47 40 01 00 00 00 	movl   $0x1,0x40(%edi)
80109a3f:	e9 b4 fe ff ff       	jmp    801098f8 <shmctl+0xb8>
80109a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80109a48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
        break;
80109a4d:	e9 b8 fe ff ff       	jmp    8010990a <shmctl+0xca>
80109a52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80109a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80109a60 <sharedMemoryInit>:

// to initialize shared memory table
void
sharedMemoryInit(void) {
80109a60:	f3 0f 1e fb          	endbr32 
80109a64:	55                   	push   %ebp
80109a65:	89 e5                	mov    %esp,%ebp
80109a67:	83 ec 10             	sub    $0x10,%esp
  // initialize shmtable lock
  initlock(&shmTable.lock, "Shared Memory");
80109a6a:	68 7c a9 10 80       	push   $0x8010a97c
80109a6f:	68 20 d7 12 80       	push   $0x8012d720
80109a74:	e8 b7 c0 ff ff       	call   80105b30 <initlock>
  acquire(&shmTable.lock);
80109a79:	c7 04 24 20 d7 12 80 	movl   $0x8012d720,(%esp)
80109a80:	e8 2b c2 ff ff       	call   80105cb0 <acquire>
  // initialize all shmtable values
  for(int i = 0; i < SHAREDREGIONS; i++) {
80109a85:	ba 64 d8 12 80       	mov    $0x8012d864,%edx
80109a8a:	83 c4 10             	add    $0x10,%esp
80109a8d:	8d 76 00             	lea    0x0(%esi),%esi
    shmTable.allRegions[i].key = shmTable.allRegions[i].shmid = -1;
80109a90:	c7 82 f8 fe ff ff ff 	movl   $0xffffffff,-0x108(%edx)
80109a97:	ff ff ff 
80109a9a:	8d 82 00 ff ff ff    	lea    -0x100(%edx),%eax
80109aa0:	c7 82 f0 fe ff ff ff 	movl   $0xffffffff,-0x110(%edx)
80109aa7:	ff ff ff 
    shmTable.allRegions[i].size = 0;
80109aaa:	c7 82 f4 fe ff ff 00 	movl   $0x0,-0x10c(%edx)
80109ab1:	00 00 00 
    shmTable.allRegions[i].toBeDeleted = 0;
80109ab4:	c7 82 fc fe ff ff 00 	movl   $0x0,-0x104(%edx)
80109abb:	00 00 00 
    shmTable.allRegions[i].buffer.shm_nattch = 0;
80109abe:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
    shmTable.allRegions[i].buffer.shm_segsz = 0;
80109ac5:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
    shmTable.allRegions[i].buffer.shm_perm.__key = -1;
80109acc:	c7 02 ff ff ff ff    	movl   $0xffffffff,(%edx)
    shmTable.allRegions[i].buffer.shm_perm.mode = 0;
80109ad2:	c7 42 04 00 00 00 00 	movl   $0x0,0x4(%edx)
    shmTable.allRegions[i].buffer.shm_cpid = -1;
80109ad9:	c7 42 10 ff ff ff ff 	movl   $0xffffffff,0x10(%edx)
    shmTable.allRegions[i].buffer.shm_lpid = -1;
80109ae0:	c7 42 14 ff ff ff ff 	movl   $0xffffffff,0x14(%edx)
    for(int j = 0; j < SHAREDREGIONS; j++) {
80109ae7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80109aee:	66 90                	xchg   %ax,%ax
      shmTable.allRegions[i].physicalAddr[j] = (void *)0;
80109af0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    for(int j = 0; j < SHAREDREGIONS; j++) {
80109af6:	83 c0 04             	add    $0x4,%eax
80109af9:	39 d0                	cmp    %edx,%eax
80109afb:	75 f3                	jne    80109af0 <sharedMemoryInit+0x90>
  for(int i = 0; i < SHAREDREGIONS; i++) {
80109afd:	8d 90 28 01 00 00    	lea    0x128(%eax),%edx
80109b03:	3d 3c 21 13 80       	cmp    $0x8013213c,%eax
80109b08:	75 86                	jne    80109a90 <sharedMemoryInit+0x30>
    }
  }
  release(&shmTable.lock);
80109b0a:	83 ec 0c             	sub    $0xc,%esp
80109b0d:	68 20 d7 12 80       	push   $0x8012d720
80109b12:	e8 59 c2 ff ff       	call   80105d70 <release>
}
80109b17:	83 c4 10             	add    $0x10,%esp
80109b1a:	c9                   	leave  
80109b1b:	c3                   	ret    
80109b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80109b20 <getShmidIndex>:

// to return shmid index from shmtable
int
getShmidIndex(int shmid) {
80109b20:	f3 0f 1e fb          	endbr32 
80109b24:	55                   	push   %ebp
80109b25:	89 e5                	mov    %esp,%ebp
80109b27:	8b 45 08             	mov    0x8(%ebp),%eax
  if(shmid < 0 || shmid > 64) {
80109b2a:	83 f8 40             	cmp    $0x40,%eax
80109b2d:	77 11                	ja     80109b40 <getShmidIndex+0x20>
    return -1;
  }
  return shmTable.allRegions[shmid].shmid;
80109b2f:	69 c0 28 01 00 00    	imul   $0x128,%eax,%eax
}
80109b35:	5d                   	pop    %ebp
  return shmTable.allRegions[shmid].shmid;
80109b36:	8b 80 5c d7 12 80    	mov    -0x7fed28a4(%eax),%eax
}
80109b3c:	c3                   	ret    
80109b3d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80109b40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80109b45:	5d                   	pop    %ebp
80109b46:	c3                   	ret    
80109b47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80109b4e:	66 90                	xchg   %ax,%ax

80109b50 <mappagesWrapper>:

void mappagesWrapper(struct proc *process, int shmIndex, int index) {
80109b50:	f3 0f 1e fb          	endbr32 
80109b54:	55                   	push   %ebp
80109b55:	89 e5                	mov    %esp,%ebp
80109b57:	57                   	push   %edi
80109b58:	56                   	push   %esi
80109b59:	53                   	push   %ebx
80109b5a:	83 ec 1c             	sub    $0x1c,%esp
80109b5d:	8b 45 10             	mov    0x10(%ebp),%eax
80109b60:	8b 7d 08             	mov    0x8(%ebp),%edi
80109b63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  for(int i = 0; i < process->pages[index].size; i++) {
80109b66:	8d 04 80             	lea    (%eax,%eax,4),%eax
80109b69:	8d 34 87             	lea    (%edi,%eax,4),%esi
void mappagesWrapper(struct proc *process, int shmIndex, int index) {
80109b6c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  for(int i = 0; i < process->pages[index].size; i++) {
80109b6f:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
80109b75:	85 c0                	test   %eax,%eax
80109b77:	74 6b                	je     80109be4 <mappagesWrapper+0x94>
80109b79:	69 c1 28 01 00 00    	imul   $0x128,%ecx,%eax
80109b7f:	31 db                	xor    %ebx,%ebx
80109b81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80109b84:	eb 15                	jmp    80109b9b <mappagesWrapper+0x4b>
80109b86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80109b8d:	8d 76 00             	lea    0x0(%esi),%esi
80109b90:	83 c3 01             	add    $0x1,%ebx
80109b93:	39 9e b0 00 00 00    	cmp    %ebx,0xb0(%esi)
80109b99:	76 49                	jbe    80109be4 <mappagesWrapper+0x94>
    uint va = (uint)process->pages[index].virtualAddr;
80109b9b:	8b 86 bc 00 00 00    	mov    0xbc(%esi),%eax
    if(mappages(process->pgdir, (void*)(va + (i * PGSIZE)), PGSIZE, (uint)shmTable.allRegions[shmIndex].physicalAddr[i], process->pages[index].perm) < 0) {
80109ba1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80109ba4:	89 da                	mov    %ebx,%edx
80109ba6:	83 ec 08             	sub    $0x8,%esp
80109ba9:	c1 e2 0c             	shl    $0xc,%edx
    uint va = (uint)process->pages[index].virtualAddr;
80109bac:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if(mappages(process->pgdir, (void*)(va + (i * PGSIZE)), PGSIZE, (uint)shmTable.allRegions[shmIndex].physicalAddr[i], process->pages[index].perm) < 0) {
80109baf:	01 c2                	add    %eax,%edx
80109bb1:	8b 47 04             	mov    0x4(%edi),%eax
80109bb4:	ff b6 b8 00 00 00    	pushl  0xb8(%esi)
80109bba:	ff b4 99 64 d7 12 80 	pushl  -0x7fed289c(%ecx,%ebx,4)
80109bc1:	b9 00 10 00 00       	mov    $0x1000,%ecx
80109bc6:	e8 95 ea ff ff       	call   80108660 <mappages>
80109bcb:	83 c4 10             	add    $0x10,%esp
80109bce:	85 c0                	test   %eax,%eax
80109bd0:	79 be                	jns    80109b90 <mappagesWrapper+0x40>
      deallocuvm(process->pgdir, va, (uint)(va + shmTable.allRegions[shmIndex].size));
80109bd2:	69 45 dc 28 01 00 00 	imul   $0x128,-0x24(%ebp),%eax
80109bd9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80109bdc:	03 88 58 d7 12 80    	add    -0x7fed28a8(%eax),%ecx
80109be2:	72 08                	jb     80109bec <mappagesWrapper+0x9c>
      return;
    }
  }
}
80109be4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80109be7:	5b                   	pop    %ebx
80109be8:	5e                   	pop    %esi
80109be9:	5f                   	pop    %edi
80109bea:	5d                   	pop    %ebp
80109beb:	c3                   	ret    
80109bec:	8b 47 04             	mov    0x4(%edi),%eax
80109bef:	8b 55 e0             	mov    -0x20(%ebp),%edx
80109bf2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80109bf5:	5b                   	pop    %ebx
80109bf6:	5e                   	pop    %esi
80109bf7:	5f                   	pop    %edi
80109bf8:	5d                   	pop    %ebp
80109bf9:	e9 f2 ea ff ff       	jmp    801086f0 <deallocuvm.part.0>
80109bfe:	66 90                	xchg   %ax,%ax

80109c00 <shmdtWrapper>:

void shmdtWrapper(void *addr) {
80109c00:	f3 0f 1e fb          	endbr32 
  // call shmdt
  shmdt(addr);
80109c04:	e9 e7 f5 ff ff       	jmp    801091f0 <shmdt>
