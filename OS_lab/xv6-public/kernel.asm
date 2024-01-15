
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
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
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
80100028:	bc 30 d6 10 80       	mov    $0x8010d630,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 60 35 10 80       	mov    $0x80103560,%eax
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
80100048:	bb 74 d6 10 80       	mov    $0x8010d674,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 80 8c 10 80       	push   $0x80108c80
80100055:	68 40 d6 10 80       	push   $0x8010d640
8010005a:	e8 61 5a 00 00       	call   80105ac0 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 3c 1d 11 80       	mov    $0x80111d3c,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 8c 1d 11 80 3c 	movl   $0x80111d3c,0x80111d8c
8010006e:	1d 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 90 1d 11 80 3c 	movl   $0x80111d3c,0x80111d90
80100078:	1d 11 80 
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
8010008b:	c7 43 50 3c 1d 11 80 	movl   $0x80111d3c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 87 8c 10 80       	push   $0x80108c87
80100097:	50                   	push   %eax
80100098:	e8 c3 57 00 00       	call   80105860 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 90 1d 11 80       	mov    0x80111d90,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 90 1d 11 80    	mov    %ebx,0x80111d90
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb e0 1a 11 80    	cmp    $0x80111ae0,%ebx
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
801000e3:	68 40 d6 10 80       	push   $0x8010d640
801000e8:	e8 53 5b 00 00       	call   80105c40 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 90 1d 11 80    	mov    0x80111d90,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb 3c 1d 11 80    	cmp    $0x80111d3c,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 3c 1d 11 80    	cmp    $0x80111d3c,%ebx
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
80100120:	8b 1d 8c 1d 11 80    	mov    0x80111d8c,%ebx
80100126:	81 fb 3c 1d 11 80    	cmp    $0x80111d3c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 3c 1d 11 80    	cmp    $0x80111d3c,%ebx
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
8010015d:	68 40 d6 10 80       	push   $0x8010d640
80100162:	e8 99 5b 00 00       	call   80105d00 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 2e 57 00 00       	call   801058a0 <acquiresleep>
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
8010018c:	e8 0f 26 00 00       	call   801027a0 <iderw>
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
801001a3:	68 8e 8c 10 80       	push   $0x80108c8e
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
801001c2:	e8 79 57 00 00       	call   80105940 <holdingsleep>
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
801001d8:	e9 c3 25 00 00       	jmp    801027a0 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 9f 8c 10 80       	push   $0x80108c9f
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
80100203:	e8 38 57 00 00       	call   80105940 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 e8 56 00 00       	call   80105900 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 40 d6 10 80 	movl   $0x8010d640,(%esp)
8010021f:	e8 1c 5a 00 00       	call   80105c40 <acquire>
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
80100246:	a1 90 1d 11 80       	mov    0x80111d90,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 3c 1d 11 80 	movl   $0x80111d3c,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 90 1d 11 80       	mov    0x80111d90,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 90 1d 11 80    	mov    %ebx,0x80111d90
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 40 d6 10 80 	movl   $0x8010d640,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 8b 5a 00 00       	jmp    80105d00 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 a6 8c 10 80       	push   $0x80108ca6
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
801002a5:	e8 b6 1a 00 00       	call   80101d60 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
801002b1:	e8 8a 59 00 00       	call   80105c40 <acquire>
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
801002c6:	a1 20 20 11 80       	mov    0x80112020,%eax
801002cb:	3b 05 24 20 11 80    	cmp    0x80112024,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 c5 10 80       	push   $0x8010c520
801002e0:	68 20 20 11 80       	push   $0x80112020
801002e5:	e8 e6 41 00 00       	call   801044d0 <sleep>
    while(input.r == input.w){
801002ea:	a1 20 20 11 80       	mov    0x80112020,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 24 20 11 80    	cmp    0x80112024,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 f1 3b 00 00       	call   80103ef0 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 c5 10 80       	push   $0x8010c520
8010030e:	e8 ed 59 00 00       	call   80105d00 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 64 19 00 00       	call   80101c80 <ilock>
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
80100333:	89 15 20 20 11 80    	mov    %edx,0x80112020
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a a0 1f 11 80 	movsbl -0x7feee060(%edx),%ecx
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
80100360:	68 20 c5 10 80       	push   $0x8010c520
80100365:	e8 96 59 00 00       	call   80105d00 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 0d 19 00 00       	call   80101c80 <ilock>
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
80100386:	a3 20 20 11 80       	mov    %eax,0x80112020
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
8010039d:	c7 05 54 c5 10 80 00 	movl   $0x0,0x8010c554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 0e 2a 00 00       	call   80102dc0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 ad 8c 10 80       	push   $0x80108cad
801003bb:	e8 00 05 00 00       	call   801008c0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 f7 04 00 00       	call   801008c0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 05 93 10 80 	movl   $0x80109305,(%esp)
801003d0:	e8 eb 04 00 00       	call   801008c0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 ff 56 00 00       	call   80105ae0 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 c1 8c 10 80       	push   $0x80108cc1
801003f1:	e8 ca 04 00 00       	call   801008c0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 5c c5 10 80 01 	movl   $0x1,0x8010c55c
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
8010042a:	e8 41 74 00 00       	call   80107870 <uartputc>
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
80100468:	8b 3d 58 c5 10 80    	mov    0x8010c558,%edi
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
801004ce:	8b 3d 58 c5 10 80    	mov    0x8010c558,%edi
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
80100560:	c7 05 58 c5 10 80 00 	movl   $0x0,0x8010c558
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
8010058d:	e8 de 72 00 00       	call   80107870 <uartputc>
80100592:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100599:	e8 d2 72 00 00       	call   80107870 <uartputc>
8010059e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801005a5:	e8 c6 72 00 00       	call   80107870 <uartputc>
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
801005cf:	e8 1c 58 00 00       	call   80105df0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801005d4:	b8 80 07 00 00       	mov    $0x780,%eax
801005d9:	83 c4 0c             	add    $0xc,%esp
801005dc:	29 d8                	sub    %ebx,%eax
801005de:	01 c0                	add    %eax,%eax
801005e0:	50                   	push   %eax
801005e1:	8d 84 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%eax
801005e8:	6a 00                	push   $0x0
801005ea:	50                   	push   %eax
801005eb:	e8 60 57 00 00       	call   80105d50 <memset>
801005f0:	8b 3d 58 c5 10 80    	mov    0x8010c558,%edi
801005f6:	c6 45 e4 07          	movb   $0x7,-0x1c(%ebp)
801005fa:	83 c4 10             	add    $0x10,%esp
801005fd:	01 df                	add    %ebx,%edi
801005ff:	e9 d7 fe ff ff       	jmp    801004db <consputc.part.0+0xcb>
    panic("pos under/overflow");
80100604:	83 ec 0c             	sub    $0xc,%esp
80100607:	68 c5 8c 10 80       	push   $0x80108cc5
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
80100649:	0f b6 92 48 8d 10 80 	movzbl -0x7fef72b8(%edx),%edx
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
80100683:	8b 15 5c c5 10 80    	mov    0x8010c55c,%edx
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
801006cc:	a1 58 c5 10 80       	mov    0x8010c558,%eax
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
8010072f:	c7 05 58 c5 10 80 00 	movl   $0x0,0x8010c558
80100736:	00 00 00 
  for ( int i = input.e ; i > input.w ; i-- ){
80100739:	8b 1d 28 20 11 80    	mov    0x80112028,%ebx
8010073f:	3b 1d 24 20 11 80    	cmp    0x80112024,%ebx
80100745:	76 2b                	jbe    80100772 <arrow+0xb2>
    if (input.buf[i - 1] != '\n'){
80100747:	83 eb 01             	sub    $0x1,%ebx
8010074a:	80 bb a0 1f 11 80 0a 	cmpb   $0xa,-0x7feee060(%ebx)
80100751:	74 17                	je     8010076a <arrow+0xaa>
  if(panicked){
80100753:	8b 15 5c c5 10 80    	mov    0x8010c55c,%edx
80100759:	85 d2                	test   %edx,%edx
8010075b:	74 03                	je     80100760 <arrow+0xa0>
  asm volatile("cli");
8010075d:	fa                   	cli    
    for(;;)
8010075e:	eb fe                	jmp    8010075e <arrow+0x9e>
80100760:	b8 00 01 00 00       	mov    $0x100,%eax
80100765:	e8 a6 fc ff ff       	call   80100410 <consputc.part.0>
  for ( int i = input.e ; i > input.w ; i-- ){
8010076a:	39 1d 24 20 11 80    	cmp    %ebx,0x80112024
80100770:	72 d5                	jb     80100747 <arrow+0x87>
  if (arr == UP){
80100772:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80100775:	a1 b8 25 11 80       	mov    0x801125b8,%eax
8010077a:	85 c9                	test   %ecx,%ecx
8010077c:	74 50                	je     801007ce <arrow+0x10e>
  if ((arr == DOWN)&&(history.index < 9)&&(history.index + 1 < history.last )){
8010077e:	83 f8 08             	cmp    $0x8,%eax
80100781:	0f 8f b8 00 00 00    	jg     8010083f <arrow+0x17f>
80100787:	8d 50 01             	lea    0x1(%eax),%edx
8010078a:	3b 15 c0 25 11 80    	cmp    0x801125c0,%edx
80100790:	0f 8d a9 00 00 00    	jge    8010083f <arrow+0x17f>
    input = history.hist[history.index + 2 ];
80100796:	8d 70 02             	lea    0x2(%eax),%esi
80100799:	bf a0 1f 11 80       	mov    $0x80111fa0,%edi
8010079e:	b9 23 00 00 00       	mov    $0x23,%ecx
    history.index ++ ;
801007a3:	89 15 b8 25 11 80    	mov    %edx,0x801125b8
    input = history.hist[history.index + 2 ];
801007a9:	69 f6 8c 00 00 00    	imul   $0x8c,%esi,%esi
801007af:	81 c6 40 20 11 80    	add    $0x80112040,%esi
801007b5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    input.e -- ;
801007b7:	8b 15 28 20 11 80    	mov    0x80112028,%edx
801007bd:	8d 42 ff             	lea    -0x1(%edx),%eax
    input.buf[input.e] = '\0';
801007c0:	c6 82 9f 1f 11 80 00 	movb   $0x0,-0x7feee061(%edx)
    input.e -- ;
801007c7:	a3 28 20 11 80       	mov    %eax,0x80112028
    input.buf[input.e] = '\0';
801007cc:	eb 35                	jmp    80100803 <arrow+0x143>
    input = history.hist[history.index ];
801007ce:	69 f0 8c 00 00 00    	imul   $0x8c,%eax,%esi
801007d4:	bf a0 1f 11 80       	mov    $0x80111fa0,%edi
801007d9:	b9 23 00 00 00       	mov    $0x23,%ecx
    history.index -- ;
801007de:	83 e8 01             	sub    $0x1,%eax
801007e1:	a3 b8 25 11 80       	mov    %eax,0x801125b8
    input = history.hist[history.index ];
801007e6:	81 c6 40 20 11 80    	add    $0x80112040,%esi
801007ec:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    input.e -- ;
801007ee:	8b 15 28 20 11 80    	mov    0x80112028,%edx
801007f4:	8d 42 ff             	lea    -0x1(%edx),%eax
    input.buf[input.e] = '\0';
801007f7:	c6 82 9f 1f 11 80 00 	movb   $0x0,-0x7feee061(%edx)
    input.e -- ;
801007fe:	a3 28 20 11 80       	mov    %eax,0x80112028
  for (int i = input.w ; i < input.e; i++)
80100803:	8b 1d 24 20 11 80    	mov    0x80112024,%ebx
80100809:	39 d8                	cmp    %ebx,%eax
8010080b:	76 2a                	jbe    80100837 <arrow+0x177>
  if(panicked){
8010080d:	a1 5c c5 10 80       	mov    0x8010c55c,%eax
80100812:	85 c0                	test   %eax,%eax
80100814:	74 0a                	je     80100820 <arrow+0x160>
80100816:	fa                   	cli    
    for(;;)
80100817:	eb fe                	jmp    80100817 <arrow+0x157>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(input.buf[i]);
80100820:	0f be 83 a0 1f 11 80 	movsbl -0x7feee060(%ebx),%eax
  for (int i = input.w ; i < input.e; i++)
80100827:	83 c3 01             	add    $0x1,%ebx
8010082a:	e8 e1 fb ff ff       	call   80100410 <consputc.part.0>
8010082f:	39 1d 28 20 11 80    	cmp    %ebx,0x80112028
80100835:	77 d6                	ja     8010080d <arrow+0x14d>
}
80100837:	83 c4 1c             	add    $0x1c,%esp
8010083a:	5b                   	pop    %ebx
8010083b:	5e                   	pop    %esi
8010083c:	5f                   	pop    %edi
8010083d:	5d                   	pop    %ebp
8010083e:	c3                   	ret    
8010083f:	a1 28 20 11 80       	mov    0x80112028,%eax
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
80100863:	e8 f8 14 00 00       	call   80101d60 <iunlock>
  acquire(&cons.lock);
80100868:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010086f:	e8 cc 53 00 00       	call   80105c40 <acquire>
  for(i = 0; i < n; i++)
80100874:	83 c4 10             	add    $0x10,%esp
80100877:	85 db                	test   %ebx,%ebx
80100879:	7e 24                	jle    8010089f <consolewrite+0x4f>
8010087b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010087e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100881:	8b 15 5c c5 10 80    	mov    0x8010c55c,%edx
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
801008a2:	68 20 c5 10 80       	push   $0x8010c520
801008a7:	e8 54 54 00 00       	call   80105d00 <release>
  ilock(ip);
801008ac:	58                   	pop    %eax
801008ad:	ff 75 08             	pushl  0x8(%ebp)
801008b0:	e8 cb 13 00 00       	call   80101c80 <ilock>

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
801008cd:	a1 54 c5 10 80       	mov    0x8010c554,%eax
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
801008fc:	8b 0d 5c c5 10 80    	mov    0x8010c55c,%ecx
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
8010098d:	bb d8 8c 10 80       	mov    $0x80108cd8,%ebx
      for(; *s; s++)
80100992:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100997:	8b 15 5c c5 10 80    	mov    0x8010c55c,%edx
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
801009c8:	68 20 c5 10 80       	push   $0x8010c520
801009cd:	e8 6e 52 00 00       	call   80105c40 <acquire>
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
801009f0:	8b 3d 5c c5 10 80    	mov    0x8010c55c,%edi
801009f6:	85 ff                	test   %edi,%edi
801009f8:	0f 84 12 ff ff ff    	je     80100910 <cprintf+0x50>
801009fe:	fa                   	cli    
    for(;;)
801009ff:	eb fe                	jmp    801009ff <cprintf+0x13f>
80100a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
80100a08:	8b 0d 5c c5 10 80    	mov    0x8010c55c,%ecx
80100a0e:	85 c9                	test   %ecx,%ecx
80100a10:	74 06                	je     80100a18 <cprintf+0x158>
80100a12:	fa                   	cli    
    for(;;)
80100a13:	eb fe                	jmp    80100a13 <cprintf+0x153>
80100a15:	8d 76 00             	lea    0x0(%esi),%esi
80100a18:	b8 25 00 00 00       	mov    $0x25,%eax
80100a1d:	e8 ee f9 ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100a22:	8b 15 5c c5 10 80    	mov    0x8010c55c,%edx
80100a28:	85 d2                	test   %edx,%edx
80100a2a:	74 2c                	je     80100a58 <cprintf+0x198>
80100a2c:	fa                   	cli    
    for(;;)
80100a2d:	eb fe                	jmp    80100a2d <cprintf+0x16d>
80100a2f:	90                   	nop
    release(&cons.lock);
80100a30:	83 ec 0c             	sub    $0xc,%esp
80100a33:	68 20 c5 10 80       	push   $0x8010c520
80100a38:	e8 c3 52 00 00       	call   80105d00 <release>
80100a3d:	83 c4 10             	add    $0x10,%esp
}
80100a40:	e9 ee fe ff ff       	jmp    80100933 <cprintf+0x73>
    panic("null fmt");
80100a45:	83 ec 0c             	sub    $0xc,%esp
80100a48:	68 df 8c 10 80       	push   $0x80108cdf
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
80100a82:	68 20 c5 10 80       	push   $0x8010c520
{
80100a87:	89 45 dc             	mov    %eax,-0x24(%ebp)
  acquire(&cons.lock);
80100a8a:	e8 b1 51 00 00       	call   80105c40 <acquire>
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
80100ab8:	3e ff 24 b5 f0 8c 10 	notrack jmp *-0x7fef7310(,%esi,4)
80100abf:	80 
80100ac0:	bb 01 00 00 00       	mov    $0x1,%ebx
80100ac5:	eb cb                	jmp    80100a92 <consoleintr+0x22>
80100ac7:	b8 00 01 00 00       	mov    $0x100,%eax
80100acc:	e8 3f f9 ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
80100ad1:	a1 28 20 11 80       	mov    0x80112028,%eax
80100ad6:	3b 05 24 20 11 80    	cmp    0x80112024,%eax
80100adc:	74 b4                	je     80100a92 <consoleintr+0x22>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100ade:	83 e8 01             	sub    $0x1,%eax
80100ae1:	89 c2                	mov    %eax,%edx
80100ae3:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100ae6:	80 ba a0 1f 11 80 0a 	cmpb   $0xa,-0x7feee060(%edx)
80100aed:	74 a3                	je     80100a92 <consoleintr+0x22>
        input.e--;
80100aef:	a3 28 20 11 80       	mov    %eax,0x80112028
  if(panicked){
80100af4:	a1 5c c5 10 80       	mov    0x8010c55c,%eax
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
80100b14:	a1 bc 25 11 80       	mov    0x801125bc,%eax
80100b19:	85 c0                	test   %eax,%eax
80100b1b:	0f 84 71 ff ff ff    	je     80100a92 <consoleintr+0x22>
80100b21:	a1 c0 25 11 80       	mov    0x801125c0,%eax
80100b26:	2b 05 b8 25 11 80    	sub    0x801125b8,%eax
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
80100b51:	a1 28 20 11 80       	mov    0x80112028,%eax
80100b56:	3b 05 24 20 11 80    	cmp    0x80112024,%eax
80100b5c:	0f 84 30 ff ff ff    	je     80100a92 <consoleintr+0x22>
        input.e--;  
80100b62:	83 e8 01             	sub    $0x1,%eax
80100b65:	a3 28 20 11 80       	mov    %eax,0x80112028
  if(panicked){
80100b6a:	a1 5c c5 10 80       	mov    0x8010c55c,%eax
80100b6f:	85 c0                	test   %eax,%eax
80100b71:	0f 84 06 02 00 00    	je     80100d7d <consoleintr+0x30d>
80100b77:	fa                   	cli    
    for(;;)
80100b78:	eb fe                	jmp    80100b78 <consoleintr+0x108>
      if (backs > 0) {
80100b7a:	a1 58 c5 10 80       	mov    0x8010c558,%eax
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
80100bdd:	a3 58 c5 10 80       	mov    %eax,0x8010c558
80100be2:	e9 ab fe ff ff       	jmp    80100a92 <consoleintr+0x22>
      if ((input.e - backs) > input.w)
80100be7:	a1 58 c5 10 80       	mov    0x8010c558,%eax
80100bec:	8b 3d 28 20 11 80    	mov    0x80112028,%edi
80100bf2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100bf5:	29 c7                	sub    %eax,%edi
80100bf7:	3b 3d 24 20 11 80    	cmp    0x80112024,%edi
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
80100c56:	a3 58 c5 10 80       	mov    %eax,0x8010c558
80100c5b:	e9 32 fe ff ff       	jmp    80100a92 <consoleintr+0x22>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100c60:	85 f6                	test   %esi,%esi
80100c62:	0f 84 2a fe ff ff    	je     80100a92 <consoleintr+0x22>
80100c68:	a1 28 20 11 80       	mov    0x80112028,%eax
80100c6d:	89 c2                	mov    %eax,%edx
80100c6f:	2b 15 20 20 11 80    	sub    0x80112020,%edx
80100c75:	83 fa 7f             	cmp    $0x7f,%edx
80100c78:	0f 87 14 fe ff ff    	ja     80100a92 <consoleintr+0x22>
        c = (c == '\r') ? '\n' : c;
80100c7e:	8d 48 01             	lea    0x1(%eax),%ecx
80100c81:	8b 15 5c c5 10 80    	mov    0x8010c55c,%edx
80100c87:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
80100c8a:	89 0d 28 20 11 80    	mov    %ecx,0x80112028
        c = (c == '\r') ? '\n' : c;
80100c90:	83 fe 0d             	cmp    $0xd,%esi
80100c93:	0f 84 f3 00 00 00    	je     80100d8c <consoleintr+0x31c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100c99:	89 f1                	mov    %esi,%ecx
80100c9b:	88 88 a0 1f 11 80    	mov    %cl,-0x7feee060(%eax)
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
80100cd1:	8b 3d 5c c5 10 80    	mov    0x8010c55c,%edi
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
80100cef:	8b 0d 5c c5 10 80    	mov    0x8010c55c,%ecx
  backs = 0;
80100cf5:	c7 05 58 c5 10 80 00 	movl   $0x0,0x8010c558
80100cfc:	00 00 00 
  input.e = input.w = input.r = 0;
80100cff:	c7 05 20 20 11 80 00 	movl   $0x0,0x80112020
80100d06:	00 00 00 
80100d09:	c7 05 24 20 11 80 00 	movl   $0x0,0x80112024
80100d10:	00 00 00 
80100d13:	c7 05 28 20 11 80 00 	movl   $0x0,0x80112028
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
80100d30:	8b 15 bc 25 11 80    	mov    0x801125bc,%edx
80100d36:	85 d2                	test   %edx,%edx
80100d38:	0f 84 54 fd ff ff    	je     80100a92 <consoleintr+0x22>
80100d3e:	a1 c0 25 11 80       	mov    0x801125c0,%eax
80100d43:	2b 05 b8 25 11 80    	sub    0x801125b8,%eax
80100d49:	39 c2                	cmp    %eax,%edx
80100d4b:	0f 8e 41 fd ff ff    	jle    80100a92 <consoleintr+0x22>
        arrow(UP);
80100d51:	31 c0                	xor    %eax,%eax
80100d53:	e8 68 f9 ff ff       	call   801006c0 <arrow>
80100d58:	e9 35 fd ff ff       	jmp    80100a92 <consoleintr+0x22>
  release(&cons.lock);
80100d5d:	83 ec 0c             	sub    $0xc,%esp
80100d60:	68 20 c5 10 80       	push   $0x8010c520
80100d65:	e8 96 4f 00 00       	call   80105d00 <release>
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
80100d8c:	c6 80 a0 1f 11 80 0a 	movb   $0xa,-0x7feee060(%eax)
  if(panicked){
80100d93:	85 d2                	test   %edx,%edx
80100d95:	0f 85 0e ff ff ff    	jne    80100ca9 <consoleintr+0x239>
80100d9b:	b8 0a 00 00 00       	mov    $0xa,%eax
80100da0:	e8 6b f6 ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100da5:	8b 15 28 20 11 80    	mov    0x80112028,%edx
          if (history.count < 9){
80100dab:	a1 bc 25 11 80       	mov    0x801125bc,%eax
80100db0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100db3:	83 f8 08             	cmp    $0x8,%eax
80100db6:	0f 8f 05 01 00 00    	jg     80100ec1 <consoleintr+0x451>
            history.hist[history.last + 1] = input;
80100dbc:	8b 3d c0 25 11 80    	mov    0x801125c0,%edi
80100dc2:	b9 23 00 00 00       	mov    $0x23,%ecx
80100dc7:	be a0 1f 11 80       	mov    $0x80111fa0,%esi
80100dcc:	83 c7 01             	add    $0x1,%edi
80100dcf:	69 c7 8c 00 00 00    	imul   $0x8c,%edi,%eax
80100dd5:	89 7d e0             	mov    %edi,-0x20(%ebp)
80100dd8:	05 40 20 11 80       	add    $0x80112040,%eax
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
80100dea:	89 3d c0 25 11 80    	mov    %edi,0x801125c0
            history.index = history.last;
80100df0:	89 3d b8 25 11 80    	mov    %edi,0x801125b8
            history.count ++ ;
80100df6:	a3 bc 25 11 80       	mov    %eax,0x801125bc
          wakeup(&input.r);
80100dfb:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100dfe:	89 15 24 20 11 80    	mov    %edx,0x80112024
          wakeup(&input.r);
80100e04:	68 20 20 11 80       	push   $0x80112020
          backs = 0;
80100e09:	c7 05 58 c5 10 80 00 	movl   $0x0,0x8010c558
80100e10:	00 00 00 
          wakeup(&input.r);
80100e13:	e8 78 38 00 00       	call   80104690 <wakeup>
80100e18:	83 c4 10             	add    $0x10,%esp
80100e1b:	e9 72 fc ff ff       	jmp    80100a92 <consoleintr+0x22>
80100e20:	b8 24 00 00 00       	mov    $0x24,%eax
80100e25:	e8 e6 f5 ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100e2a:	8b 15 5c c5 10 80    	mov    0x8010c55c,%edx
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
80100e99:	a1 20 20 11 80       	mov    0x80112020,%eax
80100e9e:	8d 90 80 00 00 00    	lea    0x80(%eax),%edx
80100ea4:	39 15 28 20 11 80    	cmp    %edx,0x80112028
80100eaa:	0f 85 e2 fb ff ff    	jne    80100a92 <consoleintr+0x22>
80100eb0:	e9 f6 fe ff ff       	jmp    80100dab <consoleintr+0x33b>
}
80100eb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100eb8:	5b                   	pop    %ebx
80100eb9:	5e                   	pop    %esi
80100eba:	5f                   	pop    %edi
80100ebb:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100ebc:	e9 af 39 00 00       	jmp    80104870 <procdump>
80100ec1:	b8 40 20 11 80       	mov    $0x80112040,%eax
              history.hist[h] = history.hist[h+1]; 
80100ec6:	8d b0 8c 00 00 00    	lea    0x8c(%eax),%esi
80100ecc:	89 c7                	mov    %eax,%edi
80100ece:	b9 23 00 00 00       	mov    $0x23,%ecx
80100ed3:	05 8c 00 00 00       	add    $0x8c,%eax
80100ed8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            for (int h = 0; h < 9; h++) {
80100eda:	bf 2c 25 11 80       	mov    $0x8011252c,%edi
80100edf:	39 c7                	cmp    %eax,%edi
80100ee1:	75 e3                	jne    80100ec6 <consoleintr+0x456>
            history.hist[9] = input;
80100ee3:	b9 23 00 00 00       	mov    $0x23,%ecx
80100ee8:	be a0 1f 11 80       	mov    $0x80111fa0,%esi
            history.index = 9;
80100eed:	c7 05 b8 25 11 80 09 	movl   $0x9,0x801125b8
80100ef4:	00 00 00 
            history.hist[9] = input;
80100ef7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            history.last = 9;
80100ef9:	c7 05 c0 25 11 80 09 	movl   $0x9,0x801125c0
80100f00:	00 00 00 
            history.count = 10;
80100f03:	c7 05 bc 25 11 80 0a 	movl   $0xa,0x801125bc
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
80100f2a:	68 e8 8c 10 80       	push   $0x80108ce8
80100f2f:	68 20 c5 10 80       	push   $0x8010c520
80100f34:	e8 87 4b 00 00       	call   80105ac0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100f39:	58                   	pop    %eax
80100f3a:	5a                   	pop    %edx
80100f3b:	6a 00                	push   $0x0
80100f3d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100f3f:	c7 05 8c 2f 11 80 50 	movl   $0x80100850,0x80112f8c
80100f46:	08 10 80 
  devsw[CONSOLE].read = consoleread;
80100f49:	c7 05 88 2f 11 80 90 	movl   $0x80100290,0x80112f88
80100f50:	02 10 80 
  cons.locking = 1;
80100f53:	c7 05 54 c5 10 80 01 	movl   $0x1,0x8010c554
80100f5a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100f5d:	e8 ee 19 00 00       	call   80102950 <ioapicenable>
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
80100f80:	e8 bb 4b 00 00       	call   80105b40 <pushcli>
  for (int i = 0; i < ncpu; i++){
80100f85:	8b 15 40 53 11 80    	mov    0x80115340,%edx
80100f8b:	85 d2                	test   %edx,%edx
80100f8d:	7e 24                	jle    80100fb3 <exec+0x43>
80100f8f:	69 d2 b4 00 00 00    	imul   $0xb4,%edx,%edx
80100f95:	31 c0                	xor    %eax,%eax
80100f97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9e:	66 90                	xchg   %ax,%ax
    cpus[i].syscalls_count = 0;
80100fa0:	c7 80 50 4e 11 80 00 	movl   $0x0,-0x7feeb1b0(%eax)
80100fa7:	00 00 00 
  for (int i = 0; i < ncpu; i++){
80100faa:	05 b4 00 00 00       	add    $0xb4,%eax
80100faf:	39 c2                	cmp    %eax,%edx
80100fb1:	75 ed                	jne    80100fa0 <exec+0x30>
  }
  count_shared_syscalls = 0;
80100fb3:	c7 05 c0 c5 10 80 00 	movl   $0x0,0x8010c5c0
80100fba:	00 00 00 
  popcli();
80100fbd:	e8 ce 4b 00 00       	call   80105b90 <popcli>
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100fc2:	e8 29 2f 00 00       	call   80103ef0 <myproc>
80100fc7:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100fcd:	e8 7e 22 00 00       	call   80103250 <begin_op>

  if((ip = namei(path)) == 0){
80100fd2:	83 ec 0c             	sub    $0xc,%esp
80100fd5:	ff 75 08             	pushl  0x8(%ebp)
80100fd8:	e8 73 15 00 00       	call   80102550 <namei>
80100fdd:	83 c4 10             	add    $0x10,%esp
80100fe0:	89 c3                	mov    %eax,%ebx
80100fe2:	85 c0                	test   %eax,%eax
80100fe4:	0f 84 e7 02 00 00    	je     801012d1 <exec+0x361>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100fea:	83 ec 0c             	sub    $0xc,%esp
80100fed:	50                   	push   %eax
80100fee:	e8 8d 0c 00 00       	call   80101c80 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ff3:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ff9:	6a 34                	push   $0x34
80100ffb:	6a 00                	push   $0x0
80100ffd:	50                   	push   %eax
80100ffe:	53                   	push   %ebx
80100fff:	e8 7c 0f 00 00       	call   80101f80 <readi>
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
80101010:	e8 0b 0f 00 00       	call   80101f20 <iunlockput>
    end_op();
80101015:	e8 a6 22 00 00       	call   801032c0 <end_op>
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
8010103c:	e8 9f 79 00 00       	call   801089e0 <setupkvm>
80101041:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80101047:	85 c0                	test   %eax,%eax
80101049:	74 c1                	je     8010100c <exec+0x9c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
8010104b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80101052:	00 
80101053:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80101059:	0f 84 91 02 00 00    	je     801012f0 <exec+0x380>
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
801010a3:	e8 58 77 00 00       	call   80108800 <allocuvm>
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
801010d9:	e8 52 76 00 00       	call   80108730 <loaduvm>
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
80101101:	e8 7a 0e 00 00       	call   80101f80 <readi>
80101106:	83 c4 10             	add    $0x10,%esp
80101109:	83 f8 20             	cmp    $0x20,%eax
8010110c:	0f 84 5e ff ff ff    	je     80101070 <exec+0x100>
    freevm(pgdir);
80101112:	83 ec 0c             	sub    $0xc,%esp
80101115:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
8010111b:	e8 40 78 00 00       	call   80108960 <freevm>
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
80101144:	e8 d7 0d 00 00       	call   80101f20 <iunlockput>
  end_op();
80101149:	e8 72 21 00 00       	call   801032c0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
8010114e:	83 c4 0c             	add    $0xc,%esp
80101151:	57                   	push   %edi
80101152:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80101158:	56                   	push   %esi
80101159:	57                   	push   %edi
8010115a:	e8 a1 76 00 00       	call   80108800 <allocuvm>
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
8010117b:	e8 00 79 00 00       	call   80108a80 <clearpteu>
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
801011cb:	e8 80 4d 00 00       	call   80105f50 <strlen>
801011d0:	f7 d0                	not    %eax
801011d2:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
801011d4:	58                   	pop    %eax
801011d5:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
801011d8:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
801011db:	ff 34 b8             	pushl  (%eax,%edi,4)
801011de:	e8 6d 4d 00 00       	call   80105f50 <strlen>
801011e3:	83 c0 01             	add    $0x1,%eax
801011e6:	50                   	push   %eax
801011e7:	8b 45 0c             	mov    0xc(%ebp),%eax
801011ea:	ff 34 b8             	pushl  (%eax,%edi,4)
801011ed:	53                   	push   %ebx
801011ee:	56                   	push   %esi
801011ef:	e8 ec 79 00 00       	call   80108be0 <copyout>
801011f4:	83 c4 20             	add    $0x20,%esp
801011f7:	85 c0                	test   %eax,%eax
801011f9:	79 ad                	jns    801011a8 <exec+0x238>
    freevm(pgdir);
801011fb:	83 ec 0c             	sub    $0xc,%esp
801011fe:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80101204:	e8 57 77 00 00       	call   80108960 <freevm>
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
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101256:	e8 85 79 00 00       	call   80108be0 <copyout>
8010125b:	83 c4 10             	add    $0x10,%esp
8010125e:	85 c0                	test   %eax,%eax
80101260:	78 99                	js     801011fb <exec+0x28b>
  for(last=s=path; *s; s++)
80101262:	8b 45 08             	mov    0x8(%ebp),%eax
80101265:	8b 55 08             	mov    0x8(%ebp),%edx
80101268:	0f b6 00             	movzbl (%eax),%eax
8010126b:	84 c0                	test   %al,%al
8010126d:	74 11                	je     80101280 <exec+0x310>
8010126f:	89 d1                	mov    %edx,%ecx
    if(*s == '/')
80101271:	83 c1 01             	add    $0x1,%ecx
80101274:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80101276:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80101279:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
8010127c:	84 c0                	test   %al,%al
8010127e:	75 f1                	jne    80101271 <exec+0x301>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80101280:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80101286:	83 ec 04             	sub    $0x4,%esp
80101289:	6a 10                	push   $0x10
8010128b:	8d 47 6c             	lea    0x6c(%edi),%eax
8010128e:	52                   	push   %edx
8010128f:	50                   	push   %eax
80101290:	e8 7b 4c 00 00       	call   80105f10 <safestrcpy>
  curproc->pgdir = pgdir;
80101295:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
  oldpgdir = curproc->pgdir;
8010129b:	89 f9                	mov    %edi,%ecx
8010129d:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
801012a0:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
801012a3:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
801012a5:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
801012a8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
801012ae:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
801012b1:	8b 41 18             	mov    0x18(%ecx),%eax
801012b4:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
801012b7:	89 0c 24             	mov    %ecx,(%esp)
801012ba:	e8 e1 72 00 00       	call   801085a0 <switchuvm>
  freevm(oldpgdir);
801012bf:	89 3c 24             	mov    %edi,(%esp)
801012c2:	e8 99 76 00 00       	call   80108960 <freevm>
  return 0;
801012c7:	83 c4 10             	add    $0x10,%esp
801012ca:	31 c0                	xor    %eax,%eax
801012cc:	e9 51 fd ff ff       	jmp    80101022 <exec+0xb2>
    end_op();
801012d1:	e8 ea 1f 00 00       	call   801032c0 <end_op>
    cprintf("exec: fail\n");
801012d6:	83 ec 0c             	sub    $0xc,%esp
801012d9:	68 59 8d 10 80       	push   $0x80108d59
801012de:	e8 dd f5 ff ff       	call   801008c0 <cprintf>
    return -1;
801012e3:	83 c4 10             	add    $0x10,%esp
801012e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012eb:	e9 32 fd ff ff       	jmp    80101022 <exec+0xb2>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801012f0:	31 f6                	xor    %esi,%esi
801012f2:	bf 00 20 00 00       	mov    $0x2000,%edi
801012f7:	e9 44 fe ff ff       	jmp    80101140 <exec+0x1d0>
801012fc:	66 90                	xchg   %ax,%ax
801012fe:	66 90                	xchg   %ax,%ax

80101300 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101300:	f3 0f 1e fb          	endbr32 
80101304:	55                   	push   %ebp
80101305:	89 e5                	mov    %esp,%ebp
80101307:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
8010130a:	68 65 8d 10 80       	push   $0x80108d65
8010130f:	68 e0 25 11 80       	push   $0x801125e0
80101314:	e8 a7 47 00 00       	call   80105ac0 <initlock>
}
80101319:	83 c4 10             	add    $0x10,%esp
8010131c:	c9                   	leave  
8010131d:	c3                   	ret    
8010131e:	66 90                	xchg   %ax,%ax

80101320 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101320:	f3 0f 1e fb          	endbr32 
80101324:	55                   	push   %ebp
80101325:	89 e5                	mov    %esp,%ebp
80101327:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101328:	bb 14 26 11 80       	mov    $0x80112614,%ebx
{
8010132d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80101330:	68 e0 25 11 80       	push   $0x801125e0
80101335:	e8 06 49 00 00       	call   80105c40 <acquire>
8010133a:	83 c4 10             	add    $0x10,%esp
8010133d:	eb 0c                	jmp    8010134b <filealloc+0x2b>
8010133f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101340:	83 c3 18             	add    $0x18,%ebx
80101343:	81 fb 74 2f 11 80    	cmp    $0x80112f74,%ebx
80101349:	74 25                	je     80101370 <filealloc+0x50>
    if(f->ref == 0){
8010134b:	8b 43 04             	mov    0x4(%ebx),%eax
8010134e:	85 c0                	test   %eax,%eax
80101350:	75 ee                	jne    80101340 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101352:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101355:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010135c:	68 e0 25 11 80       	push   $0x801125e0
80101361:	e8 9a 49 00 00       	call   80105d00 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101366:	89 d8                	mov    %ebx,%eax
      return f;
80101368:	83 c4 10             	add    $0x10,%esp
}
8010136b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010136e:	c9                   	leave  
8010136f:	c3                   	ret    
  release(&ftable.lock);
80101370:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101373:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101375:	68 e0 25 11 80       	push   $0x801125e0
8010137a:	e8 81 49 00 00       	call   80105d00 <release>
}
8010137f:	89 d8                	mov    %ebx,%eax
  return 0;
80101381:	83 c4 10             	add    $0x10,%esp
}
80101384:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101387:	c9                   	leave  
80101388:	c3                   	ret    
80101389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101390 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101390:	f3 0f 1e fb          	endbr32 
80101394:	55                   	push   %ebp
80101395:	89 e5                	mov    %esp,%ebp
80101397:	53                   	push   %ebx
80101398:	83 ec 10             	sub    $0x10,%esp
8010139b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010139e:	68 e0 25 11 80       	push   $0x801125e0
801013a3:	e8 98 48 00 00       	call   80105c40 <acquire>
  if(f->ref < 1)
801013a8:	8b 43 04             	mov    0x4(%ebx),%eax
801013ab:	83 c4 10             	add    $0x10,%esp
801013ae:	85 c0                	test   %eax,%eax
801013b0:	7e 1a                	jle    801013cc <filedup+0x3c>
    panic("filedup");
  f->ref++;
801013b2:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
801013b5:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
801013b8:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
801013bb:	68 e0 25 11 80       	push   $0x801125e0
801013c0:	e8 3b 49 00 00       	call   80105d00 <release>
  return f;
}
801013c5:	89 d8                	mov    %ebx,%eax
801013c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013ca:	c9                   	leave  
801013cb:	c3                   	ret    
    panic("filedup");
801013cc:	83 ec 0c             	sub    $0xc,%esp
801013cf:	68 6c 8d 10 80       	push   $0x80108d6c
801013d4:	e8 b7 ef ff ff       	call   80100390 <panic>
801013d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801013e0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801013e0:	f3 0f 1e fb          	endbr32 
801013e4:	55                   	push   %ebp
801013e5:	89 e5                	mov    %esp,%ebp
801013e7:	57                   	push   %edi
801013e8:	56                   	push   %esi
801013e9:	53                   	push   %ebx
801013ea:	83 ec 28             	sub    $0x28,%esp
801013ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
801013f0:	68 e0 25 11 80       	push   $0x801125e0
801013f5:	e8 46 48 00 00       	call   80105c40 <acquire>
  if(f->ref < 1)
801013fa:	8b 53 04             	mov    0x4(%ebx),%edx
801013fd:	83 c4 10             	add    $0x10,%esp
80101400:	85 d2                	test   %edx,%edx
80101402:	0f 8e a1 00 00 00    	jle    801014a9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101408:	83 ea 01             	sub    $0x1,%edx
8010140b:	89 53 04             	mov    %edx,0x4(%ebx)
8010140e:	75 40                	jne    80101450 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80101410:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101414:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101417:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101419:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010141f:	8b 73 0c             	mov    0xc(%ebx),%esi
80101422:	88 45 e7             	mov    %al,-0x19(%ebp)
80101425:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101428:	68 e0 25 11 80       	push   $0x801125e0
  ff = *f;
8010142d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101430:	e8 cb 48 00 00       	call   80105d00 <release>

  if(ff.type == FD_PIPE)
80101435:	83 c4 10             	add    $0x10,%esp
80101438:	83 ff 01             	cmp    $0x1,%edi
8010143b:	74 53                	je     80101490 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
8010143d:	83 ff 02             	cmp    $0x2,%edi
80101440:	74 26                	je     80101468 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80101442:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101445:	5b                   	pop    %ebx
80101446:	5e                   	pop    %esi
80101447:	5f                   	pop    %edi
80101448:	5d                   	pop    %ebp
80101449:	c3                   	ret    
8010144a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80101450:	c7 45 08 e0 25 11 80 	movl   $0x801125e0,0x8(%ebp)
}
80101457:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010145a:	5b                   	pop    %ebx
8010145b:	5e                   	pop    %esi
8010145c:	5f                   	pop    %edi
8010145d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010145e:	e9 9d 48 00 00       	jmp    80105d00 <release>
80101463:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101467:	90                   	nop
    begin_op();
80101468:	e8 e3 1d 00 00       	call   80103250 <begin_op>
    iput(ff.ip);
8010146d:	83 ec 0c             	sub    $0xc,%esp
80101470:	ff 75 e0             	pushl  -0x20(%ebp)
80101473:	e8 38 09 00 00       	call   80101db0 <iput>
    end_op();
80101478:	83 c4 10             	add    $0x10,%esp
}
8010147b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010147e:	5b                   	pop    %ebx
8010147f:	5e                   	pop    %esi
80101480:	5f                   	pop    %edi
80101481:	5d                   	pop    %ebp
    end_op();
80101482:	e9 39 1e 00 00       	jmp    801032c0 <end_op>
80101487:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010148e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80101490:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101494:	83 ec 08             	sub    $0x8,%esp
80101497:	53                   	push   %ebx
80101498:	56                   	push   %esi
80101499:	e8 92 25 00 00       	call   80103a30 <pipeclose>
8010149e:	83 c4 10             	add    $0x10,%esp
}
801014a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a4:	5b                   	pop    %ebx
801014a5:	5e                   	pop    %esi
801014a6:	5f                   	pop    %edi
801014a7:	5d                   	pop    %ebp
801014a8:	c3                   	ret    
    panic("fileclose");
801014a9:	83 ec 0c             	sub    $0xc,%esp
801014ac:	68 74 8d 10 80       	push   $0x80108d74
801014b1:	e8 da ee ff ff       	call   80100390 <panic>
801014b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014bd:	8d 76 00             	lea    0x0(%esi),%esi

801014c0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801014c0:	f3 0f 1e fb          	endbr32 
801014c4:	55                   	push   %ebp
801014c5:	89 e5                	mov    %esp,%ebp
801014c7:	53                   	push   %ebx
801014c8:	83 ec 04             	sub    $0x4,%esp
801014cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801014ce:	83 3b 02             	cmpl   $0x2,(%ebx)
801014d1:	75 2d                	jne    80101500 <filestat+0x40>
    ilock(f->ip);
801014d3:	83 ec 0c             	sub    $0xc,%esp
801014d6:	ff 73 10             	pushl  0x10(%ebx)
801014d9:	e8 a2 07 00 00       	call   80101c80 <ilock>
    stati(f->ip, st);
801014de:	58                   	pop    %eax
801014df:	5a                   	pop    %edx
801014e0:	ff 75 0c             	pushl  0xc(%ebp)
801014e3:	ff 73 10             	pushl  0x10(%ebx)
801014e6:	e8 65 0a 00 00       	call   80101f50 <stati>
    iunlock(f->ip);
801014eb:	59                   	pop    %ecx
801014ec:	ff 73 10             	pushl  0x10(%ebx)
801014ef:	e8 6c 08 00 00       	call   80101d60 <iunlock>
    return 0;
  }
  return -1;
}
801014f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801014f7:	83 c4 10             	add    $0x10,%esp
801014fa:	31 c0                	xor    %eax,%eax
}
801014fc:	c9                   	leave  
801014fd:	c3                   	ret    
801014fe:	66 90                	xchg   %ax,%ax
80101500:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101503:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101508:	c9                   	leave  
80101509:	c3                   	ret    
8010150a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101510 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101510:	f3 0f 1e fb          	endbr32 
80101514:	55                   	push   %ebp
80101515:	89 e5                	mov    %esp,%ebp
80101517:	57                   	push   %edi
80101518:	56                   	push   %esi
80101519:	53                   	push   %ebx
8010151a:	83 ec 0c             	sub    $0xc,%esp
8010151d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101520:	8b 75 0c             	mov    0xc(%ebp),%esi
80101523:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101526:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010152a:	74 64                	je     80101590 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010152c:	8b 03                	mov    (%ebx),%eax
8010152e:	83 f8 01             	cmp    $0x1,%eax
80101531:	74 45                	je     80101578 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101533:	83 f8 02             	cmp    $0x2,%eax
80101536:	75 5f                	jne    80101597 <fileread+0x87>
    ilock(f->ip);
80101538:	83 ec 0c             	sub    $0xc,%esp
8010153b:	ff 73 10             	pushl  0x10(%ebx)
8010153e:	e8 3d 07 00 00       	call   80101c80 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101543:	57                   	push   %edi
80101544:	ff 73 14             	pushl  0x14(%ebx)
80101547:	56                   	push   %esi
80101548:	ff 73 10             	pushl  0x10(%ebx)
8010154b:	e8 30 0a 00 00       	call   80101f80 <readi>
80101550:	83 c4 20             	add    $0x20,%esp
80101553:	89 c6                	mov    %eax,%esi
80101555:	85 c0                	test   %eax,%eax
80101557:	7e 03                	jle    8010155c <fileread+0x4c>
      f->off += r;
80101559:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010155c:	83 ec 0c             	sub    $0xc,%esp
8010155f:	ff 73 10             	pushl  0x10(%ebx)
80101562:	e8 f9 07 00 00       	call   80101d60 <iunlock>
    return r;
80101567:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010156a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010156d:	89 f0                	mov    %esi,%eax
8010156f:	5b                   	pop    %ebx
80101570:	5e                   	pop    %esi
80101571:	5f                   	pop    %edi
80101572:	5d                   	pop    %ebp
80101573:	c3                   	ret    
80101574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101578:	8b 43 0c             	mov    0xc(%ebx),%eax
8010157b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010157e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101581:	5b                   	pop    %ebx
80101582:	5e                   	pop    %esi
80101583:	5f                   	pop    %edi
80101584:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101585:	e9 46 26 00 00       	jmp    80103bd0 <piperead>
8010158a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101590:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101595:	eb d3                	jmp    8010156a <fileread+0x5a>
  panic("fileread");
80101597:	83 ec 0c             	sub    $0xc,%esp
8010159a:	68 7e 8d 10 80       	push   $0x80108d7e
8010159f:	e8 ec ed ff ff       	call   80100390 <panic>
801015a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801015af:	90                   	nop

801015b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801015b0:	f3 0f 1e fb          	endbr32 
801015b4:	55                   	push   %ebp
801015b5:	89 e5                	mov    %esp,%ebp
801015b7:	57                   	push   %edi
801015b8:	56                   	push   %esi
801015b9:	53                   	push   %ebx
801015ba:	83 ec 1c             	sub    $0x1c,%esp
801015bd:	8b 45 0c             	mov    0xc(%ebp),%eax
801015c0:	8b 75 08             	mov    0x8(%ebp),%esi
801015c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801015c6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801015c9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801015cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801015d0:	0f 84 c1 00 00 00    	je     80101697 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801015d6:	8b 06                	mov    (%esi),%eax
801015d8:	83 f8 01             	cmp    $0x1,%eax
801015db:	0f 84 c3 00 00 00    	je     801016a4 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801015e1:	83 f8 02             	cmp    $0x2,%eax
801015e4:	0f 85 cc 00 00 00    	jne    801016b6 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801015ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801015ed:	31 ff                	xor    %edi,%edi
    while(i < n){
801015ef:	85 c0                	test   %eax,%eax
801015f1:	7f 34                	jg     80101627 <filewrite+0x77>
801015f3:	e9 98 00 00 00       	jmp    80101690 <filewrite+0xe0>
801015f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015ff:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101600:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80101603:	83 ec 0c             	sub    $0xc,%esp
80101606:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101609:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010160c:	e8 4f 07 00 00       	call   80101d60 <iunlock>
      end_op();
80101611:	e8 aa 1c 00 00       	call   801032c0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101616:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101619:	83 c4 10             	add    $0x10,%esp
8010161c:	39 c3                	cmp    %eax,%ebx
8010161e:	75 60                	jne    80101680 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101620:	01 df                	add    %ebx,%edi
    while(i < n){
80101622:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101625:	7e 69                	jle    80101690 <filewrite+0xe0>
      int n1 = n - i;
80101627:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010162a:	b8 00 06 00 00       	mov    $0x600,%eax
8010162f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101631:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101637:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010163a:	e8 11 1c 00 00       	call   80103250 <begin_op>
      ilock(f->ip);
8010163f:	83 ec 0c             	sub    $0xc,%esp
80101642:	ff 76 10             	pushl  0x10(%esi)
80101645:	e8 36 06 00 00       	call   80101c80 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010164a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010164d:	53                   	push   %ebx
8010164e:	ff 76 14             	pushl  0x14(%esi)
80101651:	01 f8                	add    %edi,%eax
80101653:	50                   	push   %eax
80101654:	ff 76 10             	pushl  0x10(%esi)
80101657:	e8 24 0a 00 00       	call   80102080 <writei>
8010165c:	83 c4 20             	add    $0x20,%esp
8010165f:	85 c0                	test   %eax,%eax
80101661:	7f 9d                	jg     80101600 <filewrite+0x50>
      iunlock(f->ip);
80101663:	83 ec 0c             	sub    $0xc,%esp
80101666:	ff 76 10             	pushl  0x10(%esi)
80101669:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010166c:	e8 ef 06 00 00       	call   80101d60 <iunlock>
      end_op();
80101671:	e8 4a 1c 00 00       	call   801032c0 <end_op>
      if(r < 0)
80101676:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101679:	83 c4 10             	add    $0x10,%esp
8010167c:	85 c0                	test   %eax,%eax
8010167e:	75 17                	jne    80101697 <filewrite+0xe7>
        panic("short filewrite");
80101680:	83 ec 0c             	sub    $0xc,%esp
80101683:	68 87 8d 10 80       	push   $0x80108d87
80101688:	e8 03 ed ff ff       	call   80100390 <panic>
8010168d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101690:	89 f8                	mov    %edi,%eax
80101692:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101695:	74 05                	je     8010169c <filewrite+0xec>
80101697:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010169c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010169f:	5b                   	pop    %ebx
801016a0:	5e                   	pop    %esi
801016a1:	5f                   	pop    %edi
801016a2:	5d                   	pop    %ebp
801016a3:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801016a4:	8b 46 0c             	mov    0xc(%esi),%eax
801016a7:	89 45 08             	mov    %eax,0x8(%ebp)
}
801016aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016ad:	5b                   	pop    %ebx
801016ae:	5e                   	pop    %esi
801016af:	5f                   	pop    %edi
801016b0:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801016b1:	e9 1a 24 00 00       	jmp    80103ad0 <pipewrite>
  panic("filewrite");
801016b6:	83 ec 0c             	sub    $0xc,%esp
801016b9:	68 8d 8d 10 80       	push   $0x80108d8d
801016be:	e8 cd ec ff ff       	call   80100390 <panic>
801016c3:	66 90                	xchg   %ax,%ax
801016c5:	66 90                	xchg   %ax,%ax
801016c7:	66 90                	xchg   %ax,%ax
801016c9:	66 90                	xchg   %ax,%ax
801016cb:	66 90                	xchg   %ax,%ax
801016cd:	66 90                	xchg   %ax,%ax
801016cf:	90                   	nop

801016d0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801016d0:	55                   	push   %ebp
801016d1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801016d3:	89 d0                	mov    %edx,%eax
801016d5:	c1 e8 0c             	shr    $0xc,%eax
801016d8:	03 05 f8 2f 11 80    	add    0x80112ff8,%eax
{
801016de:	89 e5                	mov    %esp,%ebp
801016e0:	56                   	push   %esi
801016e1:	53                   	push   %ebx
801016e2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801016e4:	83 ec 08             	sub    $0x8,%esp
801016e7:	50                   	push   %eax
801016e8:	51                   	push   %ecx
801016e9:	e8 e2 e9 ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801016ee:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801016f0:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801016f3:	ba 01 00 00 00       	mov    $0x1,%edx
801016f8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801016fb:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80101701:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101704:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101706:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
8010170b:	85 d1                	test   %edx,%ecx
8010170d:	74 25                	je     80101734 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010170f:	f7 d2                	not    %edx
  log_write(bp);
80101711:	83 ec 0c             	sub    $0xc,%esp
80101714:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101716:	21 ca                	and    %ecx,%edx
80101718:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
8010171c:	50                   	push   %eax
8010171d:	e8 0e 1d 00 00       	call   80103430 <log_write>
  brelse(bp);
80101722:	89 34 24             	mov    %esi,(%esp)
80101725:	e8 c6 ea ff ff       	call   801001f0 <brelse>
}
8010172a:	83 c4 10             	add    $0x10,%esp
8010172d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101730:	5b                   	pop    %ebx
80101731:	5e                   	pop    %esi
80101732:	5d                   	pop    %ebp
80101733:	c3                   	ret    
    panic("freeing free block");
80101734:	83 ec 0c             	sub    $0xc,%esp
80101737:	68 97 8d 10 80       	push   $0x80108d97
8010173c:	e8 4f ec ff ff       	call   80100390 <panic>
80101741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101748:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010174f:	90                   	nop

80101750 <balloc>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	57                   	push   %edi
80101754:	56                   	push   %esi
80101755:	53                   	push   %ebx
80101756:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101759:	8b 0d e0 2f 11 80    	mov    0x80112fe0,%ecx
{
8010175f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101762:	85 c9                	test   %ecx,%ecx
80101764:	0f 84 87 00 00 00    	je     801017f1 <balloc+0xa1>
8010176a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101771:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101774:	83 ec 08             	sub    $0x8,%esp
80101777:	89 f0                	mov    %esi,%eax
80101779:	c1 f8 0c             	sar    $0xc,%eax
8010177c:	03 05 f8 2f 11 80    	add    0x80112ff8,%eax
80101782:	50                   	push   %eax
80101783:	ff 75 d8             	pushl  -0x28(%ebp)
80101786:	e8 45 e9 ff ff       	call   801000d0 <bread>
8010178b:	83 c4 10             	add    $0x10,%esp
8010178e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101791:	a1 e0 2f 11 80       	mov    0x80112fe0,%eax
80101796:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101799:	31 c0                	xor    %eax,%eax
8010179b:	eb 2f                	jmp    801017cc <balloc+0x7c>
8010179d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801017a0:	89 c1                	mov    %eax,%ecx
801017a2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801017a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801017aa:	83 e1 07             	and    $0x7,%ecx
801017ad:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801017af:	89 c1                	mov    %eax,%ecx
801017b1:	c1 f9 03             	sar    $0x3,%ecx
801017b4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801017b9:	89 fa                	mov    %edi,%edx
801017bb:	85 df                	test   %ebx,%edi
801017bd:	74 41                	je     80101800 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801017bf:	83 c0 01             	add    $0x1,%eax
801017c2:	83 c6 01             	add    $0x1,%esi
801017c5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801017ca:	74 05                	je     801017d1 <balloc+0x81>
801017cc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801017cf:	77 cf                	ja     801017a0 <balloc+0x50>
    brelse(bp);
801017d1:	83 ec 0c             	sub    $0xc,%esp
801017d4:	ff 75 e4             	pushl  -0x1c(%ebp)
801017d7:	e8 14 ea ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801017dc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801017e3:	83 c4 10             	add    $0x10,%esp
801017e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801017e9:	39 05 e0 2f 11 80    	cmp    %eax,0x80112fe0
801017ef:	77 80                	ja     80101771 <balloc+0x21>
  panic("balloc: out of blocks");
801017f1:	83 ec 0c             	sub    $0xc,%esp
801017f4:	68 aa 8d 10 80       	push   $0x80108daa
801017f9:	e8 92 eb ff ff       	call   80100390 <panic>
801017fe:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101800:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101803:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101806:	09 da                	or     %ebx,%edx
80101808:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010180c:	57                   	push   %edi
8010180d:	e8 1e 1c 00 00       	call   80103430 <log_write>
        brelse(bp);
80101812:	89 3c 24             	mov    %edi,(%esp)
80101815:	e8 d6 e9 ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010181a:	58                   	pop    %eax
8010181b:	5a                   	pop    %edx
8010181c:	56                   	push   %esi
8010181d:	ff 75 d8             	pushl  -0x28(%ebp)
80101820:	e8 ab e8 ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101825:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101828:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010182a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010182d:	68 00 02 00 00       	push   $0x200
80101832:	6a 00                	push   $0x0
80101834:	50                   	push   %eax
80101835:	e8 16 45 00 00       	call   80105d50 <memset>
  log_write(bp);
8010183a:	89 1c 24             	mov    %ebx,(%esp)
8010183d:	e8 ee 1b 00 00       	call   80103430 <log_write>
  brelse(bp);
80101842:	89 1c 24             	mov    %ebx,(%esp)
80101845:	e8 a6 e9 ff ff       	call   801001f0 <brelse>
}
8010184a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010184d:	89 f0                	mov    %esi,%eax
8010184f:	5b                   	pop    %ebx
80101850:	5e                   	pop    %esi
80101851:	5f                   	pop    %edi
80101852:	5d                   	pop    %ebp
80101853:	c3                   	ret    
80101854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010185b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010185f:	90                   	nop

80101860 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	57                   	push   %edi
80101864:	89 c7                	mov    %eax,%edi
80101866:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101867:	31 f6                	xor    %esi,%esi
{
80101869:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010186a:	bb 34 30 11 80       	mov    $0x80113034,%ebx
{
8010186f:	83 ec 28             	sub    $0x28,%esp
80101872:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101875:	68 00 30 11 80       	push   $0x80113000
8010187a:	e8 c1 43 00 00       	call   80105c40 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010187f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101882:	83 c4 10             	add    $0x10,%esp
80101885:	eb 1b                	jmp    801018a2 <iget+0x42>
80101887:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010188e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101890:	39 3b                	cmp    %edi,(%ebx)
80101892:	74 6c                	je     80101900 <iget+0xa0>
80101894:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010189a:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801018a0:	73 26                	jae    801018c8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801018a2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801018a5:	85 c9                	test   %ecx,%ecx
801018a7:	7f e7                	jg     80101890 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801018a9:	85 f6                	test   %esi,%esi
801018ab:	75 e7                	jne    80101894 <iget+0x34>
801018ad:	89 d8                	mov    %ebx,%eax
801018af:	81 c3 90 00 00 00    	add    $0x90,%ebx
801018b5:	85 c9                	test   %ecx,%ecx
801018b7:	75 6e                	jne    80101927 <iget+0xc7>
801018b9:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018bb:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801018c1:	72 df                	jb     801018a2 <iget+0x42>
801018c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018c7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801018c8:	85 f6                	test   %esi,%esi
801018ca:	74 73                	je     8010193f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801018cc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801018cf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801018d1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801018d4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801018db:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801018e2:	68 00 30 11 80       	push   $0x80113000
801018e7:	e8 14 44 00 00       	call   80105d00 <release>

  return ip;
801018ec:	83 c4 10             	add    $0x10,%esp
}
801018ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018f2:	89 f0                	mov    %esi,%eax
801018f4:	5b                   	pop    %ebx
801018f5:	5e                   	pop    %esi
801018f6:	5f                   	pop    %edi
801018f7:	5d                   	pop    %ebp
801018f8:	c3                   	ret    
801018f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101900:	39 53 04             	cmp    %edx,0x4(%ebx)
80101903:	75 8f                	jne    80101894 <iget+0x34>
      release(&icache.lock);
80101905:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101908:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010190b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010190d:	68 00 30 11 80       	push   $0x80113000
      ip->ref++;
80101912:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101915:	e8 e6 43 00 00       	call   80105d00 <release>
      return ip;
8010191a:	83 c4 10             	add    $0x10,%esp
}
8010191d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101920:	89 f0                	mov    %esi,%eax
80101922:	5b                   	pop    %ebx
80101923:	5e                   	pop    %esi
80101924:	5f                   	pop    %edi
80101925:	5d                   	pop    %ebp
80101926:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101927:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
8010192d:	73 10                	jae    8010193f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010192f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101932:	85 c9                	test   %ecx,%ecx
80101934:	0f 8f 56 ff ff ff    	jg     80101890 <iget+0x30>
8010193a:	e9 6e ff ff ff       	jmp    801018ad <iget+0x4d>
    panic("iget: no inodes");
8010193f:	83 ec 0c             	sub    $0xc,%esp
80101942:	68 c0 8d 10 80       	push   $0x80108dc0
80101947:	e8 44 ea ff ff       	call   80100390 <panic>
8010194c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101950 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	57                   	push   %edi
80101954:	56                   	push   %esi
80101955:	89 c6                	mov    %eax,%esi
80101957:	53                   	push   %ebx
80101958:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010195b:	83 fa 0b             	cmp    $0xb,%edx
8010195e:	0f 86 84 00 00 00    	jbe    801019e8 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101964:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101967:	83 fb 7f             	cmp    $0x7f,%ebx
8010196a:	0f 87 98 00 00 00    	ja     80101a08 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101970:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101976:	8b 16                	mov    (%esi),%edx
80101978:	85 c0                	test   %eax,%eax
8010197a:	74 54                	je     801019d0 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010197c:	83 ec 08             	sub    $0x8,%esp
8010197f:	50                   	push   %eax
80101980:	52                   	push   %edx
80101981:	e8 4a e7 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101986:	83 c4 10             	add    $0x10,%esp
80101989:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010198d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010198f:	8b 1a                	mov    (%edx),%ebx
80101991:	85 db                	test   %ebx,%ebx
80101993:	74 1b                	je     801019b0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101995:	83 ec 0c             	sub    $0xc,%esp
80101998:	57                   	push   %edi
80101999:	e8 52 e8 ff ff       	call   801001f0 <brelse>
    return addr;
8010199e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
801019a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019a4:	89 d8                	mov    %ebx,%eax
801019a6:	5b                   	pop    %ebx
801019a7:	5e                   	pop    %esi
801019a8:	5f                   	pop    %edi
801019a9:	5d                   	pop    %ebp
801019aa:	c3                   	ret    
801019ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019af:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
801019b0:	8b 06                	mov    (%esi),%eax
801019b2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801019b5:	e8 96 fd ff ff       	call   80101750 <balloc>
801019ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801019bd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801019c0:	89 c3                	mov    %eax,%ebx
801019c2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801019c4:	57                   	push   %edi
801019c5:	e8 66 1a 00 00       	call   80103430 <log_write>
801019ca:	83 c4 10             	add    $0x10,%esp
801019cd:	eb c6                	jmp    80101995 <bmap+0x45>
801019cf:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801019d0:	89 d0                	mov    %edx,%eax
801019d2:	e8 79 fd ff ff       	call   80101750 <balloc>
801019d7:	8b 16                	mov    (%esi),%edx
801019d9:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801019df:	eb 9b                	jmp    8010197c <bmap+0x2c>
801019e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
801019e8:	8d 3c 90             	lea    (%eax,%edx,4),%edi
801019eb:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801019ee:	85 db                	test   %ebx,%ebx
801019f0:	75 af                	jne    801019a1 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801019f2:	8b 00                	mov    (%eax),%eax
801019f4:	e8 57 fd ff ff       	call   80101750 <balloc>
801019f9:	89 47 5c             	mov    %eax,0x5c(%edi)
801019fc:	89 c3                	mov    %eax,%ebx
}
801019fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a01:	89 d8                	mov    %ebx,%eax
80101a03:	5b                   	pop    %ebx
80101a04:	5e                   	pop    %esi
80101a05:	5f                   	pop    %edi
80101a06:	5d                   	pop    %ebp
80101a07:	c3                   	ret    
  panic("bmap: out of range");
80101a08:	83 ec 0c             	sub    $0xc,%esp
80101a0b:	68 d0 8d 10 80       	push   $0x80108dd0
80101a10:	e8 7b e9 ff ff       	call   80100390 <panic>
80101a15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a20 <readsb>:
{
80101a20:	f3 0f 1e fb          	endbr32 
80101a24:	55                   	push   %ebp
80101a25:	89 e5                	mov    %esp,%ebp
80101a27:	56                   	push   %esi
80101a28:	53                   	push   %ebx
80101a29:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101a2c:	83 ec 08             	sub    $0x8,%esp
80101a2f:	6a 01                	push   $0x1
80101a31:	ff 75 08             	pushl  0x8(%ebp)
80101a34:	e8 97 e6 ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101a39:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101a3c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101a3e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101a41:	6a 1c                	push   $0x1c
80101a43:	50                   	push   %eax
80101a44:	56                   	push   %esi
80101a45:	e8 a6 43 00 00       	call   80105df0 <memmove>
  brelse(bp);
80101a4a:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a4d:	83 c4 10             	add    $0x10,%esp
}
80101a50:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a53:	5b                   	pop    %ebx
80101a54:	5e                   	pop    %esi
80101a55:	5d                   	pop    %ebp
  brelse(bp);
80101a56:	e9 95 e7 ff ff       	jmp    801001f0 <brelse>
80101a5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a5f:	90                   	nop

80101a60 <iinit>:
{
80101a60:	f3 0f 1e fb          	endbr32 
80101a64:	55                   	push   %ebp
80101a65:	89 e5                	mov    %esp,%ebp
80101a67:	53                   	push   %ebx
80101a68:	bb 40 30 11 80       	mov    $0x80113040,%ebx
80101a6d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101a70:	68 e3 8d 10 80       	push   $0x80108de3
80101a75:	68 00 30 11 80       	push   $0x80113000
80101a7a:	e8 41 40 00 00       	call   80105ac0 <initlock>
  for(i = 0; i < NINODE; i++) {
80101a7f:	83 c4 10             	add    $0x10,%esp
80101a82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101a88:	83 ec 08             	sub    $0x8,%esp
80101a8b:	68 ea 8d 10 80       	push   $0x80108dea
80101a90:	53                   	push   %ebx
80101a91:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101a97:	e8 c4 3d 00 00       	call   80105860 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101a9c:	83 c4 10             	add    $0x10,%esp
80101a9f:	81 fb 60 4c 11 80    	cmp    $0x80114c60,%ebx
80101aa5:	75 e1                	jne    80101a88 <iinit+0x28>
  readsb(dev, &sb);
80101aa7:	83 ec 08             	sub    $0x8,%esp
80101aaa:	68 e0 2f 11 80       	push   $0x80112fe0
80101aaf:	ff 75 08             	pushl  0x8(%ebp)
80101ab2:	e8 69 ff ff ff       	call   80101a20 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101ab7:	ff 35 f8 2f 11 80    	pushl  0x80112ff8
80101abd:	ff 35 f4 2f 11 80    	pushl  0x80112ff4
80101ac3:	ff 35 f0 2f 11 80    	pushl  0x80112ff0
80101ac9:	ff 35 ec 2f 11 80    	pushl  0x80112fec
80101acf:	ff 35 e8 2f 11 80    	pushl  0x80112fe8
80101ad5:	ff 35 e4 2f 11 80    	pushl  0x80112fe4
80101adb:	ff 35 e0 2f 11 80    	pushl  0x80112fe0
80101ae1:	68 50 8e 10 80       	push   $0x80108e50
80101ae6:	e8 d5 ed ff ff       	call   801008c0 <cprintf>
}
80101aeb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101aee:	83 c4 30             	add    $0x30,%esp
80101af1:	c9                   	leave  
80101af2:	c3                   	ret    
80101af3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101b00 <ialloc>:
{
80101b00:	f3 0f 1e fb          	endbr32 
80101b04:	55                   	push   %ebp
80101b05:	89 e5                	mov    %esp,%ebp
80101b07:	57                   	push   %edi
80101b08:	56                   	push   %esi
80101b09:	53                   	push   %ebx
80101b0a:	83 ec 1c             	sub    $0x1c,%esp
80101b0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101b10:	83 3d e8 2f 11 80 01 	cmpl   $0x1,0x80112fe8
{
80101b17:	8b 75 08             	mov    0x8(%ebp),%esi
80101b1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101b1d:	0f 86 8d 00 00 00    	jbe    80101bb0 <ialloc+0xb0>
80101b23:	bf 01 00 00 00       	mov    $0x1,%edi
80101b28:	eb 1d                	jmp    80101b47 <ialloc+0x47>
80101b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101b30:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101b33:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101b36:	53                   	push   %ebx
80101b37:	e8 b4 e6 ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101b3c:	83 c4 10             	add    $0x10,%esp
80101b3f:	3b 3d e8 2f 11 80    	cmp    0x80112fe8,%edi
80101b45:	73 69                	jae    80101bb0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101b47:	89 f8                	mov    %edi,%eax
80101b49:	83 ec 08             	sub    $0x8,%esp
80101b4c:	c1 e8 03             	shr    $0x3,%eax
80101b4f:	03 05 f4 2f 11 80    	add    0x80112ff4,%eax
80101b55:	50                   	push   %eax
80101b56:	56                   	push   %esi
80101b57:	e8 74 e5 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
80101b5c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
80101b5f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101b61:	89 f8                	mov    %edi,%eax
80101b63:	83 e0 07             	and    $0x7,%eax
80101b66:	c1 e0 06             	shl    $0x6,%eax
80101b69:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
80101b6d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101b71:	75 bd                	jne    80101b30 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101b73:	83 ec 04             	sub    $0x4,%esp
80101b76:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101b79:	6a 40                	push   $0x40
80101b7b:	6a 00                	push   $0x0
80101b7d:	51                   	push   %ecx
80101b7e:	e8 cd 41 00 00       	call   80105d50 <memset>
      dip->type = type;
80101b83:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101b87:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101b8a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101b8d:	89 1c 24             	mov    %ebx,(%esp)
80101b90:	e8 9b 18 00 00       	call   80103430 <log_write>
      brelse(bp);
80101b95:	89 1c 24             	mov    %ebx,(%esp)
80101b98:	e8 53 e6 ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80101b9d:	83 c4 10             	add    $0x10,%esp
}
80101ba0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101ba3:	89 fa                	mov    %edi,%edx
}
80101ba5:	5b                   	pop    %ebx
      return iget(dev, inum);
80101ba6:	89 f0                	mov    %esi,%eax
}
80101ba8:	5e                   	pop    %esi
80101ba9:	5f                   	pop    %edi
80101baa:	5d                   	pop    %ebp
      return iget(dev, inum);
80101bab:	e9 b0 fc ff ff       	jmp    80101860 <iget>
  panic("ialloc: no inodes");
80101bb0:	83 ec 0c             	sub    $0xc,%esp
80101bb3:	68 f0 8d 10 80       	push   $0x80108df0
80101bb8:	e8 d3 e7 ff ff       	call   80100390 <panic>
80101bbd:	8d 76 00             	lea    0x0(%esi),%esi

80101bc0 <iupdate>:
{
80101bc0:	f3 0f 1e fb          	endbr32 
80101bc4:	55                   	push   %ebp
80101bc5:	89 e5                	mov    %esp,%ebp
80101bc7:	56                   	push   %esi
80101bc8:	53                   	push   %ebx
80101bc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101bcc:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101bcf:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101bd2:	83 ec 08             	sub    $0x8,%esp
80101bd5:	c1 e8 03             	shr    $0x3,%eax
80101bd8:	03 05 f4 2f 11 80    	add    0x80112ff4,%eax
80101bde:	50                   	push   %eax
80101bdf:	ff 73 a4             	pushl  -0x5c(%ebx)
80101be2:	e8 e9 e4 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101be7:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101beb:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101bee:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101bf0:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101bf3:	83 e0 07             	and    $0x7,%eax
80101bf6:	c1 e0 06             	shl    $0x6,%eax
80101bf9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101bfd:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101c00:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101c04:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101c07:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101c0b:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101c0f:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101c13:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101c17:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101c1b:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101c1e:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101c21:	6a 34                	push   $0x34
80101c23:	53                   	push   %ebx
80101c24:	50                   	push   %eax
80101c25:	e8 c6 41 00 00       	call   80105df0 <memmove>
  log_write(bp);
80101c2a:	89 34 24             	mov    %esi,(%esp)
80101c2d:	e8 fe 17 00 00       	call   80103430 <log_write>
  brelse(bp);
80101c32:	89 75 08             	mov    %esi,0x8(%ebp)
80101c35:	83 c4 10             	add    $0x10,%esp
}
80101c38:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101c3b:	5b                   	pop    %ebx
80101c3c:	5e                   	pop    %esi
80101c3d:	5d                   	pop    %ebp
  brelse(bp);
80101c3e:	e9 ad e5 ff ff       	jmp    801001f0 <brelse>
80101c43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c50 <idup>:
{
80101c50:	f3 0f 1e fb          	endbr32 
80101c54:	55                   	push   %ebp
80101c55:	89 e5                	mov    %esp,%ebp
80101c57:	53                   	push   %ebx
80101c58:	83 ec 10             	sub    $0x10,%esp
80101c5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101c5e:	68 00 30 11 80       	push   $0x80113000
80101c63:	e8 d8 3f 00 00       	call   80105c40 <acquire>
  ip->ref++;
80101c68:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101c6c:	c7 04 24 00 30 11 80 	movl   $0x80113000,(%esp)
80101c73:	e8 88 40 00 00       	call   80105d00 <release>
}
80101c78:	89 d8                	mov    %ebx,%eax
80101c7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101c7d:	c9                   	leave  
80101c7e:	c3                   	ret    
80101c7f:	90                   	nop

80101c80 <ilock>:
{
80101c80:	f3 0f 1e fb          	endbr32 
80101c84:	55                   	push   %ebp
80101c85:	89 e5                	mov    %esp,%ebp
80101c87:	56                   	push   %esi
80101c88:	53                   	push   %ebx
80101c89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101c8c:	85 db                	test   %ebx,%ebx
80101c8e:	0f 84 b3 00 00 00    	je     80101d47 <ilock+0xc7>
80101c94:	8b 53 08             	mov    0x8(%ebx),%edx
80101c97:	85 d2                	test   %edx,%edx
80101c99:	0f 8e a8 00 00 00    	jle    80101d47 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101c9f:	83 ec 0c             	sub    $0xc,%esp
80101ca2:	8d 43 0c             	lea    0xc(%ebx),%eax
80101ca5:	50                   	push   %eax
80101ca6:	e8 f5 3b 00 00       	call   801058a0 <acquiresleep>
  if(ip->valid == 0){
80101cab:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101cae:	83 c4 10             	add    $0x10,%esp
80101cb1:	85 c0                	test   %eax,%eax
80101cb3:	74 0b                	je     80101cc0 <ilock+0x40>
}
80101cb5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101cb8:	5b                   	pop    %ebx
80101cb9:	5e                   	pop    %esi
80101cba:	5d                   	pop    %ebp
80101cbb:	c3                   	ret    
80101cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101cc0:	8b 43 04             	mov    0x4(%ebx),%eax
80101cc3:	83 ec 08             	sub    $0x8,%esp
80101cc6:	c1 e8 03             	shr    $0x3,%eax
80101cc9:	03 05 f4 2f 11 80    	add    0x80112ff4,%eax
80101ccf:	50                   	push   %eax
80101cd0:	ff 33                	pushl  (%ebx)
80101cd2:	e8 f9 e3 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101cd7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101cda:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101cdc:	8b 43 04             	mov    0x4(%ebx),%eax
80101cdf:	83 e0 07             	and    $0x7,%eax
80101ce2:	c1 e0 06             	shl    $0x6,%eax
80101ce5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101ce9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101cec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101cef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101cf3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101cf7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101cfb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101cff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101d03:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101d07:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101d0b:	8b 50 fc             	mov    -0x4(%eax),%edx
80101d0e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101d11:	6a 34                	push   $0x34
80101d13:	50                   	push   %eax
80101d14:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101d17:	50                   	push   %eax
80101d18:	e8 d3 40 00 00       	call   80105df0 <memmove>
    brelse(bp);
80101d1d:	89 34 24             	mov    %esi,(%esp)
80101d20:	e8 cb e4 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101d25:	83 c4 10             	add    $0x10,%esp
80101d28:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101d2d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101d34:	0f 85 7b ff ff ff    	jne    80101cb5 <ilock+0x35>
      panic("ilock: no type");
80101d3a:	83 ec 0c             	sub    $0xc,%esp
80101d3d:	68 08 8e 10 80       	push   $0x80108e08
80101d42:	e8 49 e6 ff ff       	call   80100390 <panic>
    panic("ilock");
80101d47:	83 ec 0c             	sub    $0xc,%esp
80101d4a:	68 02 8e 10 80       	push   $0x80108e02
80101d4f:	e8 3c e6 ff ff       	call   80100390 <panic>
80101d54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d5f:	90                   	nop

80101d60 <iunlock>:
{
80101d60:	f3 0f 1e fb          	endbr32 
80101d64:	55                   	push   %ebp
80101d65:	89 e5                	mov    %esp,%ebp
80101d67:	56                   	push   %esi
80101d68:	53                   	push   %ebx
80101d69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101d6c:	85 db                	test   %ebx,%ebx
80101d6e:	74 28                	je     80101d98 <iunlock+0x38>
80101d70:	83 ec 0c             	sub    $0xc,%esp
80101d73:	8d 73 0c             	lea    0xc(%ebx),%esi
80101d76:	56                   	push   %esi
80101d77:	e8 c4 3b 00 00       	call   80105940 <holdingsleep>
80101d7c:	83 c4 10             	add    $0x10,%esp
80101d7f:	85 c0                	test   %eax,%eax
80101d81:	74 15                	je     80101d98 <iunlock+0x38>
80101d83:	8b 43 08             	mov    0x8(%ebx),%eax
80101d86:	85 c0                	test   %eax,%eax
80101d88:	7e 0e                	jle    80101d98 <iunlock+0x38>
  releasesleep(&ip->lock);
80101d8a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101d8d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d90:	5b                   	pop    %ebx
80101d91:	5e                   	pop    %esi
80101d92:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101d93:	e9 68 3b 00 00       	jmp    80105900 <releasesleep>
    panic("iunlock");
80101d98:	83 ec 0c             	sub    $0xc,%esp
80101d9b:	68 17 8e 10 80       	push   $0x80108e17
80101da0:	e8 eb e5 ff ff       	call   80100390 <panic>
80101da5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101db0 <iput>:
{
80101db0:	f3 0f 1e fb          	endbr32 
80101db4:	55                   	push   %ebp
80101db5:	89 e5                	mov    %esp,%ebp
80101db7:	57                   	push   %edi
80101db8:	56                   	push   %esi
80101db9:	53                   	push   %ebx
80101dba:	83 ec 28             	sub    $0x28,%esp
80101dbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101dc0:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101dc3:	57                   	push   %edi
80101dc4:	e8 d7 3a 00 00       	call   801058a0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101dc9:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101dcc:	83 c4 10             	add    $0x10,%esp
80101dcf:	85 d2                	test   %edx,%edx
80101dd1:	74 07                	je     80101dda <iput+0x2a>
80101dd3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101dd8:	74 36                	je     80101e10 <iput+0x60>
  releasesleep(&ip->lock);
80101dda:	83 ec 0c             	sub    $0xc,%esp
80101ddd:	57                   	push   %edi
80101dde:	e8 1d 3b 00 00       	call   80105900 <releasesleep>
  acquire(&icache.lock);
80101de3:	c7 04 24 00 30 11 80 	movl   $0x80113000,(%esp)
80101dea:	e8 51 3e 00 00       	call   80105c40 <acquire>
  ip->ref--;
80101def:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101df3:	83 c4 10             	add    $0x10,%esp
80101df6:	c7 45 08 00 30 11 80 	movl   $0x80113000,0x8(%ebp)
}
80101dfd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e00:	5b                   	pop    %ebx
80101e01:	5e                   	pop    %esi
80101e02:	5f                   	pop    %edi
80101e03:	5d                   	pop    %ebp
  release(&icache.lock);
80101e04:	e9 f7 3e 00 00       	jmp    80105d00 <release>
80101e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101e10:	83 ec 0c             	sub    $0xc,%esp
80101e13:	68 00 30 11 80       	push   $0x80113000
80101e18:	e8 23 3e 00 00       	call   80105c40 <acquire>
    int r = ip->ref;
80101e1d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101e20:	c7 04 24 00 30 11 80 	movl   $0x80113000,(%esp)
80101e27:	e8 d4 3e 00 00       	call   80105d00 <release>
    if(r == 1){
80101e2c:	83 c4 10             	add    $0x10,%esp
80101e2f:	83 fe 01             	cmp    $0x1,%esi
80101e32:	75 a6                	jne    80101dda <iput+0x2a>
80101e34:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101e3a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101e3d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101e40:	89 cf                	mov    %ecx,%edi
80101e42:	eb 0b                	jmp    80101e4f <iput+0x9f>
80101e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101e48:	83 c6 04             	add    $0x4,%esi
80101e4b:	39 fe                	cmp    %edi,%esi
80101e4d:	74 19                	je     80101e68 <iput+0xb8>
    if(ip->addrs[i]){
80101e4f:	8b 16                	mov    (%esi),%edx
80101e51:	85 d2                	test   %edx,%edx
80101e53:	74 f3                	je     80101e48 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101e55:	8b 03                	mov    (%ebx),%eax
80101e57:	e8 74 f8 ff ff       	call   801016d0 <bfree>
      ip->addrs[i] = 0;
80101e5c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101e62:	eb e4                	jmp    80101e48 <iput+0x98>
80101e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101e68:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101e6e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101e71:	85 c0                	test   %eax,%eax
80101e73:	75 33                	jne    80101ea8 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101e75:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101e78:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101e7f:	53                   	push   %ebx
80101e80:	e8 3b fd ff ff       	call   80101bc0 <iupdate>
      ip->type = 0;
80101e85:	31 c0                	xor    %eax,%eax
80101e87:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101e8b:	89 1c 24             	mov    %ebx,(%esp)
80101e8e:	e8 2d fd ff ff       	call   80101bc0 <iupdate>
      ip->valid = 0;
80101e93:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101e9a:	83 c4 10             	add    $0x10,%esp
80101e9d:	e9 38 ff ff ff       	jmp    80101dda <iput+0x2a>
80101ea2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101ea8:	83 ec 08             	sub    $0x8,%esp
80101eab:	50                   	push   %eax
80101eac:	ff 33                	pushl  (%ebx)
80101eae:	e8 1d e2 ff ff       	call   801000d0 <bread>
80101eb3:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101eb6:	83 c4 10             	add    $0x10,%esp
80101eb9:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101ebf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101ec2:	8d 70 5c             	lea    0x5c(%eax),%esi
80101ec5:	89 cf                	mov    %ecx,%edi
80101ec7:	eb 0e                	jmp    80101ed7 <iput+0x127>
80101ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ed0:	83 c6 04             	add    $0x4,%esi
80101ed3:	39 f7                	cmp    %esi,%edi
80101ed5:	74 19                	je     80101ef0 <iput+0x140>
      if(a[j])
80101ed7:	8b 16                	mov    (%esi),%edx
80101ed9:	85 d2                	test   %edx,%edx
80101edb:	74 f3                	je     80101ed0 <iput+0x120>
        bfree(ip->dev, a[j]);
80101edd:	8b 03                	mov    (%ebx),%eax
80101edf:	e8 ec f7 ff ff       	call   801016d0 <bfree>
80101ee4:	eb ea                	jmp    80101ed0 <iput+0x120>
80101ee6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101eed:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101ef0:	83 ec 0c             	sub    $0xc,%esp
80101ef3:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ef6:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101ef9:	e8 f2 e2 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101efe:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101f04:	8b 03                	mov    (%ebx),%eax
80101f06:	e8 c5 f7 ff ff       	call   801016d0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101f0b:	83 c4 10             	add    $0x10,%esp
80101f0e:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101f15:	00 00 00 
80101f18:	e9 58 ff ff ff       	jmp    80101e75 <iput+0xc5>
80101f1d:	8d 76 00             	lea    0x0(%esi),%esi

80101f20 <iunlockput>:
{
80101f20:	f3 0f 1e fb          	endbr32 
80101f24:	55                   	push   %ebp
80101f25:	89 e5                	mov    %esp,%ebp
80101f27:	53                   	push   %ebx
80101f28:	83 ec 10             	sub    $0x10,%esp
80101f2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101f2e:	53                   	push   %ebx
80101f2f:	e8 2c fe ff ff       	call   80101d60 <iunlock>
  iput(ip);
80101f34:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101f37:	83 c4 10             	add    $0x10,%esp
}
80101f3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f3d:	c9                   	leave  
  iput(ip);
80101f3e:	e9 6d fe ff ff       	jmp    80101db0 <iput>
80101f43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f50 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101f50:	f3 0f 1e fb          	endbr32 
80101f54:	55                   	push   %ebp
80101f55:	89 e5                	mov    %esp,%ebp
80101f57:	8b 55 08             	mov    0x8(%ebp),%edx
80101f5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101f5d:	8b 0a                	mov    (%edx),%ecx
80101f5f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101f62:	8b 4a 04             	mov    0x4(%edx),%ecx
80101f65:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101f68:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101f6c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101f6f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101f73:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101f77:	8b 52 58             	mov    0x58(%edx),%edx
80101f7a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f7d:	5d                   	pop    %ebp
80101f7e:	c3                   	ret    
80101f7f:	90                   	nop

80101f80 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101f80:	f3 0f 1e fb          	endbr32 
80101f84:	55                   	push   %ebp
80101f85:	89 e5                	mov    %esp,%ebp
80101f87:	57                   	push   %edi
80101f88:	56                   	push   %esi
80101f89:	53                   	push   %ebx
80101f8a:	83 ec 1c             	sub    $0x1c,%esp
80101f8d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101f90:	8b 45 08             	mov    0x8(%ebp),%eax
80101f93:	8b 75 10             	mov    0x10(%ebp),%esi
80101f96:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101f99:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f9c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101fa1:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101fa4:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101fa7:	0f 84 a3 00 00 00    	je     80102050 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101fad:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101fb0:	8b 40 58             	mov    0x58(%eax),%eax
80101fb3:	39 c6                	cmp    %eax,%esi
80101fb5:	0f 87 b6 00 00 00    	ja     80102071 <readi+0xf1>
80101fbb:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101fbe:	31 c9                	xor    %ecx,%ecx
80101fc0:	89 da                	mov    %ebx,%edx
80101fc2:	01 f2                	add    %esi,%edx
80101fc4:	0f 92 c1             	setb   %cl
80101fc7:	89 cf                	mov    %ecx,%edi
80101fc9:	0f 82 a2 00 00 00    	jb     80102071 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101fcf:	89 c1                	mov    %eax,%ecx
80101fd1:	29 f1                	sub    %esi,%ecx
80101fd3:	39 d0                	cmp    %edx,%eax
80101fd5:	0f 43 cb             	cmovae %ebx,%ecx
80101fd8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101fdb:	85 c9                	test   %ecx,%ecx
80101fdd:	74 63                	je     80102042 <readi+0xc2>
80101fdf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fe0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101fe3:	89 f2                	mov    %esi,%edx
80101fe5:	c1 ea 09             	shr    $0x9,%edx
80101fe8:	89 d8                	mov    %ebx,%eax
80101fea:	e8 61 f9 ff ff       	call   80101950 <bmap>
80101fef:	83 ec 08             	sub    $0x8,%esp
80101ff2:	50                   	push   %eax
80101ff3:	ff 33                	pushl  (%ebx)
80101ff5:	e8 d6 e0 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ffa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101ffd:	b9 00 02 00 00       	mov    $0x200,%ecx
80102002:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102005:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80102007:	89 f0                	mov    %esi,%eax
80102009:	25 ff 01 00 00       	and    $0x1ff,%eax
8010200e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80102010:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102013:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80102015:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102019:	39 d9                	cmp    %ebx,%ecx
8010201b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
8010201e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010201f:	01 df                	add    %ebx,%edi
80102021:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80102023:	50                   	push   %eax
80102024:	ff 75 e0             	pushl  -0x20(%ebp)
80102027:	e8 c4 3d 00 00       	call   80105df0 <memmove>
    brelse(bp);
8010202c:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010202f:	89 14 24             	mov    %edx,(%esp)
80102032:	e8 b9 e1 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102037:	01 5d e0             	add    %ebx,-0x20(%ebp)
8010203a:	83 c4 10             	add    $0x10,%esp
8010203d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80102040:	77 9e                	ja     80101fe0 <readi+0x60>
  }
  return n;
80102042:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80102045:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102048:	5b                   	pop    %ebx
80102049:	5e                   	pop    %esi
8010204a:	5f                   	pop    %edi
8010204b:	5d                   	pop    %ebp
8010204c:	c3                   	ret    
8010204d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102050:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102054:	66 83 f8 09          	cmp    $0x9,%ax
80102058:	77 17                	ja     80102071 <readi+0xf1>
8010205a:	8b 04 c5 80 2f 11 80 	mov    -0x7feed080(,%eax,8),%eax
80102061:	85 c0                	test   %eax,%eax
80102063:	74 0c                	je     80102071 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80102065:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102068:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010206b:	5b                   	pop    %ebx
8010206c:	5e                   	pop    %esi
8010206d:	5f                   	pop    %edi
8010206e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
8010206f:	ff e0                	jmp    *%eax
      return -1;
80102071:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102076:	eb cd                	jmp    80102045 <readi+0xc5>
80102078:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010207f:	90                   	nop

80102080 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102080:	f3 0f 1e fb          	endbr32 
80102084:	55                   	push   %ebp
80102085:	89 e5                	mov    %esp,%ebp
80102087:	57                   	push   %edi
80102088:	56                   	push   %esi
80102089:	53                   	push   %ebx
8010208a:	83 ec 1c             	sub    $0x1c,%esp
8010208d:	8b 45 08             	mov    0x8(%ebp),%eax
80102090:	8b 75 0c             	mov    0xc(%ebp),%esi
80102093:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102096:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
8010209b:	89 75 dc             	mov    %esi,-0x24(%ebp)
8010209e:	89 45 d8             	mov    %eax,-0x28(%ebp)
801020a1:	8b 75 10             	mov    0x10(%ebp),%esi
801020a4:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
801020a7:	0f 84 b3 00 00 00    	je     80102160 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
801020ad:	8b 45 d8             	mov    -0x28(%ebp),%eax
801020b0:	39 70 58             	cmp    %esi,0x58(%eax)
801020b3:	0f 82 e3 00 00 00    	jb     8010219c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
801020b9:	8b 7d e0             	mov    -0x20(%ebp),%edi
801020bc:	89 f8                	mov    %edi,%eax
801020be:	01 f0                	add    %esi,%eax
801020c0:	0f 82 d6 00 00 00    	jb     8010219c <writei+0x11c>
801020c6:	3d 00 18 01 00       	cmp    $0x11800,%eax
801020cb:	0f 87 cb 00 00 00    	ja     8010219c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020d1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801020d8:	85 ff                	test   %edi,%edi
801020da:	74 75                	je     80102151 <writei+0xd1>
801020dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020e0:	8b 7d d8             	mov    -0x28(%ebp),%edi
801020e3:	89 f2                	mov    %esi,%edx
801020e5:	c1 ea 09             	shr    $0x9,%edx
801020e8:	89 f8                	mov    %edi,%eax
801020ea:	e8 61 f8 ff ff       	call   80101950 <bmap>
801020ef:	83 ec 08             	sub    $0x8,%esp
801020f2:	50                   	push   %eax
801020f3:	ff 37                	pushl  (%edi)
801020f5:	e8 d6 df ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801020fa:	b9 00 02 00 00       	mov    $0x200,%ecx
801020ff:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80102102:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102105:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80102107:	89 f0                	mov    %esi,%eax
80102109:	83 c4 0c             	add    $0xc,%esp
8010210c:	25 ff 01 00 00       	and    $0x1ff,%eax
80102111:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80102113:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80102117:	39 d9                	cmp    %ebx,%ecx
80102119:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
8010211c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010211d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
8010211f:	ff 75 dc             	pushl  -0x24(%ebp)
80102122:	50                   	push   %eax
80102123:	e8 c8 3c 00 00       	call   80105df0 <memmove>
    log_write(bp);
80102128:	89 3c 24             	mov    %edi,(%esp)
8010212b:	e8 00 13 00 00       	call   80103430 <log_write>
    brelse(bp);
80102130:	89 3c 24             	mov    %edi,(%esp)
80102133:	e8 b8 e0 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102138:	01 5d e4             	add    %ebx,-0x1c(%ebp)
8010213b:	83 c4 10             	add    $0x10,%esp
8010213e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102141:	01 5d dc             	add    %ebx,-0x24(%ebp)
80102144:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80102147:	77 97                	ja     801020e0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80102149:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010214c:	3b 70 58             	cmp    0x58(%eax),%esi
8010214f:	77 37                	ja     80102188 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80102151:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80102154:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102157:	5b                   	pop    %ebx
80102158:	5e                   	pop    %esi
80102159:	5f                   	pop    %edi
8010215a:	5d                   	pop    %ebp
8010215b:	c3                   	ret    
8010215c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102160:	0f bf 40 52          	movswl 0x52(%eax),%eax
80102164:	66 83 f8 09          	cmp    $0x9,%ax
80102168:	77 32                	ja     8010219c <writei+0x11c>
8010216a:	8b 04 c5 84 2f 11 80 	mov    -0x7feed07c(,%eax,8),%eax
80102171:	85 c0                	test   %eax,%eax
80102173:	74 27                	je     8010219c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80102175:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80102178:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010217b:	5b                   	pop    %ebx
8010217c:	5e                   	pop    %esi
8010217d:	5f                   	pop    %edi
8010217e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
8010217f:	ff e0                	jmp    *%eax
80102181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80102188:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
8010218b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
8010218e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80102191:	50                   	push   %eax
80102192:	e8 29 fa ff ff       	call   80101bc0 <iupdate>
80102197:	83 c4 10             	add    $0x10,%esp
8010219a:	eb b5                	jmp    80102151 <writei+0xd1>
      return -1;
8010219c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021a1:	eb b1                	jmp    80102154 <writei+0xd4>
801021a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801021b0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801021b0:	f3 0f 1e fb          	endbr32 
801021b4:	55                   	push   %ebp
801021b5:	89 e5                	mov    %esp,%ebp
801021b7:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
801021ba:	6a 0e                	push   $0xe
801021bc:	ff 75 0c             	pushl  0xc(%ebp)
801021bf:	ff 75 08             	pushl  0x8(%ebp)
801021c2:	e8 99 3c 00 00       	call   80105e60 <strncmp>
}
801021c7:	c9                   	leave  
801021c8:	c3                   	ret    
801021c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021d0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801021d0:	f3 0f 1e fb          	endbr32 
801021d4:	55                   	push   %ebp
801021d5:	89 e5                	mov    %esp,%ebp
801021d7:	57                   	push   %edi
801021d8:	56                   	push   %esi
801021d9:	53                   	push   %ebx
801021da:	83 ec 1c             	sub    $0x1c,%esp
801021dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801021e0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801021e5:	0f 85 89 00 00 00    	jne    80102274 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801021eb:	8b 53 58             	mov    0x58(%ebx),%edx
801021ee:	31 ff                	xor    %edi,%edi
801021f0:	8d 75 d8             	lea    -0x28(%ebp),%esi
801021f3:	85 d2                	test   %edx,%edx
801021f5:	74 42                	je     80102239 <dirlookup+0x69>
801021f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021fe:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102200:	6a 10                	push   $0x10
80102202:	57                   	push   %edi
80102203:	56                   	push   %esi
80102204:	53                   	push   %ebx
80102205:	e8 76 fd ff ff       	call   80101f80 <readi>
8010220a:	83 c4 10             	add    $0x10,%esp
8010220d:	83 f8 10             	cmp    $0x10,%eax
80102210:	75 55                	jne    80102267 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80102212:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102217:	74 18                	je     80102231 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80102219:	83 ec 04             	sub    $0x4,%esp
8010221c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010221f:	6a 0e                	push   $0xe
80102221:	50                   	push   %eax
80102222:	ff 75 0c             	pushl  0xc(%ebp)
80102225:	e8 36 3c 00 00       	call   80105e60 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
8010222a:	83 c4 10             	add    $0x10,%esp
8010222d:	85 c0                	test   %eax,%eax
8010222f:	74 17                	je     80102248 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102231:	83 c7 10             	add    $0x10,%edi
80102234:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102237:	72 c7                	jb     80102200 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80102239:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010223c:	31 c0                	xor    %eax,%eax
}
8010223e:	5b                   	pop    %ebx
8010223f:	5e                   	pop    %esi
80102240:	5f                   	pop    %edi
80102241:	5d                   	pop    %ebp
80102242:	c3                   	ret    
80102243:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102247:	90                   	nop
      if(poff)
80102248:	8b 45 10             	mov    0x10(%ebp),%eax
8010224b:	85 c0                	test   %eax,%eax
8010224d:	74 05                	je     80102254 <dirlookup+0x84>
        *poff = off;
8010224f:	8b 45 10             	mov    0x10(%ebp),%eax
80102252:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80102254:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80102258:	8b 03                	mov    (%ebx),%eax
8010225a:	e8 01 f6 ff ff       	call   80101860 <iget>
}
8010225f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102262:	5b                   	pop    %ebx
80102263:	5e                   	pop    %esi
80102264:	5f                   	pop    %edi
80102265:	5d                   	pop    %ebp
80102266:	c3                   	ret    
      panic("dirlookup read");
80102267:	83 ec 0c             	sub    $0xc,%esp
8010226a:	68 31 8e 10 80       	push   $0x80108e31
8010226f:	e8 1c e1 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80102274:	83 ec 0c             	sub    $0xc,%esp
80102277:	68 1f 8e 10 80       	push   $0x80108e1f
8010227c:	e8 0f e1 ff ff       	call   80100390 <panic>
80102281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102288:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010228f:	90                   	nop

80102290 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102290:	55                   	push   %ebp
80102291:	89 e5                	mov    %esp,%ebp
80102293:	57                   	push   %edi
80102294:	56                   	push   %esi
80102295:	53                   	push   %ebx
80102296:	89 c3                	mov    %eax,%ebx
80102298:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010229b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
8010229e:	89 55 e0             	mov    %edx,-0x20(%ebp)
801022a1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
801022a4:	0f 84 86 01 00 00    	je     80102430 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
801022aa:	e8 41 1c 00 00       	call   80103ef0 <myproc>
  acquire(&icache.lock);
801022af:	83 ec 0c             	sub    $0xc,%esp
801022b2:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
801022b4:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
801022b7:	68 00 30 11 80       	push   $0x80113000
801022bc:	e8 7f 39 00 00       	call   80105c40 <acquire>
  ip->ref++;
801022c1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
801022c5:	c7 04 24 00 30 11 80 	movl   $0x80113000,(%esp)
801022cc:	e8 2f 3a 00 00       	call   80105d00 <release>
801022d1:	83 c4 10             	add    $0x10,%esp
801022d4:	eb 0d                	jmp    801022e3 <namex+0x53>
801022d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022dd:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
801022e0:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
801022e3:	0f b6 07             	movzbl (%edi),%eax
801022e6:	3c 2f                	cmp    $0x2f,%al
801022e8:	74 f6                	je     801022e0 <namex+0x50>
  if(*path == 0)
801022ea:	84 c0                	test   %al,%al
801022ec:	0f 84 ee 00 00 00    	je     801023e0 <namex+0x150>
  while(*path != '/' && *path != 0)
801022f2:	0f b6 07             	movzbl (%edi),%eax
801022f5:	84 c0                	test   %al,%al
801022f7:	0f 84 fb 00 00 00    	je     801023f8 <namex+0x168>
801022fd:	89 fb                	mov    %edi,%ebx
801022ff:	3c 2f                	cmp    $0x2f,%al
80102301:	0f 84 f1 00 00 00    	je     801023f8 <namex+0x168>
80102307:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010230e:	66 90                	xchg   %ax,%ax
80102310:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80102314:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80102317:	3c 2f                	cmp    $0x2f,%al
80102319:	74 04                	je     8010231f <namex+0x8f>
8010231b:	84 c0                	test   %al,%al
8010231d:	75 f1                	jne    80102310 <namex+0x80>
  len = path - s;
8010231f:	89 d8                	mov    %ebx,%eax
80102321:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80102323:	83 f8 0d             	cmp    $0xd,%eax
80102326:	0f 8e 84 00 00 00    	jle    801023b0 <namex+0x120>
    memmove(name, s, DIRSIZ);
8010232c:	83 ec 04             	sub    $0x4,%esp
8010232f:	6a 0e                	push   $0xe
80102331:	57                   	push   %edi
    path++;
80102332:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80102334:	ff 75 e4             	pushl  -0x1c(%ebp)
80102337:	e8 b4 3a 00 00       	call   80105df0 <memmove>
8010233c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
8010233f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80102342:	75 0c                	jne    80102350 <namex+0xc0>
80102344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102348:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
8010234b:	80 3f 2f             	cmpb   $0x2f,(%edi)
8010234e:	74 f8                	je     80102348 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102350:	83 ec 0c             	sub    $0xc,%esp
80102353:	56                   	push   %esi
80102354:	e8 27 f9 ff ff       	call   80101c80 <ilock>
    if(ip->type != T_DIR){
80102359:	83 c4 10             	add    $0x10,%esp
8010235c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102361:	0f 85 a1 00 00 00    	jne    80102408 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80102367:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010236a:	85 d2                	test   %edx,%edx
8010236c:	74 09                	je     80102377 <namex+0xe7>
8010236e:	80 3f 00             	cmpb   $0x0,(%edi)
80102371:	0f 84 d9 00 00 00    	je     80102450 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102377:	83 ec 04             	sub    $0x4,%esp
8010237a:	6a 00                	push   $0x0
8010237c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010237f:	56                   	push   %esi
80102380:	e8 4b fe ff ff       	call   801021d0 <dirlookup>
80102385:	83 c4 10             	add    $0x10,%esp
80102388:	89 c3                	mov    %eax,%ebx
8010238a:	85 c0                	test   %eax,%eax
8010238c:	74 7a                	je     80102408 <namex+0x178>
  iunlock(ip);
8010238e:	83 ec 0c             	sub    $0xc,%esp
80102391:	56                   	push   %esi
80102392:	e8 c9 f9 ff ff       	call   80101d60 <iunlock>
  iput(ip);
80102397:	89 34 24             	mov    %esi,(%esp)
8010239a:	89 de                	mov    %ebx,%esi
8010239c:	e8 0f fa ff ff       	call   80101db0 <iput>
801023a1:	83 c4 10             	add    $0x10,%esp
801023a4:	e9 3a ff ff ff       	jmp    801022e3 <namex+0x53>
801023a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801023b3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
801023b6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
801023b9:	83 ec 04             	sub    $0x4,%esp
801023bc:	50                   	push   %eax
801023bd:	57                   	push   %edi
    name[len] = 0;
801023be:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
801023c0:	ff 75 e4             	pushl  -0x1c(%ebp)
801023c3:	e8 28 3a 00 00       	call   80105df0 <memmove>
    name[len] = 0;
801023c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
801023cb:	83 c4 10             	add    $0x10,%esp
801023ce:	c6 00 00             	movb   $0x0,(%eax)
801023d1:	e9 69 ff ff ff       	jmp    8010233f <namex+0xaf>
801023d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023dd:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801023e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801023e3:	85 c0                	test   %eax,%eax
801023e5:	0f 85 85 00 00 00    	jne    80102470 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
801023eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023ee:	89 f0                	mov    %esi,%eax
801023f0:	5b                   	pop    %ebx
801023f1:	5e                   	pop    %esi
801023f2:	5f                   	pop    %edi
801023f3:	5d                   	pop    %ebp
801023f4:	c3                   	ret    
801023f5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
801023f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801023fb:	89 fb                	mov    %edi,%ebx
801023fd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102400:	31 c0                	xor    %eax,%eax
80102402:	eb b5                	jmp    801023b9 <namex+0x129>
80102404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102408:	83 ec 0c             	sub    $0xc,%esp
8010240b:	56                   	push   %esi
8010240c:	e8 4f f9 ff ff       	call   80101d60 <iunlock>
  iput(ip);
80102411:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102414:	31 f6                	xor    %esi,%esi
  iput(ip);
80102416:	e8 95 f9 ff ff       	call   80101db0 <iput>
      return 0;
8010241b:	83 c4 10             	add    $0x10,%esp
}
8010241e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102421:	89 f0                	mov    %esi,%eax
80102423:	5b                   	pop    %ebx
80102424:	5e                   	pop    %esi
80102425:	5f                   	pop    %edi
80102426:	5d                   	pop    %ebp
80102427:	c3                   	ret    
80102428:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010242f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80102430:	ba 01 00 00 00       	mov    $0x1,%edx
80102435:	b8 01 00 00 00       	mov    $0x1,%eax
8010243a:	89 df                	mov    %ebx,%edi
8010243c:	e8 1f f4 ff ff       	call   80101860 <iget>
80102441:	89 c6                	mov    %eax,%esi
80102443:	e9 9b fe ff ff       	jmp    801022e3 <namex+0x53>
80102448:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010244f:	90                   	nop
      iunlock(ip);
80102450:	83 ec 0c             	sub    $0xc,%esp
80102453:	56                   	push   %esi
80102454:	e8 07 f9 ff ff       	call   80101d60 <iunlock>
      return ip;
80102459:	83 c4 10             	add    $0x10,%esp
}
8010245c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010245f:	89 f0                	mov    %esi,%eax
80102461:	5b                   	pop    %ebx
80102462:	5e                   	pop    %esi
80102463:	5f                   	pop    %edi
80102464:	5d                   	pop    %ebp
80102465:	c3                   	ret    
80102466:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010246d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80102470:	83 ec 0c             	sub    $0xc,%esp
80102473:	56                   	push   %esi
    return 0;
80102474:	31 f6                	xor    %esi,%esi
    iput(ip);
80102476:	e8 35 f9 ff ff       	call   80101db0 <iput>
    return 0;
8010247b:	83 c4 10             	add    $0x10,%esp
8010247e:	e9 68 ff ff ff       	jmp    801023eb <namex+0x15b>
80102483:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010248a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102490 <dirlink>:
{
80102490:	f3 0f 1e fb          	endbr32 
80102494:	55                   	push   %ebp
80102495:	89 e5                	mov    %esp,%ebp
80102497:	57                   	push   %edi
80102498:	56                   	push   %esi
80102499:	53                   	push   %ebx
8010249a:	83 ec 20             	sub    $0x20,%esp
8010249d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801024a0:	6a 00                	push   $0x0
801024a2:	ff 75 0c             	pushl  0xc(%ebp)
801024a5:	53                   	push   %ebx
801024a6:	e8 25 fd ff ff       	call   801021d0 <dirlookup>
801024ab:	83 c4 10             	add    $0x10,%esp
801024ae:	85 c0                	test   %eax,%eax
801024b0:	75 6b                	jne    8010251d <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
801024b2:	8b 7b 58             	mov    0x58(%ebx),%edi
801024b5:	8d 75 d8             	lea    -0x28(%ebp),%esi
801024b8:	85 ff                	test   %edi,%edi
801024ba:	74 2d                	je     801024e9 <dirlink+0x59>
801024bc:	31 ff                	xor    %edi,%edi
801024be:	8d 75 d8             	lea    -0x28(%ebp),%esi
801024c1:	eb 0d                	jmp    801024d0 <dirlink+0x40>
801024c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024c7:	90                   	nop
801024c8:	83 c7 10             	add    $0x10,%edi
801024cb:	3b 7b 58             	cmp    0x58(%ebx),%edi
801024ce:	73 19                	jae    801024e9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801024d0:	6a 10                	push   $0x10
801024d2:	57                   	push   %edi
801024d3:	56                   	push   %esi
801024d4:	53                   	push   %ebx
801024d5:	e8 a6 fa ff ff       	call   80101f80 <readi>
801024da:	83 c4 10             	add    $0x10,%esp
801024dd:	83 f8 10             	cmp    $0x10,%eax
801024e0:	75 4e                	jne    80102530 <dirlink+0xa0>
    if(de.inum == 0)
801024e2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801024e7:	75 df                	jne    801024c8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
801024e9:	83 ec 04             	sub    $0x4,%esp
801024ec:	8d 45 da             	lea    -0x26(%ebp),%eax
801024ef:	6a 0e                	push   $0xe
801024f1:	ff 75 0c             	pushl  0xc(%ebp)
801024f4:	50                   	push   %eax
801024f5:	e8 b6 39 00 00       	call   80105eb0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801024fa:	6a 10                	push   $0x10
  de.inum = inum;
801024fc:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801024ff:	57                   	push   %edi
80102500:	56                   	push   %esi
80102501:	53                   	push   %ebx
  de.inum = inum;
80102502:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102506:	e8 75 fb ff ff       	call   80102080 <writei>
8010250b:	83 c4 20             	add    $0x20,%esp
8010250e:	83 f8 10             	cmp    $0x10,%eax
80102511:	75 2a                	jne    8010253d <dirlink+0xad>
  return 0;
80102513:	31 c0                	xor    %eax,%eax
}
80102515:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102518:	5b                   	pop    %ebx
80102519:	5e                   	pop    %esi
8010251a:	5f                   	pop    %edi
8010251b:	5d                   	pop    %ebp
8010251c:	c3                   	ret    
    iput(ip);
8010251d:	83 ec 0c             	sub    $0xc,%esp
80102520:	50                   	push   %eax
80102521:	e8 8a f8 ff ff       	call   80101db0 <iput>
    return -1;
80102526:	83 c4 10             	add    $0x10,%esp
80102529:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010252e:	eb e5                	jmp    80102515 <dirlink+0x85>
      panic("dirlink read");
80102530:	83 ec 0c             	sub    $0xc,%esp
80102533:	68 40 8e 10 80       	push   $0x80108e40
80102538:	e8 53 de ff ff       	call   80100390 <panic>
    panic("dirlink");
8010253d:	83 ec 0c             	sub    $0xc,%esp
80102540:	68 66 96 10 80       	push   $0x80109666
80102545:	e8 46 de ff ff       	call   80100390 <panic>
8010254a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102550 <namei>:

struct inode*
namei(char *path)
{
80102550:	f3 0f 1e fb          	endbr32 
80102554:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102555:	31 d2                	xor    %edx,%edx
{
80102557:	89 e5                	mov    %esp,%ebp
80102559:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010255c:	8b 45 08             	mov    0x8(%ebp),%eax
8010255f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102562:	e8 29 fd ff ff       	call   80102290 <namex>
}
80102567:	c9                   	leave  
80102568:	c3                   	ret    
80102569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102570 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102570:	f3 0f 1e fb          	endbr32 
80102574:	55                   	push   %ebp
  return namex(path, 1, name);
80102575:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010257a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010257c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010257f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102582:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102583:	e9 08 fd ff ff       	jmp    80102290 <namex>
80102588:	66 90                	xchg   %ax,%ax
8010258a:	66 90                	xchg   %ax,%ax
8010258c:	66 90                	xchg   %ax,%ax
8010258e:	66 90                	xchg   %ax,%ax

80102590 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102590:	55                   	push   %ebp
80102591:	89 e5                	mov    %esp,%ebp
80102593:	57                   	push   %edi
80102594:	56                   	push   %esi
80102595:	53                   	push   %ebx
80102596:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102599:	85 c0                	test   %eax,%eax
8010259b:	0f 84 b4 00 00 00    	je     80102655 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801025a1:	8b 70 08             	mov    0x8(%eax),%esi
801025a4:	89 c3                	mov    %eax,%ebx
801025a6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801025ac:	0f 87 96 00 00 00    	ja     80102648 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025b2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801025b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025be:	66 90                	xchg   %ax,%ax
801025c0:	89 ca                	mov    %ecx,%edx
801025c2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801025c3:	83 e0 c0             	and    $0xffffffc0,%eax
801025c6:	3c 40                	cmp    $0x40,%al
801025c8:	75 f6                	jne    801025c0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025ca:	31 ff                	xor    %edi,%edi
801025cc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801025d1:	89 f8                	mov    %edi,%eax
801025d3:	ee                   	out    %al,(%dx)
801025d4:	b8 01 00 00 00       	mov    $0x1,%eax
801025d9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801025de:	ee                   	out    %al,(%dx)
801025df:	ba f3 01 00 00       	mov    $0x1f3,%edx
801025e4:	89 f0                	mov    %esi,%eax
801025e6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801025e7:	89 f0                	mov    %esi,%eax
801025e9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801025ee:	c1 f8 08             	sar    $0x8,%eax
801025f1:	ee                   	out    %al,(%dx)
801025f2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801025f7:	89 f8                	mov    %edi,%eax
801025f9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801025fa:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801025fe:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102603:	c1 e0 04             	shl    $0x4,%eax
80102606:	83 e0 10             	and    $0x10,%eax
80102609:	83 c8 e0             	or     $0xffffffe0,%eax
8010260c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010260d:	f6 03 04             	testb  $0x4,(%ebx)
80102610:	75 16                	jne    80102628 <idestart+0x98>
80102612:	b8 20 00 00 00       	mov    $0x20,%eax
80102617:	89 ca                	mov    %ecx,%edx
80102619:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010261a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010261d:	5b                   	pop    %ebx
8010261e:	5e                   	pop    %esi
8010261f:	5f                   	pop    %edi
80102620:	5d                   	pop    %ebp
80102621:	c3                   	ret    
80102622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102628:	b8 30 00 00 00       	mov    $0x30,%eax
8010262d:	89 ca                	mov    %ecx,%edx
8010262f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102630:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102635:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102638:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010263d:	fc                   	cld    
8010263e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102640:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102643:	5b                   	pop    %ebx
80102644:	5e                   	pop    %esi
80102645:	5f                   	pop    %edi
80102646:	5d                   	pop    %ebp
80102647:	c3                   	ret    
    panic("incorrect blockno");
80102648:	83 ec 0c             	sub    $0xc,%esp
8010264b:	68 ac 8e 10 80       	push   $0x80108eac
80102650:	e8 3b dd ff ff       	call   80100390 <panic>
    panic("idestart");
80102655:	83 ec 0c             	sub    $0xc,%esp
80102658:	68 a3 8e 10 80       	push   $0x80108ea3
8010265d:	e8 2e dd ff ff       	call   80100390 <panic>
80102662:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102670 <ideinit>:
{
80102670:	f3 0f 1e fb          	endbr32 
80102674:	55                   	push   %ebp
80102675:	89 e5                	mov    %esp,%ebp
80102677:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010267a:	68 be 8e 10 80       	push   $0x80108ebe
8010267f:	68 80 c5 10 80       	push   $0x8010c580
80102684:	e8 37 34 00 00       	call   80105ac0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102689:	58                   	pop    %eax
8010268a:	a1 40 53 11 80       	mov    0x80115340,%eax
8010268f:	5a                   	pop    %edx
80102690:	83 e8 01             	sub    $0x1,%eax
80102693:	50                   	push   %eax
80102694:	6a 0e                	push   $0xe
80102696:	e8 b5 02 00 00       	call   80102950 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010269b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010269e:	ba f7 01 00 00       	mov    $0x1f7,%edx
801026a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026a7:	90                   	nop
801026a8:	ec                   	in     (%dx),%al
801026a9:	83 e0 c0             	and    $0xffffffc0,%eax
801026ac:	3c 40                	cmp    $0x40,%al
801026ae:	75 f8                	jne    801026a8 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026b0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801026b5:	ba f6 01 00 00       	mov    $0x1f6,%edx
801026ba:	ee                   	out    %al,(%dx)
801026bb:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026c0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801026c5:	eb 0e                	jmp    801026d5 <ideinit+0x65>
801026c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026ce:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801026d0:	83 e9 01             	sub    $0x1,%ecx
801026d3:	74 0f                	je     801026e4 <ideinit+0x74>
801026d5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801026d6:	84 c0                	test   %al,%al
801026d8:	74 f6                	je     801026d0 <ideinit+0x60>
      havedisk1 = 1;
801026da:	c7 05 60 c5 10 80 01 	movl   $0x1,0x8010c560
801026e1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026e4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801026e9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801026ee:	ee                   	out    %al,(%dx)
}
801026ef:	c9                   	leave  
801026f0:	c3                   	ret    
801026f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026ff:	90                   	nop

80102700 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102700:	f3 0f 1e fb          	endbr32 
80102704:	55                   	push   %ebp
80102705:	89 e5                	mov    %esp,%ebp
80102707:	57                   	push   %edi
80102708:	56                   	push   %esi
80102709:	53                   	push   %ebx
8010270a:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010270d:	68 80 c5 10 80       	push   $0x8010c580
80102712:	e8 29 35 00 00       	call   80105c40 <acquire>

  if((b = idequeue) == 0){
80102717:	8b 1d 64 c5 10 80    	mov    0x8010c564,%ebx
8010271d:	83 c4 10             	add    $0x10,%esp
80102720:	85 db                	test   %ebx,%ebx
80102722:	74 5f                	je     80102783 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102724:	8b 43 58             	mov    0x58(%ebx),%eax
80102727:	a3 64 c5 10 80       	mov    %eax,0x8010c564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010272c:	8b 33                	mov    (%ebx),%esi
8010272e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102734:	75 2b                	jne    80102761 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102736:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010273b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010273f:	90                   	nop
80102740:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102741:	89 c1                	mov    %eax,%ecx
80102743:	83 e1 c0             	and    $0xffffffc0,%ecx
80102746:	80 f9 40             	cmp    $0x40,%cl
80102749:	75 f5                	jne    80102740 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010274b:	a8 21                	test   $0x21,%al
8010274d:	75 12                	jne    80102761 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010274f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102752:	b9 80 00 00 00       	mov    $0x80,%ecx
80102757:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010275c:	fc                   	cld    
8010275d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010275f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102761:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102764:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102767:	83 ce 02             	or     $0x2,%esi
8010276a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010276c:	53                   	push   %ebx
8010276d:	e8 1e 1f 00 00       	call   80104690 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102772:	a1 64 c5 10 80       	mov    0x8010c564,%eax
80102777:	83 c4 10             	add    $0x10,%esp
8010277a:	85 c0                	test   %eax,%eax
8010277c:	74 05                	je     80102783 <ideintr+0x83>
    idestart(idequeue);
8010277e:	e8 0d fe ff ff       	call   80102590 <idestart>
    release(&idelock);
80102783:	83 ec 0c             	sub    $0xc,%esp
80102786:	68 80 c5 10 80       	push   $0x8010c580
8010278b:	e8 70 35 00 00       	call   80105d00 <release>

  release(&idelock);
}
80102790:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102793:	5b                   	pop    %ebx
80102794:	5e                   	pop    %esi
80102795:	5f                   	pop    %edi
80102796:	5d                   	pop    %ebp
80102797:	c3                   	ret    
80102798:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010279f:	90                   	nop

801027a0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801027a0:	f3 0f 1e fb          	endbr32 
801027a4:	55                   	push   %ebp
801027a5:	89 e5                	mov    %esp,%ebp
801027a7:	53                   	push   %ebx
801027a8:	83 ec 10             	sub    $0x10,%esp
801027ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801027ae:	8d 43 0c             	lea    0xc(%ebx),%eax
801027b1:	50                   	push   %eax
801027b2:	e8 89 31 00 00       	call   80105940 <holdingsleep>
801027b7:	83 c4 10             	add    $0x10,%esp
801027ba:	85 c0                	test   %eax,%eax
801027bc:	0f 84 cf 00 00 00    	je     80102891 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801027c2:	8b 03                	mov    (%ebx),%eax
801027c4:	83 e0 06             	and    $0x6,%eax
801027c7:	83 f8 02             	cmp    $0x2,%eax
801027ca:	0f 84 b4 00 00 00    	je     80102884 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801027d0:	8b 53 04             	mov    0x4(%ebx),%edx
801027d3:	85 d2                	test   %edx,%edx
801027d5:	74 0d                	je     801027e4 <iderw+0x44>
801027d7:	a1 60 c5 10 80       	mov    0x8010c560,%eax
801027dc:	85 c0                	test   %eax,%eax
801027de:	0f 84 93 00 00 00    	je     80102877 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801027e4:	83 ec 0c             	sub    $0xc,%esp
801027e7:	68 80 c5 10 80       	push   $0x8010c580
801027ec:	e8 4f 34 00 00       	call   80105c40 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801027f1:	a1 64 c5 10 80       	mov    0x8010c564,%eax
  b->qnext = 0;
801027f6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801027fd:	83 c4 10             	add    $0x10,%esp
80102800:	85 c0                	test   %eax,%eax
80102802:	74 6c                	je     80102870 <iderw+0xd0>
80102804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102808:	89 c2                	mov    %eax,%edx
8010280a:	8b 40 58             	mov    0x58(%eax),%eax
8010280d:	85 c0                	test   %eax,%eax
8010280f:	75 f7                	jne    80102808 <iderw+0x68>
80102811:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102814:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102816:	39 1d 64 c5 10 80    	cmp    %ebx,0x8010c564
8010281c:	74 42                	je     80102860 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010281e:	8b 03                	mov    (%ebx),%eax
80102820:	83 e0 06             	and    $0x6,%eax
80102823:	83 f8 02             	cmp    $0x2,%eax
80102826:	74 23                	je     8010284b <iderw+0xab>
80102828:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010282f:	90                   	nop
    sleep(b, &idelock);
80102830:	83 ec 08             	sub    $0x8,%esp
80102833:	68 80 c5 10 80       	push   $0x8010c580
80102838:	53                   	push   %ebx
80102839:	e8 92 1c 00 00       	call   801044d0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010283e:	8b 03                	mov    (%ebx),%eax
80102840:	83 c4 10             	add    $0x10,%esp
80102843:	83 e0 06             	and    $0x6,%eax
80102846:	83 f8 02             	cmp    $0x2,%eax
80102849:	75 e5                	jne    80102830 <iderw+0x90>
  }


  release(&idelock);
8010284b:	c7 45 08 80 c5 10 80 	movl   $0x8010c580,0x8(%ebp)
}
80102852:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102855:	c9                   	leave  
  release(&idelock);
80102856:	e9 a5 34 00 00       	jmp    80105d00 <release>
8010285b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010285f:	90                   	nop
    idestart(b);
80102860:	89 d8                	mov    %ebx,%eax
80102862:	e8 29 fd ff ff       	call   80102590 <idestart>
80102867:	eb b5                	jmp    8010281e <iderw+0x7e>
80102869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102870:	ba 64 c5 10 80       	mov    $0x8010c564,%edx
80102875:	eb 9d                	jmp    80102814 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102877:	83 ec 0c             	sub    $0xc,%esp
8010287a:	68 ed 8e 10 80       	push   $0x80108eed
8010287f:	e8 0c db ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102884:	83 ec 0c             	sub    $0xc,%esp
80102887:	68 d8 8e 10 80       	push   $0x80108ed8
8010288c:	e8 ff da ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102891:	83 ec 0c             	sub    $0xc,%esp
80102894:	68 c2 8e 10 80       	push   $0x80108ec2
80102899:	e8 f2 da ff ff       	call   80100390 <panic>
8010289e:	66 90                	xchg   %ax,%ax

801028a0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801028a0:	f3 0f 1e fb          	endbr32 
801028a4:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801028a5:	c7 05 54 4c 11 80 00 	movl   $0xfec00000,0x80114c54
801028ac:	00 c0 fe 
{
801028af:	89 e5                	mov    %esp,%ebp
801028b1:	56                   	push   %esi
801028b2:	53                   	push   %ebx
  ioapic->reg = reg;
801028b3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801028ba:	00 00 00 
  return ioapic->data;
801028bd:	8b 15 54 4c 11 80    	mov    0x80114c54,%edx
801028c3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801028c6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801028cc:	8b 0d 54 4c 11 80    	mov    0x80114c54,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801028d2:	0f b6 15 80 4d 11 80 	movzbl 0x80114d80,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801028d9:	c1 ee 10             	shr    $0x10,%esi
801028dc:	89 f0                	mov    %esi,%eax
801028de:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801028e1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801028e4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801028e7:	39 c2                	cmp    %eax,%edx
801028e9:	74 16                	je     80102901 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801028eb:	83 ec 0c             	sub    $0xc,%esp
801028ee:	68 0c 8f 10 80       	push   $0x80108f0c
801028f3:	e8 c8 df ff ff       	call   801008c0 <cprintf>
801028f8:	8b 0d 54 4c 11 80    	mov    0x80114c54,%ecx
801028fe:	83 c4 10             	add    $0x10,%esp
80102901:	83 c6 21             	add    $0x21,%esi
{
80102904:	ba 10 00 00 00       	mov    $0x10,%edx
80102909:	b8 20 00 00 00       	mov    $0x20,%eax
8010290e:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102910:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102912:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102914:	8b 0d 54 4c 11 80    	mov    0x80114c54,%ecx
8010291a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010291d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102923:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102926:	8d 5a 01             	lea    0x1(%edx),%ebx
80102929:	83 c2 02             	add    $0x2,%edx
8010292c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010292e:	8b 0d 54 4c 11 80    	mov    0x80114c54,%ecx
80102934:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010293b:	39 f0                	cmp    %esi,%eax
8010293d:	75 d1                	jne    80102910 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010293f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102942:	5b                   	pop    %ebx
80102943:	5e                   	pop    %esi
80102944:	5d                   	pop    %ebp
80102945:	c3                   	ret    
80102946:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010294d:	8d 76 00             	lea    0x0(%esi),%esi

80102950 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102950:	f3 0f 1e fb          	endbr32 
80102954:	55                   	push   %ebp
  ioapic->reg = reg;
80102955:	8b 0d 54 4c 11 80    	mov    0x80114c54,%ecx
{
8010295b:	89 e5                	mov    %esp,%ebp
8010295d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102960:	8d 50 20             	lea    0x20(%eax),%edx
80102963:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102967:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102969:	8b 0d 54 4c 11 80    	mov    0x80114c54,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010296f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102972:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102975:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102978:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010297a:	a1 54 4c 11 80       	mov    0x80114c54,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010297f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102982:	89 50 10             	mov    %edx,0x10(%eax)
}
80102985:	5d                   	pop    %ebp
80102986:	c3                   	ret    
80102987:	66 90                	xchg   %ax,%ax
80102989:	66 90                	xchg   %ax,%ax
8010298b:	66 90                	xchg   %ax,%ax
8010298d:	66 90                	xchg   %ax,%ax
8010298f:	90                   	nop

80102990 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102990:	f3 0f 1e fb          	endbr32 
80102994:	55                   	push   %ebp
80102995:	89 e5                	mov    %esp,%ebp
80102997:	53                   	push   %ebx
80102998:	83 ec 04             	sub    $0x4,%esp
8010299b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010299e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801029a4:	75 7a                	jne    80102a20 <kfree+0x90>
801029a6:	81 fb e8 86 11 80    	cmp    $0x801186e8,%ebx
801029ac:	72 72                	jb     80102a20 <kfree+0x90>
801029ae:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801029b4:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801029b9:	77 65                	ja     80102a20 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801029bb:	83 ec 04             	sub    $0x4,%esp
801029be:	68 00 10 00 00       	push   $0x1000
801029c3:	6a 01                	push   $0x1
801029c5:	53                   	push   %ebx
801029c6:	e8 85 33 00 00       	call   80105d50 <memset>

  if(kmem.use_lock)
801029cb:	8b 15 94 4c 11 80    	mov    0x80114c94,%edx
801029d1:	83 c4 10             	add    $0x10,%esp
801029d4:	85 d2                	test   %edx,%edx
801029d6:	75 20                	jne    801029f8 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801029d8:	a1 98 4c 11 80       	mov    0x80114c98,%eax
801029dd:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801029df:	a1 94 4c 11 80       	mov    0x80114c94,%eax
  kmem.freelist = r;
801029e4:	89 1d 98 4c 11 80    	mov    %ebx,0x80114c98
  if(kmem.use_lock)
801029ea:	85 c0                	test   %eax,%eax
801029ec:	75 22                	jne    80102a10 <kfree+0x80>
    release(&kmem.lock);
}
801029ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029f1:	c9                   	leave  
801029f2:	c3                   	ret    
801029f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801029f7:	90                   	nop
    acquire(&kmem.lock);
801029f8:	83 ec 0c             	sub    $0xc,%esp
801029fb:	68 60 4c 11 80       	push   $0x80114c60
80102a00:	e8 3b 32 00 00       	call   80105c40 <acquire>
80102a05:	83 c4 10             	add    $0x10,%esp
80102a08:	eb ce                	jmp    801029d8 <kfree+0x48>
80102a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102a10:	c7 45 08 60 4c 11 80 	movl   $0x80114c60,0x8(%ebp)
}
80102a17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a1a:	c9                   	leave  
    release(&kmem.lock);
80102a1b:	e9 e0 32 00 00       	jmp    80105d00 <release>
    panic("kfree");
80102a20:	83 ec 0c             	sub    $0xc,%esp
80102a23:	68 3e 8f 10 80       	push   $0x80108f3e
80102a28:	e8 63 d9 ff ff       	call   80100390 <panic>
80102a2d:	8d 76 00             	lea    0x0(%esi),%esi

80102a30 <freerange>:
{
80102a30:	f3 0f 1e fb          	endbr32 
80102a34:	55                   	push   %ebp
80102a35:	89 e5                	mov    %esp,%ebp
80102a37:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102a38:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102a3b:	8b 75 0c             	mov    0xc(%ebp),%esi
80102a3e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102a3f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102a45:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a4b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102a51:	39 de                	cmp    %ebx,%esi
80102a53:	72 1f                	jb     80102a74 <freerange+0x44>
80102a55:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102a58:	83 ec 0c             	sub    $0xc,%esp
80102a5b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a61:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102a67:	50                   	push   %eax
80102a68:	e8 23 ff ff ff       	call   80102990 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a6d:	83 c4 10             	add    $0x10,%esp
80102a70:	39 f3                	cmp    %esi,%ebx
80102a72:	76 e4                	jbe    80102a58 <freerange+0x28>
}
80102a74:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a77:	5b                   	pop    %ebx
80102a78:	5e                   	pop    %esi
80102a79:	5d                   	pop    %ebp
80102a7a:	c3                   	ret    
80102a7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a7f:	90                   	nop

80102a80 <kinit1>:
{
80102a80:	f3 0f 1e fb          	endbr32 
80102a84:	55                   	push   %ebp
80102a85:	89 e5                	mov    %esp,%ebp
80102a87:	56                   	push   %esi
80102a88:	53                   	push   %ebx
80102a89:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102a8c:	83 ec 08             	sub    $0x8,%esp
80102a8f:	68 44 8f 10 80       	push   $0x80108f44
80102a94:	68 60 4c 11 80       	push   $0x80114c60
80102a99:	e8 22 30 00 00       	call   80105ac0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102aa1:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102aa4:	c7 05 94 4c 11 80 00 	movl   $0x0,0x80114c94
80102aab:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102aae:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102ab4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102aba:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102ac0:	39 de                	cmp    %ebx,%esi
80102ac2:	72 20                	jb     80102ae4 <kinit1+0x64>
80102ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102ac8:	83 ec 0c             	sub    $0xc,%esp
80102acb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ad1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102ad7:	50                   	push   %eax
80102ad8:	e8 b3 fe ff ff       	call   80102990 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102add:	83 c4 10             	add    $0x10,%esp
80102ae0:	39 de                	cmp    %ebx,%esi
80102ae2:	73 e4                	jae    80102ac8 <kinit1+0x48>
}
80102ae4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ae7:	5b                   	pop    %ebx
80102ae8:	5e                   	pop    %esi
80102ae9:	5d                   	pop    %ebp
80102aea:	c3                   	ret    
80102aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102aef:	90                   	nop

80102af0 <kinit2>:
{
80102af0:	f3 0f 1e fb          	endbr32 
80102af4:	55                   	push   %ebp
80102af5:	89 e5                	mov    %esp,%ebp
80102af7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102af8:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102afb:	8b 75 0c             	mov    0xc(%ebp),%esi
80102afe:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102aff:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102b05:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b0b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102b11:	39 de                	cmp    %ebx,%esi
80102b13:	72 1f                	jb     80102b34 <kinit2+0x44>
80102b15:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102b18:	83 ec 0c             	sub    $0xc,%esp
80102b1b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b21:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102b27:	50                   	push   %eax
80102b28:	e8 63 fe ff ff       	call   80102990 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b2d:	83 c4 10             	add    $0x10,%esp
80102b30:	39 de                	cmp    %ebx,%esi
80102b32:	73 e4                	jae    80102b18 <kinit2+0x28>
  kmem.use_lock = 1;
80102b34:	c7 05 94 4c 11 80 01 	movl   $0x1,0x80114c94
80102b3b:	00 00 00 
}
80102b3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b41:	5b                   	pop    %ebx
80102b42:	5e                   	pop    %esi
80102b43:	5d                   	pop    %ebp
80102b44:	c3                   	ret    
80102b45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b50 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102b50:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102b54:	a1 94 4c 11 80       	mov    0x80114c94,%eax
80102b59:	85 c0                	test   %eax,%eax
80102b5b:	75 1b                	jne    80102b78 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102b5d:	a1 98 4c 11 80       	mov    0x80114c98,%eax
  if(r)
80102b62:	85 c0                	test   %eax,%eax
80102b64:	74 0a                	je     80102b70 <kalloc+0x20>
    kmem.freelist = r->next;
80102b66:	8b 10                	mov    (%eax),%edx
80102b68:	89 15 98 4c 11 80    	mov    %edx,0x80114c98
  if(kmem.use_lock)
80102b6e:	c3                   	ret    
80102b6f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102b70:	c3                   	ret    
80102b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102b78:	55                   	push   %ebp
80102b79:	89 e5                	mov    %esp,%ebp
80102b7b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
80102b7e:	68 60 4c 11 80       	push   $0x80114c60
80102b83:	e8 b8 30 00 00       	call   80105c40 <acquire>
  r = kmem.freelist;
80102b88:	a1 98 4c 11 80       	mov    0x80114c98,%eax
  if(r)
80102b8d:	8b 15 94 4c 11 80    	mov    0x80114c94,%edx
80102b93:	83 c4 10             	add    $0x10,%esp
80102b96:	85 c0                	test   %eax,%eax
80102b98:	74 08                	je     80102ba2 <kalloc+0x52>
    kmem.freelist = r->next;
80102b9a:	8b 08                	mov    (%eax),%ecx
80102b9c:	89 0d 98 4c 11 80    	mov    %ecx,0x80114c98
  if(kmem.use_lock)
80102ba2:	85 d2                	test   %edx,%edx
80102ba4:	74 16                	je     80102bbc <kalloc+0x6c>
    release(&kmem.lock);
80102ba6:	83 ec 0c             	sub    $0xc,%esp
80102ba9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102bac:	68 60 4c 11 80       	push   $0x80114c60
80102bb1:	e8 4a 31 00 00       	call   80105d00 <release>
  return (char*)r;
80102bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102bb9:	83 c4 10             	add    $0x10,%esp
}
80102bbc:	c9                   	leave  
80102bbd:	c3                   	ret    
80102bbe:	66 90                	xchg   %ax,%ax

80102bc0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102bc0:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bc4:	ba 64 00 00 00       	mov    $0x64,%edx
80102bc9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102bca:	a8 01                	test   $0x1,%al
80102bcc:	0f 84 be 00 00 00    	je     80102c90 <kbdgetc+0xd0>
{
80102bd2:	55                   	push   %ebp
80102bd3:	ba 60 00 00 00       	mov    $0x60,%edx
80102bd8:	89 e5                	mov    %esp,%ebp
80102bda:	53                   	push   %ebx
80102bdb:	ec                   	in     (%dx),%al
  return data;
80102bdc:	8b 1d b4 c5 10 80    	mov    0x8010c5b4,%ebx
    return -1;
  data = inb(KBDATAP);
80102be2:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102be5:	3c e0                	cmp    $0xe0,%al
80102be7:	74 57                	je     80102c40 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102be9:	89 d9                	mov    %ebx,%ecx
80102beb:	83 e1 40             	and    $0x40,%ecx
80102bee:	84 c0                	test   %al,%al
80102bf0:	78 5e                	js     80102c50 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102bf2:	85 c9                	test   %ecx,%ecx
80102bf4:	74 09                	je     80102bff <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102bf6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102bf9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102bfc:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102bff:	0f b6 8a 80 90 10 80 	movzbl -0x7fef6f80(%edx),%ecx
  shift ^= togglecode[data];
80102c06:	0f b6 82 80 8f 10 80 	movzbl -0x7fef7080(%edx),%eax
  shift |= shiftcode[data];
80102c0d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
80102c0f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102c11:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102c13:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102c19:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102c1c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102c1f:	8b 04 85 60 8f 10 80 	mov    -0x7fef70a0(,%eax,4),%eax
80102c26:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102c2a:	74 0b                	je     80102c37 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
80102c2c:	8d 50 9f             	lea    -0x61(%eax),%edx
80102c2f:	83 fa 19             	cmp    $0x19,%edx
80102c32:	77 44                	ja     80102c78 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102c34:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102c37:	5b                   	pop    %ebx
80102c38:	5d                   	pop    %ebp
80102c39:	c3                   	ret    
80102c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102c40:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102c43:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102c45:	89 1d b4 c5 10 80    	mov    %ebx,0x8010c5b4
}
80102c4b:	5b                   	pop    %ebx
80102c4c:	5d                   	pop    %ebp
80102c4d:	c3                   	ret    
80102c4e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102c50:	83 e0 7f             	and    $0x7f,%eax
80102c53:	85 c9                	test   %ecx,%ecx
80102c55:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102c58:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102c5a:	0f b6 8a 80 90 10 80 	movzbl -0x7fef6f80(%edx),%ecx
80102c61:	83 c9 40             	or     $0x40,%ecx
80102c64:	0f b6 c9             	movzbl %cl,%ecx
80102c67:	f7 d1                	not    %ecx
80102c69:	21 d9                	and    %ebx,%ecx
}
80102c6b:	5b                   	pop    %ebx
80102c6c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
80102c6d:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
}
80102c73:	c3                   	ret    
80102c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102c78:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102c7b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102c7e:	5b                   	pop    %ebx
80102c7f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102c80:	83 f9 1a             	cmp    $0x1a,%ecx
80102c83:	0f 42 c2             	cmovb  %edx,%eax
}
80102c86:	c3                   	ret    
80102c87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c8e:	66 90                	xchg   %ax,%ax
    return -1;
80102c90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102c95:	c3                   	ret    
80102c96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c9d:	8d 76 00             	lea    0x0(%esi),%esi

80102ca0 <kbdintr>:

void
kbdintr(void)
{
80102ca0:	f3 0f 1e fb          	endbr32 
80102ca4:	55                   	push   %ebp
80102ca5:	89 e5                	mov    %esp,%ebp
80102ca7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102caa:	68 c0 2b 10 80       	push   $0x80102bc0
80102caf:	e8 bc dd ff ff       	call   80100a70 <consoleintr>
}
80102cb4:	83 c4 10             	add    $0x10,%esp
80102cb7:	c9                   	leave  
80102cb8:	c3                   	ret    
80102cb9:	66 90                	xchg   %ax,%ax
80102cbb:	66 90                	xchg   %ax,%ax
80102cbd:	66 90                	xchg   %ax,%ax
80102cbf:	90                   	nop

80102cc0 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102cc0:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80102cc4:	a1 9c 4c 11 80       	mov    0x80114c9c,%eax
80102cc9:	85 c0                	test   %eax,%eax
80102ccb:	0f 84 c7 00 00 00    	je     80102d98 <lapicinit+0xd8>
  lapic[index] = value;
80102cd1:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102cd8:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cdb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cde:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102ce5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ce8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ceb:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102cf2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102cf5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cf8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102cff:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102d02:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d05:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102d0c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102d0f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d12:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102d19:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102d1c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102d1f:	8b 50 30             	mov    0x30(%eax),%edx
80102d22:	c1 ea 10             	shr    $0x10,%edx
80102d25:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102d2b:	75 73                	jne    80102da0 <lapicinit+0xe0>
  lapic[index] = value;
80102d2d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102d34:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d37:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d3a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102d41:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d44:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d47:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102d4e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d51:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d54:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102d5b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d5e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d61:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102d68:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d6b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d6e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102d75:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102d78:	8b 50 20             	mov    0x20(%eax),%edx
80102d7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d7f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102d80:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102d86:	80 e6 10             	and    $0x10,%dh
80102d89:	75 f5                	jne    80102d80 <lapicinit+0xc0>
  lapic[index] = value;
80102d8b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102d92:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d95:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102d98:	c3                   	ret    
80102d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102da0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102da7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102daa:	8b 50 20             	mov    0x20(%eax),%edx
}
80102dad:	e9 7b ff ff ff       	jmp    80102d2d <lapicinit+0x6d>
80102db2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102dc0 <lapicid>:

int
lapicid(void)
{
80102dc0:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80102dc4:	a1 9c 4c 11 80       	mov    0x80114c9c,%eax
80102dc9:	85 c0                	test   %eax,%eax
80102dcb:	74 0b                	je     80102dd8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
80102dcd:	8b 40 20             	mov    0x20(%eax),%eax
80102dd0:	c1 e8 18             	shr    $0x18,%eax
80102dd3:	c3                   	ret    
80102dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102dd8:	31 c0                	xor    %eax,%eax
}
80102dda:	c3                   	ret    
80102ddb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ddf:	90                   	nop

80102de0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102de0:	f3 0f 1e fb          	endbr32 
  if(lapic)
80102de4:	a1 9c 4c 11 80       	mov    0x80114c9c,%eax
80102de9:	85 c0                	test   %eax,%eax
80102deb:	74 0d                	je     80102dfa <lapiceoi+0x1a>
  lapic[index] = value;
80102ded:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102df4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102df7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102dfa:	c3                   	ret    
80102dfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102dff:	90                   	nop

80102e00 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102e00:	f3 0f 1e fb          	endbr32 
}
80102e04:	c3                   	ret    
80102e05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102e10 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102e10:	f3 0f 1e fb          	endbr32 
80102e14:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e15:	b8 0f 00 00 00       	mov    $0xf,%eax
80102e1a:	ba 70 00 00 00       	mov    $0x70,%edx
80102e1f:	89 e5                	mov    %esp,%ebp
80102e21:	53                   	push   %ebx
80102e22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102e25:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102e28:	ee                   	out    %al,(%dx)
80102e29:	b8 0a 00 00 00       	mov    $0xa,%eax
80102e2e:	ba 71 00 00 00       	mov    $0x71,%edx
80102e33:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102e34:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102e36:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102e39:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102e3f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102e41:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102e44:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102e46:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102e49:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102e4c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102e52:	a1 9c 4c 11 80       	mov    0x80114c9c,%eax
80102e57:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e5d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e60:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102e67:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e6a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e6d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102e74:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e77:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e7a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e80:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e83:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e89:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e8c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e92:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e95:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
80102e9b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
80102e9c:	8b 40 20             	mov    0x20(%eax),%eax
}
80102e9f:	5d                   	pop    %ebp
80102ea0:	c3                   	ret    
80102ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ea8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102eaf:	90                   	nop

80102eb0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102eb0:	f3 0f 1e fb          	endbr32 
80102eb4:	55                   	push   %ebp
80102eb5:	b8 0b 00 00 00       	mov    $0xb,%eax
80102eba:	ba 70 00 00 00       	mov    $0x70,%edx
80102ebf:	89 e5                	mov    %esp,%ebp
80102ec1:	57                   	push   %edi
80102ec2:	56                   	push   %esi
80102ec3:	53                   	push   %ebx
80102ec4:	83 ec 4c             	sub    $0x4c,%esp
80102ec7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ec8:	ba 71 00 00 00       	mov    $0x71,%edx
80102ecd:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102ece:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ed1:	bb 70 00 00 00       	mov    $0x70,%ebx
80102ed6:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ee0:	31 c0                	xor    %eax,%eax
80102ee2:	89 da                	mov    %ebx,%edx
80102ee4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ee5:	b9 71 00 00 00       	mov    $0x71,%ecx
80102eea:	89 ca                	mov    %ecx,%edx
80102eec:	ec                   	in     (%dx),%al
80102eed:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ef0:	89 da                	mov    %ebx,%edx
80102ef2:	b8 02 00 00 00       	mov    $0x2,%eax
80102ef7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ef8:	89 ca                	mov    %ecx,%edx
80102efa:	ec                   	in     (%dx),%al
80102efb:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102efe:	89 da                	mov    %ebx,%edx
80102f00:	b8 04 00 00 00       	mov    $0x4,%eax
80102f05:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f06:	89 ca                	mov    %ecx,%edx
80102f08:	ec                   	in     (%dx),%al
80102f09:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f0c:	89 da                	mov    %ebx,%edx
80102f0e:	b8 07 00 00 00       	mov    $0x7,%eax
80102f13:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f14:	89 ca                	mov    %ecx,%edx
80102f16:	ec                   	in     (%dx),%al
80102f17:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f1a:	89 da                	mov    %ebx,%edx
80102f1c:	b8 08 00 00 00       	mov    $0x8,%eax
80102f21:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f22:	89 ca                	mov    %ecx,%edx
80102f24:	ec                   	in     (%dx),%al
80102f25:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f27:	89 da                	mov    %ebx,%edx
80102f29:	b8 09 00 00 00       	mov    $0x9,%eax
80102f2e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f2f:	89 ca                	mov    %ecx,%edx
80102f31:	ec                   	in     (%dx),%al
80102f32:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f34:	89 da                	mov    %ebx,%edx
80102f36:	b8 0a 00 00 00       	mov    $0xa,%eax
80102f3b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f3c:	89 ca                	mov    %ecx,%edx
80102f3e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102f3f:	84 c0                	test   %al,%al
80102f41:	78 9d                	js     80102ee0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102f43:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102f47:	89 fa                	mov    %edi,%edx
80102f49:	0f b6 fa             	movzbl %dl,%edi
80102f4c:	89 f2                	mov    %esi,%edx
80102f4e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102f51:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102f55:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f58:	89 da                	mov    %ebx,%edx
80102f5a:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102f5d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102f60:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102f64:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102f67:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102f6a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102f6e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102f71:	31 c0                	xor    %eax,%eax
80102f73:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f74:	89 ca                	mov    %ecx,%edx
80102f76:	ec                   	in     (%dx),%al
80102f77:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f7a:	89 da                	mov    %ebx,%edx
80102f7c:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102f7f:	b8 02 00 00 00       	mov    $0x2,%eax
80102f84:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f85:	89 ca                	mov    %ecx,%edx
80102f87:	ec                   	in     (%dx),%al
80102f88:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f8b:	89 da                	mov    %ebx,%edx
80102f8d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102f90:	b8 04 00 00 00       	mov    $0x4,%eax
80102f95:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f96:	89 ca                	mov    %ecx,%edx
80102f98:	ec                   	in     (%dx),%al
80102f99:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f9c:	89 da                	mov    %ebx,%edx
80102f9e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102fa1:	b8 07 00 00 00       	mov    $0x7,%eax
80102fa6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fa7:	89 ca                	mov    %ecx,%edx
80102fa9:	ec                   	in     (%dx),%al
80102faa:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fad:	89 da                	mov    %ebx,%edx
80102faf:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102fb2:	b8 08 00 00 00       	mov    $0x8,%eax
80102fb7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fb8:	89 ca                	mov    %ecx,%edx
80102fba:	ec                   	in     (%dx),%al
80102fbb:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fbe:	89 da                	mov    %ebx,%edx
80102fc0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102fc3:	b8 09 00 00 00       	mov    $0x9,%eax
80102fc8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102fc9:	89 ca                	mov    %ecx,%edx
80102fcb:	ec                   	in     (%dx),%al
80102fcc:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102fcf:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102fd2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102fd5:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102fd8:	6a 18                	push   $0x18
80102fda:	50                   	push   %eax
80102fdb:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102fde:	50                   	push   %eax
80102fdf:	e8 bc 2d 00 00       	call   80105da0 <memcmp>
80102fe4:	83 c4 10             	add    $0x10,%esp
80102fe7:	85 c0                	test   %eax,%eax
80102fe9:	0f 85 f1 fe ff ff    	jne    80102ee0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102fef:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102ff3:	75 78                	jne    8010306d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102ff5:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ff8:	89 c2                	mov    %eax,%edx
80102ffa:	83 e0 0f             	and    $0xf,%eax
80102ffd:	c1 ea 04             	shr    $0x4,%edx
80103000:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103003:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103006:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103009:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010300c:	89 c2                	mov    %eax,%edx
8010300e:	83 e0 0f             	and    $0xf,%eax
80103011:	c1 ea 04             	shr    $0x4,%edx
80103014:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103017:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010301a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
8010301d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103020:	89 c2                	mov    %eax,%edx
80103022:	83 e0 0f             	and    $0xf,%eax
80103025:	c1 ea 04             	shr    $0x4,%edx
80103028:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010302b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010302e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103031:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103034:	89 c2                	mov    %eax,%edx
80103036:	83 e0 0f             	and    $0xf,%eax
80103039:	c1 ea 04             	shr    $0x4,%edx
8010303c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010303f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103042:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80103045:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103048:	89 c2                	mov    %eax,%edx
8010304a:	83 e0 0f             	and    $0xf,%eax
8010304d:	c1 ea 04             	shr    $0x4,%edx
80103050:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103053:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103056:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103059:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010305c:	89 c2                	mov    %eax,%edx
8010305e:	83 e0 0f             	and    $0xf,%eax
80103061:	c1 ea 04             	shr    $0x4,%edx
80103064:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103067:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010306a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
8010306d:	8b 75 08             	mov    0x8(%ebp),%esi
80103070:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103073:	89 06                	mov    %eax,(%esi)
80103075:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103078:	89 46 04             	mov    %eax,0x4(%esi)
8010307b:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010307e:	89 46 08             	mov    %eax,0x8(%esi)
80103081:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103084:	89 46 0c             	mov    %eax,0xc(%esi)
80103087:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010308a:	89 46 10             	mov    %eax,0x10(%esi)
8010308d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103090:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80103093:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010309a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010309d:	5b                   	pop    %ebx
8010309e:	5e                   	pop    %esi
8010309f:	5f                   	pop    %edi
801030a0:	5d                   	pop    %ebp
801030a1:	c3                   	ret    
801030a2:	66 90                	xchg   %ax,%ax
801030a4:	66 90                	xchg   %ax,%ax
801030a6:	66 90                	xchg   %ax,%ax
801030a8:	66 90                	xchg   %ax,%ax
801030aa:	66 90                	xchg   %ax,%ax
801030ac:	66 90                	xchg   %ax,%ax
801030ae:	66 90                	xchg   %ax,%ax

801030b0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801030b0:	8b 0d e8 4c 11 80    	mov    0x80114ce8,%ecx
801030b6:	85 c9                	test   %ecx,%ecx
801030b8:	0f 8e 8a 00 00 00    	jle    80103148 <install_trans+0x98>
{
801030be:	55                   	push   %ebp
801030bf:	89 e5                	mov    %esp,%ebp
801030c1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
801030c2:	31 ff                	xor    %edi,%edi
{
801030c4:	56                   	push   %esi
801030c5:	53                   	push   %ebx
801030c6:	83 ec 0c             	sub    $0xc,%esp
801030c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801030d0:	a1 d4 4c 11 80       	mov    0x80114cd4,%eax
801030d5:	83 ec 08             	sub    $0x8,%esp
801030d8:	01 f8                	add    %edi,%eax
801030da:	83 c0 01             	add    $0x1,%eax
801030dd:	50                   	push   %eax
801030de:	ff 35 e4 4c 11 80    	pushl  0x80114ce4
801030e4:	e8 e7 cf ff ff       	call   801000d0 <bread>
801030e9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801030eb:	58                   	pop    %eax
801030ec:	5a                   	pop    %edx
801030ed:	ff 34 bd ec 4c 11 80 	pushl  -0x7feeb314(,%edi,4)
801030f4:	ff 35 e4 4c 11 80    	pushl  0x80114ce4
  for (tail = 0; tail < log.lh.n; tail++) {
801030fa:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801030fd:	e8 ce cf ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103102:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103105:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103107:	8d 46 5c             	lea    0x5c(%esi),%eax
8010310a:	68 00 02 00 00       	push   $0x200
8010310f:	50                   	push   %eax
80103110:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103113:	50                   	push   %eax
80103114:	e8 d7 2c 00 00       	call   80105df0 <memmove>
    bwrite(dbuf);  // write dst to disk
80103119:	89 1c 24             	mov    %ebx,(%esp)
8010311c:	e8 8f d0 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80103121:	89 34 24             	mov    %esi,(%esp)
80103124:	e8 c7 d0 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80103129:	89 1c 24             	mov    %ebx,(%esp)
8010312c:	e8 bf d0 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103131:	83 c4 10             	add    $0x10,%esp
80103134:	39 3d e8 4c 11 80    	cmp    %edi,0x80114ce8
8010313a:	7f 94                	jg     801030d0 <install_trans+0x20>
  }
}
8010313c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010313f:	5b                   	pop    %ebx
80103140:	5e                   	pop    %esi
80103141:	5f                   	pop    %edi
80103142:	5d                   	pop    %ebp
80103143:	c3                   	ret    
80103144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103148:	c3                   	ret    
80103149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103150 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103150:	55                   	push   %ebp
80103151:	89 e5                	mov    %esp,%ebp
80103153:	53                   	push   %ebx
80103154:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80103157:	ff 35 d4 4c 11 80    	pushl  0x80114cd4
8010315d:	ff 35 e4 4c 11 80    	pushl  0x80114ce4
80103163:	e8 68 cf ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103168:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
8010316b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
8010316d:	a1 e8 4c 11 80       	mov    0x80114ce8,%eax
80103172:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80103175:	85 c0                	test   %eax,%eax
80103177:	7e 19                	jle    80103192 <write_head+0x42>
80103179:	31 d2                	xor    %edx,%edx
8010317b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010317f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80103180:	8b 0c 95 ec 4c 11 80 	mov    -0x7feeb314(,%edx,4),%ecx
80103187:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010318b:	83 c2 01             	add    $0x1,%edx
8010318e:	39 d0                	cmp    %edx,%eax
80103190:	75 ee                	jne    80103180 <write_head+0x30>
  }
  bwrite(buf);
80103192:	83 ec 0c             	sub    $0xc,%esp
80103195:	53                   	push   %ebx
80103196:	e8 15 d0 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010319b:	89 1c 24             	mov    %ebx,(%esp)
8010319e:	e8 4d d0 ff ff       	call   801001f0 <brelse>
}
801031a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801031a6:	83 c4 10             	add    $0x10,%esp
801031a9:	c9                   	leave  
801031aa:	c3                   	ret    
801031ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031af:	90                   	nop

801031b0 <initlog>:
{
801031b0:	f3 0f 1e fb          	endbr32 
801031b4:	55                   	push   %ebp
801031b5:	89 e5                	mov    %esp,%ebp
801031b7:	53                   	push   %ebx
801031b8:	83 ec 2c             	sub    $0x2c,%esp
801031bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801031be:	68 80 91 10 80       	push   $0x80109180
801031c3:	68 a0 4c 11 80       	push   $0x80114ca0
801031c8:	e8 f3 28 00 00       	call   80105ac0 <initlock>
  readsb(dev, &sb);
801031cd:	58                   	pop    %eax
801031ce:	8d 45 dc             	lea    -0x24(%ebp),%eax
801031d1:	5a                   	pop    %edx
801031d2:	50                   	push   %eax
801031d3:	53                   	push   %ebx
801031d4:	e8 47 e8 ff ff       	call   80101a20 <readsb>
  log.start = sb.logstart;
801031d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
801031dc:	59                   	pop    %ecx
  log.dev = dev;
801031dd:	89 1d e4 4c 11 80    	mov    %ebx,0x80114ce4
  log.size = sb.nlog;
801031e3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
801031e6:	a3 d4 4c 11 80       	mov    %eax,0x80114cd4
  log.size = sb.nlog;
801031eb:	89 15 d8 4c 11 80    	mov    %edx,0x80114cd8
  struct buf *buf = bread(log.dev, log.start);
801031f1:	5a                   	pop    %edx
801031f2:	50                   	push   %eax
801031f3:	53                   	push   %ebx
801031f4:	e8 d7 ce ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
801031f9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
801031fc:	8b 48 5c             	mov    0x5c(%eax),%ecx
801031ff:	89 0d e8 4c 11 80    	mov    %ecx,0x80114ce8
  for (i = 0; i < log.lh.n; i++) {
80103205:	85 c9                	test   %ecx,%ecx
80103207:	7e 19                	jle    80103222 <initlog+0x72>
80103209:	31 d2                	xor    %edx,%edx
8010320b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010320f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80103210:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80103214:	89 1c 95 ec 4c 11 80 	mov    %ebx,-0x7feeb314(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010321b:	83 c2 01             	add    $0x1,%edx
8010321e:	39 d1                	cmp    %edx,%ecx
80103220:	75 ee                	jne    80103210 <initlog+0x60>
  brelse(buf);
80103222:	83 ec 0c             	sub    $0xc,%esp
80103225:	50                   	push   %eax
80103226:	e8 c5 cf ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010322b:	e8 80 fe ff ff       	call   801030b0 <install_trans>
  log.lh.n = 0;
80103230:	c7 05 e8 4c 11 80 00 	movl   $0x0,0x80114ce8
80103237:	00 00 00 
  write_head(); // clear the log
8010323a:	e8 11 ff ff ff       	call   80103150 <write_head>
}
8010323f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103242:	83 c4 10             	add    $0x10,%esp
80103245:	c9                   	leave  
80103246:	c3                   	ret    
80103247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010324e:	66 90                	xchg   %ax,%ax

80103250 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103250:	f3 0f 1e fb          	endbr32 
80103254:	55                   	push   %ebp
80103255:	89 e5                	mov    %esp,%ebp
80103257:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
8010325a:	68 a0 4c 11 80       	push   $0x80114ca0
8010325f:	e8 dc 29 00 00       	call   80105c40 <acquire>
80103264:	83 c4 10             	add    $0x10,%esp
80103267:	eb 1c                	jmp    80103285 <begin_op+0x35>
80103269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103270:	83 ec 08             	sub    $0x8,%esp
80103273:	68 a0 4c 11 80       	push   $0x80114ca0
80103278:	68 a0 4c 11 80       	push   $0x80114ca0
8010327d:	e8 4e 12 00 00       	call   801044d0 <sleep>
80103282:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80103285:	a1 e0 4c 11 80       	mov    0x80114ce0,%eax
8010328a:	85 c0                	test   %eax,%eax
8010328c:	75 e2                	jne    80103270 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010328e:	a1 dc 4c 11 80       	mov    0x80114cdc,%eax
80103293:	8b 15 e8 4c 11 80    	mov    0x80114ce8,%edx
80103299:	83 c0 01             	add    $0x1,%eax
8010329c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
8010329f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801032a2:	83 fa 1e             	cmp    $0x1e,%edx
801032a5:	7f c9                	jg     80103270 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
801032a7:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801032aa:	a3 dc 4c 11 80       	mov    %eax,0x80114cdc
      release(&log.lock);
801032af:	68 a0 4c 11 80       	push   $0x80114ca0
801032b4:	e8 47 2a 00 00       	call   80105d00 <release>
      break;
    }
  }
}
801032b9:	83 c4 10             	add    $0x10,%esp
801032bc:	c9                   	leave  
801032bd:	c3                   	ret    
801032be:	66 90                	xchg   %ax,%ax

801032c0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801032c0:	f3 0f 1e fb          	endbr32 
801032c4:	55                   	push   %ebp
801032c5:	89 e5                	mov    %esp,%ebp
801032c7:	57                   	push   %edi
801032c8:	56                   	push   %esi
801032c9:	53                   	push   %ebx
801032ca:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
801032cd:	68 a0 4c 11 80       	push   $0x80114ca0
801032d2:	e8 69 29 00 00       	call   80105c40 <acquire>
  log.outstanding -= 1;
801032d7:	a1 dc 4c 11 80       	mov    0x80114cdc,%eax
  if(log.committing)
801032dc:	8b 35 e0 4c 11 80    	mov    0x80114ce0,%esi
801032e2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801032e5:	8d 58 ff             	lea    -0x1(%eax),%ebx
801032e8:	89 1d dc 4c 11 80    	mov    %ebx,0x80114cdc
  if(log.committing)
801032ee:	85 f6                	test   %esi,%esi
801032f0:	0f 85 1e 01 00 00    	jne    80103414 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
801032f6:	85 db                	test   %ebx,%ebx
801032f8:	0f 85 f2 00 00 00    	jne    801033f0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
801032fe:	c7 05 e0 4c 11 80 01 	movl   $0x1,0x80114ce0
80103305:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103308:	83 ec 0c             	sub    $0xc,%esp
8010330b:	68 a0 4c 11 80       	push   $0x80114ca0
80103310:	e8 eb 29 00 00       	call   80105d00 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103315:	8b 0d e8 4c 11 80    	mov    0x80114ce8,%ecx
8010331b:	83 c4 10             	add    $0x10,%esp
8010331e:	85 c9                	test   %ecx,%ecx
80103320:	7f 3e                	jg     80103360 <end_op+0xa0>
    acquire(&log.lock);
80103322:	83 ec 0c             	sub    $0xc,%esp
80103325:	68 a0 4c 11 80       	push   $0x80114ca0
8010332a:	e8 11 29 00 00       	call   80105c40 <acquire>
    wakeup(&log);
8010332f:	c7 04 24 a0 4c 11 80 	movl   $0x80114ca0,(%esp)
    log.committing = 0;
80103336:	c7 05 e0 4c 11 80 00 	movl   $0x0,0x80114ce0
8010333d:	00 00 00 
    wakeup(&log);
80103340:	e8 4b 13 00 00       	call   80104690 <wakeup>
    release(&log.lock);
80103345:	c7 04 24 a0 4c 11 80 	movl   $0x80114ca0,(%esp)
8010334c:	e8 af 29 00 00       	call   80105d00 <release>
80103351:	83 c4 10             	add    $0x10,%esp
}
80103354:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103357:	5b                   	pop    %ebx
80103358:	5e                   	pop    %esi
80103359:	5f                   	pop    %edi
8010335a:	5d                   	pop    %ebp
8010335b:	c3                   	ret    
8010335c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103360:	a1 d4 4c 11 80       	mov    0x80114cd4,%eax
80103365:	83 ec 08             	sub    $0x8,%esp
80103368:	01 d8                	add    %ebx,%eax
8010336a:	83 c0 01             	add    $0x1,%eax
8010336d:	50                   	push   %eax
8010336e:	ff 35 e4 4c 11 80    	pushl  0x80114ce4
80103374:	e8 57 cd ff ff       	call   801000d0 <bread>
80103379:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010337b:	58                   	pop    %eax
8010337c:	5a                   	pop    %edx
8010337d:	ff 34 9d ec 4c 11 80 	pushl  -0x7feeb314(,%ebx,4)
80103384:	ff 35 e4 4c 11 80    	pushl  0x80114ce4
  for (tail = 0; tail < log.lh.n; tail++) {
8010338a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010338d:	e8 3e cd ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103392:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103395:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103397:	8d 40 5c             	lea    0x5c(%eax),%eax
8010339a:	68 00 02 00 00       	push   $0x200
8010339f:	50                   	push   %eax
801033a0:	8d 46 5c             	lea    0x5c(%esi),%eax
801033a3:	50                   	push   %eax
801033a4:	e8 47 2a 00 00       	call   80105df0 <memmove>
    bwrite(to);  // write the log
801033a9:	89 34 24             	mov    %esi,(%esp)
801033ac:	e8 ff cd ff ff       	call   801001b0 <bwrite>
    brelse(from);
801033b1:	89 3c 24             	mov    %edi,(%esp)
801033b4:	e8 37 ce ff ff       	call   801001f0 <brelse>
    brelse(to);
801033b9:	89 34 24             	mov    %esi,(%esp)
801033bc:	e8 2f ce ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801033c1:	83 c4 10             	add    $0x10,%esp
801033c4:	3b 1d e8 4c 11 80    	cmp    0x80114ce8,%ebx
801033ca:	7c 94                	jl     80103360 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801033cc:	e8 7f fd ff ff       	call   80103150 <write_head>
    install_trans(); // Now install writes to home locations
801033d1:	e8 da fc ff ff       	call   801030b0 <install_trans>
    log.lh.n = 0;
801033d6:	c7 05 e8 4c 11 80 00 	movl   $0x0,0x80114ce8
801033dd:	00 00 00 
    write_head();    // Erase the transaction from the log
801033e0:	e8 6b fd ff ff       	call   80103150 <write_head>
801033e5:	e9 38 ff ff ff       	jmp    80103322 <end_op+0x62>
801033ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
801033f0:	83 ec 0c             	sub    $0xc,%esp
801033f3:	68 a0 4c 11 80       	push   $0x80114ca0
801033f8:	e8 93 12 00 00       	call   80104690 <wakeup>
  release(&log.lock);
801033fd:	c7 04 24 a0 4c 11 80 	movl   $0x80114ca0,(%esp)
80103404:	e8 f7 28 00 00       	call   80105d00 <release>
80103409:	83 c4 10             	add    $0x10,%esp
}
8010340c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010340f:	5b                   	pop    %ebx
80103410:	5e                   	pop    %esi
80103411:	5f                   	pop    %edi
80103412:	5d                   	pop    %ebp
80103413:	c3                   	ret    
    panic("log.committing");
80103414:	83 ec 0c             	sub    $0xc,%esp
80103417:	68 84 91 10 80       	push   $0x80109184
8010341c:	e8 6f cf ff ff       	call   80100390 <panic>
80103421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103428:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010342f:	90                   	nop

80103430 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103430:	f3 0f 1e fb          	endbr32 
80103434:	55                   	push   %ebp
80103435:	89 e5                	mov    %esp,%ebp
80103437:	53                   	push   %ebx
80103438:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010343b:	8b 15 e8 4c 11 80    	mov    0x80114ce8,%edx
{
80103441:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103444:	83 fa 1d             	cmp    $0x1d,%edx
80103447:	0f 8f 91 00 00 00    	jg     801034de <log_write+0xae>
8010344d:	a1 d8 4c 11 80       	mov    0x80114cd8,%eax
80103452:	83 e8 01             	sub    $0x1,%eax
80103455:	39 c2                	cmp    %eax,%edx
80103457:	0f 8d 81 00 00 00    	jge    801034de <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
8010345d:	a1 dc 4c 11 80       	mov    0x80114cdc,%eax
80103462:	85 c0                	test   %eax,%eax
80103464:	0f 8e 81 00 00 00    	jle    801034eb <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010346a:	83 ec 0c             	sub    $0xc,%esp
8010346d:	68 a0 4c 11 80       	push   $0x80114ca0
80103472:	e8 c9 27 00 00       	call   80105c40 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103477:	8b 15 e8 4c 11 80    	mov    0x80114ce8,%edx
8010347d:	83 c4 10             	add    $0x10,%esp
80103480:	85 d2                	test   %edx,%edx
80103482:	7e 4e                	jle    801034d2 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103484:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80103487:	31 c0                	xor    %eax,%eax
80103489:	eb 0c                	jmp    80103497 <log_write+0x67>
8010348b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010348f:	90                   	nop
80103490:	83 c0 01             	add    $0x1,%eax
80103493:	39 c2                	cmp    %eax,%edx
80103495:	74 29                	je     801034c0 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103497:	39 0c 85 ec 4c 11 80 	cmp    %ecx,-0x7feeb314(,%eax,4)
8010349e:	75 f0                	jne    80103490 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
801034a0:	89 0c 85 ec 4c 11 80 	mov    %ecx,-0x7feeb314(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801034a7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801034aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801034ad:	c7 45 08 a0 4c 11 80 	movl   $0x80114ca0,0x8(%ebp)
}
801034b4:	c9                   	leave  
  release(&log.lock);
801034b5:	e9 46 28 00 00       	jmp    80105d00 <release>
801034ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801034c0:	89 0c 95 ec 4c 11 80 	mov    %ecx,-0x7feeb314(,%edx,4)
    log.lh.n++;
801034c7:	83 c2 01             	add    $0x1,%edx
801034ca:	89 15 e8 4c 11 80    	mov    %edx,0x80114ce8
801034d0:	eb d5                	jmp    801034a7 <log_write+0x77>
  log.lh.block[i] = b->blockno;
801034d2:	8b 43 08             	mov    0x8(%ebx),%eax
801034d5:	a3 ec 4c 11 80       	mov    %eax,0x80114cec
  if (i == log.lh.n)
801034da:	75 cb                	jne    801034a7 <log_write+0x77>
801034dc:	eb e9                	jmp    801034c7 <log_write+0x97>
    panic("too big a transaction");
801034de:	83 ec 0c             	sub    $0xc,%esp
801034e1:	68 93 91 10 80       	push   $0x80109193
801034e6:	e8 a5 ce ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801034eb:	83 ec 0c             	sub    $0xc,%esp
801034ee:	68 a9 91 10 80       	push   $0x801091a9
801034f3:	e8 98 ce ff ff       	call   80100390 <panic>
801034f8:	66 90                	xchg   %ax,%ax
801034fa:	66 90                	xchg   %ax,%ax
801034fc:	66 90                	xchg   %ax,%ax
801034fe:	66 90                	xchg   %ax,%ax

80103500 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	53                   	push   %ebx
80103504:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103507:	e8 c4 09 00 00       	call   80103ed0 <cpuid>
8010350c:	89 c3                	mov    %eax,%ebx
8010350e:	e8 bd 09 00 00       	call   80103ed0 <cpuid>
80103513:	83 ec 04             	sub    $0x4,%esp
80103516:	53                   	push   %ebx
80103517:	50                   	push   %eax
80103518:	68 c4 91 10 80       	push   $0x801091c4
8010351d:	e8 9e d3 ff ff       	call   801008c0 <cprintf>
  idtinit();       // load idt register
80103522:	e8 79 3f 00 00       	call   801074a0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103527:	e8 34 09 00 00       	call   80103e60 <mycpu>
8010352c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010352e:	b8 01 00 00 00       	mov    $0x1,%eax
80103533:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010353a:	e8 91 0b 00 00       	call   801040d0 <scheduler>
8010353f:	90                   	nop

80103540 <mpenter>:
{
80103540:	f3 0f 1e fb          	endbr32 
80103544:	55                   	push   %ebp
80103545:	89 e5                	mov    %esp,%ebp
80103547:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010354a:	e8 31 50 00 00       	call   80108580 <switchkvm>
  seginit();
8010354f:	e8 9c 4f 00 00       	call   801084f0 <seginit>
  lapicinit();
80103554:	e8 67 f7 ff ff       	call   80102cc0 <lapicinit>
  mpmain();
80103559:	e8 a2 ff ff ff       	call   80103500 <mpmain>
8010355e:	66 90                	xchg   %ax,%ax

80103560 <main>:
{
80103560:	f3 0f 1e fb          	endbr32 
80103564:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103568:	83 e4 f0             	and    $0xfffffff0,%esp
8010356b:	ff 71 fc             	pushl  -0x4(%ecx)
8010356e:	55                   	push   %ebp
8010356f:	89 e5                	mov    %esp,%ebp
80103571:	53                   	push   %ebx
80103572:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103573:	83 ec 08             	sub    $0x8,%esp
80103576:	68 00 00 40 80       	push   $0x80400000
8010357b:	68 e8 86 11 80       	push   $0x801186e8
80103580:	e8 fb f4 ff ff       	call   80102a80 <kinit1>
  kvmalloc();      // kernel page table
80103585:	e8 d6 54 00 00       	call   80108a60 <kvmalloc>
  mpinit();        // detect other processors
8010358a:	e8 91 01 00 00       	call   80103720 <mpinit>
  lapicinit();     // interrupt controller
8010358f:	e8 2c f7 ff ff       	call   80102cc0 <lapicinit>
  seginit();       // segment descriptors
80103594:	e8 57 4f 00 00       	call   801084f0 <seginit>
  picinit();       // disable pic
80103599:	e8 62 03 00 00       	call   80103900 <picinit>
  ioapicinit();    // another interrupt controller
8010359e:	e8 fd f2 ff ff       	call   801028a0 <ioapicinit>
  consoleinit();   // console hardware
801035a3:	e8 78 d9 ff ff       	call   80100f20 <consoleinit>
  uartinit();      // serial port
801035a8:	e8 03 42 00 00       	call   801077b0 <uartinit>
  pinit();         // process table
801035ad:	e8 8e 08 00 00       	call   80103e40 <pinit>
  tvinit();        // trap vectors
801035b2:	e8 69 3e 00 00       	call   80107420 <tvinit>
  binit();         // buffer cache
801035b7:	e8 84 ca ff ff       	call   80100040 <binit>
  init_queue_test();
801035bc:	e8 7f 22 00 00       	call   80105840 <init_queue_test>
  fileinit();      // file table
801035c1:	e8 3a dd ff ff       	call   80101300 <fileinit>
  ideinit();       // disk 
801035c6:	e8 a5 f0 ff ff       	call   80102670 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801035cb:	83 c4 0c             	add    $0xc,%esp
801035ce:	68 8a 00 00 00       	push   $0x8a
801035d3:	68 8c c4 10 80       	push   $0x8010c48c
801035d8:	68 00 70 00 80       	push   $0x80007000
801035dd:	e8 0e 28 00 00       	call   80105df0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801035e2:	83 c4 10             	add    $0x10,%esp
801035e5:	69 05 40 53 11 80 b4 	imul   $0xb4,0x80115340,%eax
801035ec:	00 00 00 
801035ef:	05 a0 4d 11 80       	add    $0x80114da0,%eax
801035f4:	3d a0 4d 11 80       	cmp    $0x80114da0,%eax
801035f9:	76 7d                	jbe    80103678 <main+0x118>
801035fb:	bb a0 4d 11 80       	mov    $0x80114da0,%ebx
80103600:	eb 1f                	jmp    80103621 <main+0xc1>
80103602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103608:	69 05 40 53 11 80 b4 	imul   $0xb4,0x80115340,%eax
8010360f:	00 00 00 
80103612:	81 c3 b4 00 00 00    	add    $0xb4,%ebx
80103618:	05 a0 4d 11 80       	add    $0x80114da0,%eax
8010361d:	39 c3                	cmp    %eax,%ebx
8010361f:	73 57                	jae    80103678 <main+0x118>
    if(c == mycpu())  // We've started already.
80103621:	e8 3a 08 00 00       	call   80103e60 <mycpu>
80103626:	39 c3                	cmp    %eax,%ebx
80103628:	74 de                	je     80103608 <main+0xa8>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
8010362a:	e8 21 f5 ff ff       	call   80102b50 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
8010362f:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
80103632:	c7 05 f8 6f 00 80 40 	movl   $0x80103540,0x80006ff8
80103639:	35 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010363c:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
80103643:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103646:	05 00 10 00 00       	add    $0x1000,%eax
8010364b:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103650:	0f b6 03             	movzbl (%ebx),%eax
80103653:	68 00 70 00 00       	push   $0x7000
80103658:	50                   	push   %eax
80103659:	e8 b2 f7 ff ff       	call   80102e10 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
8010365e:	83 c4 10             	add    $0x10,%esp
80103661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103668:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
8010366e:	85 c0                	test   %eax,%eax
80103670:	74 f6                	je     80103668 <main+0x108>
80103672:	eb 94                	jmp    80103608 <main+0xa8>
80103674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103678:	83 ec 08             	sub    $0x8,%esp
8010367b:	68 00 00 00 8e       	push   $0x8e000000
80103680:	68 00 00 40 80       	push   $0x80400000
80103685:	e8 66 f4 ff ff       	call   80102af0 <kinit2>
  userinit();      // first user process
8010368a:	e8 f1 13 00 00       	call   80104a80 <userinit>
  mpmain();        // finish this processor's setup
8010368f:	e8 6c fe ff ff       	call   80103500 <mpmain>
80103694:	66 90                	xchg   %ax,%ax
80103696:	66 90                	xchg   %ax,%ax
80103698:	66 90                	xchg   %ax,%ax
8010369a:	66 90                	xchg   %ax,%ax
8010369c:	66 90                	xchg   %ax,%ax
8010369e:	66 90                	xchg   %ax,%ax

801036a0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801036a0:	55                   	push   %ebp
801036a1:	89 e5                	mov    %esp,%ebp
801036a3:	57                   	push   %edi
801036a4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801036a5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801036ab:	53                   	push   %ebx
  e = addr+len;
801036ac:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801036af:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801036b2:	39 de                	cmp    %ebx,%esi
801036b4:	72 10                	jb     801036c6 <mpsearch1+0x26>
801036b6:	eb 50                	jmp    80103708 <mpsearch1+0x68>
801036b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036bf:	90                   	nop
801036c0:	89 fe                	mov    %edi,%esi
801036c2:	39 fb                	cmp    %edi,%ebx
801036c4:	76 42                	jbe    80103708 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801036c6:	83 ec 04             	sub    $0x4,%esp
801036c9:	8d 7e 10             	lea    0x10(%esi),%edi
801036cc:	6a 04                	push   $0x4
801036ce:	68 d8 91 10 80       	push   $0x801091d8
801036d3:	56                   	push   %esi
801036d4:	e8 c7 26 00 00       	call   80105da0 <memcmp>
801036d9:	83 c4 10             	add    $0x10,%esp
801036dc:	85 c0                	test   %eax,%eax
801036de:	75 e0                	jne    801036c0 <mpsearch1+0x20>
801036e0:	89 f2                	mov    %esi,%edx
801036e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801036e8:	0f b6 0a             	movzbl (%edx),%ecx
801036eb:	83 c2 01             	add    $0x1,%edx
801036ee:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801036f0:	39 fa                	cmp    %edi,%edx
801036f2:	75 f4                	jne    801036e8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801036f4:	84 c0                	test   %al,%al
801036f6:	75 c8                	jne    801036c0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801036f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036fb:	89 f0                	mov    %esi,%eax
801036fd:	5b                   	pop    %ebx
801036fe:	5e                   	pop    %esi
801036ff:	5f                   	pop    %edi
80103700:	5d                   	pop    %ebp
80103701:	c3                   	ret    
80103702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103708:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010370b:	31 f6                	xor    %esi,%esi
}
8010370d:	5b                   	pop    %ebx
8010370e:	89 f0                	mov    %esi,%eax
80103710:	5e                   	pop    %esi
80103711:	5f                   	pop    %edi
80103712:	5d                   	pop    %ebp
80103713:	c3                   	ret    
80103714:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010371b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010371f:	90                   	nop

80103720 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103720:	f3 0f 1e fb          	endbr32 
80103724:	55                   	push   %ebp
80103725:	89 e5                	mov    %esp,%ebp
80103727:	57                   	push   %edi
80103728:	56                   	push   %esi
80103729:	53                   	push   %ebx
8010372a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010372d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103734:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010373b:	c1 e0 08             	shl    $0x8,%eax
8010373e:	09 d0                	or     %edx,%eax
80103740:	c1 e0 04             	shl    $0x4,%eax
80103743:	75 1b                	jne    80103760 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103745:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010374c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103753:	c1 e0 08             	shl    $0x8,%eax
80103756:	09 d0                	or     %edx,%eax
80103758:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010375b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103760:	ba 00 04 00 00       	mov    $0x400,%edx
80103765:	e8 36 ff ff ff       	call   801036a0 <mpsearch1>
8010376a:	89 c6                	mov    %eax,%esi
8010376c:	85 c0                	test   %eax,%eax
8010376e:	0f 84 4c 01 00 00    	je     801038c0 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103774:	8b 5e 04             	mov    0x4(%esi),%ebx
80103777:	85 db                	test   %ebx,%ebx
80103779:	0f 84 61 01 00 00    	je     801038e0 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010377f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103782:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103788:	6a 04                	push   $0x4
8010378a:	68 dd 91 10 80       	push   $0x801091dd
8010378f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103790:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103793:	e8 08 26 00 00       	call   80105da0 <memcmp>
80103798:	83 c4 10             	add    $0x10,%esp
8010379b:	85 c0                	test   %eax,%eax
8010379d:	0f 85 3d 01 00 00    	jne    801038e0 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
801037a3:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801037aa:	3c 01                	cmp    $0x1,%al
801037ac:	74 08                	je     801037b6 <mpinit+0x96>
801037ae:	3c 04                	cmp    $0x4,%al
801037b0:	0f 85 2a 01 00 00    	jne    801038e0 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
801037b6:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
801037bd:	66 85 d2             	test   %dx,%dx
801037c0:	74 26                	je     801037e8 <mpinit+0xc8>
801037c2:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
801037c5:	89 d8                	mov    %ebx,%eax
  sum = 0;
801037c7:	31 d2                	xor    %edx,%edx
801037c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801037d0:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801037d7:	83 c0 01             	add    $0x1,%eax
801037da:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801037dc:	39 f8                	cmp    %edi,%eax
801037de:	75 f0                	jne    801037d0 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
801037e0:	84 d2                	test   %dl,%dl
801037e2:	0f 85 f8 00 00 00    	jne    801038e0 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801037e8:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801037ee:	a3 9c 4c 11 80       	mov    %eax,0x80114c9c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801037f3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
801037f9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103800:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103805:	03 55 e4             	add    -0x1c(%ebp),%edx
80103808:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010380b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010380f:	90                   	nop
80103810:	39 c2                	cmp    %eax,%edx
80103812:	76 15                	jbe    80103829 <mpinit+0x109>
    switch(*p){
80103814:	0f b6 08             	movzbl (%eax),%ecx
80103817:	80 f9 02             	cmp    $0x2,%cl
8010381a:	74 5c                	je     80103878 <mpinit+0x158>
8010381c:	77 42                	ja     80103860 <mpinit+0x140>
8010381e:	84 c9                	test   %cl,%cl
80103820:	74 6e                	je     80103890 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103822:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103825:	39 c2                	cmp    %eax,%edx
80103827:	77 eb                	ja     80103814 <mpinit+0xf4>
80103829:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010382c:	85 db                	test   %ebx,%ebx
8010382e:	0f 84 b9 00 00 00    	je     801038ed <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103834:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103838:	74 15                	je     8010384f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010383a:	b8 70 00 00 00       	mov    $0x70,%eax
8010383f:	ba 22 00 00 00       	mov    $0x22,%edx
80103844:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103845:	ba 23 00 00 00       	mov    $0x23,%edx
8010384a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010384b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010384e:	ee                   	out    %al,(%dx)
  }
}
8010384f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103852:	5b                   	pop    %ebx
80103853:	5e                   	pop    %esi
80103854:	5f                   	pop    %edi
80103855:	5d                   	pop    %ebp
80103856:	c3                   	ret    
80103857:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010385e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103860:	83 e9 03             	sub    $0x3,%ecx
80103863:	80 f9 01             	cmp    $0x1,%cl
80103866:	76 ba                	jbe    80103822 <mpinit+0x102>
80103868:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010386f:	eb 9f                	jmp    80103810 <mpinit+0xf0>
80103871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103878:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010387c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010387f:	88 0d 80 4d 11 80    	mov    %cl,0x80114d80
      continue;
80103885:	eb 89                	jmp    80103810 <mpinit+0xf0>
80103887:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010388e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103890:	8b 0d 40 53 11 80    	mov    0x80115340,%ecx
80103896:	83 f9 07             	cmp    $0x7,%ecx
80103899:	7f 19                	jg     801038b4 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010389b:	69 f9 b4 00 00 00    	imul   $0xb4,%ecx,%edi
801038a1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801038a5:	83 c1 01             	add    $0x1,%ecx
801038a8:	89 0d 40 53 11 80    	mov    %ecx,0x80115340
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801038ae:	88 9f a0 4d 11 80    	mov    %bl,-0x7feeb260(%edi)
      p += sizeof(struct mpproc);
801038b4:	83 c0 14             	add    $0x14,%eax
      continue;
801038b7:	e9 54 ff ff ff       	jmp    80103810 <mpinit+0xf0>
801038bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
801038c0:	ba 00 00 01 00       	mov    $0x10000,%edx
801038c5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801038ca:	e8 d1 fd ff ff       	call   801036a0 <mpsearch1>
801038cf:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801038d1:	85 c0                	test   %eax,%eax
801038d3:	0f 85 9b fe ff ff    	jne    80103774 <mpinit+0x54>
801038d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801038e0:	83 ec 0c             	sub    $0xc,%esp
801038e3:	68 e2 91 10 80       	push   $0x801091e2
801038e8:	e8 a3 ca ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801038ed:	83 ec 0c             	sub    $0xc,%esp
801038f0:	68 fc 91 10 80       	push   $0x801091fc
801038f5:	e8 96 ca ff ff       	call   80100390 <panic>
801038fa:	66 90                	xchg   %ax,%ax
801038fc:	66 90                	xchg   %ax,%ax
801038fe:	66 90                	xchg   %ax,%ax

80103900 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103900:	f3 0f 1e fb          	endbr32 
80103904:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103909:	ba 21 00 00 00       	mov    $0x21,%edx
8010390e:	ee                   	out    %al,(%dx)
8010390f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103914:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103915:	c3                   	ret    
80103916:	66 90                	xchg   %ax,%ax
80103918:	66 90                	xchg   %ax,%ax
8010391a:	66 90                	xchg   %ax,%ax
8010391c:	66 90                	xchg   %ax,%ax
8010391e:	66 90                	xchg   %ax,%ax

80103920 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103920:	f3 0f 1e fb          	endbr32 
80103924:	55                   	push   %ebp
80103925:	89 e5                	mov    %esp,%ebp
80103927:	57                   	push   %edi
80103928:	56                   	push   %esi
80103929:	53                   	push   %ebx
8010392a:	83 ec 0c             	sub    $0xc,%esp
8010392d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103930:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103933:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103939:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010393f:	e8 dc d9 ff ff       	call   80101320 <filealloc>
80103944:	89 03                	mov    %eax,(%ebx)
80103946:	85 c0                	test   %eax,%eax
80103948:	0f 84 ac 00 00 00    	je     801039fa <pipealloc+0xda>
8010394e:	e8 cd d9 ff ff       	call   80101320 <filealloc>
80103953:	89 06                	mov    %eax,(%esi)
80103955:	85 c0                	test   %eax,%eax
80103957:	0f 84 8b 00 00 00    	je     801039e8 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010395d:	e8 ee f1 ff ff       	call   80102b50 <kalloc>
80103962:	89 c7                	mov    %eax,%edi
80103964:	85 c0                	test   %eax,%eax
80103966:	0f 84 b4 00 00 00    	je     80103a20 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010396c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103973:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103976:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103979:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103980:	00 00 00 
  p->nwrite = 0;
80103983:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010398a:	00 00 00 
  p->nread = 0;
8010398d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103994:	00 00 00 
  initlock(&p->lock, "pipe");
80103997:	68 1b 92 10 80       	push   $0x8010921b
8010399c:	50                   	push   %eax
8010399d:	e8 1e 21 00 00       	call   80105ac0 <initlock>
  (*f0)->type = FD_PIPE;
801039a2:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801039a4:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801039a7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801039ad:	8b 03                	mov    (%ebx),%eax
801039af:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801039b3:	8b 03                	mov    (%ebx),%eax
801039b5:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801039b9:	8b 03                	mov    (%ebx),%eax
801039bb:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801039be:	8b 06                	mov    (%esi),%eax
801039c0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801039c6:	8b 06                	mov    (%esi),%eax
801039c8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801039cc:	8b 06                	mov    (%esi),%eax
801039ce:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801039d2:	8b 06                	mov    (%esi),%eax
801039d4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801039d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801039da:	31 c0                	xor    %eax,%eax
}
801039dc:	5b                   	pop    %ebx
801039dd:	5e                   	pop    %esi
801039de:	5f                   	pop    %edi
801039df:	5d                   	pop    %ebp
801039e0:	c3                   	ret    
801039e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801039e8:	8b 03                	mov    (%ebx),%eax
801039ea:	85 c0                	test   %eax,%eax
801039ec:	74 1e                	je     80103a0c <pipealloc+0xec>
    fileclose(*f0);
801039ee:	83 ec 0c             	sub    $0xc,%esp
801039f1:	50                   	push   %eax
801039f2:	e8 e9 d9 ff ff       	call   801013e0 <fileclose>
801039f7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801039fa:	8b 06                	mov    (%esi),%eax
801039fc:	85 c0                	test   %eax,%eax
801039fe:	74 0c                	je     80103a0c <pipealloc+0xec>
    fileclose(*f1);
80103a00:	83 ec 0c             	sub    $0xc,%esp
80103a03:	50                   	push   %eax
80103a04:	e8 d7 d9 ff ff       	call   801013e0 <fileclose>
80103a09:	83 c4 10             	add    $0x10,%esp
}
80103a0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103a0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103a14:	5b                   	pop    %ebx
80103a15:	5e                   	pop    %esi
80103a16:	5f                   	pop    %edi
80103a17:	5d                   	pop    %ebp
80103a18:	c3                   	ret    
80103a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103a20:	8b 03                	mov    (%ebx),%eax
80103a22:	85 c0                	test   %eax,%eax
80103a24:	75 c8                	jne    801039ee <pipealloc+0xce>
80103a26:	eb d2                	jmp    801039fa <pipealloc+0xda>
80103a28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a2f:	90                   	nop

80103a30 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103a30:	f3 0f 1e fb          	endbr32 
80103a34:	55                   	push   %ebp
80103a35:	89 e5                	mov    %esp,%ebp
80103a37:	56                   	push   %esi
80103a38:	53                   	push   %ebx
80103a39:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103a3c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103a3f:	83 ec 0c             	sub    $0xc,%esp
80103a42:	53                   	push   %ebx
80103a43:	e8 f8 21 00 00       	call   80105c40 <acquire>
  if(writable){
80103a48:	83 c4 10             	add    $0x10,%esp
80103a4b:	85 f6                	test   %esi,%esi
80103a4d:	74 41                	je     80103a90 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103a4f:	83 ec 0c             	sub    $0xc,%esp
80103a52:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103a58:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103a5f:	00 00 00 
    wakeup(&p->nread);
80103a62:	50                   	push   %eax
80103a63:	e8 28 0c 00 00       	call   80104690 <wakeup>
80103a68:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103a6b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103a71:	85 d2                	test   %edx,%edx
80103a73:	75 0a                	jne    80103a7f <pipeclose+0x4f>
80103a75:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103a7b:	85 c0                	test   %eax,%eax
80103a7d:	74 31                	je     80103ab0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103a7f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103a82:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a85:	5b                   	pop    %ebx
80103a86:	5e                   	pop    %esi
80103a87:	5d                   	pop    %ebp
    release(&p->lock);
80103a88:	e9 73 22 00 00       	jmp    80105d00 <release>
80103a8d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103a90:	83 ec 0c             	sub    $0xc,%esp
80103a93:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103a99:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103aa0:	00 00 00 
    wakeup(&p->nwrite);
80103aa3:	50                   	push   %eax
80103aa4:	e8 e7 0b 00 00       	call   80104690 <wakeup>
80103aa9:	83 c4 10             	add    $0x10,%esp
80103aac:	eb bd                	jmp    80103a6b <pipeclose+0x3b>
80103aae:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103ab0:	83 ec 0c             	sub    $0xc,%esp
80103ab3:	53                   	push   %ebx
80103ab4:	e8 47 22 00 00       	call   80105d00 <release>
    kfree((char*)p);
80103ab9:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103abc:	83 c4 10             	add    $0x10,%esp
}
80103abf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ac2:	5b                   	pop    %ebx
80103ac3:	5e                   	pop    %esi
80103ac4:	5d                   	pop    %ebp
    kfree((char*)p);
80103ac5:	e9 c6 ee ff ff       	jmp    80102990 <kfree>
80103aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ad0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103ad0:	f3 0f 1e fb          	endbr32 
80103ad4:	55                   	push   %ebp
80103ad5:	89 e5                	mov    %esp,%ebp
80103ad7:	57                   	push   %edi
80103ad8:	56                   	push   %esi
80103ad9:	53                   	push   %ebx
80103ada:	83 ec 28             	sub    $0x28,%esp
80103add:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103ae0:	53                   	push   %ebx
80103ae1:	e8 5a 21 00 00       	call   80105c40 <acquire>
  for(i = 0; i < n; i++){
80103ae6:	8b 45 10             	mov    0x10(%ebp),%eax
80103ae9:	83 c4 10             	add    $0x10,%esp
80103aec:	85 c0                	test   %eax,%eax
80103aee:	0f 8e bc 00 00 00    	jle    80103bb0 <pipewrite+0xe0>
80103af4:	8b 45 0c             	mov    0xc(%ebp),%eax
80103af7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103afd:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103b03:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b06:	03 45 10             	add    0x10(%ebp),%eax
80103b09:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103b0c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103b12:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103b18:	89 ca                	mov    %ecx,%edx
80103b1a:	05 00 02 00 00       	add    $0x200,%eax
80103b1f:	39 c1                	cmp    %eax,%ecx
80103b21:	74 3b                	je     80103b5e <pipewrite+0x8e>
80103b23:	eb 63                	jmp    80103b88 <pipewrite+0xb8>
80103b25:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103b28:	e8 c3 03 00 00       	call   80103ef0 <myproc>
80103b2d:	8b 48 24             	mov    0x24(%eax),%ecx
80103b30:	85 c9                	test   %ecx,%ecx
80103b32:	75 34                	jne    80103b68 <pipewrite+0x98>
      wakeup(&p->nread);
80103b34:	83 ec 0c             	sub    $0xc,%esp
80103b37:	57                   	push   %edi
80103b38:	e8 53 0b 00 00       	call   80104690 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103b3d:	58                   	pop    %eax
80103b3e:	5a                   	pop    %edx
80103b3f:	53                   	push   %ebx
80103b40:	56                   	push   %esi
80103b41:	e8 8a 09 00 00       	call   801044d0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103b46:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103b4c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103b52:	83 c4 10             	add    $0x10,%esp
80103b55:	05 00 02 00 00       	add    $0x200,%eax
80103b5a:	39 c2                	cmp    %eax,%edx
80103b5c:	75 2a                	jne    80103b88 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
80103b5e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103b64:	85 c0                	test   %eax,%eax
80103b66:	75 c0                	jne    80103b28 <pipewrite+0x58>
        release(&p->lock);
80103b68:	83 ec 0c             	sub    $0xc,%esp
80103b6b:	53                   	push   %ebx
80103b6c:	e8 8f 21 00 00       	call   80105d00 <release>
        return -1;
80103b71:	83 c4 10             	add    $0x10,%esp
80103b74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103b79:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b7c:	5b                   	pop    %ebx
80103b7d:	5e                   	pop    %esi
80103b7e:	5f                   	pop    %edi
80103b7f:	5d                   	pop    %ebp
80103b80:	c3                   	ret    
80103b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103b88:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103b8b:	8d 4a 01             	lea    0x1(%edx),%ecx
80103b8e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103b94:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
80103b9a:	0f b6 06             	movzbl (%esi),%eax
80103b9d:	83 c6 01             	add    $0x1,%esi
80103ba0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103ba3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103ba7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103baa:	0f 85 5c ff ff ff    	jne    80103b0c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103bb0:	83 ec 0c             	sub    $0xc,%esp
80103bb3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103bb9:	50                   	push   %eax
80103bba:	e8 d1 0a 00 00       	call   80104690 <wakeup>
  release(&p->lock);
80103bbf:	89 1c 24             	mov    %ebx,(%esp)
80103bc2:	e8 39 21 00 00       	call   80105d00 <release>
  return n;
80103bc7:	8b 45 10             	mov    0x10(%ebp),%eax
80103bca:	83 c4 10             	add    $0x10,%esp
80103bcd:	eb aa                	jmp    80103b79 <pipewrite+0xa9>
80103bcf:	90                   	nop

80103bd0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103bd0:	f3 0f 1e fb          	endbr32 
80103bd4:	55                   	push   %ebp
80103bd5:	89 e5                	mov    %esp,%ebp
80103bd7:	57                   	push   %edi
80103bd8:	56                   	push   %esi
80103bd9:	53                   	push   %ebx
80103bda:	83 ec 18             	sub    $0x18,%esp
80103bdd:	8b 75 08             	mov    0x8(%ebp),%esi
80103be0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103be3:	56                   	push   %esi
80103be4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103bea:	e8 51 20 00 00       	call   80105c40 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103bef:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103bf5:	83 c4 10             	add    $0x10,%esp
80103bf8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
80103bfe:	74 33                	je     80103c33 <piperead+0x63>
80103c00:	eb 3b                	jmp    80103c3d <piperead+0x6d>
80103c02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103c08:	e8 e3 02 00 00       	call   80103ef0 <myproc>
80103c0d:	8b 48 24             	mov    0x24(%eax),%ecx
80103c10:	85 c9                	test   %ecx,%ecx
80103c12:	0f 85 88 00 00 00    	jne    80103ca0 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103c18:	83 ec 08             	sub    $0x8,%esp
80103c1b:	56                   	push   %esi
80103c1c:	53                   	push   %ebx
80103c1d:	e8 ae 08 00 00       	call   801044d0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103c22:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103c28:	83 c4 10             	add    $0x10,%esp
80103c2b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103c31:	75 0a                	jne    80103c3d <piperead+0x6d>
80103c33:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103c39:	85 c0                	test   %eax,%eax
80103c3b:	75 cb                	jne    80103c08 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103c3d:	8b 55 10             	mov    0x10(%ebp),%edx
80103c40:	31 db                	xor    %ebx,%ebx
80103c42:	85 d2                	test   %edx,%edx
80103c44:	7f 28                	jg     80103c6e <piperead+0x9e>
80103c46:	eb 34                	jmp    80103c7c <piperead+0xac>
80103c48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c4f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103c50:	8d 48 01             	lea    0x1(%eax),%ecx
80103c53:	25 ff 01 00 00       	and    $0x1ff,%eax
80103c58:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
80103c5e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103c63:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103c66:	83 c3 01             	add    $0x1,%ebx
80103c69:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103c6c:	74 0e                	je     80103c7c <piperead+0xac>
    if(p->nread == p->nwrite)
80103c6e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103c74:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103c7a:	75 d4                	jne    80103c50 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103c7c:	83 ec 0c             	sub    $0xc,%esp
80103c7f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103c85:	50                   	push   %eax
80103c86:	e8 05 0a 00 00       	call   80104690 <wakeup>
  release(&p->lock);
80103c8b:	89 34 24             	mov    %esi,(%esp)
80103c8e:	e8 6d 20 00 00       	call   80105d00 <release>
  return i;
80103c93:	83 c4 10             	add    $0x10,%esp
}
80103c96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c99:	89 d8                	mov    %ebx,%eax
80103c9b:	5b                   	pop    %ebx
80103c9c:	5e                   	pop    %esi
80103c9d:	5f                   	pop    %edi
80103c9e:	5d                   	pop    %ebp
80103c9f:	c3                   	ret    
      release(&p->lock);
80103ca0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103ca3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103ca8:	56                   	push   %esi
80103ca9:	e8 52 20 00 00       	call   80105d00 <release>
      return -1;
80103cae:	83 c4 10             	add    $0x10,%esp
}
80103cb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cb4:	89 d8                	mov    %ebx,%eax
80103cb6:	5b                   	pop    %ebx
80103cb7:	5e                   	pop    %esi
80103cb8:	5f                   	pop    %edi
80103cb9:	5d                   	pop    %ebp
80103cba:	c3                   	ret    
80103cbb:	66 90                	xchg   %ax,%ax
80103cbd:	66 90                	xchg   %ax,%ax
80103cbf:	90                   	nop

80103cc0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103cc0:	55                   	push   %ebp
80103cc1:	89 e5                	mov    %esp,%ebp
80103cc3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cc4:	bb 94 53 11 80       	mov    $0x80115394,%ebx
{
80103cc9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103ccc:	68 60 53 11 80       	push   $0x80115360
80103cd1:	e8 6a 1f 00 00       	call   80105c40 <acquire>
80103cd6:	83 c4 10             	add    $0x10,%esp
80103cd9:	eb 17                	jmp    80103cf2 <allocproc+0x32>
80103cdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cdf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ce0:	81 c3 ac 00 00 00    	add    $0xac,%ebx
80103ce6:	81 fb 94 7e 11 80    	cmp    $0x80117e94,%ebx
80103cec:	0f 84 ce 00 00 00    	je     80103dc0 <allocproc+0x100>
    if(p->state == UNUSED)
80103cf2:	8b 43 0c             	mov    0xc(%ebx),%eax
80103cf5:	85 c0                	test   %eax,%eax
80103cf7:	75 e7                	jne    80103ce0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103cf9:	a1 04 c0 10 80       	mov    0x8010c004,%eax

  release(&ptable.lock);
80103cfe:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103d01:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103d08:	89 43 10             	mov    %eax,0x10(%ebx)
80103d0b:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103d0e:	68 60 53 11 80       	push   $0x80115360
  p->pid = nextpid++;
80103d13:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  release(&ptable.lock);
80103d19:	e8 e2 1f 00 00       	call   80105d00 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103d1e:	e8 2d ee ff ff       	call   80102b50 <kalloc>
80103d23:	83 c4 10             	add    $0x10,%esp
80103d26:	89 43 08             	mov    %eax,0x8(%ebx)
80103d29:	85 c0                	test   %eax,%eax
80103d2b:	0f 84 a8 00 00 00    	je     80103dd9 <allocproc+0x119>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103d31:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103d37:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103d3a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103d3f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103d42:	c7 40 14 14 74 10 80 	movl   $0x80107414,0x14(%eax)
  p->context = (struct context*)sp;
80103d49:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103d4c:	6a 14                	push   $0x14
80103d4e:	6a 00                	push   $0x0
80103d50:	50                   	push   %eax
80103d51:	e8 fa 1f 00 00       	call   80105d50 <memset>
  p->context->eip = (uint)forkret;
80103d56:	8b 43 1c             	mov    0x1c(%ebx),%eax
  p->sched_info.bjf.executed_cycle = 0;
  p->sched_info.bjf.executed_cycle_ratio = 1;
  p->sched_info.bjf.process_size = p->sz;
  p->sched_info.bjf.process_size_ratio = 1;
  p->start_time = ticks;
  return p;
80103d59:	83 c4 10             	add    $0x10,%esp
  p->sched_info.bjf.priority_ratio = 1;
80103d5c:	d9 e8                	fld1   
  p->context->eip = (uint)forkret;
80103d5e:	c7 40 10 f0 3d 10 80 	movl   $0x80103df0,0x10(%eax)
  p->sched_info.bjf.arrival_time = ticks;
80103d65:	a1 e0 86 11 80       	mov    0x801186e0,%eax
  p->sched_info.bjf.priority_ratio = 1;
80103d6a:	d9 93 8c 00 00 00    	fsts   0x8c(%ebx)
  p->sched_info.bjf.process_size = p->sz;
80103d70:	8b 13                	mov    (%ebx),%edx
  p->sched_info.bjf.arrival_time_ratio = 1;
80103d72:	d9 93 94 00 00 00    	fsts   0x94(%ebx)
  p->sched_info.bjf.executed_cycle_ratio = 1;
80103d78:	d9 93 9c 00 00 00    	fsts   0x9c(%ebx)
  p->sched_info.bjf.arrival_time = ticks;
80103d7e:	89 83 90 00 00 00    	mov    %eax,0x90(%ebx)
  p->start_time = ticks;
80103d84:	89 43 7c             	mov    %eax,0x7c(%ebx)
}
80103d87:	89 d8                	mov    %ebx,%eax
  p->sched_info.queue = UNSET;
80103d89:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80103d90:	00 00 00 
  p->sched_info.bjf.priority = 3;
80103d93:	c7 83 88 00 00 00 03 	movl   $0x3,0x88(%ebx)
80103d9a:	00 00 00 
  p->sched_info.bjf.executed_cycle = 0;
80103d9d:	c7 83 98 00 00 00 00 	movl   $0x0,0x98(%ebx)
80103da4:	00 00 00 
  p->sched_info.bjf.process_size = p->sz;
80103da7:	89 93 a0 00 00 00    	mov    %edx,0xa0(%ebx)
  p->sched_info.bjf.process_size_ratio = 1;
80103dad:	d9 9b a4 00 00 00    	fstps  0xa4(%ebx)
}
80103db3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103db6:	c9                   	leave  
80103db7:	c3                   	ret    
80103db8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dbf:	90                   	nop
  release(&ptable.lock);
80103dc0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103dc3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103dc5:	68 60 53 11 80       	push   $0x80115360
80103dca:	e8 31 1f 00 00       	call   80105d00 <release>
}
80103dcf:	89 d8                	mov    %ebx,%eax
  return 0;
80103dd1:	83 c4 10             	add    $0x10,%esp
}
80103dd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103dd7:	c9                   	leave  
80103dd8:	c3                   	ret    
    p->state = UNUSED;
80103dd9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103de0:	31 db                	xor    %ebx,%ebx
}
80103de2:	89 d8                	mov    %ebx,%eax
80103de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103de7:	c9                   	leave  
80103de8:	c3                   	ret    
80103de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103df0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103df0:	f3 0f 1e fb          	endbr32 
80103df4:	55                   	push   %ebp
80103df5:	89 e5                	mov    %esp,%ebp
80103df7:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103dfa:	68 60 53 11 80       	push   $0x80115360
80103dff:	e8 fc 1e 00 00       	call   80105d00 <release>

  if (first) {
80103e04:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80103e09:	83 c4 10             	add    $0x10,%esp
80103e0c:	85 c0                	test   %eax,%eax
80103e0e:	75 08                	jne    80103e18 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103e10:	c9                   	leave  
80103e11:	c3                   	ret    
80103e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103e18:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
80103e1f:	00 00 00 
    iinit(ROOTDEV);
80103e22:	83 ec 0c             	sub    $0xc,%esp
80103e25:	6a 01                	push   $0x1
80103e27:	e8 34 dc ff ff       	call   80101a60 <iinit>
    initlog(ROOTDEV);
80103e2c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103e33:	e8 78 f3 ff ff       	call   801031b0 <initlog>
}
80103e38:	83 c4 10             	add    $0x10,%esp
80103e3b:	c9                   	leave  
80103e3c:	c3                   	ret    
80103e3d:	8d 76 00             	lea    0x0(%esi),%esi

80103e40 <pinit>:
{
80103e40:	f3 0f 1e fb          	endbr32 
80103e44:	55                   	push   %ebp
80103e45:	89 e5                	mov    %esp,%ebp
80103e47:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103e4a:	68 20 92 10 80       	push   $0x80109220
80103e4f:	68 60 53 11 80       	push   $0x80115360
80103e54:	e8 67 1c 00 00       	call   80105ac0 <initlock>
}
80103e59:	83 c4 10             	add    $0x10,%esp
80103e5c:	c9                   	leave  
80103e5d:	c3                   	ret    
80103e5e:	66 90                	xchg   %ax,%ax

80103e60 <mycpu>:
{
80103e60:	f3 0f 1e fb          	endbr32 
80103e64:	55                   	push   %ebp
80103e65:	89 e5                	mov    %esp,%ebp
80103e67:	56                   	push   %esi
80103e68:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e69:	9c                   	pushf  
80103e6a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103e6b:	f6 c4 02             	test   $0x2,%ah
80103e6e:	75 4a                	jne    80103eba <mycpu+0x5a>
  apicid = lapicid();
80103e70:	e8 4b ef ff ff       	call   80102dc0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103e75:	8b 35 40 53 11 80    	mov    0x80115340,%esi
  apicid = lapicid();
80103e7b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
80103e7d:	85 f6                	test   %esi,%esi
80103e7f:	7e 2c                	jle    80103ead <mycpu+0x4d>
80103e81:	31 d2                	xor    %edx,%edx
80103e83:	eb 0a                	jmp    80103e8f <mycpu+0x2f>
80103e85:	8d 76 00             	lea    0x0(%esi),%esi
80103e88:	83 c2 01             	add    $0x1,%edx
80103e8b:	39 f2                	cmp    %esi,%edx
80103e8d:	74 1e                	je     80103ead <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
80103e8f:	69 ca b4 00 00 00    	imul   $0xb4,%edx,%ecx
80103e95:	0f b6 81 a0 4d 11 80 	movzbl -0x7feeb260(%ecx),%eax
80103e9c:	39 d8                	cmp    %ebx,%eax
80103e9e:	75 e8                	jne    80103e88 <mycpu+0x28>
}
80103ea0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103ea3:	8d 81 a0 4d 11 80    	lea    -0x7feeb260(%ecx),%eax
}
80103ea9:	5b                   	pop    %ebx
80103eaa:	5e                   	pop    %esi
80103eab:	5d                   	pop    %ebp
80103eac:	c3                   	ret    
  panic("unknown apicid\n");
80103ead:	83 ec 0c             	sub    $0xc,%esp
80103eb0:	68 27 92 10 80       	push   $0x80109227
80103eb5:	e8 d6 c4 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103eba:	83 ec 0c             	sub    $0xc,%esp
80103ebd:	68 80 93 10 80       	push   $0x80109380
80103ec2:	e8 c9 c4 ff ff       	call   80100390 <panic>
80103ec7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ece:	66 90                	xchg   %ax,%ax

80103ed0 <cpuid>:
cpuid() {
80103ed0:	f3 0f 1e fb          	endbr32 
80103ed4:	55                   	push   %ebp
80103ed5:	89 e5                	mov    %esp,%ebp
80103ed7:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103eda:	e8 81 ff ff ff       	call   80103e60 <mycpu>
}
80103edf:	c9                   	leave  
  return mycpu()-cpus;
80103ee0:	2d a0 4d 11 80       	sub    $0x80114da0,%eax
80103ee5:	c1 f8 02             	sar    $0x2,%eax
80103ee8:	69 c0 a5 4f fa a4    	imul   $0xa4fa4fa5,%eax,%eax
}
80103eee:	c3                   	ret    
80103eef:	90                   	nop

80103ef0 <myproc>:
myproc(void) {
80103ef0:	f3 0f 1e fb          	endbr32 
80103ef4:	55                   	push   %ebp
80103ef5:	89 e5                	mov    %esp,%ebp
80103ef7:	53                   	push   %ebx
80103ef8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103efb:	e8 40 1c 00 00       	call   80105b40 <pushcli>
  c = mycpu();
80103f00:	e8 5b ff ff ff       	call   80103e60 <mycpu>
  p = c->proc;
80103f05:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f0b:	e8 80 1c 00 00       	call   80105b90 <popcli>
}
80103f10:	83 c4 04             	add    $0x4,%esp
80103f13:	89 d8                	mov    %ebx,%eax
80103f15:	5b                   	pop    %ebx
80103f16:	5d                   	pop    %ebp
80103f17:	c3                   	ret    
80103f18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f1f:	90                   	nop

80103f20 <growproc>:
{
80103f20:	f3 0f 1e fb          	endbr32 
80103f24:	55                   	push   %ebp
80103f25:	89 e5                	mov    %esp,%ebp
80103f27:	56                   	push   %esi
80103f28:	53                   	push   %ebx
80103f29:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103f2c:	e8 0f 1c 00 00       	call   80105b40 <pushcli>
  c = mycpu();
80103f31:	e8 2a ff ff ff       	call   80103e60 <mycpu>
  p = c->proc;
80103f36:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f3c:	e8 4f 1c 00 00       	call   80105b90 <popcli>
  sz = curproc->sz;
80103f41:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103f43:	85 f6                	test   %esi,%esi
80103f45:	7f 19                	jg     80103f60 <growproc+0x40>
  } else if(n < 0){
80103f47:	75 37                	jne    80103f80 <growproc+0x60>
  switchuvm(curproc);
80103f49:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103f4c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103f4e:	53                   	push   %ebx
80103f4f:	e8 4c 46 00 00       	call   801085a0 <switchuvm>
  return 0;
80103f54:	83 c4 10             	add    $0x10,%esp
80103f57:	31 c0                	xor    %eax,%eax
}
80103f59:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f5c:	5b                   	pop    %ebx
80103f5d:	5e                   	pop    %esi
80103f5e:	5d                   	pop    %ebp
80103f5f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103f60:	83 ec 04             	sub    $0x4,%esp
80103f63:	01 c6                	add    %eax,%esi
80103f65:	56                   	push   %esi
80103f66:	50                   	push   %eax
80103f67:	ff 73 04             	pushl  0x4(%ebx)
80103f6a:	e8 91 48 00 00       	call   80108800 <allocuvm>
80103f6f:	83 c4 10             	add    $0x10,%esp
80103f72:	85 c0                	test   %eax,%eax
80103f74:	75 d3                	jne    80103f49 <growproc+0x29>
      return -1;
80103f76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f7b:	eb dc                	jmp    80103f59 <growproc+0x39>
80103f7d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103f80:	83 ec 04             	sub    $0x4,%esp
80103f83:	01 c6                	add    %eax,%esi
80103f85:	56                   	push   %esi
80103f86:	50                   	push   %eax
80103f87:	ff 73 04             	pushl  0x4(%ebx)
80103f8a:	e8 a1 49 00 00       	call   80108930 <deallocuvm>
80103f8f:	83 c4 10             	add    $0x10,%esp
80103f92:	85 c0                	test   %eax,%eax
80103f94:	75 b3                	jne    80103f49 <growproc+0x29>
80103f96:	eb de                	jmp    80103f76 <growproc+0x56>
80103f98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f9f:	90                   	nop

80103fa0 <bjfrank>:
{
80103fa0:	f3 0f 1e fb          	endbr32 
80103fa4:	55                   	push   %ebp
80103fa5:	89 e5                	mov    %esp,%ebp
80103fa7:	8b 45 08             	mov    0x8(%ebp),%eax
}
80103faa:	5d                   	pop    %ebp
  return p->sched_info.bjf.priority * p->sched_info.bjf.priority_ratio +
80103fab:	db 80 88 00 00 00    	fildl  0x88(%eax)
80103fb1:	d8 88 8c 00 00 00    	fmuls  0x8c(%eax)
         p->sched_info.bjf.arrival_time * p->sched_info.bjf.arrival_time_ratio +
80103fb7:	db 80 90 00 00 00    	fildl  0x90(%eax)
80103fbd:	d8 88 94 00 00 00    	fmuls  0x94(%eax)
  return p->sched_info.bjf.priority * p->sched_info.bjf.priority_ratio +
80103fc3:	de c1                	faddp  %st,%st(1)
         p->sched_info.bjf.executed_cycle * p->sched_info.bjf.executed_cycle_ratio +
80103fc5:	d9 80 98 00 00 00    	flds   0x98(%eax)
80103fcb:	d8 88 9c 00 00 00    	fmuls  0x9c(%eax)
         p->sched_info.bjf.arrival_time * p->sched_info.bjf.arrival_time_ratio +
80103fd1:	de c1                	faddp  %st,%st(1)
         p->sched_info.bjf.process_size * p->sched_info.bjf.process_size_ratio;
80103fd3:	db 80 a0 00 00 00    	fildl  0xa0(%eax)
80103fd9:	d8 88 a4 00 00 00    	fmuls  0xa4(%eax)
         p->sched_info.bjf.executed_cycle * p->sched_info.bjf.executed_cycle_ratio +
80103fdf:	de c1                	faddp  %st,%st(1)
}
80103fe1:	c3                   	ret    
80103fe2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ff0 <lcfs>:
{
80103ff0:	f3 0f 1e fb          	endbr32 
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ff4:	b8 94 53 11 80       	mov    $0x80115394,%eax
  struct proc *result = 0;
80103ff9:	31 d2                	xor    %edx,%edx
80103ffb:	eb 1f                	jmp    8010401c <lcfs+0x2c>
80103ffd:	8d 76 00             	lea    0x0(%esi),%esi
      if (result->sched_info.arrival_queue_time < p->sched_info.arrival_queue_time)
80104000:	8b 88 a8 00 00 00    	mov    0xa8(%eax),%ecx
80104006:	39 8a a8 00 00 00    	cmp    %ecx,0xa8(%edx)
8010400c:	0f 4c d0             	cmovl  %eax,%edx
8010400f:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104010:	05 ac 00 00 00       	add    $0xac,%eax
80104015:	3d 94 7e 11 80       	cmp    $0x80117e94,%eax
8010401a:	74 21                	je     8010403d <lcfs+0x4d>
    if (p->state != RUNNABLE || p->sched_info.queue != LCFS)
8010401c:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80104020:	75 ee                	jne    80104010 <lcfs+0x20>
80104022:	83 b8 80 00 00 00 02 	cmpl   $0x2,0x80(%eax)
80104029:	75 e5                	jne    80104010 <lcfs+0x20>
    if (result != 0)
8010402b:	85 d2                	test   %edx,%edx
8010402d:	75 d1                	jne    80104000 <lcfs+0x10>
8010402f:	89 c2                	mov    %eax,%edx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104031:	05 ac 00 00 00       	add    $0xac,%eax
80104036:	3d 94 7e 11 80       	cmp    $0x80117e94,%eax
8010403b:	75 df                	jne    8010401c <lcfs+0x2c>
}
8010403d:	89 d0                	mov    %edx,%eax
8010403f:	c3                   	ret    

80104040 <bestjobfirst>:
{
80104040:	f3 0f 1e fb          	endbr32 
  float min_rank = 2e6;
80104044:	d9 05 3c 95 10 80    	flds   0x8010953c
  struct proc *min_p = 0;
8010404a:	31 d2                	xor    %edx,%edx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010404c:	b8 94 53 11 80       	mov    $0x80115394,%eax
80104051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (p->state != RUNNABLE || p->sched_info.queue != BJF)
80104058:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
8010405c:	75 5a                	jne    801040b8 <bestjobfirst+0x78>
8010405e:	83 b8 80 00 00 00 03 	cmpl   $0x3,0x80(%eax)
80104065:	75 51                	jne    801040b8 <bestjobfirst+0x78>
  return p->sched_info.bjf.priority * p->sched_info.bjf.priority_ratio +
80104067:	db 80 88 00 00 00    	fildl  0x88(%eax)
8010406d:	d8 88 8c 00 00 00    	fmuls  0x8c(%eax)
         p->sched_info.bjf.arrival_time * p->sched_info.bjf.arrival_time_ratio +
80104073:	db 80 90 00 00 00    	fildl  0x90(%eax)
80104079:	d8 88 94 00 00 00    	fmuls  0x94(%eax)
  return p->sched_info.bjf.priority * p->sched_info.bjf.priority_ratio +
8010407f:	de c1                	faddp  %st,%st(1)
         p->sched_info.bjf.executed_cycle * p->sched_info.bjf.executed_cycle_ratio +
80104081:	d9 80 98 00 00 00    	flds   0x98(%eax)
80104087:	d8 88 9c 00 00 00    	fmuls  0x9c(%eax)
         p->sched_info.bjf.arrival_time * p->sched_info.bjf.arrival_time_ratio +
8010408d:	de c1                	faddp  %st,%st(1)
         p->sched_info.bjf.process_size * p->sched_info.bjf.process_size_ratio;
8010408f:	db 80 a0 00 00 00    	fildl  0xa0(%eax)
80104095:	d8 88 a4 00 00 00    	fmuls  0xa4(%eax)
         p->sched_info.bjf.executed_cycle * p->sched_info.bjf.executed_cycle_ratio +
8010409b:	de c1                	faddp  %st,%st(1)
8010409d:	d9 c9                	fxch   %st(1)
    if (p_rank < min_rank)
8010409f:	db f1                	fcomi  %st(1),%st
801040a1:	76 0d                	jbe    801040b0 <bestjobfirst+0x70>
801040a3:	dd d8                	fstp   %st(0)
801040a5:	89 c2                	mov    %eax,%edx
801040a7:	eb 0f                	jmp    801040b8 <bestjobfirst+0x78>
801040a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040b0:	dd d9                	fstp   %st(1)
801040b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040b8:	05 ac 00 00 00       	add    $0xac,%eax
801040bd:	3d 94 7e 11 80       	cmp    $0x80117e94,%eax
801040c2:	75 94                	jne    80104058 <bestjobfirst+0x18>
801040c4:	dd d8                	fstp   %st(0)
}
801040c6:	89 d0                	mov    %edx,%eax
801040c8:	c3                   	ret    
801040c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040d0 <scheduler>:
{
801040d0:	f3 0f 1e fb          	endbr32 
801040d4:	55                   	push   %ebp
801040d5:	89 e5                	mov    %esp,%ebp
801040d7:	57                   	push   %edi
      p = ptable.proc;
801040d8:	bf 94 53 11 80       	mov    $0x80115394,%edi
{
801040dd:	56                   	push   %esi
  struct proc *last_scheduled_RR = &ptable.proc[NPROC - 1];
801040de:	be e8 7d 11 80       	mov    $0x80117de8,%esi
{
801040e3:	53                   	push   %ebx
801040e4:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
801040e7:	e8 74 fd ff ff       	call   80103e60 <mycpu>
  c->proc = 0;
801040ec:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801040f3:	00 00 00 
  struct cpu *c = mycpu();
801040f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  c->proc = 0;
801040f9:	83 c0 04             	add    $0x4,%eax
801040fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
801040ff:	90                   	nop
  asm volatile("sti");
80104100:	fb                   	sti    
    acquire(&ptable.lock);
80104101:	83 ec 0c             	sub    $0xc,%esp
80104104:	89 f3                	mov    %esi,%ebx
80104106:	68 60 53 11 80       	push   $0x80115360
8010410b:	e8 30 1b 00 00       	call   80105c40 <acquire>
80104110:	83 c4 10             	add    $0x10,%esp
80104113:	eb 0b                	jmp    80104120 <scheduler+0x50>
80104115:	8d 76 00             	lea    0x0(%esi),%esi
    if (p == last_scheduled)
80104118:	39 de                	cmp    %ebx,%esi
8010411a:	0f 84 90 00 00 00    	je     801041b0 <scheduler+0xe0>
    p++;
80104120:	81 c3 ac 00 00 00    	add    $0xac,%ebx
      p = ptable.proc;
80104126:	81 fb 94 7e 11 80    	cmp    $0x80117e94,%ebx
8010412c:	0f 43 df             	cmovae %edi,%ebx
    if (p->state == RUNNABLE && p->sched_info.queue == ROUND_ROBIN)
8010412f:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104133:	75 e3                	jne    80104118 <scheduler+0x48>
80104135:	83 bb 80 00 00 00 01 	cmpl   $0x1,0x80(%ebx)
8010413c:	75 da                	jne    80104118 <scheduler+0x48>
8010413e:	89 de                	mov    %ebx,%esi
    c->proc = p;
80104140:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    switchuvm(p);
80104143:	83 ec 0c             	sub    $0xc,%esp
    c->proc = p;
80104146:	89 98 ac 00 00 00    	mov    %ebx,0xac(%eax)
    switchuvm(p);
8010414c:	53                   	push   %ebx
8010414d:	e8 4e 44 00 00       	call   801085a0 <switchuvm>
    p->sched_info.bjf.executed_cycle += 0.1f;
80104152:	d9 05 40 95 10 80    	flds   0x80109540
80104158:	d8 83 98 00 00 00    	fadds  0x98(%ebx)
    p->state = RUNNING;
8010415e:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
    p->sched_info.last_run = ticks;
80104165:	a1 e0 86 11 80       	mov    0x801186e0,%eax
8010416a:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
    p->sched_info.bjf.executed_cycle += 0.1f;
80104170:	d9 9b 98 00 00 00    	fstps  0x98(%ebx)
    swtch(&(c->scheduler), p->context);
80104176:	58                   	pop    %eax
80104177:	5a                   	pop    %edx
80104178:	ff 73 1c             	pushl  0x1c(%ebx)
8010417b:	ff 75 e0             	pushl  -0x20(%ebp)
8010417e:	e8 f0 1d 00 00       	call   80105f73 <swtch>
    switchkvm();
80104183:	e8 f8 43 00 00       	call   80108580 <switchkvm>
    c->proc = 0;
80104188:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010418b:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104192:	00 00 00 
  release(&ptable.lock);
80104195:	c7 04 24 60 53 11 80 	movl   $0x80115360,(%esp)
8010419c:	e8 5f 1b 00 00       	call   80105d00 <release>
801041a1:	83 c4 10             	add    $0x10,%esp
801041a4:	e9 57 ff ff ff       	jmp    80104100 <scheduler+0x30>
801041a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *result = 0;
801041b0:	31 db                	xor    %ebx,%ebx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041b2:	b8 94 53 11 80       	mov    $0x80115394,%eax
801041b7:	eb 23                	jmp    801041dc <scheduler+0x10c>
801041b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if (result->sched_info.arrival_queue_time < p->sched_info.arrival_queue_time)
801041c0:	8b 90 a8 00 00 00    	mov    0xa8(%eax),%edx
801041c6:	39 93 a8 00 00 00    	cmp    %edx,0xa8(%ebx)
801041cc:	0f 4c d8             	cmovl  %eax,%ebx
801041cf:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041d0:	05 ac 00 00 00       	add    $0xac,%eax
801041d5:	3d 94 7e 11 80       	cmp    $0x80117e94,%eax
801041da:	74 24                	je     80104200 <scheduler+0x130>
    if (p->state != RUNNABLE || p->sched_info.queue != LCFS)
801041dc:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801041e0:	75 ee                	jne    801041d0 <scheduler+0x100>
801041e2:	83 b8 80 00 00 00 02 	cmpl   $0x2,0x80(%eax)
801041e9:	75 e5                	jne    801041d0 <scheduler+0x100>
    if (result != 0)
801041eb:	85 db                	test   %ebx,%ebx
801041ed:	75 d1                	jne    801041c0 <scheduler+0xf0>
801041ef:	89 c3                	mov    %eax,%ebx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041f1:	05 ac 00 00 00       	add    $0xac,%eax
801041f6:	3d 94 7e 11 80       	cmp    $0x80117e94,%eax
801041fb:	75 df                	jne    801041dc <scheduler+0x10c>
801041fd:	8d 76 00             	lea    0x0(%esi),%esi
      if (!p)
80104200:	85 db                	test   %ebx,%ebx
80104202:	0f 85 38 ff ff ff    	jne    80104140 <scheduler+0x70>
        p = bestjobfirst();
80104208:	e8 33 fe ff ff       	call   80104040 <bestjobfirst>
8010420d:	89 c3                	mov    %eax,%ebx
        if (!p)
8010420f:	85 c0                	test   %eax,%eax
80104211:	0f 85 29 ff ff ff    	jne    80104140 <scheduler+0x70>
          release(&ptable.lock);
80104217:	83 ec 0c             	sub    $0xc,%esp
8010421a:	68 60 53 11 80       	push   $0x80115360
8010421f:	e8 dc 1a 00 00       	call   80105d00 <release>
          continue;
80104224:	83 c4 10             	add    $0x10,%esp
80104227:	e9 d4 fe ff ff       	jmp    80104100 <scheduler+0x30>
8010422c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104230 <roundrobin>:
{
80104230:	f3 0f 1e fb          	endbr32 
80104234:	55                   	push   %ebp
      p = ptable.proc;
80104235:	b9 94 53 11 80       	mov    $0x80115394,%ecx
{
8010423a:	89 e5                	mov    %esp,%ebp
8010423c:	8b 55 08             	mov    0x8(%ebp),%edx
  struct proc *p = last_scheduled;
8010423f:	89 d0                	mov    %edx,%eax
80104241:	eb 09                	jmp    8010424c <roundrobin+0x1c>
80104243:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104247:	90                   	nop
    if (p == last_scheduled)
80104248:	39 d0                	cmp    %edx,%eax
8010424a:	74 24                	je     80104270 <roundrobin+0x40>
    p++;
8010424c:	05 ac 00 00 00       	add    $0xac,%eax
      p = ptable.proc;
80104251:	3d 94 7e 11 80       	cmp    $0x80117e94,%eax
80104256:	0f 43 c1             	cmovae %ecx,%eax
    if (p->state == RUNNABLE && p->sched_info.queue == ROUND_ROBIN)
80104259:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
8010425d:	75 e9                	jne    80104248 <roundrobin+0x18>
8010425f:	83 b8 80 00 00 00 01 	cmpl   $0x1,0x80(%eax)
80104266:	75 e0                	jne    80104248 <roundrobin+0x18>
}
80104268:	5d                   	pop    %ebp
80104269:	c3                   	ret    
8010426a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return 0;
80104270:	31 c0                	xor    %eax,%eax
}
80104272:	5d                   	pop    %ebp
80104273:	c3                   	ret    
80104274:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010427b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010427f:	90                   	nop

80104280 <sched>:
{
80104280:	f3 0f 1e fb          	endbr32 
80104284:	55                   	push   %ebp
80104285:	89 e5                	mov    %esp,%ebp
80104287:	56                   	push   %esi
80104288:	53                   	push   %ebx
  pushcli();
80104289:	e8 b2 18 00 00       	call   80105b40 <pushcli>
  c = mycpu();
8010428e:	e8 cd fb ff ff       	call   80103e60 <mycpu>
  p = c->proc;
80104293:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104299:	e8 f2 18 00 00       	call   80105b90 <popcli>
  if(!holding(&ptable.lock))
8010429e:	83 ec 0c             	sub    $0xc,%esp
801042a1:	68 60 53 11 80       	push   $0x80115360
801042a6:	e8 45 19 00 00       	call   80105bf0 <holding>
801042ab:	83 c4 10             	add    $0x10,%esp
801042ae:	85 c0                	test   %eax,%eax
801042b0:	74 4f                	je     80104301 <sched+0x81>
  if(mycpu()->ncli != 1)
801042b2:	e8 a9 fb ff ff       	call   80103e60 <mycpu>
801042b7:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801042be:	75 68                	jne    80104328 <sched+0xa8>
  if(p->state == RUNNING)
801042c0:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801042c4:	74 55                	je     8010431b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801042c6:	9c                   	pushf  
801042c7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801042c8:	f6 c4 02             	test   $0x2,%ah
801042cb:	75 41                	jne    8010430e <sched+0x8e>
  intena = mycpu()->intena;
801042cd:	e8 8e fb ff ff       	call   80103e60 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801042d2:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801042d5:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801042db:	e8 80 fb ff ff       	call   80103e60 <mycpu>
801042e0:	83 ec 08             	sub    $0x8,%esp
801042e3:	ff 70 04             	pushl  0x4(%eax)
801042e6:	53                   	push   %ebx
801042e7:	e8 87 1c 00 00       	call   80105f73 <swtch>
  mycpu()->intena = intena;
801042ec:	e8 6f fb ff ff       	call   80103e60 <mycpu>
}
801042f1:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801042f4:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801042fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042fd:	5b                   	pop    %ebx
801042fe:	5e                   	pop    %esi
801042ff:	5d                   	pop    %ebp
80104300:	c3                   	ret    
    panic("sched ptable.lock");
80104301:	83 ec 0c             	sub    $0xc,%esp
80104304:	68 37 92 10 80       	push   $0x80109237
80104309:	e8 82 c0 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010430e:	83 ec 0c             	sub    $0xc,%esp
80104311:	68 63 92 10 80       	push   $0x80109263
80104316:	e8 75 c0 ff ff       	call   80100390 <panic>
    panic("sched running");
8010431b:	83 ec 0c             	sub    $0xc,%esp
8010431e:	68 55 92 10 80       	push   $0x80109255
80104323:	e8 68 c0 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104328:	83 ec 0c             	sub    $0xc,%esp
8010432b:	68 49 92 10 80       	push   $0x80109249
80104330:	e8 5b c0 ff ff       	call   80100390 <panic>
80104335:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010433c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104340 <exit>:
{
80104340:	f3 0f 1e fb          	endbr32 
80104344:	55                   	push   %ebp
80104345:	89 e5                	mov    %esp,%ebp
80104347:	57                   	push   %edi
80104348:	56                   	push   %esi
80104349:	53                   	push   %ebx
8010434a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010434d:	e8 ee 17 00 00       	call   80105b40 <pushcli>
  c = mycpu();
80104352:	e8 09 fb ff ff       	call   80103e60 <mycpu>
  p = c->proc;
80104357:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010435d:	e8 2e 18 00 00       	call   80105b90 <popcli>
  if(curproc == initproc)
80104362:	8d 5e 28             	lea    0x28(%esi),%ebx
80104365:	8d 7e 68             	lea    0x68(%esi),%edi
80104368:	39 35 1c c6 10 80    	cmp    %esi,0x8010c61c
8010436e:	0f 84 fd 00 00 00    	je     80104471 <exit+0x131>
80104374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80104378:	8b 03                	mov    (%ebx),%eax
8010437a:	85 c0                	test   %eax,%eax
8010437c:	74 12                	je     80104390 <exit+0x50>
      fileclose(curproc->ofile[fd]);
8010437e:	83 ec 0c             	sub    $0xc,%esp
80104381:	50                   	push   %eax
80104382:	e8 59 d0 ff ff       	call   801013e0 <fileclose>
      curproc->ofile[fd] = 0;
80104387:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010438d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104390:	83 c3 04             	add    $0x4,%ebx
80104393:	39 df                	cmp    %ebx,%edi
80104395:	75 e1                	jne    80104378 <exit+0x38>
  begin_op();
80104397:	e8 b4 ee ff ff       	call   80103250 <begin_op>
  iput(curproc->cwd);
8010439c:	83 ec 0c             	sub    $0xc,%esp
8010439f:	ff 76 68             	pushl  0x68(%esi)
801043a2:	e8 09 da ff ff       	call   80101db0 <iput>
  end_op();
801043a7:	e8 14 ef ff ff       	call   801032c0 <end_op>
  curproc->cwd = 0;
801043ac:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
801043b3:	c7 04 24 60 53 11 80 	movl   $0x80115360,(%esp)
801043ba:	e8 81 18 00 00       	call   80105c40 <acquire>
  wakeup1(curproc->parent);
801043bf:	8b 56 14             	mov    0x14(%esi),%edx
801043c2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043c5:	b8 94 53 11 80       	mov    $0x80115394,%eax
801043ca:	eb 10                	jmp    801043dc <exit+0x9c>
801043cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043d0:	05 ac 00 00 00       	add    $0xac,%eax
801043d5:	3d 94 7e 11 80       	cmp    $0x80117e94,%eax
801043da:	74 1e                	je     801043fa <exit+0xba>
    if(p->state == SLEEPING && p->chan == chan)
801043dc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801043e0:	75 ee                	jne    801043d0 <exit+0x90>
801043e2:	3b 50 20             	cmp    0x20(%eax),%edx
801043e5:	75 e9                	jne    801043d0 <exit+0x90>
      p->state = RUNNABLE;
801043e7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043ee:	05 ac 00 00 00       	add    $0xac,%eax
801043f3:	3d 94 7e 11 80       	cmp    $0x80117e94,%eax
801043f8:	75 e2                	jne    801043dc <exit+0x9c>
      p->parent = initproc;
801043fa:	8b 0d 1c c6 10 80    	mov    0x8010c61c,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104400:	ba 94 53 11 80       	mov    $0x80115394,%edx
80104405:	eb 17                	jmp    8010441e <exit+0xde>
80104407:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010440e:	66 90                	xchg   %ax,%ax
80104410:	81 c2 ac 00 00 00    	add    $0xac,%edx
80104416:	81 fa 94 7e 11 80    	cmp    $0x80117e94,%edx
8010441c:	74 3a                	je     80104458 <exit+0x118>
    if(p->parent == curproc){
8010441e:	39 72 14             	cmp    %esi,0x14(%edx)
80104421:	75 ed                	jne    80104410 <exit+0xd0>
      if(p->state == ZOMBIE)
80104423:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104427:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010442a:	75 e4                	jne    80104410 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010442c:	b8 94 53 11 80       	mov    $0x80115394,%eax
80104431:	eb 11                	jmp    80104444 <exit+0x104>
80104433:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104437:	90                   	nop
80104438:	05 ac 00 00 00       	add    $0xac,%eax
8010443d:	3d 94 7e 11 80       	cmp    $0x80117e94,%eax
80104442:	74 cc                	je     80104410 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80104444:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104448:	75 ee                	jne    80104438 <exit+0xf8>
8010444a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010444d:	75 e9                	jne    80104438 <exit+0xf8>
      p->state = RUNNABLE;
8010444f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104456:	eb e0                	jmp    80104438 <exit+0xf8>
  curproc->state = ZOMBIE;
80104458:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010445f:	e8 1c fe ff ff       	call   80104280 <sched>
  panic("zombie exit");
80104464:	83 ec 0c             	sub    $0xc,%esp
80104467:	68 84 92 10 80       	push   $0x80109284
8010446c:	e8 1f bf ff ff       	call   80100390 <panic>
    panic("init exiting");
80104471:	83 ec 0c             	sub    $0xc,%esp
80104474:	68 77 92 10 80       	push   $0x80109277
80104479:	e8 12 bf ff ff       	call   80100390 <panic>
8010447e:	66 90                	xchg   %ax,%ax

80104480 <yield>:
{
80104480:	f3 0f 1e fb          	endbr32 
80104484:	55                   	push   %ebp
80104485:	89 e5                	mov    %esp,%ebp
80104487:	53                   	push   %ebx
80104488:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010448b:	68 60 53 11 80       	push   $0x80115360
80104490:	e8 ab 17 00 00       	call   80105c40 <acquire>
  pushcli();
80104495:	e8 a6 16 00 00       	call   80105b40 <pushcli>
  c = mycpu();
8010449a:	e8 c1 f9 ff ff       	call   80103e60 <mycpu>
  p = c->proc;
8010449f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044a5:	e8 e6 16 00 00       	call   80105b90 <popcli>
  myproc()->state = RUNNABLE;
801044aa:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801044b1:	e8 ca fd ff ff       	call   80104280 <sched>
  release(&ptable.lock);
801044b6:	c7 04 24 60 53 11 80 	movl   $0x80115360,(%esp)
801044bd:	e8 3e 18 00 00       	call   80105d00 <release>
}
801044c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044c5:	83 c4 10             	add    $0x10,%esp
801044c8:	c9                   	leave  
801044c9:	c3                   	ret    
801044ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044d0 <sleep>:
{
801044d0:	f3 0f 1e fb          	endbr32 
801044d4:	55                   	push   %ebp
801044d5:	89 e5                	mov    %esp,%ebp
801044d7:	57                   	push   %edi
801044d8:	56                   	push   %esi
801044d9:	53                   	push   %ebx
801044da:	83 ec 0c             	sub    $0xc,%esp
801044dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801044e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801044e3:	e8 58 16 00 00       	call   80105b40 <pushcli>
  c = mycpu();
801044e8:	e8 73 f9 ff ff       	call   80103e60 <mycpu>
  p = c->proc;
801044ed:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044f3:	e8 98 16 00 00       	call   80105b90 <popcli>
  if(p == 0)
801044f8:	85 db                	test   %ebx,%ebx
801044fa:	0f 84 83 00 00 00    	je     80104583 <sleep+0xb3>
  if(lk == 0)
80104500:	85 f6                	test   %esi,%esi
80104502:	74 72                	je     80104576 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104504:	81 fe 60 53 11 80    	cmp    $0x80115360,%esi
8010450a:	74 4c                	je     80104558 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010450c:	83 ec 0c             	sub    $0xc,%esp
8010450f:	68 60 53 11 80       	push   $0x80115360
80104514:	e8 27 17 00 00       	call   80105c40 <acquire>
    release(lk);
80104519:	89 34 24             	mov    %esi,(%esp)
8010451c:	e8 df 17 00 00       	call   80105d00 <release>
  p->chan = chan;
80104521:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104524:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010452b:	e8 50 fd ff ff       	call   80104280 <sched>
  p->chan = 0;
80104530:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104537:	c7 04 24 60 53 11 80 	movl   $0x80115360,(%esp)
8010453e:	e8 bd 17 00 00       	call   80105d00 <release>
    acquire(lk);
80104543:	89 75 08             	mov    %esi,0x8(%ebp)
80104546:	83 c4 10             	add    $0x10,%esp
}
80104549:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010454c:	5b                   	pop    %ebx
8010454d:	5e                   	pop    %esi
8010454e:	5f                   	pop    %edi
8010454f:	5d                   	pop    %ebp
    acquire(lk);
80104550:	e9 eb 16 00 00       	jmp    80105c40 <acquire>
80104555:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104558:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010455b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104562:	e8 19 fd ff ff       	call   80104280 <sched>
  p->chan = 0;
80104567:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010456e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104571:	5b                   	pop    %ebx
80104572:	5e                   	pop    %esi
80104573:	5f                   	pop    %edi
80104574:	5d                   	pop    %ebp
80104575:	c3                   	ret    
    panic("sleep without lk");
80104576:	83 ec 0c             	sub    $0xc,%esp
80104579:	68 96 92 10 80       	push   $0x80109296
8010457e:	e8 0d be ff ff       	call   80100390 <panic>
    panic("sleep");
80104583:	83 ec 0c             	sub    $0xc,%esp
80104586:	68 90 92 10 80       	push   $0x80109290
8010458b:	e8 00 be ff ff       	call   80100390 <panic>

80104590 <wait>:
{
80104590:	f3 0f 1e fb          	endbr32 
80104594:	55                   	push   %ebp
80104595:	89 e5                	mov    %esp,%ebp
80104597:	56                   	push   %esi
80104598:	53                   	push   %ebx
  pushcli();
80104599:	e8 a2 15 00 00       	call   80105b40 <pushcli>
  c = mycpu();
8010459e:	e8 bd f8 ff ff       	call   80103e60 <mycpu>
  p = c->proc;
801045a3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801045a9:	e8 e2 15 00 00       	call   80105b90 <popcli>
  acquire(&ptable.lock);
801045ae:	83 ec 0c             	sub    $0xc,%esp
801045b1:	68 60 53 11 80       	push   $0x80115360
801045b6:	e8 85 16 00 00       	call   80105c40 <acquire>
801045bb:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801045be:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045c0:	bb 94 53 11 80       	mov    $0x80115394,%ebx
801045c5:	eb 17                	jmp    801045de <wait+0x4e>
801045c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045ce:	66 90                	xchg   %ax,%ax
801045d0:	81 c3 ac 00 00 00    	add    $0xac,%ebx
801045d6:	81 fb 94 7e 11 80    	cmp    $0x80117e94,%ebx
801045dc:	74 1e                	je     801045fc <wait+0x6c>
      if(p->parent != curproc)
801045de:	39 73 14             	cmp    %esi,0x14(%ebx)
801045e1:	75 ed                	jne    801045d0 <wait+0x40>
      if(p->state == ZOMBIE){
801045e3:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801045e7:	74 37                	je     80104620 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045e9:	81 c3 ac 00 00 00    	add    $0xac,%ebx
      havekids = 1;
801045ef:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045f4:	81 fb 94 7e 11 80    	cmp    $0x80117e94,%ebx
801045fa:	75 e2                	jne    801045de <wait+0x4e>
    if(!havekids || curproc->killed){
801045fc:	85 c0                	test   %eax,%eax
801045fe:	74 76                	je     80104676 <wait+0xe6>
80104600:	8b 46 24             	mov    0x24(%esi),%eax
80104603:	85 c0                	test   %eax,%eax
80104605:	75 6f                	jne    80104676 <wait+0xe6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104607:	83 ec 08             	sub    $0x8,%esp
8010460a:	68 60 53 11 80       	push   $0x80115360
8010460f:	56                   	push   %esi
80104610:	e8 bb fe ff ff       	call   801044d0 <sleep>
    havekids = 0;
80104615:	83 c4 10             	add    $0x10,%esp
80104618:	eb a4                	jmp    801045be <wait+0x2e>
8010461a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104620:	83 ec 0c             	sub    $0xc,%esp
80104623:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104626:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104629:	e8 62 e3 ff ff       	call   80102990 <kfree>
        freevm(p->pgdir);
8010462e:	5a                   	pop    %edx
8010462f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104632:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104639:	e8 22 43 00 00       	call   80108960 <freevm>
        release(&ptable.lock);
8010463e:	c7 04 24 60 53 11 80 	movl   $0x80115360,(%esp)
        p->pid = 0;
80104645:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010464c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104653:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104657:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010465e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104665:	e8 96 16 00 00       	call   80105d00 <release>
        return pid;
8010466a:	83 c4 10             	add    $0x10,%esp
}
8010466d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104670:	89 f0                	mov    %esi,%eax
80104672:	5b                   	pop    %ebx
80104673:	5e                   	pop    %esi
80104674:	5d                   	pop    %ebp
80104675:	c3                   	ret    
      release(&ptable.lock);
80104676:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104679:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010467e:	68 60 53 11 80       	push   $0x80115360
80104683:	e8 78 16 00 00       	call   80105d00 <release>
      return -1;
80104688:	83 c4 10             	add    $0x10,%esp
8010468b:	eb e0                	jmp    8010466d <wait+0xdd>
8010468d:	8d 76 00             	lea    0x0(%esi),%esi

80104690 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104690:	f3 0f 1e fb          	endbr32 
80104694:	55                   	push   %ebp
80104695:	89 e5                	mov    %esp,%ebp
80104697:	53                   	push   %ebx
80104698:	83 ec 10             	sub    $0x10,%esp
8010469b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010469e:	68 60 53 11 80       	push   $0x80115360
801046a3:	e8 98 15 00 00       	call   80105c40 <acquire>
801046a8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046ab:	b8 94 53 11 80       	mov    $0x80115394,%eax
801046b0:	eb 12                	jmp    801046c4 <wakeup+0x34>
801046b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801046b8:	05 ac 00 00 00       	add    $0xac,%eax
801046bd:	3d 94 7e 11 80       	cmp    $0x80117e94,%eax
801046c2:	74 1e                	je     801046e2 <wakeup+0x52>
    if(p->state == SLEEPING && p->chan == chan)
801046c4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801046c8:	75 ee                	jne    801046b8 <wakeup+0x28>
801046ca:	3b 58 20             	cmp    0x20(%eax),%ebx
801046cd:	75 e9                	jne    801046b8 <wakeup+0x28>
      p->state = RUNNABLE;
801046cf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046d6:	05 ac 00 00 00       	add    $0xac,%eax
801046db:	3d 94 7e 11 80       	cmp    $0x80117e94,%eax
801046e0:	75 e2                	jne    801046c4 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
801046e2:	c7 45 08 60 53 11 80 	movl   $0x80115360,0x8(%ebp)
}
801046e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046ec:	c9                   	leave  
  release(&ptable.lock);
801046ed:	e9 0e 16 00 00       	jmp    80105d00 <release>
801046f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104700 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104700:	f3 0f 1e fb          	endbr32 
80104704:	55                   	push   %ebp
80104705:	89 e5                	mov    %esp,%ebp
80104707:	53                   	push   %ebx
80104708:	83 ec 10             	sub    $0x10,%esp
8010470b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010470e:	68 60 53 11 80       	push   $0x80115360
80104713:	e8 28 15 00 00       	call   80105c40 <acquire>
80104718:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010471b:	b8 94 53 11 80       	mov    $0x80115394,%eax
80104720:	eb 12                	jmp    80104734 <kill+0x34>
80104722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104728:	05 ac 00 00 00       	add    $0xac,%eax
8010472d:	3d 94 7e 11 80       	cmp    $0x80117e94,%eax
80104732:	74 34                	je     80104768 <kill+0x68>
    if(p->pid == pid){
80104734:	39 58 10             	cmp    %ebx,0x10(%eax)
80104737:	75 ef                	jne    80104728 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104739:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
8010473d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104744:	75 07                	jne    8010474d <kill+0x4d>
        p->state = RUNNABLE;
80104746:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
8010474d:	83 ec 0c             	sub    $0xc,%esp
80104750:	68 60 53 11 80       	push   $0x80115360
80104755:	e8 a6 15 00 00       	call   80105d00 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
8010475a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
8010475d:	83 c4 10             	add    $0x10,%esp
80104760:	31 c0                	xor    %eax,%eax
}
80104762:	c9                   	leave  
80104763:	c3                   	ret    
80104764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104768:	83 ec 0c             	sub    $0xc,%esp
8010476b:	68 60 53 11 80       	push   $0x80115360
80104770:	e8 8b 15 00 00       	call   80105d00 <release>
}
80104775:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104778:	83 c4 10             	add    $0x10,%esp
8010477b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104780:	c9                   	leave  
80104781:	c3                   	ret    
80104782:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104790 <get_uncle_count>:
    
}*/


//get_uncle_count
int get_uncle_count(int pid){
80104790:	f3 0f 1e fb          	endbr32 
80104794:	55                   	push   %ebp
80104795:	89 e5                	mov    %esp,%ebp
80104797:	53                   	push   %ebx
80104798:	83 ec 10             	sub    $0x10,%esp
8010479b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;
  struct proc *p_parent;
  struct proc *p_grandParent = 0;
  acquire(&ptable.lock);
8010479e:	68 60 53 11 80       	push   $0x80115360
801047a3:	e8 98 14 00 00       	call   80105c40 <acquire>
  if(pid < 0 || pid >= NPROC){
801047a8:	83 c4 10             	add    $0x10,%esp
801047ab:	83 fb 3f             	cmp    $0x3f,%ebx
801047ae:	0f 87 a8 00 00 00    	ja     8010485c <get_uncle_count+0xcc>
  struct proc *p_grandParent = 0;
801047b4:	31 c9                	xor    %ecx,%ecx
      return -1;
      }
  int count = 0;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047b6:	b8 94 53 11 80       	mov    $0x80115394,%eax
801047bb:	eb 0f                	jmp    801047cc <get_uncle_count+0x3c>
801047bd:	8d 76 00             	lea    0x0(%esi),%esi
801047c0:	05 ac 00 00 00       	add    $0xac,%eax
801047c5:	3d 94 7e 11 80       	cmp    $0x80117e94,%eax
801047ca:	74 34                	je     80104800 <get_uncle_count+0x70>
    count ++;
    if((p->pid) == pid){
801047cc:	39 58 10             	cmp    %ebx,0x10(%eax)
801047cf:	75 ef                	jne    801047c0 <get_uncle_count+0x30>
      p_parent = p->parent;
801047d1:	8b 50 14             	mov    0x14(%eax),%edx
      if(p_parent != 0){
801047d4:	85 d2                	test   %edx,%edx
801047d6:	74 68                	je     80104840 <get_uncle_count+0xb0>
        p_grandParent = p_parent->parent;
801047d8:	8b 4a 14             	mov    0x14(%edx),%ecx
        if(p_grandParent == 0){
801047db:	85 c9                	test   %ecx,%ecx
801047dd:	75 e1                	jne    801047c0 <get_uncle_count+0x30>
          cprintf("grandparent is zero.");
801047df:	83 ec 0c             	sub    $0xc,%esp
          return -1;
801047e2:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
          cprintf("grandparent is zero.");
801047e7:	68 a7 92 10 80       	push   $0x801092a7
801047ec:	e8 cf c0 ff ff       	call   801008c0 <cprintf>
          return -1;
801047f1:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ptable.lock);
  return siblings;

}
801047f4:	89 d8                	mov    %ebx,%eax
801047f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047f9:	c9                   	leave  
801047fa:	c3                   	ret    
801047fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047ff:	90                   	nop
  for(struct proc *i = ptable.proc; i < &ptable.proc[NPROC]; i++){
80104800:	b8 94 53 11 80       	mov    $0x80115394,%eax
  int siblings = 0;
80104805:	31 db                	xor    %ebx,%ebx
80104807:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010480e:	66 90                	xchg   %ax,%ax
      siblings++;
80104810:	31 d2                	xor    %edx,%edx
80104812:	39 48 14             	cmp    %ecx,0x14(%eax)
80104815:	0f 94 c2             	sete   %dl
  for(struct proc *i = ptable.proc; i < &ptable.proc[NPROC]; i++){
80104818:	05 ac 00 00 00       	add    $0xac,%eax
      siblings++;
8010481d:	01 d3                	add    %edx,%ebx
  for(struct proc *i = ptable.proc; i < &ptable.proc[NPROC]; i++){
8010481f:	3d 94 7e 11 80       	cmp    $0x80117e94,%eax
80104824:	75 ea                	jne    80104810 <get_uncle_count+0x80>
  release(&ptable.lock);
80104826:	83 ec 0c             	sub    $0xc,%esp
80104829:	68 60 53 11 80       	push   $0x80115360
8010482e:	e8 cd 14 00 00       	call   80105d00 <release>
}
80104833:	89 d8                	mov    %ebx,%eax
  return siblings;
80104835:	83 c4 10             	add    $0x10,%esp
}
80104838:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010483b:	c9                   	leave  
8010483c:	c3                   	ret    
8010483d:	8d 76 00             	lea    0x0(%esi),%esi
        cprintf("parent is zero.");
80104840:	83 ec 0c             	sub    $0xc,%esp
        return -1;
80104843:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
        cprintf("parent is zero.");
80104848:	68 ac 92 10 80       	push   $0x801092ac
8010484d:	e8 6e c0 ff ff       	call   801008c0 <cprintf>
}
80104852:	89 d8                	mov    %ebx,%eax
        return -1;
80104854:	83 c4 10             	add    $0x10,%esp
}
80104857:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010485a:	c9                   	leave  
8010485b:	c3                   	ret    
      return -1;
8010485c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104861:	eb 91                	jmp    801047f4 <get_uncle_count+0x64>
80104863:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010486a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104870 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104870:	f3 0f 1e fb          	endbr32 
80104874:	55                   	push   %ebp
80104875:	89 e5                	mov    %esp,%ebp
80104877:	57                   	push   %edi
80104878:	56                   	push   %esi
80104879:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010487c:	53                   	push   %ebx
8010487d:	bb 00 54 11 80       	mov    $0x80115400,%ebx
80104882:	83 ec 3c             	sub    $0x3c,%esp
80104885:	eb 2b                	jmp    801048b2 <procdump+0x42>
80104887:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010488e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104890:	83 ec 0c             	sub    $0xc,%esp
80104893:	68 05 93 10 80       	push   $0x80109305
80104898:	e8 23 c0 ff ff       	call   801008c0 <cprintf>
8010489d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048a0:	81 c3 ac 00 00 00    	add    $0xac,%ebx
801048a6:	81 fb 00 7f 11 80    	cmp    $0x80117f00,%ebx
801048ac:	0f 84 8e 00 00 00    	je     80104940 <procdump+0xd0>
    if(p->state == UNUSED)
801048b2:	8b 43 a0             	mov    -0x60(%ebx),%eax
801048b5:	85 c0                	test   %eax,%eax
801048b7:	74 e7                	je     801048a0 <procdump+0x30>
      state = "???";
801048b9:	ba bc 92 10 80       	mov    $0x801092bc,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801048be:	83 f8 05             	cmp    $0x5,%eax
801048c1:	77 11                	ja     801048d4 <procdump+0x64>
801048c3:	8b 14 85 24 95 10 80 	mov    -0x7fef6adc(,%eax,4),%edx
      state = "???";
801048ca:	b8 bc 92 10 80       	mov    $0x801092bc,%eax
801048cf:	85 d2                	test   %edx,%edx
801048d1:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801048d4:	53                   	push   %ebx
801048d5:	52                   	push   %edx
801048d6:	ff 73 a4             	pushl  -0x5c(%ebx)
801048d9:	68 c0 92 10 80       	push   $0x801092c0
801048de:	e8 dd bf ff ff       	call   801008c0 <cprintf>
    if(p->state == SLEEPING){
801048e3:	83 c4 10             	add    $0x10,%esp
801048e6:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801048ea:	75 a4                	jne    80104890 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801048ec:	83 ec 08             	sub    $0x8,%esp
801048ef:	8d 45 c0             	lea    -0x40(%ebp),%eax
801048f2:	8d 7d c0             	lea    -0x40(%ebp),%edi
801048f5:	50                   	push   %eax
801048f6:	8b 43 b0             	mov    -0x50(%ebx),%eax
801048f9:	8b 40 0c             	mov    0xc(%eax),%eax
801048fc:	83 c0 08             	add    $0x8,%eax
801048ff:	50                   	push   %eax
80104900:	e8 db 11 00 00       	call   80105ae0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104905:	83 c4 10             	add    $0x10,%esp
80104908:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010490f:	90                   	nop
80104910:	8b 17                	mov    (%edi),%edx
80104912:	85 d2                	test   %edx,%edx
80104914:	0f 84 76 ff ff ff    	je     80104890 <procdump+0x20>
        cprintf(" %p", pc[i]);
8010491a:	83 ec 08             	sub    $0x8,%esp
8010491d:	83 c7 04             	add    $0x4,%edi
80104920:	52                   	push   %edx
80104921:	68 c1 8c 10 80       	push   $0x80108cc1
80104926:	e8 95 bf ff ff       	call   801008c0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010492b:	83 c4 10             	add    $0x10,%esp
8010492e:	39 fe                	cmp    %edi,%esi
80104930:	75 de                	jne    80104910 <procdump+0xa0>
80104932:	e9 59 ff ff ff       	jmp    80104890 <procdump+0x20>
80104937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010493e:	66 90                	xchg   %ax,%ax
  }
}
80104940:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104943:	5b                   	pop    %ebx
80104944:	5e                   	pop    %esi
80104945:	5f                   	pop    %edi
80104946:	5d                   	pop    %ebp
80104947:	c3                   	ret    
80104948:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010494f:	90                   	nop

80104950 <find_digital_root>:

int 
find_digital_root(int n){
80104950:	f3 0f 1e fb          	endbr32 
80104954:	55                   	push   %ebp
80104955:	89 e5                	mov    %esp,%ebp
80104957:	57                   	push   %edi
80104958:	56                   	push   %esi
80104959:	53                   	push   %ebx
8010495a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  while(n>9){
8010495d:	83 fb 09             	cmp    $0x9,%ebx
80104960:	7e 3d                	jle    8010499f <find_digital_root+0x4f>
    int sum = 0 ;
    while(n > 0){
      int digit = n%10;
80104962:	be 67 66 66 66       	mov    $0x66666667,%esi
80104967:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010496e:	66 90                	xchg   %ax,%ax
find_digital_root(int n){
80104970:	89 d9                	mov    %ebx,%ecx
    int sum = 0 ;
80104972:	31 db                	xor    %ebx,%ebx
80104974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      int digit = n%10;
80104978:	89 c8                	mov    %ecx,%eax
8010497a:	89 cf                	mov    %ecx,%edi
8010497c:	f7 ee                	imul   %esi
8010497e:	89 c8                	mov    %ecx,%eax
80104980:	c1 f8 1f             	sar    $0x1f,%eax
80104983:	c1 fa 02             	sar    $0x2,%edx
80104986:	29 c2                	sub    %eax,%edx
80104988:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010498b:	01 c0                	add    %eax,%eax
8010498d:	29 c7                	sub    %eax,%edi
8010498f:	89 c8                	mov    %ecx,%eax
      sum += digit;
      n = n/10;
80104991:	89 d1                	mov    %edx,%ecx
      sum += digit;
80104993:	01 fb                	add    %edi,%ebx
    while(n > 0){
80104995:	83 f8 09             	cmp    $0x9,%eax
80104998:	7f de                	jg     80104978 <find_digital_root+0x28>
  while(n>9){
8010499a:	83 fb 09             	cmp    $0x9,%ebx
8010499d:	7f d1                	jg     80104970 <find_digital_root+0x20>
    }
    n = sum;
  }
  
  return n;
}
8010499f:	89 d8                	mov    %ebx,%eax
801049a1:	5b                   	pop    %ebx
801049a2:	5e                   	pop    %esi
801049a3:	5f                   	pop    %edi
801049a4:	5d                   	pop    %ebp
801049a5:	c3                   	ret    
801049a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ad:	8d 76 00             	lea    0x0(%esi),%esi

801049b0 <get_process_lifetime>:

int
get_process_lifetime(void){
801049b0:	f3 0f 1e fb          	endbr32 
801049b4:	55                   	push   %ebp
801049b5:	89 e5                	mov    %esp,%ebp
801049b7:	56                   	push   %esi
801049b8:	53                   	push   %ebx
  return sys_uptime() - myproc()->start_time ; 
801049b9:	e8 02 28 00 00       	call   801071c0 <sys_uptime>
801049be:	89 c3                	mov    %eax,%ebx
  pushcli();
801049c0:	e8 7b 11 00 00       	call   80105b40 <pushcli>
  c = mycpu();
801049c5:	e8 96 f4 ff ff       	call   80103e60 <mycpu>
  p = c->proc;
801049ca:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801049d0:	e8 bb 11 00 00       	call   80105b90 <popcli>
  return sys_uptime() - myproc()->start_time ; 
801049d5:	89 d8                	mov    %ebx,%eax
}
801049d7:	5b                   	pop    %ebx
  return sys_uptime() - myproc()->start_time ; 
801049d8:	2b 46 7c             	sub    0x7c(%esi),%eax
}
801049db:	5e                   	pop    %esi
801049dc:	5d                   	pop    %ebp
801049dd:	c3                   	ret    
801049de:	66 90                	xchg   %ax,%ax

801049e0 <change_Q>:
  }
  release(&ptable.lock);
}

int change_Q(int pid, int new_queue)
{
801049e0:	f3 0f 1e fb          	endbr32 
801049e4:	55                   	push   %ebp
801049e5:	89 e5                	mov    %esp,%ebp
801049e7:	57                   	push   %edi
801049e8:	56                   	push   %esi
801049e9:	53                   	push   %ebx
801049ea:	83 ec 0c             	sub    $0xc,%esp
801049ed:	8b 75 0c             	mov    0xc(%ebp),%esi
801049f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;
  int old_queue = -1;

  if (new_queue == UNSET)
801049f3:	85 f6                	test   %esi,%esi
801049f5:	75 0c                	jne    80104a03 <change_Q+0x23>
  {
    if (pid == 1)
801049f7:	83 fb 01             	cmp    $0x1,%ebx
801049fa:	74 69                	je     80104a65 <change_Q+0x85>
      new_queue = ROUND_ROBIN;
    else if (pid > 1)
801049fc:	7e 6e                	jle    80104a6c <change_Q+0x8c>
      new_queue = LCFS;
801049fe:	be 02 00 00 00       	mov    $0x2,%esi
    else
      return -1;
  }
  acquire(&ptable.lock);
80104a03:	83 ec 0c             	sub    $0xc,%esp
  int old_queue = -1;
80104a06:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  acquire(&ptable.lock);
80104a0b:	68 60 53 11 80       	push   $0x80115360
80104a10:	e8 2b 12 00 00       	call   80105c40 <acquire>
    if (p->pid == pid)
    {
      old_queue = p->sched_info.queue;
      p->sched_info.queue = new_queue;

      p->sched_info.arrival_queue_time = ticks;
80104a15:	8b 15 e0 86 11 80    	mov    0x801186e0,%edx
80104a1b:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a1e:	b8 94 53 11 80       	mov    $0x80115394,%eax
80104a23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a27:	90                   	nop
    if (p->pid == pid)
80104a28:	39 58 10             	cmp    %ebx,0x10(%eax)
80104a2b:	75 12                	jne    80104a3f <change_Q+0x5f>
      old_queue = p->sched_info.queue;
80104a2d:	8b b8 80 00 00 00    	mov    0x80(%eax),%edi
      p->sched_info.arrival_queue_time = ticks;
80104a33:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
      p->sched_info.queue = new_queue;
80104a39:	89 b0 80 00 00 00    	mov    %esi,0x80(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a3f:	05 ac 00 00 00       	add    $0xac,%eax
80104a44:	3d 94 7e 11 80       	cmp    $0x80117e94,%eax
80104a49:	75 dd                	jne    80104a28 <change_Q+0x48>
    }
  }
  release(&ptable.lock);
80104a4b:	83 ec 0c             	sub    $0xc,%esp
80104a4e:	68 60 53 11 80       	push   $0x80115360
80104a53:	e8 a8 12 00 00       	call   80105d00 <release>
  return old_queue;
80104a58:	83 c4 10             	add    $0x10,%esp
}
80104a5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a5e:	89 f8                	mov    %edi,%eax
80104a60:	5b                   	pop    %ebx
80104a61:	5e                   	pop    %esi
80104a62:	5f                   	pop    %edi
80104a63:	5d                   	pop    %ebp
80104a64:	c3                   	ret    
      new_queue = ROUND_ROBIN;
80104a65:	be 01 00 00 00       	mov    $0x1,%esi
80104a6a:	eb 97                	jmp    80104a03 <change_Q+0x23>
      return -1;
80104a6c:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104a71:	eb e8                	jmp    80104a5b <change_Q+0x7b>
80104a73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a80 <userinit>:
{
80104a80:	f3 0f 1e fb          	endbr32 
80104a84:	55                   	push   %ebp
80104a85:	89 e5                	mov    %esp,%ebp
80104a87:	53                   	push   %ebx
80104a88:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80104a8b:	e8 30 f2 ff ff       	call   80103cc0 <allocproc>
80104a90:	89 c3                	mov    %eax,%ebx
  initproc = p;
80104a92:	a3 1c c6 10 80       	mov    %eax,0x8010c61c
  if((p->pgdir = setupkvm()) == 0)
80104a97:	e8 44 3f 00 00       	call   801089e0 <setupkvm>
80104a9c:	89 43 04             	mov    %eax,0x4(%ebx)
80104a9f:	85 c0                	test   %eax,%eax
80104aa1:	0f 84 c9 00 00 00    	je     80104b70 <userinit+0xf0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104aa7:	83 ec 04             	sub    $0x4,%esp
80104aaa:	68 2c 00 00 00       	push   $0x2c
80104aaf:	68 60 c4 10 80       	push   $0x8010c460
80104ab4:	50                   	push   %eax
80104ab5:	e8 f6 3b 00 00       	call   801086b0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104aba:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104abd:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80104ac3:	6a 4c                	push   $0x4c
80104ac5:	6a 00                	push   $0x0
80104ac7:	ff 73 18             	pushl  0x18(%ebx)
80104aca:	e8 81 12 00 00       	call   80105d50 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104acf:	8b 43 18             	mov    0x18(%ebx),%eax
80104ad2:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104ad7:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104ada:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104adf:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104ae3:	8b 43 18             	mov    0x18(%ebx),%eax
80104ae6:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104aea:	8b 43 18             	mov    0x18(%ebx),%eax
80104aed:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104af1:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104af5:	8b 43 18             	mov    0x18(%ebx),%eax
80104af8:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104afc:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104b00:	8b 43 18             	mov    0x18(%ebx),%eax
80104b03:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104b0a:	8b 43 18             	mov    0x18(%ebx),%eax
80104b0d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104b14:	8b 43 18             	mov    0x18(%ebx),%eax
80104b17:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104b1e:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104b21:	6a 10                	push   $0x10
80104b23:	68 e2 92 10 80       	push   $0x801092e2
80104b28:	50                   	push   %eax
80104b29:	e8 e2 13 00 00       	call   80105f10 <safestrcpy>
  p->cwd = namei("/");
80104b2e:	c7 04 24 eb 92 10 80 	movl   $0x801092eb,(%esp)
80104b35:	e8 16 da ff ff       	call   80102550 <namei>
80104b3a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80104b3d:	c7 04 24 60 53 11 80 	movl   $0x80115360,(%esp)
80104b44:	e8 f7 10 00 00       	call   80105c40 <acquire>
  p->state = RUNNABLE;
80104b49:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80104b50:	c7 04 24 60 53 11 80 	movl   $0x80115360,(%esp)
80104b57:	e8 a4 11 00 00       	call   80105d00 <release>
  change_Q(p->pid, UNSET);
80104b5c:	58                   	pop    %eax
80104b5d:	5a                   	pop    %edx
80104b5e:	6a 00                	push   $0x0
80104b60:	ff 73 10             	pushl  0x10(%ebx)
80104b63:	e8 78 fe ff ff       	call   801049e0 <change_Q>
}
80104b68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b6b:	83 c4 10             	add    $0x10,%esp
80104b6e:	c9                   	leave  
80104b6f:	c3                   	ret    
    panic("userinit: out of memory?");
80104b70:	83 ec 0c             	sub    $0xc,%esp
80104b73:	68 c9 92 10 80       	push   $0x801092c9
80104b78:	e8 13 b8 ff ff       	call   80100390 <panic>
80104b7d:	8d 76 00             	lea    0x0(%esi),%esi

80104b80 <fork>:
{
80104b80:	f3 0f 1e fb          	endbr32 
80104b84:	55                   	push   %ebp
80104b85:	89 e5                	mov    %esp,%ebp
80104b87:	57                   	push   %edi
80104b88:	56                   	push   %esi
80104b89:	53                   	push   %ebx
80104b8a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104b8d:	e8 ae 0f 00 00       	call   80105b40 <pushcli>
  c = mycpu();
80104b92:	e8 c9 f2 ff ff       	call   80103e60 <mycpu>
  p = c->proc;
80104b97:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104b9d:	e8 ee 0f 00 00       	call   80105b90 <popcli>
  if((np = allocproc()) == 0){
80104ba2:	e8 19 f1 ff ff       	call   80103cc0 <allocproc>
80104ba7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104baa:	85 c0                	test   %eax,%eax
80104bac:	0f 84 c7 00 00 00    	je     80104c79 <fork+0xf9>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80104bb2:	83 ec 08             	sub    $0x8,%esp
80104bb5:	ff 33                	pushl  (%ebx)
80104bb7:	89 c7                	mov    %eax,%edi
80104bb9:	ff 73 04             	pushl  0x4(%ebx)
80104bbc:	e8 ef 3e 00 00       	call   80108ab0 <copyuvm>
80104bc1:	83 c4 10             	add    $0x10,%esp
80104bc4:	89 47 04             	mov    %eax,0x4(%edi)
80104bc7:	85 c0                	test   %eax,%eax
80104bc9:	0f 84 b1 00 00 00    	je     80104c80 <fork+0x100>
  np->sz = curproc->sz;
80104bcf:	8b 03                	mov    (%ebx),%eax
80104bd1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104bd4:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104bd6:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104bd9:	89 c8                	mov    %ecx,%eax
80104bdb:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80104bde:	b9 13 00 00 00       	mov    $0x13,%ecx
80104be3:	8b 73 18             	mov    0x18(%ebx),%esi
80104be6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104be8:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104bea:	8b 40 18             	mov    0x18(%eax),%eax
80104bed:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80104bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80104bf8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104bfc:	85 c0                	test   %eax,%eax
80104bfe:	74 13                	je     80104c13 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104c00:	83 ec 0c             	sub    $0xc,%esp
80104c03:	50                   	push   %eax
80104c04:	e8 87 c7 ff ff       	call   80101390 <filedup>
80104c09:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104c0c:	83 c4 10             	add    $0x10,%esp
80104c0f:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104c13:	83 c6 01             	add    $0x1,%esi
80104c16:	83 fe 10             	cmp    $0x10,%esi
80104c19:	75 dd                	jne    80104bf8 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80104c1b:	83 ec 0c             	sub    $0xc,%esp
80104c1e:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104c21:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104c24:	e8 27 d0 ff ff       	call   80101c50 <idup>
80104c29:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104c2c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104c2f:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104c32:	8d 47 6c             	lea    0x6c(%edi),%eax
80104c35:	6a 10                	push   $0x10
80104c37:	53                   	push   %ebx
80104c38:	50                   	push   %eax
80104c39:	e8 d2 12 00 00       	call   80105f10 <safestrcpy>
  pid = np->pid;
80104c3e:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104c41:	c7 04 24 60 53 11 80 	movl   $0x80115360,(%esp)
80104c48:	e8 f3 0f 00 00       	call   80105c40 <acquire>
  np->state = RUNNABLE;
80104c4d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80104c54:	c7 04 24 60 53 11 80 	movl   $0x80115360,(%esp)
80104c5b:	e8 a0 10 00 00       	call   80105d00 <release>
  change_Q(np->pid, UNSET);
80104c60:	58                   	pop    %eax
80104c61:	5a                   	pop    %edx
80104c62:	6a 00                	push   $0x0
80104c64:	ff 77 10             	pushl  0x10(%edi)
80104c67:	e8 74 fd ff ff       	call   801049e0 <change_Q>
  return pid;
80104c6c:	83 c4 10             	add    $0x10,%esp
}
80104c6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c72:	89 d8                	mov    %ebx,%eax
80104c74:	5b                   	pop    %ebx
80104c75:	5e                   	pop    %esi
80104c76:	5f                   	pop    %edi
80104c77:	5d                   	pop    %ebp
80104c78:	c3                   	ret    
    return -1;
80104c79:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104c7e:	eb ef                	jmp    80104c6f <fork+0xef>
    kfree(np->kstack);
80104c80:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80104c83:	83 ec 0c             	sub    $0xc,%esp
80104c86:	ff 73 08             	pushl  0x8(%ebx)
80104c89:	e8 02 dd ff ff       	call   80102990 <kfree>
    np->kstack = 0;
80104c8e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80104c95:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80104c98:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104c9f:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104ca4:	eb c9                	jmp    80104c6f <fork+0xef>
80104ca6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cad:	8d 76 00             	lea    0x0(%esi),%esi

80104cb0 <ageprocs>:
{
80104cb0:	f3 0f 1e fb          	endbr32 
80104cb4:	55                   	push   %ebp
80104cb5:	89 e5                	mov    %esp,%ebp
80104cb7:	56                   	push   %esi
80104cb8:	53                   	push   %ebx
80104cb9:	8b 75 08             	mov    0x8(%ebp),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104cbc:	bb 94 53 11 80       	mov    $0x80115394,%ebx
  acquire(&ptable.lock);
80104cc1:	83 ec 0c             	sub    $0xc,%esp
80104cc4:	68 60 53 11 80       	push   $0x80115360
80104cc9:	e8 72 0f 00 00       	call   80105c40 <acquire>
80104cce:	83 c4 10             	add    $0x10,%esp
80104cd1:	eb 13                	jmp    80104ce6 <ageprocs+0x36>
80104cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104cd7:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104cd8:	81 c3 ac 00 00 00    	add    $0xac,%ebx
80104cde:	81 fb 94 7e 11 80    	cmp    $0x80117e94,%ebx
80104ce4:	74 57                	je     80104d3d <ageprocs+0x8d>
    if (p->state == RUNNABLE && p->sched_info.queue != ROUND_ROBIN)
80104ce6:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104cea:	75 ec                	jne    80104cd8 <ageprocs+0x28>
80104cec:	83 bb 80 00 00 00 01 	cmpl   $0x1,0x80(%ebx)
80104cf3:	74 e3                	je     80104cd8 <ageprocs+0x28>
      if (os_ticks - p->sched_info.last_run > AGING_THRESHOLD)
80104cf5:	89 f0                	mov    %esi,%eax
80104cf7:	2b 83 84 00 00 00    	sub    0x84(%ebx),%eax
80104cfd:	3d 40 1f 00 00       	cmp    $0x1f40,%eax
80104d02:	7e d4                	jle    80104cd8 <ageprocs+0x28>
        release(&ptable.lock);
80104d04:	83 ec 0c             	sub    $0xc,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d07:	81 c3 ac 00 00 00    	add    $0xac,%ebx
        release(&ptable.lock);
80104d0d:	68 60 53 11 80       	push   $0x80115360
80104d12:	e8 e9 0f 00 00       	call   80105d00 <release>
        change_Q(p->pid, ROUND_ROBIN);
80104d17:	58                   	pop    %eax
80104d18:	5a                   	pop    %edx
80104d19:	6a 01                	push   $0x1
80104d1b:	ff b3 64 ff ff ff    	pushl  -0x9c(%ebx)
80104d21:	e8 ba fc ff ff       	call   801049e0 <change_Q>
        acquire(&ptable.lock);
80104d26:	c7 04 24 60 53 11 80 	movl   $0x80115360,(%esp)
80104d2d:	e8 0e 0f 00 00       	call   80105c40 <acquire>
80104d32:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d35:	81 fb 94 7e 11 80    	cmp    $0x80117e94,%ebx
80104d3b:	75 a9                	jne    80104ce6 <ageprocs+0x36>
  release(&ptable.lock);
80104d3d:	c7 45 08 60 53 11 80 	movl   $0x80115360,0x8(%ebp)
}
80104d44:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d47:	5b                   	pop    %ebx
80104d48:	5e                   	pop    %esi
80104d49:	5d                   	pop    %ebp
  release(&ptable.lock);
80104d4a:	e9 b1 0f 00 00       	jmp    80105d00 <release>
80104d4f:	90                   	nop

80104d50 <num_digits>:

int num_digits(int n) {
80104d50:	f3 0f 1e fb          	endbr32 
80104d54:	55                   	push   %ebp
80104d55:	89 e5                	mov    %esp,%ebp
80104d57:	56                   	push   %esi
80104d58:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104d5b:	53                   	push   %ebx
  int num = 0;
80104d5c:	31 db                	xor    %ebx,%ebx
  while(n!= 0) {
80104d5e:	85 c9                	test   %ecx,%ecx
80104d60:	74 21                	je     80104d83 <num_digits+0x33>
    n/=10;
80104d62:	be 67 66 66 66       	mov    $0x66666667,%esi
80104d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d6e:	66 90                	xchg   %ax,%ax
80104d70:	89 c8                	mov    %ecx,%eax
80104d72:	c1 f9 1f             	sar    $0x1f,%ecx
    num += 1;
80104d75:	83 c3 01             	add    $0x1,%ebx
    n/=10;
80104d78:	f7 ee                	imul   %esi
80104d7a:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
80104d7d:	29 ca                	sub    %ecx,%edx
80104d7f:	89 d1                	mov    %edx,%ecx
80104d81:	75 ed                	jne    80104d70 <num_digits+0x20>
  }
  return num;
}
80104d83:	89 d8                	mov    %ebx,%eax
80104d85:	5b                   	pop    %ebx
80104d86:	5e                   	pop    %esi
80104d87:	5d                   	pop    %ebp
80104d88:	c3                   	ret    
80104d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104d90 <space>:

void
space(int count)
{
80104d90:	f3 0f 1e fb          	endbr32 
80104d94:	55                   	push   %ebp
80104d95:	89 e5                	mov    %esp,%ebp
80104d97:	56                   	push   %esi
80104d98:	8b 75 08             	mov    0x8(%ebp),%esi
80104d9b:	53                   	push   %ebx
  for(int i = 0; i < count; ++i)
80104d9c:	85 f6                	test   %esi,%esi
80104d9e:	7e 1f                	jle    80104dbf <space+0x2f>
80104da0:	31 db                	xor    %ebx,%ebx
80104da2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf(" ");
80104da8:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80104dab:	83 c3 01             	add    $0x1,%ebx
    cprintf(" ");
80104dae:	68 7e 93 10 80       	push   $0x8010937e
80104db3:	e8 08 bb ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
80104db8:	83 c4 10             	add    $0x10,%esp
80104dbb:	39 de                	cmp    %ebx,%esi
80104dbd:	75 e9                	jne    80104da8 <space+0x18>
}
80104dbf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dc2:	5b                   	pop    %ebx
80104dc3:	5e                   	pop    %esi
80104dc4:	5d                   	pop    %ebp
80104dc5:	c3                   	ret    
80104dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dcd:	8d 76 00             	lea    0x0(%esi),%esi

80104dd0 <set_proc_bjf_params>:

int set_proc_bjf_params(int pid, float priority_ratio, float arrival_time_ratio, float executed_cycle_ratio, float process_size_ratio)
{
80104dd0:	f3 0f 1e fb          	endbr32 
80104dd4:	55                   	push   %ebp
80104dd5:	89 e5                	mov    %esp,%ebp
80104dd7:	53                   	push   %ebx
80104dd8:	83 ec 10             	sub    $0x10,%esp
80104ddb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104dde:	68 60 53 11 80       	push   $0x80115360
80104de3:	e8 58 0e 00 00       	call   80105c40 <acquire>
80104de8:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104deb:	b8 94 53 11 80       	mov    $0x80115394,%eax
80104df0:	eb 12                	jmp    80104e04 <set_proc_bjf_params+0x34>
80104df2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104df8:	05 ac 00 00 00       	add    $0xac,%eax
80104dfd:	3d 94 7e 11 80       	cmp    $0x80117e94,%eax
80104e02:	74 44                	je     80104e48 <set_proc_bjf_params+0x78>
  {
    if (p->pid == pid)
80104e04:	39 58 10             	cmp    %ebx,0x10(%eax)
80104e07:	75 ef                	jne    80104df8 <set_proc_bjf_params+0x28>
    {
      p->sched_info.bjf.priority_ratio = priority_ratio;
80104e09:	d9 45 0c             	flds   0xc(%ebp)
      p->sched_info.bjf.arrival_time_ratio = arrival_time_ratio;
      p->sched_info.bjf.executed_cycle_ratio = executed_cycle_ratio;
      p->sched_info.bjf.process_size_ratio = process_size_ratio;
      release(&ptable.lock);
80104e0c:	83 ec 0c             	sub    $0xc,%esp
      p->sched_info.bjf.priority_ratio = priority_ratio;
80104e0f:	d9 98 8c 00 00 00    	fstps  0x8c(%eax)
      p->sched_info.bjf.arrival_time_ratio = arrival_time_ratio;
80104e15:	d9 45 10             	flds   0x10(%ebp)
80104e18:	d9 98 94 00 00 00    	fstps  0x94(%eax)
      p->sched_info.bjf.executed_cycle_ratio = executed_cycle_ratio;
80104e1e:	d9 45 14             	flds   0x14(%ebp)
80104e21:	d9 98 9c 00 00 00    	fstps  0x9c(%eax)
      p->sched_info.bjf.process_size_ratio = process_size_ratio;
80104e27:	d9 45 18             	flds   0x18(%ebp)
80104e2a:	d9 98 a4 00 00 00    	fstps  0xa4(%eax)
      release(&ptable.lock);
80104e30:	68 60 53 11 80       	push   $0x80115360
80104e35:	e8 c6 0e 00 00       	call   80105d00 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104e3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104e3d:	83 c4 10             	add    $0x10,%esp
80104e40:	31 c0                	xor    %eax,%eax
}
80104e42:	c9                   	leave  
80104e43:	c3                   	ret    
80104e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104e48:	83 ec 0c             	sub    $0xc,%esp
80104e4b:	68 60 53 11 80       	push   $0x80115360
80104e50:	e8 ab 0e 00 00       	call   80105d00 <release>
}
80104e55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104e58:	83 c4 10             	add    $0x10,%esp
80104e5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e60:	c9                   	leave  
80104e61:	c3                   	ret    
80104e62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104e70 <set_system_bjf_params>:

int set_system_bjf_params(float priority_ratio, float arrival_time_ratio, float executed_cycle_ratio, float process_size_ratio)
{
80104e70:	f3 0f 1e fb          	endbr32 
80104e74:	55                   	push   %ebp
80104e75:	89 e5                	mov    %esp,%ebp
80104e77:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104e7a:	68 60 53 11 80       	push   $0x80115360
80104e7f:	e8 bc 0d 00 00       	call   80105c40 <acquire>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e84:	d9 45 08             	flds   0x8(%ebp)
80104e87:	d9 45 0c             	flds   0xc(%ebp)
  acquire(&ptable.lock);
80104e8a:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e8d:	d9 45 10             	flds   0x10(%ebp)
80104e90:	d9 45 14             	flds   0x14(%ebp)
80104e93:	d9 cb                	fxch   %st(3)
80104e95:	b8 94 53 11 80       	mov    $0x80115394,%eax
80104e9a:	eb 0a                	jmp    80104ea6 <set_system_bjf_params+0x36>
80104e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ea0:	d9 cb                	fxch   %st(3)
80104ea2:	d9 c9                	fxch   %st(1)
80104ea4:	d9 ca                	fxch   %st(2)
  {
    p->sched_info.bjf.priority_ratio = priority_ratio;
80104ea6:	d9 90 8c 00 00 00    	fsts   0x8c(%eax)
80104eac:	d9 ca                	fxch   %st(2)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104eae:	05 ac 00 00 00       	add    $0xac,%eax
    p->sched_info.bjf.arrival_time_ratio = arrival_time_ratio;
80104eb3:	d9 50 e8             	fsts   -0x18(%eax)
80104eb6:	d9 c9                	fxch   %st(1)
    p->sched_info.bjf.executed_cycle_ratio = executed_cycle_ratio;
80104eb8:	d9 50 f0             	fsts   -0x10(%eax)
80104ebb:	d9 cb                	fxch   %st(3)
    p->sched_info.bjf.process_size_ratio = process_size_ratio;
80104ebd:	d9 50 f8             	fsts   -0x8(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ec0:	3d 94 7e 11 80       	cmp    $0x80117e94,%eax
80104ec5:	75 d9                	jne    80104ea0 <set_system_bjf_params+0x30>
80104ec7:	dd d8                	fstp   %st(0)
80104ec9:	dd d8                	fstp   %st(0)
80104ecb:	dd d8                	fstp   %st(0)
80104ecd:	dd d8                	fstp   %st(0)
  }
  release(&ptable.lock);
80104ecf:	83 ec 0c             	sub    $0xc,%esp
80104ed2:	68 60 53 11 80       	push   $0x80115360
80104ed7:	e8 24 0e 00 00       	call   80105d00 <release>
  return 0;
}
80104edc:	31 c0                	xor    %eax,%eax
80104ede:	c9                   	leave  
80104edf:	c3                   	ret    

80104ee0 <show_process_info>:

void show_process_info()
{
80104ee0:	f3 0f 1e fb          	endbr32 
80104ee4:	55                   	push   %ebp
80104ee5:	89 e5                	mov    %esp,%ebp
80104ee7:	57                   	push   %edi
80104ee8:	56                   	push   %esi
  static int columns[] = {16, 8, 9, 8, 8, 8, 9, 8, 8, 8, 8};
  cprintf("Process_Name    PID     State    Queue   Cycle   Arrival Priority R_Prty  R_Arvl  R_Exec  R_Size  Rank\n"
          "------------------------------------------------------------------------------------------------------\n");

  struct proc *p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ee9:	be 94 53 11 80       	mov    $0x80115394,%esi
{
80104eee:	53                   	push   %ebx
    n/=10;
80104eef:	bb 67 66 66 66       	mov    $0x66666667,%ebx
{
80104ef4:	83 ec 28             	sub    $0x28,%esp
  cprintf("Process_Name    PID     State    Queue   Cycle   Arrival Priority R_Prty  R_Arvl  R_Exec  R_Size  Rank\n"
80104ef7:	68 a8 93 10 80       	push   $0x801093a8
80104efc:	e8 bf b9 ff ff       	call   801008c0 <cprintf>
80104f01:	83 c4 10             	add    $0x10,%esp
80104f04:	eb 1c                	jmp    80104f22 <show_process_info+0x42>
80104f06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f0d:	8d 76 00             	lea    0x0(%esi),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104f10:	81 c6 ac 00 00 00    	add    $0xac,%esi
80104f16:	81 fe 94 7e 11 80    	cmp    $0x80117e94,%esi
80104f1c:	0f 84 7a 06 00 00    	je     8010559c <show_process_info+0x6bc>
  {
    if (p->state == UNUSED)
80104f22:	8b 46 0c             	mov    0xc(%esi),%eax
80104f25:	85 c0                	test   %eax,%eax
80104f27:	74 e7                	je     80104f10 <show_process_info+0x30>

    const char *state;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "unknown state";
80104f29:	c7 45 e0 ed 92 10 80 	movl   $0x801092ed,-0x20(%ebp)
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104f30:	83 f8 05             	cmp    $0x5,%eax
80104f33:	77 14                	ja     80104f49 <show_process_info+0x69>
80104f35:	8b 3c 85 0c 95 10 80 	mov    -0x7fef6af4(,%eax,4),%edi
      state = "unknown state";
80104f3c:	b8 ed 92 10 80       	mov    $0x801092ed,%eax
80104f41:	85 ff                	test   %edi,%edi
80104f43:	0f 45 c7             	cmovne %edi,%eax
80104f46:	89 45 e0             	mov    %eax,-0x20(%ebp)

    cprintf("%s", p->name);
80104f49:	83 ec 08             	sub    $0x8,%esp
80104f4c:	8d 7e 6c             	lea    0x6c(%esi),%edi
80104f4f:	57                   	push   %edi
80104f50:	68 c6 92 10 80       	push   $0x801092c6
80104f55:	e8 66 b9 ff ff       	call   801008c0 <cprintf>
    space(columns[0] - strlen(p->name));
80104f5a:	89 3c 24             	mov    %edi,(%esp)
80104f5d:	bf 10 00 00 00       	mov    $0x10,%edi
80104f62:	e8 e9 0f 00 00       	call   80105f50 <strlen>
  for(int i = 0; i < count; ++i)
80104f67:	83 c4 10             	add    $0x10,%esp
    space(columns[0] - strlen(p->name));
80104f6a:	29 c7                	sub    %eax,%edi
80104f6c:	89 f8                	mov    %edi,%eax
  for(int i = 0; i < count; ++i)
80104f6e:	31 ff                	xor    %edi,%edi
80104f70:	85 c0                	test   %eax,%eax
80104f72:	7e 26                	jle    80104f9a <show_process_info+0xba>
80104f74:	89 75 dc             	mov    %esi,-0x24(%ebp)
80104f77:	89 fe                	mov    %edi,%esi
80104f79:	89 c7                	mov    %eax,%edi
80104f7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f7f:	90                   	nop
    cprintf(" ");
80104f80:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80104f83:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
80104f86:	68 7e 93 10 80       	push   $0x8010937e
80104f8b:	e8 30 b9 ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
80104f90:	83 c4 10             	add    $0x10,%esp
80104f93:	39 f7                	cmp    %esi,%edi
80104f95:	75 e9                	jne    80104f80 <show_process_info+0xa0>
80104f97:	8b 75 dc             	mov    -0x24(%ebp),%esi

    cprintf("%d", p->pid);
80104f9a:	83 ec 08             	sub    $0x8,%esp
80104f9d:	ff 76 10             	pushl  0x10(%esi)
  int num = 0;
80104fa0:	31 ff                	xor    %edi,%edi
    cprintf("%d", p->pid);
80104fa2:	68 fb 92 10 80       	push   $0x801092fb
80104fa7:	e8 14 b9 ff ff       	call   801008c0 <cprintf>
    space(columns[1] - num_digits(p->pid));
80104fac:	8b 4e 10             	mov    0x10(%esi),%ecx
  while(n!= 0) {
80104faf:	83 c4 10             	add    $0x10,%esp
    space(columns[1] - num_digits(p->pid));
80104fb2:	b8 08 00 00 00       	mov    $0x8,%eax
  while(n!= 0) {
80104fb7:	85 c9                	test   %ecx,%ecx
80104fb9:	74 23                	je     80104fde <show_process_info+0xfe>
80104fbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fbf:	90                   	nop
    n/=10;
80104fc0:	89 c8                	mov    %ecx,%eax
80104fc2:	c1 f9 1f             	sar    $0x1f,%ecx
    num += 1;
80104fc5:	83 c7 01             	add    $0x1,%edi
    n/=10;
80104fc8:	f7 eb                	imul   %ebx
80104fca:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
80104fcd:	29 ca                	sub    %ecx,%edx
80104fcf:	89 d1                	mov    %edx,%ecx
80104fd1:	75 ed                	jne    80104fc0 <show_process_info+0xe0>
    space(columns[1] - num_digits(p->pid));
80104fd3:	b8 08 00 00 00       	mov    $0x8,%eax
80104fd8:	29 f8                	sub    %edi,%eax
  for(int i = 0; i < count; ++i)
80104fda:	85 c0                	test   %eax,%eax
80104fdc:	7e 2c                	jle    8010500a <show_process_info+0x12a>
    space(columns[1] - num_digits(p->pid));
80104fde:	31 ff                	xor    %edi,%edi
80104fe0:	89 75 dc             	mov    %esi,-0x24(%ebp)
80104fe3:	89 fe                	mov    %edi,%esi
80104fe5:	89 c7                	mov    %eax,%edi
80104fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fee:	66 90                	xchg   %ax,%ax
    cprintf(" ");
80104ff0:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80104ff3:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
80104ff6:	68 7e 93 10 80       	push   $0x8010937e
80104ffb:	e8 c0 b8 ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
80105000:	83 c4 10             	add    $0x10,%esp
80105003:	39 fe                	cmp    %edi,%esi
80105005:	7c e9                	jl     80104ff0 <show_process_info+0x110>
80105007:	8b 75 dc             	mov    -0x24(%ebp),%esi

    cprintf("%s", state);
8010500a:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010500d:	83 ec 08             	sub    $0x8,%esp
80105010:	57                   	push   %edi
80105011:	68 c6 92 10 80       	push   $0x801092c6
80105016:	e8 a5 b8 ff ff       	call   801008c0 <cprintf>
    space(columns[2] - strlen(state));
8010501b:	89 3c 24             	mov    %edi,(%esp)
8010501e:	bf 09 00 00 00       	mov    $0x9,%edi
80105023:	e8 28 0f 00 00       	call   80105f50 <strlen>
  for(int i = 0; i < count; ++i)
80105028:	83 c4 10             	add    $0x10,%esp
    space(columns[2] - strlen(state));
8010502b:	29 c7                	sub    %eax,%edi
8010502d:	89 f8                	mov    %edi,%eax
  for(int i = 0; i < count; ++i)
8010502f:	31 ff                	xor    %edi,%edi
80105031:	85 c0                	test   %eax,%eax
80105033:	7e 25                	jle    8010505a <show_process_info+0x17a>
80105035:	89 75 e0             	mov    %esi,-0x20(%ebp)
80105038:	89 fe                	mov    %edi,%esi
8010503a:	89 c7                	mov    %eax,%edi
8010503c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" ");
80105040:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80105043:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
80105046:	68 7e 93 10 80       	push   $0x8010937e
8010504b:	e8 70 b8 ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
80105050:	83 c4 10             	add    $0x10,%esp
80105053:	39 f7                	cmp    %esi,%edi
80105055:	75 e9                	jne    80105040 <show_process_info+0x160>
80105057:	8b 75 e0             	mov    -0x20(%ebp),%esi

    cprintf("%d", p->sched_info.queue);
8010505a:	83 ec 08             	sub    $0x8,%esp
8010505d:	ff b6 80 00 00 00    	pushl  0x80(%esi)
  int num = 0;
80105063:	31 ff                	xor    %edi,%edi
    cprintf("%d", p->sched_info.queue);
80105065:	68 fb 92 10 80       	push   $0x801092fb
8010506a:	e8 51 b8 ff ff       	call   801008c0 <cprintf>
    space(columns[3] - num_digits(p->sched_info.queue));
8010506f:	8b 8e 80 00 00 00    	mov    0x80(%esi),%ecx
  while(n!= 0) {
80105075:	83 c4 10             	add    $0x10,%esp
    space(columns[3] - num_digits(p->sched_info.queue));
80105078:	b8 08 00 00 00       	mov    $0x8,%eax
  while(n!= 0) {
8010507d:	85 c9                	test   %ecx,%ecx
8010507f:	74 25                	je     801050a6 <show_process_info+0x1c6>
80105081:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    n/=10;
80105088:	89 c8                	mov    %ecx,%eax
8010508a:	c1 f9 1f             	sar    $0x1f,%ecx
    num += 1;
8010508d:	83 c7 01             	add    $0x1,%edi
    n/=10;
80105090:	f7 eb                	imul   %ebx
80105092:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
80105095:	29 ca                	sub    %ecx,%edx
80105097:	89 d1                	mov    %edx,%ecx
80105099:	75 ed                	jne    80105088 <show_process_info+0x1a8>
    space(columns[3] - num_digits(p->sched_info.queue));
8010509b:	b8 08 00 00 00       	mov    $0x8,%eax
801050a0:	29 f8                	sub    %edi,%eax
  for(int i = 0; i < count; ++i)
801050a2:	85 c0                	test   %eax,%eax
801050a4:	7e 24                	jle    801050ca <show_process_info+0x1ea>
    space(columns[3] - num_digits(p->sched_info.queue));
801050a6:	31 ff                	xor    %edi,%edi
801050a8:	89 75 e0             	mov    %esi,-0x20(%ebp)
801050ab:	89 fe                	mov    %edi,%esi
801050ad:	89 c7                	mov    %eax,%edi
801050af:	90                   	nop
    cprintf(" ");
801050b0:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
801050b3:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
801050b6:	68 7e 93 10 80       	push   $0x8010937e
801050bb:	e8 00 b8 ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
801050c0:	83 c4 10             	add    $0x10,%esp
801050c3:	39 f7                	cmp    %esi,%edi
801050c5:	7f e9                	jg     801050b0 <show_process_info+0x1d0>
801050c7:	8b 75 e0             	mov    -0x20(%ebp),%esi

    cprintf("%d", (int)p->sched_info.bjf.executed_cycle);
801050ca:	d9 86 98 00 00 00    	flds   0x98(%esi)
801050d0:	83 ec 08             	sub    $0x8,%esp
  int num = 0;
801050d3:	31 ff                	xor    %edi,%edi
    cprintf("%d", (int)p->sched_info.bjf.executed_cycle);
801050d5:	d9 7d e6             	fnstcw -0x1a(%ebp)
801050d8:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
801050dc:	80 cc 0c             	or     $0xc,%ah
801050df:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
801050e3:	d9 6d e4             	fldcw  -0x1c(%ebp)
801050e6:	db 5d e0             	fistpl -0x20(%ebp)
801050e9:	d9 6d e6             	fldcw  -0x1a(%ebp)
801050ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
801050ef:	50                   	push   %eax
801050f0:	68 fb 92 10 80       	push   $0x801092fb
801050f5:	e8 c6 b7 ff ff       	call   801008c0 <cprintf>
    space(columns[4] - num_digits((int)p->sched_info.bjf.executed_cycle));
801050fa:	d9 86 98 00 00 00    	flds   0x98(%esi)
  while(n!= 0) {
80105100:	83 c4 10             	add    $0x10,%esp
    space(columns[4] - num_digits((int)p->sched_info.bjf.executed_cycle));
80105103:	d9 7d e6             	fnstcw -0x1a(%ebp)
80105106:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
8010510a:	80 cc 0c             	or     $0xc,%ah
8010510d:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80105111:	b8 08 00 00 00       	mov    $0x8,%eax
80105116:	d9 6d e4             	fldcw  -0x1c(%ebp)
80105119:	db 5d e0             	fistpl -0x20(%ebp)
8010511c:	d9 6d e6             	fldcw  -0x1a(%ebp)
8010511f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  while(n!= 0) {
80105122:	85 c9                	test   %ecx,%ecx
80105124:	74 28                	je     8010514e <show_process_info+0x26e>
80105126:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010512d:	8d 76 00             	lea    0x0(%esi),%esi
    n/=10;
80105130:	89 c8                	mov    %ecx,%eax
80105132:	c1 f9 1f             	sar    $0x1f,%ecx
    num += 1;
80105135:	83 c7 01             	add    $0x1,%edi
    n/=10;
80105138:	f7 eb                	imul   %ebx
8010513a:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
8010513d:	29 ca                	sub    %ecx,%edx
8010513f:	89 d1                	mov    %edx,%ecx
80105141:	75 ed                	jne    80105130 <show_process_info+0x250>
    space(columns[4] - num_digits((int)p->sched_info.bjf.executed_cycle));
80105143:	b8 08 00 00 00       	mov    $0x8,%eax
80105148:	29 f8                	sub    %edi,%eax
  for(int i = 0; i < count; ++i)
8010514a:	85 c0                	test   %eax,%eax
8010514c:	7e 2c                	jle    8010517a <show_process_info+0x29a>
    space(columns[4] - num_digits((int)p->sched_info.bjf.executed_cycle));
8010514e:	31 ff                	xor    %edi,%edi
80105150:	89 75 e0             	mov    %esi,-0x20(%ebp)
80105153:	89 fe                	mov    %edi,%esi
80105155:	89 c7                	mov    %eax,%edi
80105157:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010515e:	66 90                	xchg   %ax,%ax
    cprintf(" ");
80105160:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80105163:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
80105166:	68 7e 93 10 80       	push   $0x8010937e
8010516b:	e8 50 b7 ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
80105170:	83 c4 10             	add    $0x10,%esp
80105173:	39 fe                	cmp    %edi,%esi
80105175:	7c e9                	jl     80105160 <show_process_info+0x280>
80105177:	8b 75 e0             	mov    -0x20(%ebp),%esi

    cprintf("%d", p->sched_info.bjf.arrival_time);
8010517a:	83 ec 08             	sub    $0x8,%esp
8010517d:	ff b6 90 00 00 00    	pushl  0x90(%esi)
  int num = 0;
80105183:	31 ff                	xor    %edi,%edi
    cprintf("%d", p->sched_info.bjf.arrival_time);
80105185:	68 fb 92 10 80       	push   $0x801092fb
8010518a:	e8 31 b7 ff ff       	call   801008c0 <cprintf>
    space(columns[5] - num_digits(p->sched_info.bjf.arrival_time));
8010518f:	8b 8e 90 00 00 00    	mov    0x90(%esi),%ecx
  while(n!= 0) {
80105195:	83 c4 10             	add    $0x10,%esp
    space(columns[5] - num_digits(p->sched_info.bjf.arrival_time));
80105198:	b8 08 00 00 00       	mov    $0x8,%eax
  while(n!= 0) {
8010519d:	85 c9                	test   %ecx,%ecx
8010519f:	74 25                	je     801051c6 <show_process_info+0x2e6>
801051a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    n/=10;
801051a8:	89 c8                	mov    %ecx,%eax
801051aa:	c1 f9 1f             	sar    $0x1f,%ecx
    num += 1;
801051ad:	83 c7 01             	add    $0x1,%edi
    n/=10;
801051b0:	f7 eb                	imul   %ebx
801051b2:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
801051b5:	29 ca                	sub    %ecx,%edx
801051b7:	89 d1                	mov    %edx,%ecx
801051b9:	75 ed                	jne    801051a8 <show_process_info+0x2c8>
    space(columns[5] - num_digits(p->sched_info.bjf.arrival_time));
801051bb:	b8 08 00 00 00       	mov    $0x8,%eax
801051c0:	29 f8                	sub    %edi,%eax
  for(int i = 0; i < count; ++i)
801051c2:	85 c0                	test   %eax,%eax
801051c4:	7e 24                	jle    801051ea <show_process_info+0x30a>
    space(columns[5] - num_digits(p->sched_info.bjf.arrival_time));
801051c6:	31 ff                	xor    %edi,%edi
801051c8:	89 75 e0             	mov    %esi,-0x20(%ebp)
801051cb:	89 fe                	mov    %edi,%esi
801051cd:	89 c7                	mov    %eax,%edi
801051cf:	90                   	nop
    cprintf(" ");
801051d0:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
801051d3:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
801051d6:	68 7e 93 10 80       	push   $0x8010937e
801051db:	e8 e0 b6 ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
801051e0:	83 c4 10             	add    $0x10,%esp
801051e3:	39 fe                	cmp    %edi,%esi
801051e5:	7c e9                	jl     801051d0 <show_process_info+0x2f0>
801051e7:	8b 75 e0             	mov    -0x20(%ebp),%esi

    cprintf("%d", p->sched_info.bjf.priority);
801051ea:	83 ec 08             	sub    $0x8,%esp
801051ed:	ff b6 88 00 00 00    	pushl  0x88(%esi)
  int num = 0;
801051f3:	31 ff                	xor    %edi,%edi
    cprintf("%d", p->sched_info.bjf.priority);
801051f5:	68 fb 92 10 80       	push   $0x801092fb
801051fa:	e8 c1 b6 ff ff       	call   801008c0 <cprintf>
    space(columns[6] - num_digits(p->sched_info.bjf.priority));
801051ff:	8b 8e 88 00 00 00    	mov    0x88(%esi),%ecx
  while(n!= 0) {
80105205:	83 c4 10             	add    $0x10,%esp
    space(columns[6] - num_digits(p->sched_info.bjf.priority));
80105208:	b8 09 00 00 00       	mov    $0x9,%eax
  while(n!= 0) {
8010520d:	85 c9                	test   %ecx,%ecx
8010520f:	74 25                	je     80105236 <show_process_info+0x356>
80105211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    n/=10;
80105218:	89 c8                	mov    %ecx,%eax
8010521a:	c1 f9 1f             	sar    $0x1f,%ecx
    num += 1;
8010521d:	83 c7 01             	add    $0x1,%edi
    n/=10;
80105220:	f7 eb                	imul   %ebx
80105222:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
80105225:	29 ca                	sub    %ecx,%edx
80105227:	89 d1                	mov    %edx,%ecx
80105229:	75 ed                	jne    80105218 <show_process_info+0x338>
    space(columns[6] - num_digits(p->sched_info.bjf.priority));
8010522b:	b8 09 00 00 00       	mov    $0x9,%eax
80105230:	29 f8                	sub    %edi,%eax
  for(int i = 0; i < count; ++i)
80105232:	85 c0                	test   %eax,%eax
80105234:	7e 24                	jle    8010525a <show_process_info+0x37a>
    space(columns[6] - num_digits(p->sched_info.bjf.priority));
80105236:	31 ff                	xor    %edi,%edi
80105238:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010523b:	89 fe                	mov    %edi,%esi
8010523d:	89 c7                	mov    %eax,%edi
8010523f:	90                   	nop
    cprintf(" ");
80105240:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80105243:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
80105246:	68 7e 93 10 80       	push   $0x8010937e
8010524b:	e8 70 b6 ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
80105250:	83 c4 10             	add    $0x10,%esp
80105253:	39 fe                	cmp    %edi,%esi
80105255:	7c e9                	jl     80105240 <show_process_info+0x360>
80105257:	8b 75 e0             	mov    -0x20(%ebp),%esi

    cprintf("%d", (int)p->sched_info.bjf.priority_ratio);
8010525a:	d9 86 8c 00 00 00    	flds   0x8c(%esi)
80105260:	83 ec 08             	sub    $0x8,%esp
  int num = 0;
80105263:	31 ff                	xor    %edi,%edi
    cprintf("%d", (int)p->sched_info.bjf.priority_ratio);
80105265:	d9 7d e6             	fnstcw -0x1a(%ebp)
80105268:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
8010526c:	80 cc 0c             	or     $0xc,%ah
8010526f:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80105273:	d9 6d e4             	fldcw  -0x1c(%ebp)
80105276:	db 5d e0             	fistpl -0x20(%ebp)
80105279:	d9 6d e6             	fldcw  -0x1a(%ebp)
8010527c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010527f:	50                   	push   %eax
80105280:	68 fb 92 10 80       	push   $0x801092fb
80105285:	e8 36 b6 ff ff       	call   801008c0 <cprintf>
    space(columns[7] - num_digits((int)p->sched_info.bjf.priority_ratio));
8010528a:	d9 86 8c 00 00 00    	flds   0x8c(%esi)
  while(n!= 0) {
80105290:	83 c4 10             	add    $0x10,%esp
    space(columns[7] - num_digits((int)p->sched_info.bjf.priority_ratio));
80105293:	d9 7d e6             	fnstcw -0x1a(%ebp)
80105296:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
8010529a:	80 cc 0c             	or     $0xc,%ah
8010529d:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
801052a1:	b8 08 00 00 00       	mov    $0x8,%eax
801052a6:	d9 6d e4             	fldcw  -0x1c(%ebp)
801052a9:	db 5d e0             	fistpl -0x20(%ebp)
801052ac:	d9 6d e6             	fldcw  -0x1a(%ebp)
801052af:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  while(n!= 0) {
801052b2:	85 c9                	test   %ecx,%ecx
801052b4:	74 28                	je     801052de <show_process_info+0x3fe>
801052b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052bd:	8d 76 00             	lea    0x0(%esi),%esi
    n/=10;
801052c0:	89 c8                	mov    %ecx,%eax
801052c2:	c1 f9 1f             	sar    $0x1f,%ecx
    num += 1;
801052c5:	83 c7 01             	add    $0x1,%edi
    n/=10;
801052c8:	f7 eb                	imul   %ebx
801052ca:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
801052cd:	29 ca                	sub    %ecx,%edx
801052cf:	89 d1                	mov    %edx,%ecx
801052d1:	75 ed                	jne    801052c0 <show_process_info+0x3e0>
    space(columns[7] - num_digits((int)p->sched_info.bjf.priority_ratio));
801052d3:	b8 08 00 00 00       	mov    $0x8,%eax
801052d8:	29 f8                	sub    %edi,%eax
  for(int i = 0; i < count; ++i)
801052da:	85 c0                	test   %eax,%eax
801052dc:	7e 3a                	jle    80105318 <show_process_info+0x438>
    space(columns[7] - num_digits((int)p->sched_info.bjf.priority_ratio));
801052de:	31 ff                	xor    %edi,%edi
801052e0:	89 75 e0             	mov    %esi,-0x20(%ebp)
801052e3:	89 fe                	mov    %edi,%esi
801052e5:	89 c7                	mov    %eax,%edi
801052e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052ee:	66 90                	xchg   %ax,%ax
    cprintf(" ");
801052f0:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
801052f3:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
801052f6:	68 7e 93 10 80       	push   $0x8010937e
801052fb:	e8 c0 b5 ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
80105300:	83 c4 10             	add    $0x10,%esp
80105303:	39 fe                	cmp    %edi,%esi
80105305:	7c e9                	jl     801052f0 <show_process_info+0x410>
80105307:	d9 7d e6             	fnstcw -0x1a(%ebp)
8010530a:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010530d:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
80105311:	80 cc 0c             	or     $0xc,%ah
80105314:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)

    cprintf("%d", (int)p->sched_info.bjf.arrival_time_ratio);
80105318:	d9 86 94 00 00 00    	flds   0x94(%esi)
8010531e:	83 ec 08             	sub    $0x8,%esp
  int num = 0;
80105321:	31 ff                	xor    %edi,%edi
    cprintf("%d", (int)p->sched_info.bjf.arrival_time_ratio);
80105323:	d9 6d e4             	fldcw  -0x1c(%ebp)
80105326:	db 5d e0             	fistpl -0x20(%ebp)
80105329:	d9 6d e6             	fldcw  -0x1a(%ebp)
8010532c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010532f:	50                   	push   %eax
80105330:	68 fb 92 10 80       	push   $0x801092fb
80105335:	e8 86 b5 ff ff       	call   801008c0 <cprintf>
    space(columns[8] - num_digits((int)p->sched_info.bjf.arrival_time_ratio));
8010533a:	d9 86 94 00 00 00    	flds   0x94(%esi)
  while(n!= 0) {
80105340:	83 c4 10             	add    $0x10,%esp
    space(columns[8] - num_digits((int)p->sched_info.bjf.arrival_time_ratio));
80105343:	d9 7d e6             	fnstcw -0x1a(%ebp)
80105346:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
8010534a:	80 cc 0c             	or     $0xc,%ah
8010534d:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80105351:	b8 08 00 00 00       	mov    $0x8,%eax
80105356:	d9 6d e4             	fldcw  -0x1c(%ebp)
80105359:	db 5d e0             	fistpl -0x20(%ebp)
8010535c:	d9 6d e6             	fldcw  -0x1a(%ebp)
8010535f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  while(n!= 0) {
80105362:	85 c9                	test   %ecx,%ecx
80105364:	74 28                	je     8010538e <show_process_info+0x4ae>
80105366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010536d:	8d 76 00             	lea    0x0(%esi),%esi
    n/=10;
80105370:	89 c8                	mov    %ecx,%eax
80105372:	c1 f9 1f             	sar    $0x1f,%ecx
    num += 1;
80105375:	83 c7 01             	add    $0x1,%edi
    n/=10;
80105378:	f7 eb                	imul   %ebx
8010537a:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
8010537d:	29 ca                	sub    %ecx,%edx
8010537f:	89 d1                	mov    %edx,%ecx
80105381:	75 ed                	jne    80105370 <show_process_info+0x490>
    space(columns[8] - num_digits((int)p->sched_info.bjf.arrival_time_ratio));
80105383:	b8 08 00 00 00       	mov    $0x8,%eax
80105388:	29 f8                	sub    %edi,%eax
  for(int i = 0; i < count; ++i)
8010538a:	85 c0                	test   %eax,%eax
8010538c:	7e 3a                	jle    801053c8 <show_process_info+0x4e8>
    space(columns[8] - num_digits((int)p->sched_info.bjf.arrival_time_ratio));
8010538e:	31 ff                	xor    %edi,%edi
80105390:	89 75 e0             	mov    %esi,-0x20(%ebp)
80105393:	89 fe                	mov    %edi,%esi
80105395:	89 c7                	mov    %eax,%edi
80105397:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010539e:	66 90                	xchg   %ax,%ax
    cprintf(" ");
801053a0:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
801053a3:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
801053a6:	68 7e 93 10 80       	push   $0x8010937e
801053ab:	e8 10 b5 ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
801053b0:	83 c4 10             	add    $0x10,%esp
801053b3:	39 fe                	cmp    %edi,%esi
801053b5:	7c e9                	jl     801053a0 <show_process_info+0x4c0>
801053b7:	d9 7d e6             	fnstcw -0x1a(%ebp)
801053ba:	8b 75 e0             	mov    -0x20(%ebp),%esi
801053bd:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
801053c1:	80 cc 0c             	or     $0xc,%ah
801053c4:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)

    cprintf("%d", (int)p->sched_info.bjf.executed_cycle_ratio);
801053c8:	d9 86 9c 00 00 00    	flds   0x9c(%esi)
801053ce:	83 ec 08             	sub    $0x8,%esp
  int num = 0;
801053d1:	31 ff                	xor    %edi,%edi
    cprintf("%d", (int)p->sched_info.bjf.executed_cycle_ratio);
801053d3:	d9 6d e4             	fldcw  -0x1c(%ebp)
801053d6:	db 5d e0             	fistpl -0x20(%ebp)
801053d9:	d9 6d e6             	fldcw  -0x1a(%ebp)
801053dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801053df:	50                   	push   %eax
801053e0:	68 fb 92 10 80       	push   $0x801092fb
801053e5:	e8 d6 b4 ff ff       	call   801008c0 <cprintf>
    space(columns[9] - num_digits((int)p->sched_info.bjf.executed_cycle_ratio));
801053ea:	d9 86 9c 00 00 00    	flds   0x9c(%esi)
  while(n!= 0) {
801053f0:	83 c4 10             	add    $0x10,%esp
    space(columns[9] - num_digits((int)p->sched_info.bjf.executed_cycle_ratio));
801053f3:	d9 7d e6             	fnstcw -0x1a(%ebp)
801053f6:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
801053fa:	80 cc 0c             	or     $0xc,%ah
801053fd:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
80105401:	b8 08 00 00 00       	mov    $0x8,%eax
80105406:	d9 6d e4             	fldcw  -0x1c(%ebp)
80105409:	db 5d e0             	fistpl -0x20(%ebp)
8010540c:	d9 6d e6             	fldcw  -0x1a(%ebp)
8010540f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  while(n!= 0) {
80105412:	85 c9                	test   %ecx,%ecx
80105414:	74 28                	je     8010543e <show_process_info+0x55e>
80105416:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010541d:	8d 76 00             	lea    0x0(%esi),%esi
    n/=10;
80105420:	89 c8                	mov    %ecx,%eax
80105422:	c1 f9 1f             	sar    $0x1f,%ecx
    num += 1;
80105425:	83 c7 01             	add    $0x1,%edi
    n/=10;
80105428:	f7 eb                	imul   %ebx
8010542a:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
8010542d:	29 ca                	sub    %ecx,%edx
8010542f:	89 d1                	mov    %edx,%ecx
80105431:	75 ed                	jne    80105420 <show_process_info+0x540>
    space(columns[9] - num_digits((int)p->sched_info.bjf.executed_cycle_ratio));
80105433:	b8 08 00 00 00       	mov    $0x8,%eax
80105438:	29 f8                	sub    %edi,%eax
  for(int i = 0; i < count; ++i)
8010543a:	85 c0                	test   %eax,%eax
8010543c:	7e 3a                	jle    80105478 <show_process_info+0x598>
    space(columns[9] - num_digits((int)p->sched_info.bjf.executed_cycle_ratio));
8010543e:	31 ff                	xor    %edi,%edi
80105440:	89 75 e0             	mov    %esi,-0x20(%ebp)
80105443:	89 fe                	mov    %edi,%esi
80105445:	89 c7                	mov    %eax,%edi
80105447:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010544e:	66 90                	xchg   %ax,%ax
    cprintf(" ");
80105450:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80105453:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
80105456:	68 7e 93 10 80       	push   $0x8010937e
8010545b:	e8 60 b4 ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
80105460:	83 c4 10             	add    $0x10,%esp
80105463:	39 fe                	cmp    %edi,%esi
80105465:	7c e9                	jl     80105450 <show_process_info+0x570>
80105467:	d9 7d e6             	fnstcw -0x1a(%ebp)
8010546a:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010546d:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
80105471:	80 cc 0c             	or     $0xc,%ah
80105474:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)

    cprintf("%d", (int)p->sched_info.bjf.process_size_ratio);
80105478:	d9 86 a4 00 00 00    	flds   0xa4(%esi)
8010547e:	83 ec 08             	sub    $0x8,%esp
  int num = 0;
80105481:	31 ff                	xor    %edi,%edi
    cprintf("%d", (int)p->sched_info.bjf.process_size_ratio);
80105483:	d9 6d e4             	fldcw  -0x1c(%ebp)
80105486:	db 5d e0             	fistpl -0x20(%ebp)
80105489:	d9 6d e6             	fldcw  -0x1a(%ebp)
8010548c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010548f:	50                   	push   %eax
80105490:	68 fb 92 10 80       	push   $0x801092fb
80105495:	e8 26 b4 ff ff       	call   801008c0 <cprintf>
    space(columns[10] - num_digits((int)p->sched_info.bjf.process_size_ratio));
8010549a:	d9 86 a4 00 00 00    	flds   0xa4(%esi)
  while(n!= 0) {
801054a0:	83 c4 10             	add    $0x10,%esp
    space(columns[10] - num_digits((int)p->sched_info.bjf.process_size_ratio));
801054a3:	d9 7d e6             	fnstcw -0x1a(%ebp)
801054a6:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
801054aa:	80 cc 0c             	or     $0xc,%ah
801054ad:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
801054b1:	b8 08 00 00 00       	mov    $0x8,%eax
801054b6:	d9 6d e4             	fldcw  -0x1c(%ebp)
801054b9:	db 55 e0             	fistl  -0x20(%ebp)
801054bc:	d9 6d e6             	fldcw  -0x1a(%ebp)
801054bf:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  while(n!= 0) {
801054c2:	85 c9                	test   %ecx,%ecx
801054c4:	74 32                	je     801054f8 <show_process_info+0x618>
801054c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054cd:	8d 76 00             	lea    0x0(%esi),%esi
    n/=10;
801054d0:	89 c8                	mov    %ecx,%eax
801054d2:	c1 f9 1f             	sar    $0x1f,%ecx
    num += 1;
801054d5:	83 c7 01             	add    $0x1,%edi
    n/=10;
801054d8:	f7 eb                	imul   %ebx
801054da:	c1 fa 02             	sar    $0x2,%edx
  while(n!= 0) {
801054dd:	29 ca                	sub    %ecx,%edx
801054df:	89 d1                	mov    %edx,%ecx
801054e1:	75 ed                	jne    801054d0 <show_process_info+0x5f0>
    space(columns[10] - num_digits((int)p->sched_info.bjf.process_size_ratio));
801054e3:	b8 08 00 00 00       	mov    $0x8,%eax
801054e8:	29 f8                	sub    %edi,%eax
  for(int i = 0; i < count; ++i)
801054ea:	85 c0                	test   %eax,%eax
801054ec:	7e 50                	jle    8010553e <show_process_info+0x65e>
801054ee:	dd d8                	fstp   %st(0)
801054f0:	eb 0e                	jmp    80105500 <show_process_info+0x620>
801054f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801054f8:	dd d8                	fstp   %st(0)
801054fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    space(columns[10] - num_digits((int)p->sched_info.bjf.process_size_ratio));
80105500:	31 ff                	xor    %edi,%edi
80105502:	89 75 e0             	mov    %esi,-0x20(%ebp)
80105505:	89 fe                	mov    %edi,%esi
80105507:	89 c7                	mov    %eax,%edi
80105509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" ");
80105510:	83 ec 0c             	sub    $0xc,%esp
  for(int i = 0; i < count; ++i)
80105513:	83 c6 01             	add    $0x1,%esi
    cprintf(" ");
80105516:	68 7e 93 10 80       	push   $0x8010937e
8010551b:	e8 a0 b3 ff ff       	call   801008c0 <cprintf>
  for(int i = 0; i < count; ++i)
80105520:	83 c4 10             	add    $0x10,%esp
80105523:	39 fe                	cmp    %edi,%esi
80105525:	7c e9                	jl     80105510 <show_process_info+0x630>
80105527:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010552a:	d9 86 a4 00 00 00    	flds   0xa4(%esi)
80105530:	d9 7d e6             	fnstcw -0x1a(%ebp)
80105533:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
80105537:	80 cc 0c             	or     $0xc,%ah
8010553a:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
         p->sched_info.bjf.arrival_time * p->sched_info.bjf.arrival_time_ratio +
8010553e:	db 86 90 00 00 00    	fildl  0x90(%esi)
80105544:	d8 8e 94 00 00 00    	fmuls  0x94(%esi)

    cprintf("%d", (int)bjfrank(p));
8010554a:	83 ec 08             	sub    $0x8,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010554d:	81 c6 ac 00 00 00    	add    $0xac,%esi
  return p->sched_info.bjf.priority * p->sched_info.bjf.priority_ratio +
80105553:	db 46 dc             	fildl  -0x24(%esi)
80105556:	d8 4e e0             	fmuls  -0x20(%esi)
80105559:	de c1                	faddp  %st,%st(1)
         p->sched_info.bjf.executed_cycle * p->sched_info.bjf.executed_cycle_ratio +
8010555b:	d9 46 ec             	flds   -0x14(%esi)
8010555e:	d8 4e f0             	fmuls  -0x10(%esi)
         p->sched_info.bjf.arrival_time * p->sched_info.bjf.arrival_time_ratio +
80105561:	de c1                	faddp  %st,%st(1)
         p->sched_info.bjf.process_size * p->sched_info.bjf.process_size_ratio;
80105563:	db 46 f4             	fildl  -0xc(%esi)
80105566:	de ca                	fmulp  %st,%st(2)
         p->sched_info.bjf.executed_cycle * p->sched_info.bjf.executed_cycle_ratio +
80105568:	de c1                	faddp  %st,%st(1)
    cprintf("%d", (int)bjfrank(p));
8010556a:	d9 6d e4             	fldcw  -0x1c(%ebp)
8010556d:	db 5d e0             	fistpl -0x20(%ebp)
80105570:	d9 6d e6             	fldcw  -0x1a(%ebp)
80105573:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105576:	50                   	push   %eax
80105577:	68 fb 92 10 80       	push   $0x801092fb
8010557c:	e8 3f b3 ff ff       	call   801008c0 <cprintf>
    cprintf("\n");
80105581:	c7 04 24 05 93 10 80 	movl   $0x80109305,(%esp)
80105588:	e8 33 b3 ff ff       	call   801008c0 <cprintf>
8010558d:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105590:	81 fe 94 7e 11 80    	cmp    $0x80117e94,%esi
80105596:	0f 85 86 f9 ff ff    	jne    80104f22 <show_process_info+0x42>
  }
}
8010559c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010559f:	5b                   	pop    %ebx
801055a0:	5e                   	pop    %esi
801055a1:	5f                   	pop    %edi
801055a2:	5d                   	pop    %ebp
801055a3:	c3                   	ret    
801055a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055af:	90                   	nop

801055b0 <priority_wakeup>:

void priority_wakeup(void* chan){
801055b0:	f3 0f 1e fb          	endbr32 
801055b4:	55                   	push   %ebp
801055b5:	89 e5                	mov    %esp,%ebp
801055b7:	56                   	push   %esi
801055b8:	53                   	push   %ebx
801055b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801055bc:	83 ec 0c             	sub    $0xc,%esp
801055bf:	68 60 53 11 80       	push   $0x80115360
801055c4:	e8 77 06 00 00       	call   80105c40 <acquire>
801055c9:	83 c4 10             	add    $0x10,%esp
  struct proc *p;
  struct proc * p_max_pid = 0 ;
  int first = 1 ; 
801055cc:	b9 01 00 00 00       	mov    $0x1,%ecx
  struct proc * p_max_pid = 0 ;
801055d1:	31 d2                	xor    %edx,%edx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801055d3:	b8 94 53 11 80       	mov    $0x80115394,%eax
801055d8:	eb 12                	jmp    801055ec <priority_wakeup+0x3c>
801055da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801055e0:	05 ac 00 00 00       	add    $0xac,%eax
801055e5:	3d 94 7e 11 80       	cmp    $0x80117e94,%eax
801055ea:	74 24                	je     80105610 <priority_wakeup+0x60>
    if(p->state == SLEEPING && p->chan == chan){
801055ec:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801055f0:	75 ee                	jne    801055e0 <priority_wakeup+0x30>
801055f2:	39 58 20             	cmp    %ebx,0x20(%eax)
801055f5:	75 e9                	jne    801055e0 <priority_wakeup+0x30>
      if(first){
801055f7:	85 c9                	test   %ecx,%ecx
801055f9:	75 35                	jne    80105630 <priority_wakeup+0x80>
        p_max_pid = p;
        first = 0;
      }
      else{
        if(p->pid > p_max_pid->pid){
801055fb:	8b 72 10             	mov    0x10(%edx),%esi
801055fe:	39 70 10             	cmp    %esi,0x10(%eax)
80105601:	0f 4f d0             	cmovg  %eax,%edx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105604:	05 ac 00 00 00       	add    $0xac,%eax
80105609:	3d 94 7e 11 80       	cmp    $0x80117e94,%eax
8010560e:	75 dc                	jne    801055ec <priority_wakeup+0x3c>
          p_max_pid = p;
        }
      }
    }
  }
  if (p_max_pid)
80105610:	85 d2                	test   %edx,%edx
80105612:	74 07                	je     8010561b <priority_wakeup+0x6b>
  {
      p_max_pid->state = RUNNABLE;
80105614:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)

    
  }
  
  release(&ptable.lock);
8010561b:	c7 45 08 60 53 11 80 	movl   $0x80115360,0x8(%ebp)
}
80105622:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105625:	5b                   	pop    %ebx
80105626:	5e                   	pop    %esi
80105627:	5d                   	pop    %ebp
  release(&ptable.lock);
80105628:	e9 d3 06 00 00       	jmp    80105d00 <release>
8010562d:	8d 76 00             	lea    0x0(%esi),%esi
80105630:	89 c2                	mov    %eax,%edx
        first = 0;
80105632:	31 c9                	xor    %ecx,%ecx
80105634:	eb aa                	jmp    801055e0 <priority_wakeup+0x30>
80105636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010563d:	8d 76 00             	lea    0x0(%esi),%esi

80105640 <compare_pid>:

int compare_pid(const void *a, const void *b) {
80105640:	f3 0f 1e fb          	endbr32 
80105644:	55                   	push   %ebp
80105645:	89 e5                	mov    %esp,%ebp
  struct proc *procA = (struct proc *)a;
  struct proc *procB = (struct proc *)b;
  return procA->pid - procB->pid;
80105647:	8b 45 08             	mov    0x8(%ebp),%eax
8010564a:	8b 55 0c             	mov    0xc(%ebp),%edx
}
8010564d:	5d                   	pop    %ebp
  return procA->pid - procB->pid;
8010564e:	8b 40 10             	mov    0x10(%eax),%eax
80105651:	2b 42 10             	sub    0x10(%edx),%eax
}
80105654:	c3                   	ret    
80105655:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010565c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105660 <make_priority_queue>:


void make_priority_queue(void * chan) {
80105660:	f3 0f 1e fb          	endbr32 
80105664:	55                   	push   %ebp
80105665:	89 e5                	mov    %esp,%ebp
80105667:	57                   	push   %edi
    // Handle the allocation failure 
    release(&ptable.lock);
    return;
  }*/

  int first = 1;
80105668:	bf 01 00 00 00       	mov    $0x1,%edi
void make_priority_queue(void * chan) {
8010566d:	56                   	push   %esi
8010566e:	53                   	push   %ebx
  int i = 0;
  cprintf("Queue: \n" );
  // Populate the queue with processes that match the channel
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010566f:	bb 94 53 11 80       	mov    $0x80115394,%ebx
void make_priority_queue(void * chan) {
80105674:	83 ec 18             	sub    $0x18,%esp
80105677:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&ptable.lock); // Lock the ptable before making changes
8010567a:	68 60 53 11 80       	push   $0x80115360
8010567f:	e8 bc 05 00 00       	call   80105c40 <acquire>
  cprintf("Queue: \n" );
80105684:	c7 04 24 fe 92 10 80 	movl   $0x801092fe,(%esp)
8010568b:	e8 30 b2 ff ff       	call   801008c0 <cprintf>
80105690:	83 c4 10             	add    $0x10,%esp
  struct proc *proc_queue = 0;
80105693:	31 d2                	xor    %edx,%edx
80105695:	eb 17                	jmp    801056ae <make_priority_queue+0x4e>
80105697:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010569e:	66 90                	xchg   %ax,%ax
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801056a0:	81 c3 ac 00 00 00    	add    $0xac,%ebx
801056a6:	81 fb 94 7e 11 80    	cmp    $0x80117e94,%ebx
801056ac:	74 42                	je     801056f0 <make_priority_queue+0x90>
    if (p->state == SLEEPING && p->chan == chan) {
801056ae:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801056b2:	75 ec                	jne    801056a0 <make_priority_queue+0x40>
801056b4:	39 73 20             	cmp    %esi,0x20(%ebx)
801056b7:	75 e7                	jne    801056a0 <make_priority_queue+0x40>
      if(first){
801056b9:	85 ff                	test   %edi,%edi
801056bb:	75 63                	jne    80105720 <make_priority_queue+0xc0>
801056bd:	8b 43 10             	mov    0x10(%ebx),%eax
        proc_queue = p ;
        first = 0;
        i ++;
        cprintf("Pid %d , Name: %s \n", p->pid , p->name );
      }
      else if(p->pid > proc_queue->pid){
801056c0:	39 42 10             	cmp    %eax,0x10(%edx)
801056c3:	7d db                	jge    801056a0 <make_priority_queue+0x40>
        proc_queue = p ;
        i ++ ;
        cprintf("Pid %d , Name: %s \n", p->pid , p->name );
801056c5:	83 ec 04             	sub    $0x4,%esp
801056c8:	8d 53 6c             	lea    0x6c(%ebx),%edx
801056cb:	52                   	push   %edx
801056cc:	50                   	push   %eax
801056cd:	68 07 93 10 80       	push   $0x80109307
801056d2:	e8 e9 b1 ff ff       	call   801008c0 <cprintf>
801056d7:	89 da                	mov    %ebx,%edx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801056d9:	81 c3 ac 00 00 00    	add    $0xac,%ebx
        cprintf("Pid %d , Name: %s \n", p->pid , p->name );
801056df:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801056e2:	81 fb 94 7e 11 80    	cmp    $0x80117e94,%ebx
801056e8:	75 c4                	jne    801056ae <make_priority_queue+0x4e>
801056ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      }
    }
  }
  if(first){
801056f0:	85 ff                	test   %edi,%edi
801056f2:	74 4c                	je     80105740 <make_priority_queue+0xe0>
    cprintf("Queue is empty\n");
801056f4:	83 ec 0c             	sub    $0xc,%esp
801056f7:	68 1b 93 10 80       	push   $0x8010931b
801056fc:	e8 bf b1 ff ff       	call   801008c0 <cprintf>
80105701:	83 c4 10             	add    $0x10,%esp
  // Sort the queue by pid using the comparison function
  //qsort(proc_queue, i, sizeof(struct proc), compare_pid);
  


  release(&ptable.lock); // Release the lock after modifications are done
80105704:	c7 45 08 60 53 11 80 	movl   $0x80115360,0x8(%ebp)
}
8010570b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010570e:	5b                   	pop    %ebx
8010570f:	5e                   	pop    %esi
80105710:	5f                   	pop    %edi
80105711:	5d                   	pop    %ebp
  release(&ptable.lock); // Release the lock after modifications are done
80105712:	e9 e9 05 00 00       	jmp    80105d00 <release>
80105717:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010571e:	66 90                	xchg   %ax,%ax
        cprintf("Pid %d , Name: %s \n", p->pid , p->name );
80105720:	83 ec 04             	sub    $0x4,%esp
80105723:	8d 43 6c             	lea    0x6c(%ebx),%eax
        first = 0;
80105726:	31 ff                	xor    %edi,%edi
        cprintf("Pid %d , Name: %s \n", p->pid , p->name );
80105728:	50                   	push   %eax
80105729:	ff 73 10             	pushl  0x10(%ebx)
8010572c:	68 07 93 10 80       	push   $0x80109307
80105731:	e8 8a b1 ff ff       	call   801008c0 <cprintf>
80105736:	83 c4 10             	add    $0x10,%esp
80105739:	89 da                	mov    %ebx,%edx
8010573b:	e9 60 ff ff ff       	jmp    801056a0 <make_priority_queue+0x40>
    cprintf("Now it is pid %d's turn\n");
80105740:	83 ec 0c             	sub    $0xc,%esp
80105743:	68 2b 93 10 80       	push   $0x8010932b
80105748:	e8 73 b1 ff ff       	call   801008c0 <cprintf>
8010574d:	83 c4 10             	add    $0x10,%esp
80105750:	eb b2                	jmp    80105704 <make_priority_queue+0xa4>
80105752:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105760 <priorityLock_test>:


void priorityLock_test(){
80105760:	f3 0f 1e fb          	endbr32 
80105764:	55                   	push   %ebp
80105765:	89 e5                	mov    %esp,%ebp
80105767:	53                   	push   %ebx
80105768:	83 ec 14             	sub    $0x14,%esp
  pushcli();
8010576b:	e8 d0 03 00 00       	call   80105b40 <pushcli>
  c = mycpu();
80105770:	e8 eb e6 ff ff       	call   80103e60 <mycpu>
  p = c->proc;
80105775:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010577b:	e8 10 04 00 00       	call   80105b90 <popcli>
  cprintf("Process pid:%d want access to critical section\n" , myproc()->pid);
80105780:	83 ec 08             	sub    $0x8,%esp
80105783:	ff 73 10             	pushl  0x10(%ebx)
80105786:	68 78 94 10 80       	push   $0x80109478
8010578b:	e8 30 b1 ff ff       	call   801008c0 <cprintf>
  acquirePriorityLock(&lock);
80105790:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80105797:	e8 04 02 00 00       	call   801059a0 <acquirePriorityLock>
  pushcli();
8010579c:	e8 9f 03 00 00       	call   80105b40 <pushcli>
  c = mycpu();
801057a1:	e8 ba e6 ff ff       	call   80103e60 <mycpu>
  p = c->proc;
801057a6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801057ac:	e8 df 03 00 00       	call   80105b90 <popcli>
  cprintf("Process pid:%d acquired access to critical section\n" , myproc()->pid);
801057b1:	59                   	pop    %ecx
801057b2:	58                   	pop    %eax
801057b3:	ff 73 10             	pushl  0x10(%ebx)
801057b6:	68 a8 94 10 80       	push   $0x801094a8
801057bb:	e8 00 b1 ff ff       	call   801008c0 <cprintf>
  volatile long long temp = 0;
801057c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801057c7:	83 c4 10             	add    $0x10,%esp
801057ca:	31 c9                	xor    %ecx,%ecx
801057cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  for (long long l = 0; l < 200000000; l++){
801057d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057d7:	90                   	nop
    temp += 5 * 7 + 1;
801057d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057db:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057de:	83 c0 24             	add    $0x24,%eax
801057e1:	83 d2 00             	adc    $0x0,%edx
801057e4:	83 c1 01             	add    $0x1,%ecx
801057e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
801057ea:	89 55 f4             	mov    %edx,-0xc(%ebp)
  for (long long l = 0; l < 200000000; l++){
801057ed:	81 f9 00 c2 eb 0b    	cmp    $0xbebc200,%ecx
801057f3:	75 e3                	jne    801057d8 <priorityLock_test+0x78>
  }
            
  make_priority_queue(&lock);
801057f5:	83 ec 0c             	sub    $0xc,%esp
801057f8:	68 e0 c5 10 80       	push   $0x8010c5e0
801057fd:	e8 5e fe ff ff       	call   80105660 <make_priority_queue>
  releasePriorityLock(&lock);
80105802:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80105809:	e8 f2 01 00 00       	call   80105a00 <releasePriorityLock>
  pushcli();
8010580e:	e8 2d 03 00 00       	call   80105b40 <pushcli>
  c = mycpu();
80105813:	e8 48 e6 ff ff       	call   80103e60 <mycpu>
  p = c->proc;
80105818:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010581e:	e8 6d 03 00 00       	call   80105b90 <popcli>
  cprintf("Process pid: %d exited from critical section\n" , myproc()->pid);
80105823:	58                   	pop    %eax
80105824:	5a                   	pop    %edx
80105825:	ff 73 10             	pushl  0x10(%ebx)
80105828:	68 dc 94 10 80       	push   $0x801094dc
8010582d:	e8 8e b0 ff ff       	call   801008c0 <cprintf>
}
80105832:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105835:	83 c4 10             	add    $0x10,%esp
80105838:	c9                   	leave  
80105839:	c3                   	ret    
8010583a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105840 <init_queue_test>:

void
init_queue_test(void){
80105840:	f3 0f 1e fb          	endbr32 
80105844:	55                   	push   %ebp
80105845:	89 e5                	mov    %esp,%ebp
80105847:	83 ec 14             	sub    $0x14,%esp
  initPriorityLock(&lock);
8010584a:	68 e0 c5 10 80       	push   $0x8010c5e0
8010584f:	e8 ec 01 00 00       	call   80105a40 <initPriorityLock>
80105854:	83 c4 10             	add    $0x10,%esp
80105857:	c9                   	leave  
80105858:	c3                   	ret    
80105859:	66 90                	xchg   %ax,%ax
8010585b:	66 90                	xchg   %ax,%ax
8010585d:	66 90                	xchg   %ax,%ax
8010585f:	90                   	nop

80105860 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80105860:	f3 0f 1e fb          	endbr32 
80105864:	55                   	push   %ebp
80105865:	89 e5                	mov    %esp,%ebp
80105867:	53                   	push   %ebx
80105868:	83 ec 0c             	sub    $0xc,%esp
8010586b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010586e:	68 44 95 10 80       	push   $0x80109544
80105873:	8d 43 04             	lea    0x4(%ebx),%eax
80105876:	50                   	push   %eax
80105877:	e8 44 02 00 00       	call   80105ac0 <initlock>
  lk->name = name;
8010587c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010587f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80105885:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80105888:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010588f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80105892:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105895:	c9                   	leave  
80105896:	c3                   	ret    
80105897:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010589e:	66 90                	xchg   %ax,%ax

801058a0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801058a0:	f3 0f 1e fb          	endbr32 
801058a4:	55                   	push   %ebp
801058a5:	89 e5                	mov    %esp,%ebp
801058a7:	56                   	push   %esi
801058a8:	53                   	push   %ebx
801058a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801058ac:	8d 73 04             	lea    0x4(%ebx),%esi
801058af:	83 ec 0c             	sub    $0xc,%esp
801058b2:	56                   	push   %esi
801058b3:	e8 88 03 00 00       	call   80105c40 <acquire>
  while (lk->locked) {
801058b8:	8b 13                	mov    (%ebx),%edx
801058ba:	83 c4 10             	add    $0x10,%esp
801058bd:	85 d2                	test   %edx,%edx
801058bf:	74 1a                	je     801058db <acquiresleep+0x3b>
801058c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
801058c8:	83 ec 08             	sub    $0x8,%esp
801058cb:	56                   	push   %esi
801058cc:	53                   	push   %ebx
801058cd:	e8 fe eb ff ff       	call   801044d0 <sleep>
  while (lk->locked) {
801058d2:	8b 03                	mov    (%ebx),%eax
801058d4:	83 c4 10             	add    $0x10,%esp
801058d7:	85 c0                	test   %eax,%eax
801058d9:	75 ed                	jne    801058c8 <acquiresleep+0x28>
  }
  lk->locked = 1;
801058db:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801058e1:	e8 0a e6 ff ff       	call   80103ef0 <myproc>
801058e6:	8b 40 10             	mov    0x10(%eax),%eax
801058e9:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801058ec:	89 75 08             	mov    %esi,0x8(%ebp)
}
801058ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801058f2:	5b                   	pop    %ebx
801058f3:	5e                   	pop    %esi
801058f4:	5d                   	pop    %ebp
  release(&lk->lk);
801058f5:	e9 06 04 00 00       	jmp    80105d00 <release>
801058fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105900 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105900:	f3 0f 1e fb          	endbr32 
80105904:	55                   	push   %ebp
80105905:	89 e5                	mov    %esp,%ebp
80105907:	56                   	push   %esi
80105908:	53                   	push   %ebx
80105909:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010590c:	8d 73 04             	lea    0x4(%ebx),%esi
8010590f:	83 ec 0c             	sub    $0xc,%esp
80105912:	56                   	push   %esi
80105913:	e8 28 03 00 00       	call   80105c40 <acquire>
  lk->locked = 0;
80105918:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010591e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80105925:	89 1c 24             	mov    %ebx,(%esp)
80105928:	e8 63 ed ff ff       	call   80104690 <wakeup>
  release(&lk->lk);
8010592d:	89 75 08             	mov    %esi,0x8(%ebp)
80105930:	83 c4 10             	add    $0x10,%esp
}
80105933:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105936:	5b                   	pop    %ebx
80105937:	5e                   	pop    %esi
80105938:	5d                   	pop    %ebp
  release(&lk->lk);
80105939:	e9 c2 03 00 00       	jmp    80105d00 <release>
8010593e:	66 90                	xchg   %ax,%ax

80105940 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80105940:	f3 0f 1e fb          	endbr32 
80105944:	55                   	push   %ebp
80105945:	89 e5                	mov    %esp,%ebp
80105947:	57                   	push   %edi
80105948:	31 ff                	xor    %edi,%edi
8010594a:	56                   	push   %esi
8010594b:	53                   	push   %ebx
8010594c:	83 ec 18             	sub    $0x18,%esp
8010594f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80105952:	8d 73 04             	lea    0x4(%ebx),%esi
80105955:	56                   	push   %esi
80105956:	e8 e5 02 00 00       	call   80105c40 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
8010595b:	8b 03                	mov    (%ebx),%eax
8010595d:	83 c4 10             	add    $0x10,%esp
80105960:	85 c0                	test   %eax,%eax
80105962:	75 1c                	jne    80105980 <holdingsleep+0x40>
  release(&lk->lk);
80105964:	83 ec 0c             	sub    $0xc,%esp
80105967:	56                   	push   %esi
80105968:	e8 93 03 00 00       	call   80105d00 <release>
  return r;
}
8010596d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105970:	89 f8                	mov    %edi,%eax
80105972:	5b                   	pop    %ebx
80105973:	5e                   	pop    %esi
80105974:	5f                   	pop    %edi
80105975:	5d                   	pop    %ebp
80105976:	c3                   	ret    
80105977:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010597e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80105980:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80105983:	e8 68 e5 ff ff       	call   80103ef0 <myproc>
80105988:	39 58 10             	cmp    %ebx,0x10(%eax)
8010598b:	0f 94 c0             	sete   %al
8010598e:	0f b6 c0             	movzbl %al,%eax
80105991:	89 c7                	mov    %eax,%edi
80105993:	eb cf                	jmp    80105964 <holdingsleep+0x24>
80105995:	66 90                	xchg   %ax,%ax
80105997:	66 90                	xchg   %ax,%ax
80105999:	66 90                	xchg   %ax,%ax
8010599b:	66 90                	xchg   %ax,%ax
8010599d:	66 90                	xchg   %ax,%ax
8010599f:	90                   	nop

801059a0 <acquirePriorityLock>:
#include "proc.h"
#include "spinlock.h"
#include "priorityLock.h"

void acquirePriorityLock(struct PriorityLock *lock)
{
801059a0:	f3 0f 1e fb          	endbr32 
801059a4:	55                   	push   %ebp
801059a5:	89 e5                	mov    %esp,%ebp
801059a7:	53                   	push   %ebx
801059a8:	83 ec 10             	sub    $0x10,%esp
801059ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	acquire(&lock->lock);
801059ae:	53                   	push   %ebx
801059af:	e8 8c 02 00 00       	call   80105c40 <acquire>
	while(lock->is_lock){
801059b4:	8b 53 34             	mov    0x34(%ebx),%edx
801059b7:	83 c4 10             	add    $0x10,%esp
801059ba:	85 d2                	test   %edx,%edx
801059bc:	74 16                	je     801059d4 <acquirePriorityLock+0x34>
801059be:	66 90                	xchg   %ax,%ax
		sleep(lock, &lock->lock);
801059c0:	83 ec 08             	sub    $0x8,%esp
801059c3:	53                   	push   %ebx
801059c4:	53                   	push   %ebx
801059c5:	e8 06 eb ff ff       	call   801044d0 <sleep>
	while(lock->is_lock){
801059ca:	8b 43 34             	mov    0x34(%ebx),%eax
801059cd:	83 c4 10             	add    $0x10,%esp
801059d0:	85 c0                	test   %eax,%eax
801059d2:	75 ec                	jne    801059c0 <acquirePriorityLock+0x20>
	}
	lock->is_lock = 1;
801059d4:	c7 43 34 01 00 00 00 	movl   $0x1,0x34(%ebx)
	lock->pid = myproc()->pid;	
801059db:	e8 10 e5 ff ff       	call   80103ef0 <myproc>
801059e0:	8b 40 10             	mov    0x10(%eax),%eax
801059e3:	89 43 38             	mov    %eax,0x38(%ebx)
	release(&lock->lock);
801059e6:	89 5d 08             	mov    %ebx,0x8(%ebp)

}
801059e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059ec:	c9                   	leave  
	release(&lock->lock);
801059ed:	e9 0e 03 00 00       	jmp    80105d00 <release>
801059f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a00 <releasePriorityLock>:


void releasePriorityLock(struct PriorityLock *lock)
{
80105a00:	f3 0f 1e fb          	endbr32 
80105a04:	55                   	push   %ebp
80105a05:	89 e5                	mov    %esp,%ebp
80105a07:	53                   	push   %ebx
80105a08:	83 ec 10             	sub    $0x10,%esp
80105a0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	acquire(&lock->lock);
80105a0e:	53                   	push   %ebx
80105a0f:	e8 2c 02 00 00       	call   80105c40 <acquire>
	lock->is_lock = 0;
80105a14:	c7 43 34 00 00 00 00 	movl   $0x0,0x34(%ebx)
	lock->pid = 0;
80105a1b:	c7 43 38 00 00 00 00 	movl   $0x0,0x38(%ebx)
	priority_wakeup(lock);
80105a22:	89 1c 24             	mov    %ebx,(%esp)
80105a25:	e8 86 fb ff ff       	call   801055b0 <priority_wakeup>
	release(&lock->lock);
80105a2a:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105a2d:	83 c4 10             	add    $0x10,%esp
}
80105a30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a33:	c9                   	leave  
	release(&lock->lock);
80105a34:	e9 c7 02 00 00       	jmp    80105d00 <release>
80105a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a40 <initPriorityLock>:

void initPriorityLock(struct PriorityLock * lock){
80105a40:	f3 0f 1e fb          	endbr32 
80105a44:	55                   	push   %ebp
80105a45:	89 e5                	mov    %esp,%ebp
80105a47:	53                   	push   %ebx
80105a48:	83 ec 0c             	sub    $0xc,%esp
80105a4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	initlock(&lock->lock , "priority lock");
80105a4e:	68 4f 95 10 80       	push   $0x8010954f
80105a53:	53                   	push   %ebx
80105a54:	e8 67 00 00 00       	call   80105ac0 <initlock>
	lock->is_lock = 0;
80105a59:	c7 43 34 00 00 00 00 	movl   $0x0,0x34(%ebx)
	lock->pid = 0;

}
80105a60:	83 c4 10             	add    $0x10,%esp
	lock->pid = 0;
80105a63:	c7 43 38 00 00 00 00 	movl   $0x0,0x38(%ebx)
}
80105a6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a6d:	c9                   	leave  
80105a6e:	c3                   	ret    
80105a6f:	90                   	nop

80105a70 <holdingPriorityLock>:

int
holdingPriorityLock(struct PriorityLock * lock)
{
80105a70:	f3 0f 1e fb          	endbr32 
80105a74:	55                   	push   %ebp
80105a75:	89 e5                	mov    %esp,%ebp
80105a77:	57                   	push   %edi
80105a78:	56                   	push   %esi
80105a79:	31 f6                	xor    %esi,%esi
80105a7b:	53                   	push   %ebx
80105a7c:	83 ec 18             	sub    $0x18,%esp
80105a7f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int ret = 0;
	acquire(&lock->lock);
80105a82:	53                   	push   %ebx
80105a83:	e8 b8 01 00 00       	call   80105c40 <acquire>
	ret = (lock->pid == myproc()->pid)&& lock->is_lock;
80105a88:	8b 7b 38             	mov    0x38(%ebx),%edi
80105a8b:	e8 60 e4 ff ff       	call   80103ef0 <myproc>
80105a90:	83 c4 10             	add    $0x10,%esp
80105a93:	3b 78 10             	cmp    0x10(%eax),%edi
80105a96:	75 0c                	jne    80105aa4 <holdingPriorityLock+0x34>
80105a98:	8b 53 34             	mov    0x34(%ebx),%edx
80105a9b:	31 c0                	xor    %eax,%eax
80105a9d:	85 d2                	test   %edx,%edx
80105a9f:	0f 95 c0             	setne  %al
80105aa2:	89 c6                	mov    %eax,%esi
	release(&lock->lock);
80105aa4:	83 ec 0c             	sub    $0xc,%esp
80105aa7:	53                   	push   %ebx
80105aa8:	e8 53 02 00 00       	call   80105d00 <release>
	return ret;
80105aad:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ab0:	89 f0                	mov    %esi,%eax
80105ab2:	5b                   	pop    %ebx
80105ab3:	5e                   	pop    %esi
80105ab4:	5f                   	pop    %edi
80105ab5:	5d                   	pop    %ebp
80105ab6:	c3                   	ret    
80105ab7:	66 90                	xchg   %ax,%ax
80105ab9:	66 90                	xchg   %ax,%ax
80105abb:	66 90                	xchg   %ax,%ax
80105abd:	66 90                	xchg   %ax,%ax
80105abf:	90                   	nop

80105ac0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105ac0:	f3 0f 1e fb          	endbr32 
80105ac4:	55                   	push   %ebp
80105ac5:	89 e5                	mov    %esp,%ebp
80105ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80105aca:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80105acd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80105ad3:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80105ad6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105add:	5d                   	pop    %ebp
80105ade:	c3                   	ret    
80105adf:	90                   	nop

80105ae0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105ae0:	f3 0f 1e fb          	endbr32 
80105ae4:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105ae5:	31 d2                	xor    %edx,%edx
{
80105ae7:	89 e5                	mov    %esp,%ebp
80105ae9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80105aea:	8b 45 08             	mov    0x8(%ebp),%eax
{
80105aed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80105af0:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80105af3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105af7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105af8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80105afe:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80105b04:	77 1a                	ja     80105b20 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105b06:	8b 58 04             	mov    0x4(%eax),%ebx
80105b09:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80105b0c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80105b0f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105b11:	83 fa 0a             	cmp    $0xa,%edx
80105b14:	75 e2                	jne    80105af8 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80105b16:	5b                   	pop    %ebx
80105b17:	5d                   	pop    %ebp
80105b18:	c3                   	ret    
80105b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80105b20:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80105b23:	8d 51 28             	lea    0x28(%ecx),%edx
80105b26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b2d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80105b30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105b36:	83 c0 04             	add    $0x4,%eax
80105b39:	39 d0                	cmp    %edx,%eax
80105b3b:	75 f3                	jne    80105b30 <getcallerpcs+0x50>
}
80105b3d:	5b                   	pop    %ebx
80105b3e:	5d                   	pop    %ebp
80105b3f:	c3                   	ret    

80105b40 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105b40:	f3 0f 1e fb          	endbr32 
80105b44:	55                   	push   %ebp
80105b45:	89 e5                	mov    %esp,%ebp
80105b47:	53                   	push   %ebx
80105b48:	83 ec 04             	sub    $0x4,%esp
80105b4b:	9c                   	pushf  
80105b4c:	5b                   	pop    %ebx
  asm volatile("cli");
80105b4d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80105b4e:	e8 0d e3 ff ff       	call   80103e60 <mycpu>
80105b53:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105b59:	85 c0                	test   %eax,%eax
80105b5b:	74 13                	je     80105b70 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80105b5d:	e8 fe e2 ff ff       	call   80103e60 <mycpu>
80105b62:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105b69:	83 c4 04             	add    $0x4,%esp
80105b6c:	5b                   	pop    %ebx
80105b6d:	5d                   	pop    %ebp
80105b6e:	c3                   	ret    
80105b6f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80105b70:	e8 eb e2 ff ff       	call   80103e60 <mycpu>
80105b75:	81 e3 00 02 00 00    	and    $0x200,%ebx
80105b7b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80105b81:	eb da                	jmp    80105b5d <pushcli+0x1d>
80105b83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b90 <popcli>:

void
popcli(void)
{
80105b90:	f3 0f 1e fb          	endbr32 
80105b94:	55                   	push   %ebp
80105b95:	89 e5                	mov    %esp,%ebp
80105b97:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105b9a:	9c                   	pushf  
80105b9b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105b9c:	f6 c4 02             	test   $0x2,%ah
80105b9f:	75 31                	jne    80105bd2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80105ba1:	e8 ba e2 ff ff       	call   80103e60 <mycpu>
80105ba6:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80105bad:	78 30                	js     80105bdf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105baf:	e8 ac e2 ff ff       	call   80103e60 <mycpu>
80105bb4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105bba:	85 d2                	test   %edx,%edx
80105bbc:	74 02                	je     80105bc0 <popcli+0x30>
    sti();
}
80105bbe:	c9                   	leave  
80105bbf:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105bc0:	e8 9b e2 ff ff       	call   80103e60 <mycpu>
80105bc5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80105bcb:	85 c0                	test   %eax,%eax
80105bcd:	74 ef                	je     80105bbe <popcli+0x2e>
  asm volatile("sti");
80105bcf:	fb                   	sti    
}
80105bd0:	c9                   	leave  
80105bd1:	c3                   	ret    
    panic("popcli - interruptible");
80105bd2:	83 ec 0c             	sub    $0xc,%esp
80105bd5:	68 5d 95 10 80       	push   $0x8010955d
80105bda:	e8 b1 a7 ff ff       	call   80100390 <panic>
    panic("popcli");
80105bdf:	83 ec 0c             	sub    $0xc,%esp
80105be2:	68 74 95 10 80       	push   $0x80109574
80105be7:	e8 a4 a7 ff ff       	call   80100390 <panic>
80105bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105bf0 <holding>:
{
80105bf0:	f3 0f 1e fb          	endbr32 
80105bf4:	55                   	push   %ebp
80105bf5:	89 e5                	mov    %esp,%ebp
80105bf7:	56                   	push   %esi
80105bf8:	53                   	push   %ebx
80105bf9:	8b 75 08             	mov    0x8(%ebp),%esi
80105bfc:	31 db                	xor    %ebx,%ebx
  pushcli();
80105bfe:	e8 3d ff ff ff       	call   80105b40 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105c03:	8b 06                	mov    (%esi),%eax
80105c05:	85 c0                	test   %eax,%eax
80105c07:	75 0f                	jne    80105c18 <holding+0x28>
  popcli();
80105c09:	e8 82 ff ff ff       	call   80105b90 <popcli>
}
80105c0e:	89 d8                	mov    %ebx,%eax
80105c10:	5b                   	pop    %ebx
80105c11:	5e                   	pop    %esi
80105c12:	5d                   	pop    %ebp
80105c13:	c3                   	ret    
80105c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80105c18:	8b 5e 08             	mov    0x8(%esi),%ebx
80105c1b:	e8 40 e2 ff ff       	call   80103e60 <mycpu>
80105c20:	39 c3                	cmp    %eax,%ebx
80105c22:	0f 94 c3             	sete   %bl
  popcli();
80105c25:	e8 66 ff ff ff       	call   80105b90 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80105c2a:	0f b6 db             	movzbl %bl,%ebx
}
80105c2d:	89 d8                	mov    %ebx,%eax
80105c2f:	5b                   	pop    %ebx
80105c30:	5e                   	pop    %esi
80105c31:	5d                   	pop    %ebp
80105c32:	c3                   	ret    
80105c33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105c40 <acquire>:
{
80105c40:	f3 0f 1e fb          	endbr32 
80105c44:	55                   	push   %ebp
80105c45:	89 e5                	mov    %esp,%ebp
80105c47:	56                   	push   %esi
80105c48:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80105c49:	e8 f2 fe ff ff       	call   80105b40 <pushcli>
  if(holding(lk))
80105c4e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105c51:	83 ec 0c             	sub    $0xc,%esp
80105c54:	53                   	push   %ebx
80105c55:	e8 96 ff ff ff       	call   80105bf0 <holding>
80105c5a:	83 c4 10             	add    $0x10,%esp
80105c5d:	85 c0                	test   %eax,%eax
80105c5f:	0f 85 7f 00 00 00    	jne    80105ce4 <acquire+0xa4>
80105c65:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80105c67:	ba 01 00 00 00       	mov    $0x1,%edx
80105c6c:	eb 05                	jmp    80105c73 <acquire+0x33>
80105c6e:	66 90                	xchg   %ax,%ax
80105c70:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105c73:	89 d0                	mov    %edx,%eax
80105c75:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80105c78:	85 c0                	test   %eax,%eax
80105c7a:	75 f4                	jne    80105c70 <acquire+0x30>
  __sync_synchronize();
80105c7c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105c81:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105c84:	e8 d7 e1 ff ff       	call   80103e60 <mycpu>
80105c89:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80105c8c:	89 e8                	mov    %ebp,%eax
80105c8e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105c90:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80105c96:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80105c9c:	77 22                	ja     80105cc0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80105c9e:	8b 50 04             	mov    0x4(%eax),%edx
80105ca1:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80105ca5:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80105ca8:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105caa:	83 fe 0a             	cmp    $0xa,%esi
80105cad:	75 e1                	jne    80105c90 <acquire+0x50>
}
80105caf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105cb2:	5b                   	pop    %ebx
80105cb3:	5e                   	pop    %esi
80105cb4:	5d                   	pop    %ebp
80105cb5:	c3                   	ret    
80105cb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cbd:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80105cc0:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80105cc4:	83 c3 34             	add    $0x34,%ebx
80105cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cce:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105cd0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105cd6:	83 c0 04             	add    $0x4,%eax
80105cd9:	39 d8                	cmp    %ebx,%eax
80105cdb:	75 f3                	jne    80105cd0 <acquire+0x90>
}
80105cdd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105ce0:	5b                   	pop    %ebx
80105ce1:	5e                   	pop    %esi
80105ce2:	5d                   	pop    %ebp
80105ce3:	c3                   	ret    
    panic("acquire");
80105ce4:	83 ec 0c             	sub    $0xc,%esp
80105ce7:	68 7b 95 10 80       	push   $0x8010957b
80105cec:	e8 9f a6 ff ff       	call   80100390 <panic>
80105cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cff:	90                   	nop

80105d00 <release>:
{
80105d00:	f3 0f 1e fb          	endbr32 
80105d04:	55                   	push   %ebp
80105d05:	89 e5                	mov    %esp,%ebp
80105d07:	53                   	push   %ebx
80105d08:	83 ec 10             	sub    $0x10,%esp
80105d0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80105d0e:	53                   	push   %ebx
80105d0f:	e8 dc fe ff ff       	call   80105bf0 <holding>
80105d14:	83 c4 10             	add    $0x10,%esp
80105d17:	85 c0                	test   %eax,%eax
80105d19:	74 22                	je     80105d3d <release+0x3d>
  lk->pcs[0] = 0;
80105d1b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80105d22:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105d29:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80105d2e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105d34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d37:	c9                   	leave  
  popcli();
80105d38:	e9 53 fe ff ff       	jmp    80105b90 <popcli>
    panic("release");
80105d3d:	83 ec 0c             	sub    $0xc,%esp
80105d40:	68 83 95 10 80       	push   $0x80109583
80105d45:	e8 46 a6 ff ff       	call   80100390 <panic>
80105d4a:	66 90                	xchg   %ax,%ax
80105d4c:	66 90                	xchg   %ax,%ax
80105d4e:	66 90                	xchg   %ax,%ax

80105d50 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105d50:	f3 0f 1e fb          	endbr32 
80105d54:	55                   	push   %ebp
80105d55:	89 e5                	mov    %esp,%ebp
80105d57:	57                   	push   %edi
80105d58:	8b 55 08             	mov    0x8(%ebp),%edx
80105d5b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105d5e:	53                   	push   %ebx
80105d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80105d62:	89 d7                	mov    %edx,%edi
80105d64:	09 cf                	or     %ecx,%edi
80105d66:	83 e7 03             	and    $0x3,%edi
80105d69:	75 25                	jne    80105d90 <memset+0x40>
    c &= 0xFF;
80105d6b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105d6e:	c1 e0 18             	shl    $0x18,%eax
80105d71:	89 fb                	mov    %edi,%ebx
80105d73:	c1 e9 02             	shr    $0x2,%ecx
80105d76:	c1 e3 10             	shl    $0x10,%ebx
80105d79:	09 d8                	or     %ebx,%eax
80105d7b:	09 f8                	or     %edi,%eax
80105d7d:	c1 e7 08             	shl    $0x8,%edi
80105d80:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105d82:	89 d7                	mov    %edx,%edi
80105d84:	fc                   	cld    
80105d85:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80105d87:	5b                   	pop    %ebx
80105d88:	89 d0                	mov    %edx,%eax
80105d8a:	5f                   	pop    %edi
80105d8b:	5d                   	pop    %ebp
80105d8c:	c3                   	ret    
80105d8d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80105d90:	89 d7                	mov    %edx,%edi
80105d92:	fc                   	cld    
80105d93:	f3 aa                	rep stos %al,%es:(%edi)
80105d95:	5b                   	pop    %ebx
80105d96:	89 d0                	mov    %edx,%eax
80105d98:	5f                   	pop    %edi
80105d99:	5d                   	pop    %ebp
80105d9a:	c3                   	ret    
80105d9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d9f:	90                   	nop

80105da0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105da0:	f3 0f 1e fb          	endbr32 
80105da4:	55                   	push   %ebp
80105da5:	89 e5                	mov    %esp,%ebp
80105da7:	56                   	push   %esi
80105da8:	8b 75 10             	mov    0x10(%ebp),%esi
80105dab:	8b 55 08             	mov    0x8(%ebp),%edx
80105dae:	53                   	push   %ebx
80105daf:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105db2:	85 f6                	test   %esi,%esi
80105db4:	74 2a                	je     80105de0 <memcmp+0x40>
80105db6:	01 c6                	add    %eax,%esi
80105db8:	eb 10                	jmp    80105dca <memcmp+0x2a>
80105dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80105dc0:	83 c0 01             	add    $0x1,%eax
80105dc3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80105dc6:	39 f0                	cmp    %esi,%eax
80105dc8:	74 16                	je     80105de0 <memcmp+0x40>
    if(*s1 != *s2)
80105dca:	0f b6 0a             	movzbl (%edx),%ecx
80105dcd:	0f b6 18             	movzbl (%eax),%ebx
80105dd0:	38 d9                	cmp    %bl,%cl
80105dd2:	74 ec                	je     80105dc0 <memcmp+0x20>
      return *s1 - *s2;
80105dd4:	0f b6 c1             	movzbl %cl,%eax
80105dd7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80105dd9:	5b                   	pop    %ebx
80105dda:	5e                   	pop    %esi
80105ddb:	5d                   	pop    %ebp
80105ddc:	c3                   	ret    
80105ddd:	8d 76 00             	lea    0x0(%esi),%esi
80105de0:	5b                   	pop    %ebx
  return 0;
80105de1:	31 c0                	xor    %eax,%eax
}
80105de3:	5e                   	pop    %esi
80105de4:	5d                   	pop    %ebp
80105de5:	c3                   	ret    
80105de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ded:	8d 76 00             	lea    0x0(%esi),%esi

80105df0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105df0:	f3 0f 1e fb          	endbr32 
80105df4:	55                   	push   %ebp
80105df5:	89 e5                	mov    %esp,%ebp
80105df7:	57                   	push   %edi
80105df8:	8b 55 08             	mov    0x8(%ebp),%edx
80105dfb:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105dfe:	56                   	push   %esi
80105dff:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105e02:	39 d6                	cmp    %edx,%esi
80105e04:	73 2a                	jae    80105e30 <memmove+0x40>
80105e06:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80105e09:	39 fa                	cmp    %edi,%edx
80105e0b:	73 23                	jae    80105e30 <memmove+0x40>
80105e0d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80105e10:	85 c9                	test   %ecx,%ecx
80105e12:	74 13                	je     80105e27 <memmove+0x37>
80105e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80105e18:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80105e1c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80105e1f:	83 e8 01             	sub    $0x1,%eax
80105e22:	83 f8 ff             	cmp    $0xffffffff,%eax
80105e25:	75 f1                	jne    80105e18 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105e27:	5e                   	pop    %esi
80105e28:	89 d0                	mov    %edx,%eax
80105e2a:	5f                   	pop    %edi
80105e2b:	5d                   	pop    %ebp
80105e2c:	c3                   	ret    
80105e2d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80105e30:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80105e33:	89 d7                	mov    %edx,%edi
80105e35:	85 c9                	test   %ecx,%ecx
80105e37:	74 ee                	je     80105e27 <memmove+0x37>
80105e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105e40:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105e41:	39 f0                	cmp    %esi,%eax
80105e43:	75 fb                	jne    80105e40 <memmove+0x50>
}
80105e45:	5e                   	pop    %esi
80105e46:	89 d0                	mov    %edx,%eax
80105e48:	5f                   	pop    %edi
80105e49:	5d                   	pop    %ebp
80105e4a:	c3                   	ret    
80105e4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e4f:	90                   	nop

80105e50 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105e50:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80105e54:	eb 9a                	jmp    80105df0 <memmove>
80105e56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e5d:	8d 76 00             	lea    0x0(%esi),%esi

80105e60 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105e60:	f3 0f 1e fb          	endbr32 
80105e64:	55                   	push   %ebp
80105e65:	89 e5                	mov    %esp,%ebp
80105e67:	56                   	push   %esi
80105e68:	8b 75 10             	mov    0x10(%ebp),%esi
80105e6b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105e6e:	53                   	push   %ebx
80105e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80105e72:	85 f6                	test   %esi,%esi
80105e74:	74 32                	je     80105ea8 <strncmp+0x48>
80105e76:	01 c6                	add    %eax,%esi
80105e78:	eb 14                	jmp    80105e8e <strncmp+0x2e>
80105e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105e80:	38 da                	cmp    %bl,%dl
80105e82:	75 14                	jne    80105e98 <strncmp+0x38>
    n--, p++, q++;
80105e84:	83 c0 01             	add    $0x1,%eax
80105e87:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80105e8a:	39 f0                	cmp    %esi,%eax
80105e8c:	74 1a                	je     80105ea8 <strncmp+0x48>
80105e8e:	0f b6 11             	movzbl (%ecx),%edx
80105e91:	0f b6 18             	movzbl (%eax),%ebx
80105e94:	84 d2                	test   %dl,%dl
80105e96:	75 e8                	jne    80105e80 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105e98:	0f b6 c2             	movzbl %dl,%eax
80105e9b:	29 d8                	sub    %ebx,%eax
}
80105e9d:	5b                   	pop    %ebx
80105e9e:	5e                   	pop    %esi
80105e9f:	5d                   	pop    %ebp
80105ea0:	c3                   	ret    
80105ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ea8:	5b                   	pop    %ebx
    return 0;
80105ea9:	31 c0                	xor    %eax,%eax
}
80105eab:	5e                   	pop    %esi
80105eac:	5d                   	pop    %ebp
80105ead:	c3                   	ret    
80105eae:	66 90                	xchg   %ax,%ax

80105eb0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105eb0:	f3 0f 1e fb          	endbr32 
80105eb4:	55                   	push   %ebp
80105eb5:	89 e5                	mov    %esp,%ebp
80105eb7:	57                   	push   %edi
80105eb8:	56                   	push   %esi
80105eb9:	8b 75 08             	mov    0x8(%ebp),%esi
80105ebc:	53                   	push   %ebx
80105ebd:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105ec0:	89 f2                	mov    %esi,%edx
80105ec2:	eb 1b                	jmp    80105edf <strncpy+0x2f>
80105ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ec8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105ecc:	8b 7d 0c             	mov    0xc(%ebp),%edi
80105ecf:	83 c2 01             	add    $0x1,%edx
80105ed2:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80105ed6:	89 f9                	mov    %edi,%ecx
80105ed8:	88 4a ff             	mov    %cl,-0x1(%edx)
80105edb:	84 c9                	test   %cl,%cl
80105edd:	74 09                	je     80105ee8 <strncpy+0x38>
80105edf:	89 c3                	mov    %eax,%ebx
80105ee1:	83 e8 01             	sub    $0x1,%eax
80105ee4:	85 db                	test   %ebx,%ebx
80105ee6:	7f e0                	jg     80105ec8 <strncpy+0x18>
    ;
  while(n-- > 0)
80105ee8:	89 d1                	mov    %edx,%ecx
80105eea:	85 c0                	test   %eax,%eax
80105eec:	7e 15                	jle    80105f03 <strncpy+0x53>
80105eee:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80105ef0:	83 c1 01             	add    $0x1,%ecx
80105ef3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80105ef7:	89 c8                	mov    %ecx,%eax
80105ef9:	f7 d0                	not    %eax
80105efb:	01 d0                	add    %edx,%eax
80105efd:	01 d8                	add    %ebx,%eax
80105eff:	85 c0                	test   %eax,%eax
80105f01:	7f ed                	jg     80105ef0 <strncpy+0x40>
  return os;
}
80105f03:	5b                   	pop    %ebx
80105f04:	89 f0                	mov    %esi,%eax
80105f06:	5e                   	pop    %esi
80105f07:	5f                   	pop    %edi
80105f08:	5d                   	pop    %ebp
80105f09:	c3                   	ret    
80105f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105f10 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105f10:	f3 0f 1e fb          	endbr32 
80105f14:	55                   	push   %ebp
80105f15:	89 e5                	mov    %esp,%ebp
80105f17:	56                   	push   %esi
80105f18:	8b 55 10             	mov    0x10(%ebp),%edx
80105f1b:	8b 75 08             	mov    0x8(%ebp),%esi
80105f1e:	53                   	push   %ebx
80105f1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105f22:	85 d2                	test   %edx,%edx
80105f24:	7e 21                	jle    80105f47 <safestrcpy+0x37>
80105f26:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80105f2a:	89 f2                	mov    %esi,%edx
80105f2c:	eb 12                	jmp    80105f40 <safestrcpy+0x30>
80105f2e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105f30:	0f b6 08             	movzbl (%eax),%ecx
80105f33:	83 c0 01             	add    $0x1,%eax
80105f36:	83 c2 01             	add    $0x1,%edx
80105f39:	88 4a ff             	mov    %cl,-0x1(%edx)
80105f3c:	84 c9                	test   %cl,%cl
80105f3e:	74 04                	je     80105f44 <safestrcpy+0x34>
80105f40:	39 d8                	cmp    %ebx,%eax
80105f42:	75 ec                	jne    80105f30 <safestrcpy+0x20>
    ;
  *s = 0;
80105f44:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105f47:	89 f0                	mov    %esi,%eax
80105f49:	5b                   	pop    %ebx
80105f4a:	5e                   	pop    %esi
80105f4b:	5d                   	pop    %ebp
80105f4c:	c3                   	ret    
80105f4d:	8d 76 00             	lea    0x0(%esi),%esi

80105f50 <strlen>:

int
strlen(const char *s)
{
80105f50:	f3 0f 1e fb          	endbr32 
80105f54:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105f55:	31 c0                	xor    %eax,%eax
{
80105f57:	89 e5                	mov    %esp,%ebp
80105f59:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105f5c:	80 3a 00             	cmpb   $0x0,(%edx)
80105f5f:	74 10                	je     80105f71 <strlen+0x21>
80105f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f68:	83 c0 01             	add    $0x1,%eax
80105f6b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105f6f:	75 f7                	jne    80105f68 <strlen+0x18>
    ;
  return n;
}
80105f71:	5d                   	pop    %ebp
80105f72:	c3                   	ret    

80105f73 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105f73:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105f77:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105f7b:	55                   	push   %ebp
  pushl %ebx
80105f7c:	53                   	push   %ebx
  pushl %esi
80105f7d:	56                   	push   %esi
  pushl %edi
80105f7e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105f7f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105f81:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105f83:	5f                   	pop    %edi
  popl %esi
80105f84:	5e                   	pop    %esi
  popl %ebx
80105f85:	5b                   	pop    %ebx
  popl %ebp
80105f86:	5d                   	pop    %ebp
  ret
80105f87:	c3                   	ret    
80105f88:	66 90                	xchg   %ax,%ax
80105f8a:	66 90                	xchg   %ax,%ax
80105f8c:	66 90                	xchg   %ax,%ax
80105f8e:	66 90                	xchg   %ax,%ax

80105f90 <fetchfloat>:
#include "x86.h"
#include "syscall.h"

int
fetchfloat(uint addr, float *fp)
{
80105f90:	f3 0f 1e fb          	endbr32 
80105f94:	55                   	push   %ebp
80105f95:	89 e5                	mov    %esp,%ebp
80105f97:	53                   	push   %ebx
80105f98:	83 ec 04             	sub    $0x4,%esp
80105f9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80105f9e:	e8 4d df ff ff       	call   80103ef0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105fa3:	8b 00                	mov    (%eax),%eax
80105fa5:	39 d8                	cmp    %ebx,%eax
80105fa7:	76 17                	jbe    80105fc0 <fetchfloat+0x30>
80105fa9:	8d 53 04             	lea    0x4(%ebx),%edx
80105fac:	39 d0                	cmp    %edx,%eax
80105fae:	72 10                	jb     80105fc0 <fetchfloat+0x30>
    return -1;
  *fp = *(float*)(addr);
80105fb0:	d9 03                	flds   (%ebx)
80105fb2:	8b 45 0c             	mov    0xc(%ebp),%eax
80105fb5:	d9 18                	fstps  (%eax)
  return 0;
80105fb7:	31 c0                	xor    %eax,%eax
}
80105fb9:	83 c4 04             	add    $0x4,%esp
80105fbc:	5b                   	pop    %ebx
80105fbd:	5d                   	pop    %ebp
80105fbe:	c3                   	ret    
80105fbf:	90                   	nop
    return -1;
80105fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fc5:	eb f2                	jmp    80105fb9 <fetchfloat+0x29>
80105fc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fce:	66 90                	xchg   %ax,%ax

80105fd0 <argfloat>:


int
argfloat(int n, float *fp)
{
80105fd0:	f3 0f 1e fb          	endbr32 
80105fd4:	55                   	push   %ebp
80105fd5:	89 e5                	mov    %esp,%ebp
80105fd7:	56                   	push   %esi
80105fd8:	53                   	push   %ebx
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
80105fd9:	e8 12 df ff ff       	call   80103ef0 <myproc>
80105fde:	8b 55 08             	mov    0x8(%ebp),%edx
80105fe1:	8b 40 18             	mov    0x18(%eax),%eax
80105fe4:	8b 40 44             	mov    0x44(%eax),%eax
80105fe7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105fea:	e8 01 df ff ff       	call   80103ef0 <myproc>
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
80105fef:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105ff2:	8b 00                	mov    (%eax),%eax
80105ff4:	39 c6                	cmp    %eax,%esi
80105ff6:	73 18                	jae    80106010 <argfloat+0x40>
80105ff8:	8d 53 08             	lea    0x8(%ebx),%edx
80105ffb:	39 d0                	cmp    %edx,%eax
80105ffd:	72 11                	jb     80106010 <argfloat+0x40>
  *fp = *(float*)(addr);
80105fff:	d9 43 04             	flds   0x4(%ebx)
80106002:	8b 45 0c             	mov    0xc(%ebp),%eax
80106005:	d9 18                	fstps  (%eax)
  return 0;
80106007:	31 c0                	xor    %eax,%eax
}
80106009:	5b                   	pop    %ebx
8010600a:	5e                   	pop    %esi
8010600b:	5d                   	pop    %ebp
8010600c:	c3                   	ret    
8010600d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106010:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchfloat((myproc()->tf->esp) + 4 + 4*n, fp);
80106015:	eb f2                	jmp    80106009 <argfloat+0x39>
80106017:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010601e:	66 90                	xchg   %ax,%ax

80106020 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80106020:	f3 0f 1e fb          	endbr32 
80106024:	55                   	push   %ebp
80106025:	89 e5                	mov    %esp,%ebp
80106027:	53                   	push   %ebx
80106028:	83 ec 04             	sub    $0x4,%esp
8010602b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010602e:	e8 bd de ff ff       	call   80103ef0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80106033:	8b 00                	mov    (%eax),%eax
80106035:	39 d8                	cmp    %ebx,%eax
80106037:	76 17                	jbe    80106050 <fetchint+0x30>
80106039:	8d 53 04             	lea    0x4(%ebx),%edx
8010603c:	39 d0                	cmp    %edx,%eax
8010603e:	72 10                	jb     80106050 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80106040:	8b 45 0c             	mov    0xc(%ebp),%eax
80106043:	8b 13                	mov    (%ebx),%edx
80106045:	89 10                	mov    %edx,(%eax)
  return 0;
80106047:	31 c0                	xor    %eax,%eax
}
80106049:	83 c4 04             	add    $0x4,%esp
8010604c:	5b                   	pop    %ebx
8010604d:	5d                   	pop    %ebp
8010604e:	c3                   	ret    
8010604f:	90                   	nop
    return -1;
80106050:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106055:	eb f2                	jmp    80106049 <fetchint+0x29>
80106057:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010605e:	66 90                	xchg   %ax,%ax

80106060 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80106060:	f3 0f 1e fb          	endbr32 
80106064:	55                   	push   %ebp
80106065:	89 e5                	mov    %esp,%ebp
80106067:	53                   	push   %ebx
80106068:	83 ec 04             	sub    $0x4,%esp
8010606b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010606e:	e8 7d de ff ff       	call   80103ef0 <myproc>

  if(addr >= curproc->sz)
80106073:	39 18                	cmp    %ebx,(%eax)
80106075:	76 31                	jbe    801060a8 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80106077:	8b 55 0c             	mov    0xc(%ebp),%edx
8010607a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010607c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010607e:	39 d3                	cmp    %edx,%ebx
80106080:	73 26                	jae    801060a8 <fetchstr+0x48>
80106082:	89 d8                	mov    %ebx,%eax
80106084:	eb 11                	jmp    80106097 <fetchstr+0x37>
80106086:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010608d:	8d 76 00             	lea    0x0(%esi),%esi
80106090:	83 c0 01             	add    $0x1,%eax
80106093:	39 c2                	cmp    %eax,%edx
80106095:	76 11                	jbe    801060a8 <fetchstr+0x48>
    if(*s == 0)
80106097:	80 38 00             	cmpb   $0x0,(%eax)
8010609a:	75 f4                	jne    80106090 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
8010609c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010609f:	29 d8                	sub    %ebx,%eax
}
801060a1:	5b                   	pop    %ebx
801060a2:	5d                   	pop    %ebp
801060a3:	c3                   	ret    
801060a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801060a8:	83 c4 04             	add    $0x4,%esp
    return -1;
801060ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060b0:	5b                   	pop    %ebx
801060b1:	5d                   	pop    %ebp
801060b2:	c3                   	ret    
801060b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801060c0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801060c0:	f3 0f 1e fb          	endbr32 
801060c4:	55                   	push   %ebp
801060c5:	89 e5                	mov    %esp,%ebp
801060c7:	56                   	push   %esi
801060c8:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801060c9:	e8 22 de ff ff       	call   80103ef0 <myproc>
801060ce:	8b 55 08             	mov    0x8(%ebp),%edx
801060d1:	8b 40 18             	mov    0x18(%eax),%eax
801060d4:	8b 40 44             	mov    0x44(%eax),%eax
801060d7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801060da:	e8 11 de ff ff       	call   80103ef0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801060df:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801060e2:	8b 00                	mov    (%eax),%eax
801060e4:	39 c6                	cmp    %eax,%esi
801060e6:	73 18                	jae    80106100 <argint+0x40>
801060e8:	8d 53 08             	lea    0x8(%ebx),%edx
801060eb:	39 d0                	cmp    %edx,%eax
801060ed:	72 11                	jb     80106100 <argint+0x40>
  *ip = *(int*)(addr);
801060ef:	8b 45 0c             	mov    0xc(%ebp),%eax
801060f2:	8b 53 04             	mov    0x4(%ebx),%edx
801060f5:	89 10                	mov    %edx,(%eax)
  return 0;
801060f7:	31 c0                	xor    %eax,%eax
}
801060f9:	5b                   	pop    %ebx
801060fa:	5e                   	pop    %esi
801060fb:	5d                   	pop    %ebp
801060fc:	c3                   	ret    
801060fd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106100:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80106105:	eb f2                	jmp    801060f9 <argint+0x39>
80106107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010610e:	66 90                	xchg   %ax,%ax

80106110 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80106110:	f3 0f 1e fb          	endbr32 
80106114:	55                   	push   %ebp
80106115:	89 e5                	mov    %esp,%ebp
80106117:	56                   	push   %esi
80106118:	53                   	push   %ebx
80106119:	83 ec 10             	sub    $0x10,%esp
8010611c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010611f:	e8 cc dd ff ff       	call   80103ef0 <myproc>
 
  if(argint(n, &i) < 0)
80106124:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80106127:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80106129:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010612c:	50                   	push   %eax
8010612d:	ff 75 08             	pushl  0x8(%ebp)
80106130:	e8 8b ff ff ff       	call   801060c0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80106135:	83 c4 10             	add    $0x10,%esp
80106138:	85 c0                	test   %eax,%eax
8010613a:	78 24                	js     80106160 <argptr+0x50>
8010613c:	85 db                	test   %ebx,%ebx
8010613e:	78 20                	js     80106160 <argptr+0x50>
80106140:	8b 16                	mov    (%esi),%edx
80106142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106145:	39 c2                	cmp    %eax,%edx
80106147:	76 17                	jbe    80106160 <argptr+0x50>
80106149:	01 c3                	add    %eax,%ebx
8010614b:	39 da                	cmp    %ebx,%edx
8010614d:	72 11                	jb     80106160 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010614f:	8b 55 0c             	mov    0xc(%ebp),%edx
80106152:	89 02                	mov    %eax,(%edx)
  return 0;
80106154:	31 c0                	xor    %eax,%eax
}
80106156:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106159:	5b                   	pop    %ebx
8010615a:	5e                   	pop    %esi
8010615b:	5d                   	pop    %ebp
8010615c:	c3                   	ret    
8010615d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106160:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106165:	eb ef                	jmp    80106156 <argptr+0x46>
80106167:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010616e:	66 90                	xchg   %ax,%ax

80106170 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80106170:	f3 0f 1e fb          	endbr32 
80106174:	55                   	push   %ebp
80106175:	89 e5                	mov    %esp,%ebp
80106177:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010617a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010617d:	50                   	push   %eax
8010617e:	ff 75 08             	pushl  0x8(%ebp)
80106181:	e8 3a ff ff ff       	call   801060c0 <argint>
80106186:	83 c4 10             	add    $0x10,%esp
80106189:	85 c0                	test   %eax,%eax
8010618b:	78 13                	js     801061a0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010618d:	83 ec 08             	sub    $0x8,%esp
80106190:	ff 75 0c             	pushl  0xc(%ebp)
80106193:	ff 75 f4             	pushl  -0xc(%ebp)
80106196:	e8 c5 fe ff ff       	call   80106060 <fetchstr>
8010619b:	83 c4 10             	add    $0x10,%esp
}
8010619e:	c9                   	leave  
8010619f:	c3                   	ret    
801061a0:	c9                   	leave  
    return -1;
801061a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801061a6:	c3                   	ret    
801061a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061ae:	66 90                	xchg   %ax,%ax

801061b0 <syscall>:

};

void
syscall(void)
{
801061b0:	f3 0f 1e fb          	endbr32 
801061b4:	55                   	push   %ebp
801061b5:	89 e5                	mov    %esp,%ebp
801061b7:	53                   	push   %ebx
801061b8:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801061bb:	e8 30 dd ff ff       	call   80103ef0 <myproc>
801061c0:	89 c3                	mov    %eax,%ebx
  num = curproc->tf->eax;
801061c2:	8b 40 18             	mov    0x18(%eax),%eax
801061c5:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801061c8:	8d 50 ff             	lea    -0x1(%eax),%edx
801061cb:	83 fa 1e             	cmp    $0x1e,%edx
801061ce:	77 20                	ja     801061f0 <syscall+0x40>
801061d0:	8b 14 85 c0 95 10 80 	mov    -0x7fef6a40(,%eax,4),%edx
801061d7:	85 d2                	test   %edx,%edx
801061d9:	74 15                	je     801061f0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
801061db:	ff d2                	call   *%edx
801061dd:	89 c2                	mov    %eax,%edx
801061df:	8b 43 18             	mov    0x18(%ebx),%eax
801061e2:	89 50 1c             	mov    %edx,0x1c(%eax)
801061e5:	eb 28                	jmp    8010620f <syscall+0x5f>
801061e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061ee:	66 90                	xchg   %ax,%ax
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801061f0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801061f1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801061f4:	50                   	push   %eax
801061f5:	ff 73 10             	pushl  0x10(%ebx)
801061f8:	68 8b 95 10 80       	push   $0x8010958b
801061fd:	e8 be a6 ff ff       	call   801008c0 <cprintf>
    curproc->tf->eax = -1;
80106202:	8b 43 18             	mov    0x18(%ebx),%eax
80106205:	83 c4 10             	add    $0x10,%esp
80106208:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }

  pushcli();
8010620f:	e8 2c f9 ff ff       	call   80105b40 <pushcli>
  mycpu()->syscalls_count++;
80106214:	e8 47 dc ff ff       	call   80103e60 <mycpu>
80106219:	83 80 b0 00 00 00 01 	addl   $0x1,0xb0(%eax)
  popcli();
80106220:	e8 6b f9 ff ff       	call   80105b90 <popcli>
  count_shared_syscalls++;
80106225:	83 05 c0 c5 10 80 01 	addl   $0x1,0x8010c5c0
}
8010622c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010622f:	c9                   	leave  
80106230:	c3                   	ret    
80106231:	66 90                	xchg   %ax,%ax
80106233:	66 90                	xchg   %ax,%ax
80106235:	66 90                	xchg   %ax,%ax
80106237:	66 90                	xchg   %ax,%ax
80106239:	66 90                	xchg   %ax,%ax
8010623b:	66 90                	xchg   %ax,%ax
8010623d:	66 90                	xchg   %ax,%ax
8010623f:	90                   	nop

80106240 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80106240:	55                   	push   %ebp
80106241:	89 e5                	mov    %esp,%ebp
80106243:	57                   	push   %edi
80106244:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106245:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80106248:	53                   	push   %ebx
80106249:	83 ec 34             	sub    $0x34,%esp
8010624c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010624f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80106252:	57                   	push   %edi
80106253:	50                   	push   %eax
{
80106254:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80106257:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010625a:	e8 11 c3 ff ff       	call   80102570 <nameiparent>
8010625f:	83 c4 10             	add    $0x10,%esp
80106262:	85 c0                	test   %eax,%eax
80106264:	0f 84 46 01 00 00    	je     801063b0 <create+0x170>
    return 0;
  ilock(dp);
8010626a:	83 ec 0c             	sub    $0xc,%esp
8010626d:	89 c3                	mov    %eax,%ebx
8010626f:	50                   	push   %eax
80106270:	e8 0b ba ff ff       	call   80101c80 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80106275:	83 c4 0c             	add    $0xc,%esp
80106278:	6a 00                	push   $0x0
8010627a:	57                   	push   %edi
8010627b:	53                   	push   %ebx
8010627c:	e8 4f bf ff ff       	call   801021d0 <dirlookup>
80106281:	83 c4 10             	add    $0x10,%esp
80106284:	89 c6                	mov    %eax,%esi
80106286:	85 c0                	test   %eax,%eax
80106288:	74 56                	je     801062e0 <create+0xa0>
    iunlockput(dp);
8010628a:	83 ec 0c             	sub    $0xc,%esp
8010628d:	53                   	push   %ebx
8010628e:	e8 8d bc ff ff       	call   80101f20 <iunlockput>
    ilock(ip);
80106293:	89 34 24             	mov    %esi,(%esp)
80106296:	e8 e5 b9 ff ff       	call   80101c80 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010629b:	83 c4 10             	add    $0x10,%esp
8010629e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801062a3:	75 1b                	jne    801062c0 <create+0x80>
801062a5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801062aa:	75 14                	jne    801062c0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801062ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062af:	89 f0                	mov    %esi,%eax
801062b1:	5b                   	pop    %ebx
801062b2:	5e                   	pop    %esi
801062b3:	5f                   	pop    %edi
801062b4:	5d                   	pop    %ebp
801062b5:	c3                   	ret    
801062b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062bd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801062c0:	83 ec 0c             	sub    $0xc,%esp
801062c3:	56                   	push   %esi
    return 0;
801062c4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
801062c6:	e8 55 bc ff ff       	call   80101f20 <iunlockput>
    return 0;
801062cb:	83 c4 10             	add    $0x10,%esp
}
801062ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062d1:	89 f0                	mov    %esi,%eax
801062d3:	5b                   	pop    %ebx
801062d4:	5e                   	pop    %esi
801062d5:	5f                   	pop    %edi
801062d6:	5d                   	pop    %ebp
801062d7:	c3                   	ret    
801062d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062df:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
801062e0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801062e4:	83 ec 08             	sub    $0x8,%esp
801062e7:	50                   	push   %eax
801062e8:	ff 33                	pushl  (%ebx)
801062ea:	e8 11 b8 ff ff       	call   80101b00 <ialloc>
801062ef:	83 c4 10             	add    $0x10,%esp
801062f2:	89 c6                	mov    %eax,%esi
801062f4:	85 c0                	test   %eax,%eax
801062f6:	0f 84 cd 00 00 00    	je     801063c9 <create+0x189>
  ilock(ip);
801062fc:	83 ec 0c             	sub    $0xc,%esp
801062ff:	50                   	push   %eax
80106300:	e8 7b b9 ff ff       	call   80101c80 <ilock>
  ip->major = major;
80106305:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80106309:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010630d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80106311:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80106315:	b8 01 00 00 00       	mov    $0x1,%eax
8010631a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010631e:	89 34 24             	mov    %esi,(%esp)
80106321:	e8 9a b8 ff ff       	call   80101bc0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80106326:	83 c4 10             	add    $0x10,%esp
80106329:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010632e:	74 30                	je     80106360 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80106330:	83 ec 04             	sub    $0x4,%esp
80106333:	ff 76 04             	pushl  0x4(%esi)
80106336:	57                   	push   %edi
80106337:	53                   	push   %ebx
80106338:	e8 53 c1 ff ff       	call   80102490 <dirlink>
8010633d:	83 c4 10             	add    $0x10,%esp
80106340:	85 c0                	test   %eax,%eax
80106342:	78 78                	js     801063bc <create+0x17c>
  iunlockput(dp);
80106344:	83 ec 0c             	sub    $0xc,%esp
80106347:	53                   	push   %ebx
80106348:	e8 d3 bb ff ff       	call   80101f20 <iunlockput>
  return ip;
8010634d:	83 c4 10             	add    $0x10,%esp
}
80106350:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106353:	89 f0                	mov    %esi,%eax
80106355:	5b                   	pop    %ebx
80106356:	5e                   	pop    %esi
80106357:	5f                   	pop    %edi
80106358:	5d                   	pop    %ebp
80106359:	c3                   	ret    
8010635a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80106360:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80106363:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80106368:	53                   	push   %ebx
80106369:	e8 52 b8 ff ff       	call   80101bc0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010636e:	83 c4 0c             	add    $0xc,%esp
80106371:	ff 76 04             	pushl  0x4(%esi)
80106374:	68 5c 96 10 80       	push   $0x8010965c
80106379:	56                   	push   %esi
8010637a:	e8 11 c1 ff ff       	call   80102490 <dirlink>
8010637f:	83 c4 10             	add    $0x10,%esp
80106382:	85 c0                	test   %eax,%eax
80106384:	78 18                	js     8010639e <create+0x15e>
80106386:	83 ec 04             	sub    $0x4,%esp
80106389:	ff 73 04             	pushl  0x4(%ebx)
8010638c:	68 5b 96 10 80       	push   $0x8010965b
80106391:	56                   	push   %esi
80106392:	e8 f9 c0 ff ff       	call   80102490 <dirlink>
80106397:	83 c4 10             	add    $0x10,%esp
8010639a:	85 c0                	test   %eax,%eax
8010639c:	79 92                	jns    80106330 <create+0xf0>
      panic("create dots");
8010639e:	83 ec 0c             	sub    $0xc,%esp
801063a1:	68 4f 96 10 80       	push   $0x8010964f
801063a6:	e8 e5 9f ff ff       	call   80100390 <panic>
801063ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801063af:	90                   	nop
}
801063b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801063b3:	31 f6                	xor    %esi,%esi
}
801063b5:	5b                   	pop    %ebx
801063b6:	89 f0                	mov    %esi,%eax
801063b8:	5e                   	pop    %esi
801063b9:	5f                   	pop    %edi
801063ba:	5d                   	pop    %ebp
801063bb:	c3                   	ret    
    panic("create: dirlink");
801063bc:	83 ec 0c             	sub    $0xc,%esp
801063bf:	68 5e 96 10 80       	push   $0x8010965e
801063c4:	e8 c7 9f ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801063c9:	83 ec 0c             	sub    $0xc,%esp
801063cc:	68 40 96 10 80       	push   $0x80109640
801063d1:	e8 ba 9f ff ff       	call   80100390 <panic>
801063d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063dd:	8d 76 00             	lea    0x0(%esi),%esi

801063e0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
801063e0:	55                   	push   %ebp
801063e1:	89 e5                	mov    %esp,%ebp
801063e3:	56                   	push   %esi
801063e4:	89 d6                	mov    %edx,%esi
801063e6:	53                   	push   %ebx
801063e7:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
801063e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
801063ec:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801063ef:	50                   	push   %eax
801063f0:	6a 00                	push   $0x0
801063f2:	e8 c9 fc ff ff       	call   801060c0 <argint>
801063f7:	83 c4 10             	add    $0x10,%esp
801063fa:	85 c0                	test   %eax,%eax
801063fc:	78 2a                	js     80106428 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801063fe:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80106402:	77 24                	ja     80106428 <argfd.constprop.0+0x48>
80106404:	e8 e7 da ff ff       	call   80103ef0 <myproc>
80106409:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010640c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80106410:	85 c0                	test   %eax,%eax
80106412:	74 14                	je     80106428 <argfd.constprop.0+0x48>
  if(pfd)
80106414:	85 db                	test   %ebx,%ebx
80106416:	74 02                	je     8010641a <argfd.constprop.0+0x3a>
    *pfd = fd;
80106418:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010641a:	89 06                	mov    %eax,(%esi)
  return 0;
8010641c:	31 c0                	xor    %eax,%eax
}
8010641e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106421:	5b                   	pop    %ebx
80106422:	5e                   	pop    %esi
80106423:	5d                   	pop    %ebp
80106424:	c3                   	ret    
80106425:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106428:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010642d:	eb ef                	jmp    8010641e <argfd.constprop.0+0x3e>
8010642f:	90                   	nop

80106430 <sys_dup>:
{
80106430:	f3 0f 1e fb          	endbr32 
80106434:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80106435:	31 c0                	xor    %eax,%eax
{
80106437:	89 e5                	mov    %esp,%ebp
80106439:	56                   	push   %esi
8010643a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
8010643b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010643e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80106441:	e8 9a ff ff ff       	call   801063e0 <argfd.constprop.0>
80106446:	85 c0                	test   %eax,%eax
80106448:	78 1e                	js     80106468 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
8010644a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
8010644d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010644f:	e8 9c da ff ff       	call   80103ef0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80106458:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
8010645c:	85 d2                	test   %edx,%edx
8010645e:	74 20                	je     80106480 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80106460:	83 c3 01             	add    $0x1,%ebx
80106463:	83 fb 10             	cmp    $0x10,%ebx
80106466:	75 f0                	jne    80106458 <sys_dup+0x28>
}
80106468:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010646b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80106470:	89 d8                	mov    %ebx,%eax
80106472:	5b                   	pop    %ebx
80106473:	5e                   	pop    %esi
80106474:	5d                   	pop    %ebp
80106475:	c3                   	ret    
80106476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010647d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80106480:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80106484:	83 ec 0c             	sub    $0xc,%esp
80106487:	ff 75 f4             	pushl  -0xc(%ebp)
8010648a:	e8 01 af ff ff       	call   80101390 <filedup>
  return fd;
8010648f:	83 c4 10             	add    $0x10,%esp
}
80106492:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106495:	89 d8                	mov    %ebx,%eax
80106497:	5b                   	pop    %ebx
80106498:	5e                   	pop    %esi
80106499:	5d                   	pop    %ebp
8010649a:	c3                   	ret    
8010649b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010649f:	90                   	nop

801064a0 <sys_read>:
{
801064a0:	f3 0f 1e fb          	endbr32 
801064a4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801064a5:	31 c0                	xor    %eax,%eax
{
801064a7:	89 e5                	mov    %esp,%ebp
801064a9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801064ac:	8d 55 ec             	lea    -0x14(%ebp),%edx
801064af:	e8 2c ff ff ff       	call   801063e0 <argfd.constprop.0>
801064b4:	85 c0                	test   %eax,%eax
801064b6:	78 48                	js     80106500 <sys_read+0x60>
801064b8:	83 ec 08             	sub    $0x8,%esp
801064bb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064be:	50                   	push   %eax
801064bf:	6a 02                	push   $0x2
801064c1:	e8 fa fb ff ff       	call   801060c0 <argint>
801064c6:	83 c4 10             	add    $0x10,%esp
801064c9:	85 c0                	test   %eax,%eax
801064cb:	78 33                	js     80106500 <sys_read+0x60>
801064cd:	83 ec 04             	sub    $0x4,%esp
801064d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801064d3:	ff 75 f0             	pushl  -0x10(%ebp)
801064d6:	50                   	push   %eax
801064d7:	6a 01                	push   $0x1
801064d9:	e8 32 fc ff ff       	call   80106110 <argptr>
801064de:	83 c4 10             	add    $0x10,%esp
801064e1:	85 c0                	test   %eax,%eax
801064e3:	78 1b                	js     80106500 <sys_read+0x60>
  return fileread(f, p, n);
801064e5:	83 ec 04             	sub    $0x4,%esp
801064e8:	ff 75 f0             	pushl  -0x10(%ebp)
801064eb:	ff 75 f4             	pushl  -0xc(%ebp)
801064ee:	ff 75 ec             	pushl  -0x14(%ebp)
801064f1:	e8 1a b0 ff ff       	call   80101510 <fileread>
801064f6:	83 c4 10             	add    $0x10,%esp
}
801064f9:	c9                   	leave  
801064fa:	c3                   	ret    
801064fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801064ff:	90                   	nop
80106500:	c9                   	leave  
    return -1;
80106501:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106506:	c3                   	ret    
80106507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010650e:	66 90                	xchg   %ax,%ax

80106510 <sys_write>:
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
8010651f:	e8 bc fe ff ff       	call   801063e0 <argfd.constprop.0>
80106524:	85 c0                	test   %eax,%eax
80106526:	78 48                	js     80106570 <sys_write+0x60>
80106528:	83 ec 08             	sub    $0x8,%esp
8010652b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010652e:	50                   	push   %eax
8010652f:	6a 02                	push   $0x2
80106531:	e8 8a fb ff ff       	call   801060c0 <argint>
80106536:	83 c4 10             	add    $0x10,%esp
80106539:	85 c0                	test   %eax,%eax
8010653b:	78 33                	js     80106570 <sys_write+0x60>
8010653d:	83 ec 04             	sub    $0x4,%esp
80106540:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106543:	ff 75 f0             	pushl  -0x10(%ebp)
80106546:	50                   	push   %eax
80106547:	6a 01                	push   $0x1
80106549:	e8 c2 fb ff ff       	call   80106110 <argptr>
8010654e:	83 c4 10             	add    $0x10,%esp
80106551:	85 c0                	test   %eax,%eax
80106553:	78 1b                	js     80106570 <sys_write+0x60>
  return filewrite(f, p, n);
80106555:	83 ec 04             	sub    $0x4,%esp
80106558:	ff 75 f0             	pushl  -0x10(%ebp)
8010655b:	ff 75 f4             	pushl  -0xc(%ebp)
8010655e:	ff 75 ec             	pushl  -0x14(%ebp)
80106561:	e8 4a b0 ff ff       	call   801015b0 <filewrite>
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

80106580 <sys_close>:
{
80106580:	f3 0f 1e fb          	endbr32 
80106584:	55                   	push   %ebp
80106585:	89 e5                	mov    %esp,%ebp
80106587:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
8010658a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010658d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106590:	e8 4b fe ff ff       	call   801063e0 <argfd.constprop.0>
80106595:	85 c0                	test   %eax,%eax
80106597:	78 27                	js     801065c0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80106599:	e8 52 d9 ff ff       	call   80103ef0 <myproc>
8010659e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801065a1:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801065a4:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801065ab:	00 
  fileclose(f);
801065ac:	ff 75 f4             	pushl  -0xc(%ebp)
801065af:	e8 2c ae ff ff       	call   801013e0 <fileclose>
  return 0;
801065b4:	83 c4 10             	add    $0x10,%esp
801065b7:	31 c0                	xor    %eax,%eax
}
801065b9:	c9                   	leave  
801065ba:	c3                   	ret    
801065bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801065bf:	90                   	nop
801065c0:	c9                   	leave  
    return -1;
801065c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801065c6:	c3                   	ret    
801065c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065ce:	66 90                	xchg   %ax,%ax

801065d0 <sys_fstat>:
{
801065d0:	f3 0f 1e fb          	endbr32 
801065d4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801065d5:	31 c0                	xor    %eax,%eax
{
801065d7:	89 e5                	mov    %esp,%ebp
801065d9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801065dc:	8d 55 f0             	lea    -0x10(%ebp),%edx
801065df:	e8 fc fd ff ff       	call   801063e0 <argfd.constprop.0>
801065e4:	85 c0                	test   %eax,%eax
801065e6:	78 30                	js     80106618 <sys_fstat+0x48>
801065e8:	83 ec 04             	sub    $0x4,%esp
801065eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801065ee:	6a 14                	push   $0x14
801065f0:	50                   	push   %eax
801065f1:	6a 01                	push   $0x1
801065f3:	e8 18 fb ff ff       	call   80106110 <argptr>
801065f8:	83 c4 10             	add    $0x10,%esp
801065fb:	85 c0                	test   %eax,%eax
801065fd:	78 19                	js     80106618 <sys_fstat+0x48>
  return filestat(f, st);
801065ff:	83 ec 08             	sub    $0x8,%esp
80106602:	ff 75 f4             	pushl  -0xc(%ebp)
80106605:	ff 75 f0             	pushl  -0x10(%ebp)
80106608:	e8 b3 ae ff ff       	call   801014c0 <filestat>
8010660d:	83 c4 10             	add    $0x10,%esp
}
80106610:	c9                   	leave  
80106611:	c3                   	ret    
80106612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106618:	c9                   	leave  
    return -1;
80106619:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010661e:	c3                   	ret    
8010661f:	90                   	nop

80106620 <sys_link>:
{
80106620:	f3 0f 1e fb          	endbr32 
80106624:	55                   	push   %ebp
80106625:	89 e5                	mov    %esp,%ebp
80106627:	57                   	push   %edi
80106628:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106629:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010662c:	53                   	push   %ebx
8010662d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106630:	50                   	push   %eax
80106631:	6a 00                	push   $0x0
80106633:	e8 38 fb ff ff       	call   80106170 <argstr>
80106638:	83 c4 10             	add    $0x10,%esp
8010663b:	85 c0                	test   %eax,%eax
8010663d:	0f 88 ff 00 00 00    	js     80106742 <sys_link+0x122>
80106643:	83 ec 08             	sub    $0x8,%esp
80106646:	8d 45 d0             	lea    -0x30(%ebp),%eax
80106649:	50                   	push   %eax
8010664a:	6a 01                	push   $0x1
8010664c:	e8 1f fb ff ff       	call   80106170 <argstr>
80106651:	83 c4 10             	add    $0x10,%esp
80106654:	85 c0                	test   %eax,%eax
80106656:	0f 88 e6 00 00 00    	js     80106742 <sys_link+0x122>
  begin_op();
8010665c:	e8 ef cb ff ff       	call   80103250 <begin_op>
  if((ip = namei(old)) == 0){
80106661:	83 ec 0c             	sub    $0xc,%esp
80106664:	ff 75 d4             	pushl  -0x2c(%ebp)
80106667:	e8 e4 be ff ff       	call   80102550 <namei>
8010666c:	83 c4 10             	add    $0x10,%esp
8010666f:	89 c3                	mov    %eax,%ebx
80106671:	85 c0                	test   %eax,%eax
80106673:	0f 84 e8 00 00 00    	je     80106761 <sys_link+0x141>
  ilock(ip);
80106679:	83 ec 0c             	sub    $0xc,%esp
8010667c:	50                   	push   %eax
8010667d:	e8 fe b5 ff ff       	call   80101c80 <ilock>
  if(ip->type == T_DIR){
80106682:	83 c4 10             	add    $0x10,%esp
80106685:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010668a:	0f 84 b9 00 00 00    	je     80106749 <sys_link+0x129>
  iupdate(ip);
80106690:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80106693:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80106698:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
8010669b:	53                   	push   %ebx
8010669c:	e8 1f b5 ff ff       	call   80101bc0 <iupdate>
  iunlock(ip);
801066a1:	89 1c 24             	mov    %ebx,(%esp)
801066a4:	e8 b7 b6 ff ff       	call   80101d60 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801066a9:	58                   	pop    %eax
801066aa:	5a                   	pop    %edx
801066ab:	57                   	push   %edi
801066ac:	ff 75 d0             	pushl  -0x30(%ebp)
801066af:	e8 bc be ff ff       	call   80102570 <nameiparent>
801066b4:	83 c4 10             	add    $0x10,%esp
801066b7:	89 c6                	mov    %eax,%esi
801066b9:	85 c0                	test   %eax,%eax
801066bb:	74 5f                	je     8010671c <sys_link+0xfc>
  ilock(dp);
801066bd:	83 ec 0c             	sub    $0xc,%esp
801066c0:	50                   	push   %eax
801066c1:	e8 ba b5 ff ff       	call   80101c80 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801066c6:	8b 03                	mov    (%ebx),%eax
801066c8:	83 c4 10             	add    $0x10,%esp
801066cb:	39 06                	cmp    %eax,(%esi)
801066cd:	75 41                	jne    80106710 <sys_link+0xf0>
801066cf:	83 ec 04             	sub    $0x4,%esp
801066d2:	ff 73 04             	pushl  0x4(%ebx)
801066d5:	57                   	push   %edi
801066d6:	56                   	push   %esi
801066d7:	e8 b4 bd ff ff       	call   80102490 <dirlink>
801066dc:	83 c4 10             	add    $0x10,%esp
801066df:	85 c0                	test   %eax,%eax
801066e1:	78 2d                	js     80106710 <sys_link+0xf0>
  iunlockput(dp);
801066e3:	83 ec 0c             	sub    $0xc,%esp
801066e6:	56                   	push   %esi
801066e7:	e8 34 b8 ff ff       	call   80101f20 <iunlockput>
  iput(ip);
801066ec:	89 1c 24             	mov    %ebx,(%esp)
801066ef:	e8 bc b6 ff ff       	call   80101db0 <iput>
  end_op();
801066f4:	e8 c7 cb ff ff       	call   801032c0 <end_op>
  return 0;
801066f9:	83 c4 10             	add    $0x10,%esp
801066fc:	31 c0                	xor    %eax,%eax
}
801066fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106701:	5b                   	pop    %ebx
80106702:	5e                   	pop    %esi
80106703:	5f                   	pop    %edi
80106704:	5d                   	pop    %ebp
80106705:	c3                   	ret    
80106706:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010670d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80106710:	83 ec 0c             	sub    $0xc,%esp
80106713:	56                   	push   %esi
80106714:	e8 07 b8 ff ff       	call   80101f20 <iunlockput>
    goto bad;
80106719:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010671c:	83 ec 0c             	sub    $0xc,%esp
8010671f:	53                   	push   %ebx
80106720:	e8 5b b5 ff ff       	call   80101c80 <ilock>
  ip->nlink--;
80106725:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010672a:	89 1c 24             	mov    %ebx,(%esp)
8010672d:	e8 8e b4 ff ff       	call   80101bc0 <iupdate>
  iunlockput(ip);
80106732:	89 1c 24             	mov    %ebx,(%esp)
80106735:	e8 e6 b7 ff ff       	call   80101f20 <iunlockput>
  end_op();
8010673a:	e8 81 cb ff ff       	call   801032c0 <end_op>
  return -1;
8010673f:	83 c4 10             	add    $0x10,%esp
80106742:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106747:	eb b5                	jmp    801066fe <sys_link+0xde>
    iunlockput(ip);
80106749:	83 ec 0c             	sub    $0xc,%esp
8010674c:	53                   	push   %ebx
8010674d:	e8 ce b7 ff ff       	call   80101f20 <iunlockput>
    end_op();
80106752:	e8 69 cb ff ff       	call   801032c0 <end_op>
    return -1;
80106757:	83 c4 10             	add    $0x10,%esp
8010675a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010675f:	eb 9d                	jmp    801066fe <sys_link+0xde>
    end_op();
80106761:	e8 5a cb ff ff       	call   801032c0 <end_op>
    return -1;
80106766:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010676b:	eb 91                	jmp    801066fe <sys_link+0xde>
8010676d:	8d 76 00             	lea    0x0(%esi),%esi

80106770 <sys_unlink>:
{
80106770:	f3 0f 1e fb          	endbr32 
80106774:	55                   	push   %ebp
80106775:	89 e5                	mov    %esp,%ebp
80106777:	57                   	push   %edi
80106778:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80106779:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010677c:	53                   	push   %ebx
8010677d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80106780:	50                   	push   %eax
80106781:	6a 00                	push   $0x0
80106783:	e8 e8 f9 ff ff       	call   80106170 <argstr>
80106788:	83 c4 10             	add    $0x10,%esp
8010678b:	85 c0                	test   %eax,%eax
8010678d:	0f 88 7d 01 00 00    	js     80106910 <sys_unlink+0x1a0>
  begin_op();
80106793:	e8 b8 ca ff ff       	call   80103250 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80106798:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010679b:	83 ec 08             	sub    $0x8,%esp
8010679e:	53                   	push   %ebx
8010679f:	ff 75 c0             	pushl  -0x40(%ebp)
801067a2:	e8 c9 bd ff ff       	call   80102570 <nameiparent>
801067a7:	83 c4 10             	add    $0x10,%esp
801067aa:	89 c6                	mov    %eax,%esi
801067ac:	85 c0                	test   %eax,%eax
801067ae:	0f 84 66 01 00 00    	je     8010691a <sys_unlink+0x1aa>
  ilock(dp);
801067b4:	83 ec 0c             	sub    $0xc,%esp
801067b7:	50                   	push   %eax
801067b8:	e8 c3 b4 ff ff       	call   80101c80 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801067bd:	58                   	pop    %eax
801067be:	5a                   	pop    %edx
801067bf:	68 5c 96 10 80       	push   $0x8010965c
801067c4:	53                   	push   %ebx
801067c5:	e8 e6 b9 ff ff       	call   801021b0 <namecmp>
801067ca:	83 c4 10             	add    $0x10,%esp
801067cd:	85 c0                	test   %eax,%eax
801067cf:	0f 84 03 01 00 00    	je     801068d8 <sys_unlink+0x168>
801067d5:	83 ec 08             	sub    $0x8,%esp
801067d8:	68 5b 96 10 80       	push   $0x8010965b
801067dd:	53                   	push   %ebx
801067de:	e8 cd b9 ff ff       	call   801021b0 <namecmp>
801067e3:	83 c4 10             	add    $0x10,%esp
801067e6:	85 c0                	test   %eax,%eax
801067e8:	0f 84 ea 00 00 00    	je     801068d8 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
801067ee:	83 ec 04             	sub    $0x4,%esp
801067f1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801067f4:	50                   	push   %eax
801067f5:	53                   	push   %ebx
801067f6:	56                   	push   %esi
801067f7:	e8 d4 b9 ff ff       	call   801021d0 <dirlookup>
801067fc:	83 c4 10             	add    $0x10,%esp
801067ff:	89 c3                	mov    %eax,%ebx
80106801:	85 c0                	test   %eax,%eax
80106803:	0f 84 cf 00 00 00    	je     801068d8 <sys_unlink+0x168>
  ilock(ip);
80106809:	83 ec 0c             	sub    $0xc,%esp
8010680c:	50                   	push   %eax
8010680d:	e8 6e b4 ff ff       	call   80101c80 <ilock>
  if(ip->nlink < 1)
80106812:	83 c4 10             	add    $0x10,%esp
80106815:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010681a:	0f 8e 23 01 00 00    	jle    80106943 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106820:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106825:	8d 7d d8             	lea    -0x28(%ebp),%edi
80106828:	74 66                	je     80106890 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010682a:	83 ec 04             	sub    $0x4,%esp
8010682d:	6a 10                	push   $0x10
8010682f:	6a 00                	push   $0x0
80106831:	57                   	push   %edi
80106832:	e8 19 f5 ff ff       	call   80105d50 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106837:	6a 10                	push   $0x10
80106839:	ff 75 c4             	pushl  -0x3c(%ebp)
8010683c:	57                   	push   %edi
8010683d:	56                   	push   %esi
8010683e:	e8 3d b8 ff ff       	call   80102080 <writei>
80106843:	83 c4 20             	add    $0x20,%esp
80106846:	83 f8 10             	cmp    $0x10,%eax
80106849:	0f 85 e7 00 00 00    	jne    80106936 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
8010684f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106854:	0f 84 96 00 00 00    	je     801068f0 <sys_unlink+0x180>
  iunlockput(dp);
8010685a:	83 ec 0c             	sub    $0xc,%esp
8010685d:	56                   	push   %esi
8010685e:	e8 bd b6 ff ff       	call   80101f20 <iunlockput>
  ip->nlink--;
80106863:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80106868:	89 1c 24             	mov    %ebx,(%esp)
8010686b:	e8 50 b3 ff ff       	call   80101bc0 <iupdate>
  iunlockput(ip);
80106870:	89 1c 24             	mov    %ebx,(%esp)
80106873:	e8 a8 b6 ff ff       	call   80101f20 <iunlockput>
  end_op();
80106878:	e8 43 ca ff ff       	call   801032c0 <end_op>
  return 0;
8010687d:	83 c4 10             	add    $0x10,%esp
80106880:	31 c0                	xor    %eax,%eax
}
80106882:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106885:	5b                   	pop    %ebx
80106886:	5e                   	pop    %esi
80106887:	5f                   	pop    %edi
80106888:	5d                   	pop    %ebp
80106889:	c3                   	ret    
8010688a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106890:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80106894:	76 94                	jbe    8010682a <sys_unlink+0xba>
80106896:	ba 20 00 00 00       	mov    $0x20,%edx
8010689b:	eb 0b                	jmp    801068a8 <sys_unlink+0x138>
8010689d:	8d 76 00             	lea    0x0(%esi),%esi
801068a0:	83 c2 10             	add    $0x10,%edx
801068a3:	39 53 58             	cmp    %edx,0x58(%ebx)
801068a6:	76 82                	jbe    8010682a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801068a8:	6a 10                	push   $0x10
801068aa:	52                   	push   %edx
801068ab:	57                   	push   %edi
801068ac:	53                   	push   %ebx
801068ad:	89 55 b4             	mov    %edx,-0x4c(%ebp)
801068b0:	e8 cb b6 ff ff       	call   80101f80 <readi>
801068b5:	83 c4 10             	add    $0x10,%esp
801068b8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
801068bb:	83 f8 10             	cmp    $0x10,%eax
801068be:	75 69                	jne    80106929 <sys_unlink+0x1b9>
    if(de.inum != 0)
801068c0:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801068c5:	74 d9                	je     801068a0 <sys_unlink+0x130>
    iunlockput(ip);
801068c7:	83 ec 0c             	sub    $0xc,%esp
801068ca:	53                   	push   %ebx
801068cb:	e8 50 b6 ff ff       	call   80101f20 <iunlockput>
    goto bad;
801068d0:	83 c4 10             	add    $0x10,%esp
801068d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801068d7:	90                   	nop
  iunlockput(dp);
801068d8:	83 ec 0c             	sub    $0xc,%esp
801068db:	56                   	push   %esi
801068dc:	e8 3f b6 ff ff       	call   80101f20 <iunlockput>
  end_op();
801068e1:	e8 da c9 ff ff       	call   801032c0 <end_op>
  return -1;
801068e6:	83 c4 10             	add    $0x10,%esp
801068e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068ee:	eb 92                	jmp    80106882 <sys_unlink+0x112>
    iupdate(dp);
801068f0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801068f3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801068f8:	56                   	push   %esi
801068f9:	e8 c2 b2 ff ff       	call   80101bc0 <iupdate>
801068fe:	83 c4 10             	add    $0x10,%esp
80106901:	e9 54 ff ff ff       	jmp    8010685a <sys_unlink+0xea>
80106906:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010690d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106910:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106915:	e9 68 ff ff ff       	jmp    80106882 <sys_unlink+0x112>
    end_op();
8010691a:	e8 a1 c9 ff ff       	call   801032c0 <end_op>
    return -1;
8010691f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106924:	e9 59 ff ff ff       	jmp    80106882 <sys_unlink+0x112>
      panic("isdirempty: readi");
80106929:	83 ec 0c             	sub    $0xc,%esp
8010692c:	68 80 96 10 80       	push   $0x80109680
80106931:	e8 5a 9a ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80106936:	83 ec 0c             	sub    $0xc,%esp
80106939:	68 92 96 10 80       	push   $0x80109692
8010693e:	e8 4d 9a ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80106943:	83 ec 0c             	sub    $0xc,%esp
80106946:	68 6e 96 10 80       	push   $0x8010966e
8010694b:	e8 40 9a ff ff       	call   80100390 <panic>

80106950 <sys_open>:

int
sys_open(void)
{
80106950:	f3 0f 1e fb          	endbr32 
80106954:	55                   	push   %ebp
80106955:	89 e5                	mov    %esp,%ebp
80106957:	57                   	push   %edi
80106958:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106959:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
8010695c:	53                   	push   %ebx
8010695d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106960:	50                   	push   %eax
80106961:	6a 00                	push   $0x0
80106963:	e8 08 f8 ff ff       	call   80106170 <argstr>
80106968:	83 c4 10             	add    $0x10,%esp
8010696b:	85 c0                	test   %eax,%eax
8010696d:	0f 88 8a 00 00 00    	js     801069fd <sys_open+0xad>
80106973:	83 ec 08             	sub    $0x8,%esp
80106976:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106979:	50                   	push   %eax
8010697a:	6a 01                	push   $0x1
8010697c:	e8 3f f7 ff ff       	call   801060c0 <argint>
80106981:	83 c4 10             	add    $0x10,%esp
80106984:	85 c0                	test   %eax,%eax
80106986:	78 75                	js     801069fd <sys_open+0xad>
    return -1;

  begin_op();
80106988:	e8 c3 c8 ff ff       	call   80103250 <begin_op>

  if(omode & O_CREATE){
8010698d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80106991:	75 75                	jne    80106a08 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80106993:	83 ec 0c             	sub    $0xc,%esp
80106996:	ff 75 e0             	pushl  -0x20(%ebp)
80106999:	e8 b2 bb ff ff       	call   80102550 <namei>
8010699e:	83 c4 10             	add    $0x10,%esp
801069a1:	89 c6                	mov    %eax,%esi
801069a3:	85 c0                	test   %eax,%eax
801069a5:	74 7e                	je     80106a25 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801069a7:	83 ec 0c             	sub    $0xc,%esp
801069aa:	50                   	push   %eax
801069ab:	e8 d0 b2 ff ff       	call   80101c80 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801069b0:	83 c4 10             	add    $0x10,%esp
801069b3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801069b8:	0f 84 c2 00 00 00    	je     80106a80 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801069be:	e8 5d a9 ff ff       	call   80101320 <filealloc>
801069c3:	89 c7                	mov    %eax,%edi
801069c5:	85 c0                	test   %eax,%eax
801069c7:	74 23                	je     801069ec <sys_open+0x9c>
  struct proc *curproc = myproc();
801069c9:	e8 22 d5 ff ff       	call   80103ef0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801069ce:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801069d0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801069d4:	85 d2                	test   %edx,%edx
801069d6:	74 60                	je     80106a38 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801069d8:	83 c3 01             	add    $0x1,%ebx
801069db:	83 fb 10             	cmp    $0x10,%ebx
801069de:	75 f0                	jne    801069d0 <sys_open+0x80>
    if(f)
      fileclose(f);
801069e0:	83 ec 0c             	sub    $0xc,%esp
801069e3:	57                   	push   %edi
801069e4:	e8 f7 a9 ff ff       	call   801013e0 <fileclose>
801069e9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801069ec:	83 ec 0c             	sub    $0xc,%esp
801069ef:	56                   	push   %esi
801069f0:	e8 2b b5 ff ff       	call   80101f20 <iunlockput>
    end_op();
801069f5:	e8 c6 c8 ff ff       	call   801032c0 <end_op>
    return -1;
801069fa:	83 c4 10             	add    $0x10,%esp
801069fd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106a02:	eb 6d                	jmp    80106a71 <sys_open+0x121>
80106a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80106a08:	83 ec 0c             	sub    $0xc,%esp
80106a0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a0e:	31 c9                	xor    %ecx,%ecx
80106a10:	ba 02 00 00 00       	mov    $0x2,%edx
80106a15:	6a 00                	push   $0x0
80106a17:	e8 24 f8 ff ff       	call   80106240 <create>
    if(ip == 0){
80106a1c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80106a1f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80106a21:	85 c0                	test   %eax,%eax
80106a23:	75 99                	jne    801069be <sys_open+0x6e>
      end_op();
80106a25:	e8 96 c8 ff ff       	call   801032c0 <end_op>
      return -1;
80106a2a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106a2f:	eb 40                	jmp    80106a71 <sys_open+0x121>
80106a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80106a38:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80106a3b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80106a3f:	56                   	push   %esi
80106a40:	e8 1b b3 ff ff       	call   80101d60 <iunlock>
  end_op();
80106a45:	e8 76 c8 ff ff       	call   801032c0 <end_op>

  f->type = FD_INODE;
80106a4a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80106a50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106a53:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80106a56:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80106a59:	89 d0                	mov    %edx,%eax
  f->off = 0;
80106a5b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80106a62:	f7 d0                	not    %eax
80106a64:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106a67:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80106a6a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106a6d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80106a71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a74:	89 d8                	mov    %ebx,%eax
80106a76:	5b                   	pop    %ebx
80106a77:	5e                   	pop    %esi
80106a78:	5f                   	pop    %edi
80106a79:	5d                   	pop    %ebp
80106a7a:	c3                   	ret    
80106a7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106a7f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80106a80:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106a83:	85 c9                	test   %ecx,%ecx
80106a85:	0f 84 33 ff ff ff    	je     801069be <sys_open+0x6e>
80106a8b:	e9 5c ff ff ff       	jmp    801069ec <sys_open+0x9c>

80106a90 <sys_mkdir>:

int
sys_mkdir(void)
{
80106a90:	f3 0f 1e fb          	endbr32 
80106a94:	55                   	push   %ebp
80106a95:	89 e5                	mov    %esp,%ebp
80106a97:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106a9a:	e8 b1 c7 ff ff       	call   80103250 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106a9f:	83 ec 08             	sub    $0x8,%esp
80106aa2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106aa5:	50                   	push   %eax
80106aa6:	6a 00                	push   $0x0
80106aa8:	e8 c3 f6 ff ff       	call   80106170 <argstr>
80106aad:	83 c4 10             	add    $0x10,%esp
80106ab0:	85 c0                	test   %eax,%eax
80106ab2:	78 34                	js     80106ae8 <sys_mkdir+0x58>
80106ab4:	83 ec 0c             	sub    $0xc,%esp
80106ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106aba:	31 c9                	xor    %ecx,%ecx
80106abc:	ba 01 00 00 00       	mov    $0x1,%edx
80106ac1:	6a 00                	push   $0x0
80106ac3:	e8 78 f7 ff ff       	call   80106240 <create>
80106ac8:	83 c4 10             	add    $0x10,%esp
80106acb:	85 c0                	test   %eax,%eax
80106acd:	74 19                	je     80106ae8 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
80106acf:	83 ec 0c             	sub    $0xc,%esp
80106ad2:	50                   	push   %eax
80106ad3:	e8 48 b4 ff ff       	call   80101f20 <iunlockput>
  end_op();
80106ad8:	e8 e3 c7 ff ff       	call   801032c0 <end_op>
  return 0;
80106add:	83 c4 10             	add    $0x10,%esp
80106ae0:	31 c0                	xor    %eax,%eax
}
80106ae2:	c9                   	leave  
80106ae3:	c3                   	ret    
80106ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80106ae8:	e8 d3 c7 ff ff       	call   801032c0 <end_op>
    return -1;
80106aed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106af2:	c9                   	leave  
80106af3:	c3                   	ret    
80106af4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106afb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106aff:	90                   	nop

80106b00 <sys_mknod>:

int
sys_mknod(void)
{
80106b00:	f3 0f 1e fb          	endbr32 
80106b04:	55                   	push   %ebp
80106b05:	89 e5                	mov    %esp,%ebp
80106b07:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106b0a:	e8 41 c7 ff ff       	call   80103250 <begin_op>
  if((argstr(0, &path)) < 0 ||
80106b0f:	83 ec 08             	sub    $0x8,%esp
80106b12:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106b15:	50                   	push   %eax
80106b16:	6a 00                	push   $0x0
80106b18:	e8 53 f6 ff ff       	call   80106170 <argstr>
80106b1d:	83 c4 10             	add    $0x10,%esp
80106b20:	85 c0                	test   %eax,%eax
80106b22:	78 64                	js     80106b88 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80106b24:	83 ec 08             	sub    $0x8,%esp
80106b27:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b2a:	50                   	push   %eax
80106b2b:	6a 01                	push   $0x1
80106b2d:	e8 8e f5 ff ff       	call   801060c0 <argint>
  if((argstr(0, &path)) < 0 ||
80106b32:	83 c4 10             	add    $0x10,%esp
80106b35:	85 c0                	test   %eax,%eax
80106b37:	78 4f                	js     80106b88 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80106b39:	83 ec 08             	sub    $0x8,%esp
80106b3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b3f:	50                   	push   %eax
80106b40:	6a 02                	push   $0x2
80106b42:	e8 79 f5 ff ff       	call   801060c0 <argint>
     argint(1, &major) < 0 ||
80106b47:	83 c4 10             	add    $0x10,%esp
80106b4a:	85 c0                	test   %eax,%eax
80106b4c:	78 3a                	js     80106b88 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
80106b4e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80106b52:	83 ec 0c             	sub    $0xc,%esp
80106b55:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80106b59:	ba 03 00 00 00       	mov    $0x3,%edx
80106b5e:	50                   	push   %eax
80106b5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106b62:	e8 d9 f6 ff ff       	call   80106240 <create>
     argint(2, &minor) < 0 ||
80106b67:	83 c4 10             	add    $0x10,%esp
80106b6a:	85 c0                	test   %eax,%eax
80106b6c:	74 1a                	je     80106b88 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
80106b6e:	83 ec 0c             	sub    $0xc,%esp
80106b71:	50                   	push   %eax
80106b72:	e8 a9 b3 ff ff       	call   80101f20 <iunlockput>
  end_op();
80106b77:	e8 44 c7 ff ff       	call   801032c0 <end_op>
  return 0;
80106b7c:	83 c4 10             	add    $0x10,%esp
80106b7f:	31 c0                	xor    %eax,%eax
}
80106b81:	c9                   	leave  
80106b82:	c3                   	ret    
80106b83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106b87:	90                   	nop
    end_op();
80106b88:	e8 33 c7 ff ff       	call   801032c0 <end_op>
    return -1;
80106b8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b92:	c9                   	leave  
80106b93:	c3                   	ret    
80106b94:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106b9f:	90                   	nop

80106ba0 <sys_chdir>:

int
sys_chdir(void)
{
80106ba0:	f3 0f 1e fb          	endbr32 
80106ba4:	55                   	push   %ebp
80106ba5:	89 e5                	mov    %esp,%ebp
80106ba7:	56                   	push   %esi
80106ba8:	53                   	push   %ebx
80106ba9:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80106bac:	e8 3f d3 ff ff       	call   80103ef0 <myproc>
80106bb1:	89 c6                	mov    %eax,%esi
  
  begin_op();
80106bb3:	e8 98 c6 ff ff       	call   80103250 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106bb8:	83 ec 08             	sub    $0x8,%esp
80106bbb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106bbe:	50                   	push   %eax
80106bbf:	6a 00                	push   $0x0
80106bc1:	e8 aa f5 ff ff       	call   80106170 <argstr>
80106bc6:	83 c4 10             	add    $0x10,%esp
80106bc9:	85 c0                	test   %eax,%eax
80106bcb:	78 73                	js     80106c40 <sys_chdir+0xa0>
80106bcd:	83 ec 0c             	sub    $0xc,%esp
80106bd0:	ff 75 f4             	pushl  -0xc(%ebp)
80106bd3:	e8 78 b9 ff ff       	call   80102550 <namei>
80106bd8:	83 c4 10             	add    $0x10,%esp
80106bdb:	89 c3                	mov    %eax,%ebx
80106bdd:	85 c0                	test   %eax,%eax
80106bdf:	74 5f                	je     80106c40 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80106be1:	83 ec 0c             	sub    $0xc,%esp
80106be4:	50                   	push   %eax
80106be5:	e8 96 b0 ff ff       	call   80101c80 <ilock>
  if(ip->type != T_DIR){
80106bea:	83 c4 10             	add    $0x10,%esp
80106bed:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80106bf2:	75 2c                	jne    80106c20 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106bf4:	83 ec 0c             	sub    $0xc,%esp
80106bf7:	53                   	push   %ebx
80106bf8:	e8 63 b1 ff ff       	call   80101d60 <iunlock>
  iput(curproc->cwd);
80106bfd:	58                   	pop    %eax
80106bfe:	ff 76 68             	pushl  0x68(%esi)
80106c01:	e8 aa b1 ff ff       	call   80101db0 <iput>
  end_op();
80106c06:	e8 b5 c6 ff ff       	call   801032c0 <end_op>
  curproc->cwd = ip;
80106c0b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80106c0e:	83 c4 10             	add    $0x10,%esp
80106c11:	31 c0                	xor    %eax,%eax
}
80106c13:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106c16:	5b                   	pop    %ebx
80106c17:	5e                   	pop    %esi
80106c18:	5d                   	pop    %ebp
80106c19:	c3                   	ret    
80106c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80106c20:	83 ec 0c             	sub    $0xc,%esp
80106c23:	53                   	push   %ebx
80106c24:	e8 f7 b2 ff ff       	call   80101f20 <iunlockput>
    end_op();
80106c29:	e8 92 c6 ff ff       	call   801032c0 <end_op>
    return -1;
80106c2e:	83 c4 10             	add    $0x10,%esp
80106c31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c36:	eb db                	jmp    80106c13 <sys_chdir+0x73>
80106c38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c3f:	90                   	nop
    end_op();
80106c40:	e8 7b c6 ff ff       	call   801032c0 <end_op>
    return -1;
80106c45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c4a:	eb c7                	jmp    80106c13 <sys_chdir+0x73>
80106c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106c50 <sys_exec>:

int
sys_exec(void)
{
80106c50:	f3 0f 1e fb          	endbr32 
80106c54:	55                   	push   %ebp
80106c55:	89 e5                	mov    %esp,%ebp
80106c57:	57                   	push   %edi
80106c58:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106c59:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80106c5f:	53                   	push   %ebx
80106c60:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106c66:	50                   	push   %eax
80106c67:	6a 00                	push   $0x0
80106c69:	e8 02 f5 ff ff       	call   80106170 <argstr>
80106c6e:	83 c4 10             	add    $0x10,%esp
80106c71:	85 c0                	test   %eax,%eax
80106c73:	0f 88 8b 00 00 00    	js     80106d04 <sys_exec+0xb4>
80106c79:	83 ec 08             	sub    $0x8,%esp
80106c7c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80106c82:	50                   	push   %eax
80106c83:	6a 01                	push   $0x1
80106c85:	e8 36 f4 ff ff       	call   801060c0 <argint>
80106c8a:	83 c4 10             	add    $0x10,%esp
80106c8d:	85 c0                	test   %eax,%eax
80106c8f:	78 73                	js     80106d04 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80106c91:	83 ec 04             	sub    $0x4,%esp
80106c94:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80106c9a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80106c9c:	68 80 00 00 00       	push   $0x80
80106ca1:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80106ca7:	6a 00                	push   $0x0
80106ca9:	50                   	push   %eax
80106caa:	e8 a1 f0 ff ff       	call   80105d50 <memset>
80106caf:	83 c4 10             	add    $0x10,%esp
80106cb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106cb8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106cbe:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80106cc5:	83 ec 08             	sub    $0x8,%esp
80106cc8:	57                   	push   %edi
80106cc9:	01 f0                	add    %esi,%eax
80106ccb:	50                   	push   %eax
80106ccc:	e8 4f f3 ff ff       	call   80106020 <fetchint>
80106cd1:	83 c4 10             	add    $0x10,%esp
80106cd4:	85 c0                	test   %eax,%eax
80106cd6:	78 2c                	js     80106d04 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80106cd8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80106cde:	85 c0                	test   %eax,%eax
80106ce0:	74 36                	je     80106d18 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106ce2:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80106ce8:	83 ec 08             	sub    $0x8,%esp
80106ceb:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80106cee:	52                   	push   %edx
80106cef:	50                   	push   %eax
80106cf0:	e8 6b f3 ff ff       	call   80106060 <fetchstr>
80106cf5:	83 c4 10             	add    $0x10,%esp
80106cf8:	85 c0                	test   %eax,%eax
80106cfa:	78 08                	js     80106d04 <sys_exec+0xb4>
  for(i=0;; i++){
80106cfc:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80106cff:	83 fb 20             	cmp    $0x20,%ebx
80106d02:	75 b4                	jne    80106cb8 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80106d04:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80106d07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d0c:	5b                   	pop    %ebx
80106d0d:	5e                   	pop    %esi
80106d0e:	5f                   	pop    %edi
80106d0f:	5d                   	pop    %ebp
80106d10:	c3                   	ret    
80106d11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106d18:	83 ec 08             	sub    $0x8,%esp
80106d1b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80106d21:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106d28:	00 00 00 00 
  return exec(path, argv);
80106d2c:	50                   	push   %eax
80106d2d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80106d33:	e8 38 a2 ff ff       	call   80100f70 <exec>
80106d38:	83 c4 10             	add    $0x10,%esp
}
80106d3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d3e:	5b                   	pop    %ebx
80106d3f:	5e                   	pop    %esi
80106d40:	5f                   	pop    %edi
80106d41:	5d                   	pop    %ebp
80106d42:	c3                   	ret    
80106d43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d50 <sys_pipe>:

int
sys_pipe(void)
{
80106d50:	f3 0f 1e fb          	endbr32 
80106d54:	55                   	push   %ebp
80106d55:	89 e5                	mov    %esp,%ebp
80106d57:	57                   	push   %edi
80106d58:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106d59:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106d5c:	53                   	push   %ebx
80106d5d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106d60:	6a 08                	push   $0x8
80106d62:	50                   	push   %eax
80106d63:	6a 00                	push   $0x0
80106d65:	e8 a6 f3 ff ff       	call   80106110 <argptr>
80106d6a:	83 c4 10             	add    $0x10,%esp
80106d6d:	85 c0                	test   %eax,%eax
80106d6f:	78 4e                	js     80106dbf <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106d71:	83 ec 08             	sub    $0x8,%esp
80106d74:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106d77:	50                   	push   %eax
80106d78:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106d7b:	50                   	push   %eax
80106d7c:	e8 9f cb ff ff       	call   80103920 <pipealloc>
80106d81:	83 c4 10             	add    $0x10,%esp
80106d84:	85 c0                	test   %eax,%eax
80106d86:	78 37                	js     80106dbf <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106d88:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80106d8b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80106d8d:	e8 5e d1 ff ff       	call   80103ef0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80106d98:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80106d9c:	85 f6                	test   %esi,%esi
80106d9e:	74 30                	je     80106dd0 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80106da0:	83 c3 01             	add    $0x1,%ebx
80106da3:	83 fb 10             	cmp    $0x10,%ebx
80106da6:	75 f0                	jne    80106d98 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80106da8:	83 ec 0c             	sub    $0xc,%esp
80106dab:	ff 75 e0             	pushl  -0x20(%ebp)
80106dae:	e8 2d a6 ff ff       	call   801013e0 <fileclose>
    fileclose(wf);
80106db3:	58                   	pop    %eax
80106db4:	ff 75 e4             	pushl  -0x1c(%ebp)
80106db7:	e8 24 a6 ff ff       	call   801013e0 <fileclose>
    return -1;
80106dbc:	83 c4 10             	add    $0x10,%esp
80106dbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106dc4:	eb 5b                	jmp    80106e21 <sys_pipe+0xd1>
80106dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dcd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80106dd0:	8d 73 08             	lea    0x8(%ebx),%esi
80106dd3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106dd7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80106dda:	e8 11 d1 ff ff       	call   80103ef0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80106ddf:	31 d2                	xor    %edx,%edx
80106de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80106de8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80106dec:	85 c9                	test   %ecx,%ecx
80106dee:	74 20                	je     80106e10 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80106df0:	83 c2 01             	add    $0x1,%edx
80106df3:	83 fa 10             	cmp    $0x10,%edx
80106df6:	75 f0                	jne    80106de8 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80106df8:	e8 f3 d0 ff ff       	call   80103ef0 <myproc>
80106dfd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106e04:	00 
80106e05:	eb a1                	jmp    80106da8 <sys_pipe+0x58>
80106e07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e0e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106e10:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80106e14:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106e17:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106e19:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106e1c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80106e1f:	31 c0                	xor    %eax,%eax
}
80106e21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e24:	5b                   	pop    %ebx
80106e25:	5e                   	pop    %esi
80106e26:	5f                   	pop    %edi
80106e27:	5d                   	pop    %ebp
80106e28:	c3                   	ret    
80106e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e30 <sys_copy_file>:

int 
sys_copy_file(void) {
80106e30:	f3 0f 1e fb          	endbr32 
80106e34:	55                   	push   %ebp
80106e35:	89 e5                	mov    %esp,%ebp
80106e37:	57                   	push   %edi
80106e38:	56                   	push   %esi
  struct inode* ip_dst;
  struct inode* ip_src;
  int bytesRead;
  char buf[1024];

  if (argstr(0, &src_path) < 0 || argstr(1, &dst_path) < 0)
80106e39:	8d 85 e0 fb ff ff    	lea    -0x420(%ebp),%eax
sys_copy_file(void) {
80106e3f:	53                   	push   %ebx
80106e40:	81 ec 34 04 00 00    	sub    $0x434,%esp
  if (argstr(0, &src_path) < 0 || argstr(1, &dst_path) < 0)
80106e46:	50                   	push   %eax
80106e47:	6a 00                	push   $0x0
80106e49:	e8 22 f3 ff ff       	call   80106170 <argstr>
80106e4e:	83 c4 10             	add    $0x10,%esp
80106e51:	85 c0                	test   %eax,%eax
80106e53:	0f 88 fa 00 00 00    	js     80106f53 <sys_copy_file+0x123>
80106e59:	83 ec 08             	sub    $0x8,%esp
80106e5c:	8d 85 e4 fb ff ff    	lea    -0x41c(%ebp),%eax
80106e62:	50                   	push   %eax
80106e63:	6a 01                	push   $0x1
80106e65:	e8 06 f3 ff ff       	call   80106170 <argstr>
80106e6a:	83 c4 10             	add    $0x10,%esp
80106e6d:	85 c0                	test   %eax,%eax
80106e6f:	0f 88 de 00 00 00    	js     80106f53 <sys_copy_file+0x123>
    return -1;
  begin_op();
80106e75:	e8 d6 c3 ff ff       	call   80103250 <begin_op>

  if ((ip_src = namei(src_path)) == 0) { // Check if source file exists
80106e7a:	83 ec 0c             	sub    $0xc,%esp
80106e7d:	ff b5 e0 fb ff ff    	pushl  -0x420(%ebp)
80106e83:	e8 c8 b6 ff ff       	call   80102550 <namei>
80106e88:	83 c4 10             	add    $0x10,%esp
80106e8b:	89 85 d4 fb ff ff    	mov    %eax,-0x42c(%ebp)
80106e91:	85 c0                	test   %eax,%eax
80106e93:	0f 84 b5 00 00 00    	je     80106f4e <sys_copy_file+0x11e>
    end_op();
    return -1;
  }
 
  ip_dst = namei(dst_path);
80106e99:	83 ec 0c             	sub    $0xc,%esp
80106e9c:	ff b5 e4 fb ff ff    	pushl  -0x41c(%ebp)
80106ea2:	e8 a9 b6 ff ff       	call   80102550 <namei>
  if (ip_dst > 0) { // Check if destination file already exists
80106ea7:	83 c4 10             	add    $0x10,%esp
80106eaa:	85 c0                	test   %eax,%eax
80106eac:	0f 85 9c 00 00 00    	jne    80106f4e <sys_copy_file+0x11e>
    end_op();
    return -1;
  }
  ip_dst = create(dst_path, T_FILE, 0, 0);
80106eb2:	83 ec 0c             	sub    $0xc,%esp
80106eb5:	8b 85 e4 fb ff ff    	mov    -0x41c(%ebp),%eax
80106ebb:	31 c9                	xor    %ecx,%ecx
80106ebd:	ba 02 00 00 00       	mov    $0x2,%edx
80106ec2:	6a 00                	push   $0x0

  int bytesWrote = 0;
  int readOffset = 0;
  int writeOffset = 0;
80106ec4:	31 f6                	xor    %esi,%esi
  int readOffset = 0;
80106ec6:	31 db                	xor    %ebx,%ebx
80106ec8:	8d bd e8 fb ff ff    	lea    -0x418(%ebp),%edi
  ip_dst = create(dst_path, T_FILE, 0, 0);
80106ece:	e8 6d f3 ff ff       	call   80106240 <create>
  ilock(ip_src);
80106ed3:	5a                   	pop    %edx
80106ed4:	ff b5 d4 fb ff ff    	pushl  -0x42c(%ebp)
  ip_dst = create(dst_path, T_FILE, 0, 0);
80106eda:	89 85 d0 fb ff ff    	mov    %eax,-0x430(%ebp)
  ilock(ip_src);
80106ee0:	e8 9b ad ff ff       	call   80101c80 <ilock>
  while ((bytesRead = readi(ip_src, buf, readOffset, sizeof(buf))) > 0) {
80106ee5:	83 c4 10             	add    $0x10,%esp
80106ee8:	eb 1f                	jmp    80106f09 <sys_copy_file+0xd9>
80106eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    readOffset += bytesRead;
    if ((bytesWrote = writei(ip_dst , buf,writeOffset,  bytesRead)) <= 0)
80106ef0:	50                   	push   %eax
    readOffset += bytesRead;
80106ef1:	01 c3                	add    %eax,%ebx
    if ((bytesWrote = writei(ip_dst , buf,writeOffset,  bytesRead)) <= 0)
80106ef3:	56                   	push   %esi
80106ef4:	57                   	push   %edi
80106ef5:	ff b5 d0 fb ff ff    	pushl  -0x430(%ebp)
80106efb:	e8 80 b1 ff ff       	call   80102080 <writei>
80106f00:	83 c4 10             	add    $0x10,%esp
80106f03:	85 c0                	test   %eax,%eax
80106f05:	7e 4c                	jle    80106f53 <sys_copy_file+0x123>
      return -1;
    writeOffset += bytesWrote;
80106f07:	01 c6                	add    %eax,%esi
  while ((bytesRead = readi(ip_src, buf, readOffset, sizeof(buf))) > 0) {
80106f09:	68 00 04 00 00       	push   $0x400
80106f0e:	53                   	push   %ebx
80106f0f:	57                   	push   %edi
80106f10:	ff b5 d4 fb ff ff    	pushl  -0x42c(%ebp)
80106f16:	e8 65 b0 ff ff       	call   80101f80 <readi>
80106f1b:	83 c4 10             	add    $0x10,%esp
80106f1e:	85 c0                	test   %eax,%eax
80106f20:	7f ce                	jg     80106ef0 <sys_copy_file+0xc0>
   
}

  iunlock(ip_src);
80106f22:	83 ec 0c             	sub    $0xc,%esp
80106f25:	ff b5 d4 fb ff ff    	pushl  -0x42c(%ebp)
80106f2b:	e8 30 ae ff ff       	call   80101d60 <iunlock>
  iunlock(ip_dst);
80106f30:	58                   	pop    %eax
80106f31:	ff b5 d0 fb ff ff    	pushl  -0x430(%ebp)
80106f37:	e8 24 ae ff ff       	call   80101d60 <iunlock>
  end_op();
80106f3c:	e8 7f c3 ff ff       	call   801032c0 <end_op>

  return 0;
80106f41:	83 c4 10             	add    $0x10,%esp
}
80106f44:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f47:	31 c0                	xor    %eax,%eax
}
80106f49:	5b                   	pop    %ebx
80106f4a:	5e                   	pop    %esi
80106f4b:	5f                   	pop    %edi
80106f4c:	5d                   	pop    %ebp
80106f4d:	c3                   	ret    
    end_op();
80106f4e:	e8 6d c3 ff ff       	call   801032c0 <end_op>
}
80106f53:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80106f56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f5b:	5b                   	pop    %ebx
80106f5c:	5e                   	pop    %esi
80106f5d:	5f                   	pop    %edi
80106f5e:	5d                   	pop    %ebp
80106f5f:	c3                   	ret    

80106f60 <sys_get_process_lifetime>:
    return -1;
  //cprintf("sysproc.h %d", pid);
  return get_process_lifetime(pid);
}*/

int sys_get_process_lifetime(void){
80106f60:	f3 0f 1e fb          	endbr32 
  return get_process_lifetime();
80106f64:	e9 47 da ff ff       	jmp    801049b0 <get_process_lifetime>
80106f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106f70 <sys_get_uncle_count>:
}

int sys_get_uncle_count(void){
80106f70:	f3 0f 1e fb          	endbr32 
80106f74:	55                   	push   %ebp
80106f75:	89 e5                	mov    %esp,%ebp
80106f77:	83 ec 20             	sub    $0x20,%esp
  int pid;
  if(argint(0, &pid) < 0){
80106f7a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106f7d:	50                   	push   %eax
80106f7e:	6a 00                	push   $0x0
80106f80:	e8 3b f1 ff ff       	call   801060c0 <argint>
80106f85:	83 c4 10             	add    $0x10,%esp
80106f88:	85 c0                	test   %eax,%eax
80106f8a:	78 14                	js     80106fa0 <sys_get_uncle_count+0x30>
    return -1;
  }
  return get_uncle_count(pid);
80106f8c:	83 ec 0c             	sub    $0xc,%esp
80106f8f:	ff 75 f4             	pushl  -0xc(%ebp)
80106f92:	e8 f9 d7 ff ff       	call   80104790 <get_uncle_count>
80106f97:	83 c4 10             	add    $0x10,%esp
}
80106f9a:	c9                   	leave  
80106f9b:	c3                   	ret    
80106f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106fa0:	c9                   	leave  
    return -1;
80106fa1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106fa6:	c3                   	ret    
80106fa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fae:	66 90                	xchg   %ax,%ax

80106fb0 <sys_fork>:

int
sys_fork(void)
{
80106fb0:	f3 0f 1e fb          	endbr32 
  return fork();
80106fb4:	e9 c7 db ff ff       	jmp    80104b80 <fork>
80106fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106fc0 <sys_exit>:
}

int
sys_exit(void)
{
80106fc0:	f3 0f 1e fb          	endbr32 
80106fc4:	55                   	push   %ebp
80106fc5:	89 e5                	mov    %esp,%ebp
80106fc7:	83 ec 08             	sub    $0x8,%esp
  exit();
80106fca:	e8 71 d3 ff ff       	call   80104340 <exit>
  return 0;  // not reached
}
80106fcf:	31 c0                	xor    %eax,%eax
80106fd1:	c9                   	leave  
80106fd2:	c3                   	ret    
80106fd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106fe0 <sys_wait>:

int
sys_wait(void)
{
80106fe0:	f3 0f 1e fb          	endbr32 
  return wait();
80106fe4:	e9 a7 d5 ff ff       	jmp    80104590 <wait>
80106fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ff0 <sys_kill>:
}

int
sys_kill(void)
{
80106ff0:	f3 0f 1e fb          	endbr32 
80106ff4:	55                   	push   %ebp
80106ff5:	89 e5                	mov    %esp,%ebp
80106ff7:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106ffa:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106ffd:	50                   	push   %eax
80106ffe:	6a 00                	push   $0x0
80107000:	e8 bb f0 ff ff       	call   801060c0 <argint>
80107005:	83 c4 10             	add    $0x10,%esp
80107008:	85 c0                	test   %eax,%eax
8010700a:	78 14                	js     80107020 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010700c:	83 ec 0c             	sub    $0xc,%esp
8010700f:	ff 75 f4             	pushl  -0xc(%ebp)
80107012:	e8 e9 d6 ff ff       	call   80104700 <kill>
80107017:	83 c4 10             	add    $0x10,%esp
}
8010701a:	c9                   	leave  
8010701b:	c3                   	ret    
8010701c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107020:	c9                   	leave  
    return -1;
80107021:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107026:	c3                   	ret    
80107027:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010702e:	66 90                	xchg   %ax,%ax

80107030 <sys_getpid>:

int
sys_getpid(void)
{
80107030:	f3 0f 1e fb          	endbr32 
80107034:	55                   	push   %ebp
80107035:	89 e5                	mov    %esp,%ebp
80107037:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010703a:	e8 b1 ce ff ff       	call   80103ef0 <myproc>
8010703f:	8b 40 10             	mov    0x10(%eax),%eax
}
80107042:	c9                   	leave  
80107043:	c3                   	ret    
80107044:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010704b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010704f:	90                   	nop

80107050 <sys_sbrk>:

int
sys_sbrk(void)
{
80107050:	f3 0f 1e fb          	endbr32 
80107054:	55                   	push   %ebp
80107055:	89 e5                	mov    %esp,%ebp
80107057:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80107058:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010705b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010705e:	50                   	push   %eax
8010705f:	6a 00                	push   $0x0
80107061:	e8 5a f0 ff ff       	call   801060c0 <argint>
80107066:	83 c4 10             	add    $0x10,%esp
80107069:	85 c0                	test   %eax,%eax
8010706b:	78 23                	js     80107090 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010706d:	e8 7e ce ff ff       	call   80103ef0 <myproc>
  if(growproc(n) < 0)
80107072:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80107075:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80107077:	ff 75 f4             	pushl  -0xc(%ebp)
8010707a:	e8 a1 ce ff ff       	call   80103f20 <growproc>
8010707f:	83 c4 10             	add    $0x10,%esp
80107082:	85 c0                	test   %eax,%eax
80107084:	78 0a                	js     80107090 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80107086:	89 d8                	mov    %ebx,%eax
80107088:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010708b:	c9                   	leave  
8010708c:	c3                   	ret    
8010708d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80107090:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80107095:	eb ef                	jmp    80107086 <sys_sbrk+0x36>
80107097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010709e:	66 90                	xchg   %ax,%ax

801070a0 <sys_sleep>:

int
sys_sleep(void)
{
801070a0:	f3 0f 1e fb          	endbr32 
801070a4:	55                   	push   %ebp
801070a5:	89 e5                	mov    %esp,%ebp
801070a7:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801070a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801070ab:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801070ae:	50                   	push   %eax
801070af:	6a 00                	push   $0x0
801070b1:	e8 0a f0 ff ff       	call   801060c0 <argint>
801070b6:	83 c4 10             	add    $0x10,%esp
801070b9:	85 c0                	test   %eax,%eax
801070bb:	0f 88 86 00 00 00    	js     80107147 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801070c1:	83 ec 0c             	sub    $0xc,%esp
801070c4:	68 a0 7e 11 80       	push   $0x80117ea0
801070c9:	e8 72 eb ff ff       	call   80105c40 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801070ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801070d1:	8b 1d e0 86 11 80    	mov    0x801186e0,%ebx
  while(ticks - ticks0 < n){
801070d7:	83 c4 10             	add    $0x10,%esp
801070da:	85 d2                	test   %edx,%edx
801070dc:	75 23                	jne    80107101 <sys_sleep+0x61>
801070de:	eb 50                	jmp    80107130 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801070e0:	83 ec 08             	sub    $0x8,%esp
801070e3:	68 a0 7e 11 80       	push   $0x80117ea0
801070e8:	68 e0 86 11 80       	push   $0x801186e0
801070ed:	e8 de d3 ff ff       	call   801044d0 <sleep>
  while(ticks - ticks0 < n){
801070f2:	a1 e0 86 11 80       	mov    0x801186e0,%eax
801070f7:	83 c4 10             	add    $0x10,%esp
801070fa:	29 d8                	sub    %ebx,%eax
801070fc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801070ff:	73 2f                	jae    80107130 <sys_sleep+0x90>
    if(myproc()->killed){
80107101:	e8 ea cd ff ff       	call   80103ef0 <myproc>
80107106:	8b 40 24             	mov    0x24(%eax),%eax
80107109:	85 c0                	test   %eax,%eax
8010710b:	74 d3                	je     801070e0 <sys_sleep+0x40>
      release(&tickslock);
8010710d:	83 ec 0c             	sub    $0xc,%esp
80107110:	68 a0 7e 11 80       	push   $0x80117ea0
80107115:	e8 e6 eb ff ff       	call   80105d00 <release>
  }
  release(&tickslock);
  return 0;
}
8010711a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
8010711d:	83 c4 10             	add    $0x10,%esp
80107120:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107125:	c9                   	leave  
80107126:	c3                   	ret    
80107127:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010712e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80107130:	83 ec 0c             	sub    $0xc,%esp
80107133:	68 a0 7e 11 80       	push   $0x80117ea0
80107138:	e8 c3 eb ff ff       	call   80105d00 <release>
  return 0;
8010713d:	83 c4 10             	add    $0x10,%esp
80107140:	31 c0                	xor    %eax,%eax
}
80107142:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107145:	c9                   	leave  
80107146:	c3                   	ret    
    return -1;
80107147:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010714c:	eb f4                	jmp    80107142 <sys_sleep+0xa2>
8010714e:	66 90                	xchg   %ax,%ax

80107150 <sys_change_sched_Q>:
int
sys_change_sched_Q(void)
{
80107150:	f3 0f 1e fb          	endbr32 
80107154:	55                   	push   %ebp
80107155:	89 e5                	mov    %esp,%ebp
80107157:	83 ec 20             	sub    $0x20,%esp
  int queue_number, pid;
  if(argint(0, &pid) < 0 || argint(1, &queue_number) < 0)
8010715a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010715d:	50                   	push   %eax
8010715e:	6a 00                	push   $0x0
80107160:	e8 5b ef ff ff       	call   801060c0 <argint>
80107165:	83 c4 10             	add    $0x10,%esp
80107168:	85 c0                	test   %eax,%eax
8010716a:	78 34                	js     801071a0 <sys_change_sched_Q+0x50>
8010716c:	83 ec 08             	sub    $0x8,%esp
8010716f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107172:	50                   	push   %eax
80107173:	6a 01                	push   $0x1
80107175:	e8 46 ef ff ff       	call   801060c0 <argint>
8010717a:	83 c4 10             	add    $0x10,%esp
8010717d:	85 c0                	test   %eax,%eax
8010717f:	78 1f                	js     801071a0 <sys_change_sched_Q+0x50>
    return -1;

  if(queue_number < ROUND_ROBIN || queue_number > BJF)
80107181:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107184:	8d 50 ff             	lea    -0x1(%eax),%edx
80107187:	83 fa 02             	cmp    $0x2,%edx
8010718a:	77 14                	ja     801071a0 <sys_change_sched_Q+0x50>
    return -1;

  return change_Q(pid, queue_number);
8010718c:	83 ec 08             	sub    $0x8,%esp
8010718f:	50                   	push   %eax
80107190:	ff 75 f4             	pushl  -0xc(%ebp)
80107193:	e8 48 d8 ff ff       	call   801049e0 <change_Q>
80107198:	83 c4 10             	add    $0x10,%esp
}
8010719b:	c9                   	leave  
8010719c:	c3                   	ret    
8010719d:	8d 76 00             	lea    0x0(%esi),%esi
801071a0:	c9                   	leave  
    return -1;
801071a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801071a6:	c3                   	ret    
801071a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071ae:	66 90                	xchg   %ax,%ax

801071b0 <sys_show_process_info>:

void sys_show_process_info(void) {
801071b0:	f3 0f 1e fb          	endbr32 
  show_process_info();
801071b4:	e9 27 dd ff ff       	jmp    80104ee0 <show_process_info>
801071b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801071c0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801071c0:	f3 0f 1e fb          	endbr32 
801071c4:	55                   	push   %ebp
801071c5:	89 e5                	mov    %esp,%ebp
801071c7:	53                   	push   %ebx
801071c8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801071cb:	68 a0 7e 11 80       	push   $0x80117ea0
801071d0:	e8 6b ea ff ff       	call   80105c40 <acquire>
  xticks = ticks;
801071d5:	8b 1d e0 86 11 80    	mov    0x801186e0,%ebx
  release(&tickslock);
801071db:	c7 04 24 a0 7e 11 80 	movl   $0x80117ea0,(%esp)
801071e2:	e8 19 eb ff ff       	call   80105d00 <release>
  return xticks;
}
801071e7:	89 d8                	mov    %ebx,%eax
801071e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801071ec:	c9                   	leave  
801071ed:	c3                   	ret    
801071ee:	66 90                	xchg   %ax,%ax

801071f0 <sys_find_digital_root>:

int
sys_find_digital_root(void)
{
801071f0:	f3 0f 1e fb          	endbr32 
801071f4:	55                   	push   %ebp
801071f5:	89 e5                	mov    %esp,%ebp
801071f7:	53                   	push   %ebx
801071f8:	83 ec 04             	sub    $0x4,%esp
  int n = myproc()->tf->ebx;
801071fb:	e8 f0 cc ff ff       	call   80103ef0 <myproc>
  cprintf("KERNEL: sys_find_digital_root(%d)\n", n);
80107200:	83 ec 08             	sub    $0x8,%esp
  int n = myproc()->tf->ebx;
80107203:	8b 40 18             	mov    0x18(%eax),%eax
80107206:	8b 58 10             	mov    0x10(%eax),%ebx
  cprintf("KERNEL: sys_find_digital_root(%d)\n", n);
80107209:	53                   	push   %ebx
8010720a:	68 a4 96 10 80       	push   $0x801096a4
8010720f:	e8 ac 96 ff ff       	call   801008c0 <cprintf>
  return find_digital_root(n);
80107214:	89 1c 24             	mov    %ebx,(%esp)
80107217:	e8 34 d7 ff ff       	call   80104950 <find_digital_root>

}
8010721c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010721f:	c9                   	leave  
80107220:	c3                   	ret    
80107221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010722f:	90                   	nop

80107230 <sys_priorityLock_test>:


void
sys_priorityLock_test(void){
80107230:	f3 0f 1e fb          	endbr32 
  priorityLock_test();
80107234:	e9 27 e5 ff ff       	jmp    80105760 <priorityLock_test>
80107239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107240 <sys_set_proc_bjf_params>:
//   return 0;
// }

int
sys_set_proc_bjf_params(void)
{
80107240:	f3 0f 1e fb          	endbr32 
80107244:	55                   	push   %ebp
80107245:	89 e5                	mov    %esp,%ebp
80107247:	83 ec 30             	sub    $0x30,%esp
  int pid;
  float priority_ratio, arrival_time_ratio, executed_cycle_ratio, process_size_ratio;
  if(argint(0, &pid) < 0 ||
8010724a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010724d:	50                   	push   %eax
8010724e:	6a 00                	push   $0x0
80107250:	e8 6b ee ff ff       	call   801060c0 <argint>
80107255:	83 c4 10             	add    $0x10,%esp
80107258:	85 c0                	test   %eax,%eax
8010725a:	78 74                	js     801072d0 <sys_set_proc_bjf_params+0x90>
     argfloat(1, &priority_ratio) < 0 ||
8010725c:	83 ec 08             	sub    $0x8,%esp
8010725f:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107262:	50                   	push   %eax
80107263:	6a 01                	push   $0x1
80107265:	e8 66 ed ff ff       	call   80105fd0 <argfloat>
  if(argint(0, &pid) < 0 ||
8010726a:	83 c4 10             	add    $0x10,%esp
8010726d:	85 c0                	test   %eax,%eax
8010726f:	78 5f                	js     801072d0 <sys_set_proc_bjf_params+0x90>
     argfloat(2, &arrival_time_ratio) < 0 ||
80107271:	83 ec 08             	sub    $0x8,%esp
80107274:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107277:	50                   	push   %eax
80107278:	6a 02                	push   $0x2
8010727a:	e8 51 ed ff ff       	call   80105fd0 <argfloat>
     argfloat(1, &priority_ratio) < 0 ||
8010727f:	83 c4 10             	add    $0x10,%esp
80107282:	85 c0                	test   %eax,%eax
80107284:	78 4a                	js     801072d0 <sys_set_proc_bjf_params+0x90>
     argfloat(3, &executed_cycle_ratio) < 0||
80107286:	83 ec 08             	sub    $0x8,%esp
80107289:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010728c:	50                   	push   %eax
8010728d:	6a 03                	push   $0x3
8010728f:	e8 3c ed ff ff       	call   80105fd0 <argfloat>
     argfloat(2, &arrival_time_ratio) < 0 ||
80107294:	83 c4 10             	add    $0x10,%esp
80107297:	85 c0                	test   %eax,%eax
80107299:	78 35                	js     801072d0 <sys_set_proc_bjf_params+0x90>
     argfloat(4, &process_size_ratio)<0 ){
8010729b:	83 ec 08             	sub    $0x8,%esp
8010729e:	8d 45 f4             	lea    -0xc(%ebp),%eax
801072a1:	50                   	push   %eax
801072a2:	6a 04                	push   $0x4
801072a4:	e8 27 ed ff ff       	call   80105fd0 <argfloat>
     argfloat(3, &executed_cycle_ratio) < 0||
801072a9:	83 c4 10             	add    $0x10,%esp
801072ac:	85 c0                	test   %eax,%eax
801072ae:	78 20                	js     801072d0 <sys_set_proc_bjf_params+0x90>
    return -1;
  }

  return set_proc_bjf_params(pid, priority_ratio, arrival_time_ratio, executed_cycle_ratio,process_size_ratio);
801072b0:	83 ec 0c             	sub    $0xc,%esp
801072b3:	ff 75 f4             	pushl  -0xc(%ebp)
801072b6:	ff 75 f0             	pushl  -0x10(%ebp)
801072b9:	ff 75 ec             	pushl  -0x14(%ebp)
801072bc:	ff 75 e8             	pushl  -0x18(%ebp)
801072bf:	ff 75 e4             	pushl  -0x1c(%ebp)
801072c2:	e8 09 db ff ff       	call   80104dd0 <set_proc_bjf_params>
801072c7:	83 c4 20             	add    $0x20,%esp
}
801072ca:	c9                   	leave  
801072cb:	c3                   	ret    
801072cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801072d0:	c9                   	leave  
    return -1;
801072d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801072d6:	c3                   	ret    
801072d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072de:	66 90                	xchg   %ax,%ax

801072e0 <sys_set_system_bjf_params>:

int
sys_set_system_bjf_params(void)
{
801072e0:	f3 0f 1e fb          	endbr32 
801072e4:	55                   	push   %ebp
801072e5:	89 e5                	mov    %esp,%ebp
801072e7:	83 ec 20             	sub    $0x20,%esp
  float priority_ratio, arrival_time_ratio, executed_cycle_ratio,process_size_ratio;
  if(argfloat(0, &priority_ratio) < 0 ||
801072ea:	8d 45 e8             	lea    -0x18(%ebp),%eax
801072ed:	50                   	push   %eax
801072ee:	6a 00                	push   $0x0
801072f0:	e8 db ec ff ff       	call   80105fd0 <argfloat>
801072f5:	83 c4 10             	add    $0x10,%esp
801072f8:	85 c0                	test   %eax,%eax
801072fa:	78 5c                	js     80107358 <sys_set_system_bjf_params+0x78>
     argfloat(1, &arrival_time_ratio) < 0 ||
801072fc:	83 ec 08             	sub    $0x8,%esp
801072ff:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107302:	50                   	push   %eax
80107303:	6a 01                	push   $0x1
80107305:	e8 c6 ec ff ff       	call   80105fd0 <argfloat>
  if(argfloat(0, &priority_ratio) < 0 ||
8010730a:	83 c4 10             	add    $0x10,%esp
8010730d:	85 c0                	test   %eax,%eax
8010730f:	78 47                	js     80107358 <sys_set_system_bjf_params+0x78>
     argfloat(2, &executed_cycle_ratio) < 0||
80107311:	83 ec 08             	sub    $0x8,%esp
80107314:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107317:	50                   	push   %eax
80107318:	6a 02                	push   $0x2
8010731a:	e8 b1 ec ff ff       	call   80105fd0 <argfloat>
     argfloat(1, &arrival_time_ratio) < 0 ||
8010731f:	83 c4 10             	add    $0x10,%esp
80107322:	85 c0                	test   %eax,%eax
80107324:	78 32                	js     80107358 <sys_set_system_bjf_params+0x78>
     argfloat(3,&process_size_ratio)<0){
80107326:	83 ec 08             	sub    $0x8,%esp
80107329:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010732c:	50                   	push   %eax
8010732d:	6a 03                	push   $0x3
8010732f:	e8 9c ec ff ff       	call   80105fd0 <argfloat>
     argfloat(2, &executed_cycle_ratio) < 0||
80107334:	83 c4 10             	add    $0x10,%esp
80107337:	85 c0                	test   %eax,%eax
80107339:	78 1d                	js     80107358 <sys_set_system_bjf_params+0x78>
    return -1;
  }

  set_system_bjf_params(priority_ratio, arrival_time_ratio, executed_cycle_ratio,process_size_ratio);
8010733b:	ff 75 f4             	pushl  -0xc(%ebp)
8010733e:	ff 75 f0             	pushl  -0x10(%ebp)
80107341:	ff 75 ec             	pushl  -0x14(%ebp)
80107344:	ff 75 e8             	pushl  -0x18(%ebp)
80107347:	e8 24 db ff ff       	call   80104e70 <set_system_bjf_params>
  return 0;
8010734c:	83 c4 10             	add    $0x10,%esp
8010734f:	31 c0                	xor    %eax,%eax
}
80107351:	c9                   	leave  
80107352:	c3                   	ret    
80107353:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107357:	90                   	nop
80107358:	c9                   	leave  
    return -1;
80107359:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010735e:	c3                   	ret    
8010735f:	90                   	nop

80107360 <sys_init_queue_test>:

int sys_init_queue_test(void) {
80107360:	f3 0f 1e fb          	endbr32 
80107364:	55                   	push   %ebp
80107365:	89 e5                	mov    %esp,%ebp
80107367:	83 ec 08             	sub    $0x8,%esp
  init_queue_test();
8010736a:	e8 d1 e4 ff ff       	call   80105840 <init_queue_test>
  return 0;
}
8010736f:	31 c0                	xor    %eax,%eax
80107371:	c9                   	leave  
80107372:	c3                   	ret    
80107373:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010737a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107380 <sys_syscalls_count>:

int sys_syscalls_count(void) {
80107380:	f3 0f 1e fb          	endbr32 
80107384:	55                   	push   %ebp
80107385:	89 e5                	mov    %esp,%ebp
80107387:	57                   	push   %edi
80107388:	56                   	push   %esi
80107389:	53                   	push   %ebx
8010738a:	83 ec 0c             	sub    $0xc,%esp
  int total_syscalls_count = 0;
  for(int i = 0 ; i < ncpu ; ++i) {
8010738d:	8b 0d 40 53 11 80    	mov    0x80115340,%ecx
80107393:	85 c9                	test   %ecx,%ecx
80107395:	7e 61                	jle    801073f8 <sys_syscalls_count+0x78>
80107397:	be 50 4e 11 80       	mov    $0x80114e50,%esi
8010739c:	31 db                	xor    %ebx,%ebx
  int total_syscalls_count = 0;
8010739e:	31 ff                	xor    %edi,%edi
    int syscalls_count = 0;
    syscalls_count += cpus[i].syscalls_count;
801073a0:	8b 06                	mov    (%esi),%eax
    total_syscalls_count += syscalls_count;
    cprintf("cpus[%d].syscalls_count = %d\n", i, syscalls_count);
801073a2:	83 ec 04             	sub    $0x4,%esp
801073a5:	81 c6 b4 00 00 00    	add    $0xb4,%esi
801073ab:	50                   	push   %eax
    total_syscalls_count += syscalls_count;
801073ac:	01 c7                	add    %eax,%edi
    cprintf("cpus[%d].syscalls_count = %d\n", i, syscalls_count);
801073ae:	53                   	push   %ebx
  for(int i = 0 ; i < ncpu ; ++i) {
801073af:	83 c3 01             	add    $0x1,%ebx
    cprintf("cpus[%d].syscalls_count = %d\n", i, syscalls_count);
801073b2:	68 c7 96 10 80       	push   $0x801096c7
801073b7:	e8 04 95 ff ff       	call   801008c0 <cprintf>
  for(int i = 0 ; i < ncpu ; ++i) {
801073bc:	83 c4 10             	add    $0x10,%esp
801073bf:	39 1d 40 53 11 80    	cmp    %ebx,0x80115340
801073c5:	7f d9                	jg     801073a0 <sys_syscalls_count+0x20>
  }
  cprintf("total_syscalls_count = %d\n", total_syscalls_count);
801073c7:	83 ec 08             	sub    $0x8,%esp
801073ca:	57                   	push   %edi
801073cb:	68 e5 96 10 80       	push   $0x801096e5
801073d0:	e8 eb 94 ff ff       	call   801008c0 <cprintf>
  cprintf("Shared syscalls count = %d\n", count_shared_syscalls);
801073d5:	58                   	pop    %eax
801073d6:	5a                   	pop    %edx
801073d7:	ff 35 c0 c5 10 80    	pushl  0x8010c5c0
801073dd:	68 00 97 10 80       	push   $0x80109700
801073e2:	e8 d9 94 ff ff       	call   801008c0 <cprintf>
  return total_syscalls_count;
}
801073e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073ea:	89 f8                	mov    %edi,%eax
801073ec:	5b                   	pop    %ebx
801073ed:	5e                   	pop    %esi
801073ee:	5f                   	pop    %edi
801073ef:	5d                   	pop    %ebp
801073f0:	c3                   	ret    
801073f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int total_syscalls_count = 0;
801073f8:	31 ff                	xor    %edi,%edi
801073fa:	eb cb                	jmp    801073c7 <sys_syscalls_count+0x47>

801073fc <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801073fc:	1e                   	push   %ds
  pushl %es
801073fd:	06                   	push   %es
  pushl %fs
801073fe:	0f a0                	push   %fs
  pushl %gs
80107400:	0f a8                	push   %gs
  pushal
80107402:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80107403:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80107407:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80107409:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010740b:	54                   	push   %esp
  call trap
8010740c:	e8 bf 00 00 00       	call   801074d0 <trap>
  addl $4, %esp
80107411:	83 c4 04             	add    $0x4,%esp

80107414 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80107414:	61                   	popa   
  popl %gs
80107415:	0f a9                	pop    %gs
  popl %fs
80107417:	0f a1                	pop    %fs
  popl %es
80107419:	07                   	pop    %es
  popl %ds
8010741a:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010741b:	83 c4 08             	add    $0x8,%esp
  iret
8010741e:	cf                   	iret   
8010741f:	90                   	nop

80107420 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80107420:	f3 0f 1e fb          	endbr32 
80107424:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80107425:	31 c0                	xor    %eax,%eax
{
80107427:	89 e5                	mov    %esp,%ebp
80107429:	83 ec 08             	sub    $0x8,%esp
8010742c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80107430:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
80107437:	c7 04 c5 e2 7e 11 80 	movl   $0x8e000008,-0x7fee811e(,%eax,8)
8010743e:	08 00 00 8e 
80107442:	66 89 14 c5 e0 7e 11 	mov    %dx,-0x7fee8120(,%eax,8)
80107449:	80 
8010744a:	c1 ea 10             	shr    $0x10,%edx
8010744d:	66 89 14 c5 e6 7e 11 	mov    %dx,-0x7fee811a(,%eax,8)
80107454:	80 
  for(i = 0; i < 256; i++)
80107455:	83 c0 01             	add    $0x1,%eax
80107458:	3d 00 01 00 00       	cmp    $0x100,%eax
8010745d:	75 d1                	jne    80107430 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010745f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80107462:	a1 08 c1 10 80       	mov    0x8010c108,%eax
80107467:	c7 05 e2 80 11 80 08 	movl   $0xef000008,0x801180e2
8010746e:	00 00 ef 
  initlock(&tickslock, "time");
80107471:	68 1c 97 10 80       	push   $0x8010971c
80107476:	68 a0 7e 11 80       	push   $0x80117ea0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010747b:	66 a3 e0 80 11 80    	mov    %ax,0x801180e0
80107481:	c1 e8 10             	shr    $0x10,%eax
80107484:	66 a3 e6 80 11 80    	mov    %ax,0x801180e6
  initlock(&tickslock, "time");
8010748a:	e8 31 e6 ff ff       	call   80105ac0 <initlock>
}
8010748f:	83 c4 10             	add    $0x10,%esp
80107492:	c9                   	leave  
80107493:	c3                   	ret    
80107494:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010749b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010749f:	90                   	nop

801074a0 <idtinit>:

void
idtinit(void)
{
801074a0:	f3 0f 1e fb          	endbr32 
801074a4:	55                   	push   %ebp
  pd[0] = size-1;
801074a5:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801074aa:	89 e5                	mov    %esp,%ebp
801074ac:	83 ec 10             	sub    $0x10,%esp
801074af:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801074b3:	b8 e0 7e 11 80       	mov    $0x80117ee0,%eax
801074b8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801074bc:	c1 e8 10             	shr    $0x10,%eax
801074bf:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801074c3:	8d 45 fa             	lea    -0x6(%ebp),%eax
801074c6:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801074c9:	c9                   	leave  
801074ca:	c3                   	ret    
801074cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801074cf:	90                   	nop

801074d0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801074d0:	f3 0f 1e fb          	endbr32 
801074d4:	55                   	push   %ebp
801074d5:	89 e5                	mov    %esp,%ebp
801074d7:	57                   	push   %edi
801074d8:	56                   	push   %esi
801074d9:	53                   	push   %ebx
801074da:	83 ec 1c             	sub    $0x1c,%esp
801074dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801074e0:	8b 43 30             	mov    0x30(%ebx),%eax
801074e3:	83 f8 40             	cmp    $0x40,%eax
801074e6:	0f 84 cc 01 00 00    	je     801076b8 <trap+0x1e8>
    if(myproc()->killed)
      exit();
    return;
  }
  int os_tick;
  switch(tf->trapno){
801074ec:	83 e8 20             	sub    $0x20,%eax
801074ef:	83 f8 1f             	cmp    $0x1f,%eax
801074f2:	77 08                	ja     801074fc <trap+0x2c>
801074f4:	3e ff 24 85 c4 97 10 	notrack jmp *-0x7fef683c(,%eax,4)
801074fb:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801074fc:	e8 ef c9 ff ff       	call   80103ef0 <myproc>
80107501:	8b 7b 38             	mov    0x38(%ebx),%edi
80107504:	85 c0                	test   %eax,%eax
80107506:	0f 84 fb 01 00 00    	je     80107707 <trap+0x237>
8010750c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80107510:	0f 84 f1 01 00 00    	je     80107707 <trap+0x237>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107516:	0f 20 d1             	mov    %cr2,%ecx
80107519:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010751c:	e8 af c9 ff ff       	call   80103ed0 <cpuid>
80107521:	8b 73 30             	mov    0x30(%ebx),%esi
80107524:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107527:	8b 43 34             	mov    0x34(%ebx),%eax
8010752a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010752d:	e8 be c9 ff ff       	call   80103ef0 <myproc>
80107532:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107535:	e8 b6 c9 ff ff       	call   80103ef0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010753a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
8010753d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80107540:	51                   	push   %ecx
80107541:	57                   	push   %edi
80107542:	52                   	push   %edx
80107543:	ff 75 e4             	pushl  -0x1c(%ebp)
80107546:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80107547:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010754a:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010754d:	56                   	push   %esi
8010754e:	ff 70 10             	pushl  0x10(%eax)
80107551:	68 80 97 10 80       	push   $0x80109780
80107556:	e8 65 93 ff ff       	call   801008c0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010755b:	83 c4 20             	add    $0x20,%esp
8010755e:	e8 8d c9 ff ff       	call   80103ef0 <myproc>
80107563:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010756a:	e8 81 c9 ff ff       	call   80103ef0 <myproc>
8010756f:	85 c0                	test   %eax,%eax
80107571:	74 1d                	je     80107590 <trap+0xc0>
80107573:	e8 78 c9 ff ff       	call   80103ef0 <myproc>
80107578:	8b 50 24             	mov    0x24(%eax),%edx
8010757b:	85 d2                	test   %edx,%edx
8010757d:	74 11                	je     80107590 <trap+0xc0>
8010757f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80107583:	83 e0 03             	and    $0x3,%eax
80107586:	66 83 f8 03          	cmp    $0x3,%ax
8010758a:	0f 84 60 01 00 00    	je     801076f0 <trap+0x220>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80107590:	e8 5b c9 ff ff       	call   80103ef0 <myproc>
80107595:	85 c0                	test   %eax,%eax
80107597:	74 0f                	je     801075a8 <trap+0xd8>
80107599:	e8 52 c9 ff ff       	call   80103ef0 <myproc>
8010759e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801075a2:	0f 84 f8 00 00 00    	je     801076a0 <trap+0x1d0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801075a8:	e8 43 c9 ff ff       	call   80103ef0 <myproc>
801075ad:	85 c0                	test   %eax,%eax
801075af:	74 1d                	je     801075ce <trap+0xfe>
801075b1:	e8 3a c9 ff ff       	call   80103ef0 <myproc>
801075b6:	8b 40 24             	mov    0x24(%eax),%eax
801075b9:	85 c0                	test   %eax,%eax
801075bb:	74 11                	je     801075ce <trap+0xfe>
801075bd:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801075c1:	83 e0 03             	and    $0x3,%eax
801075c4:	66 83 f8 03          	cmp    $0x3,%ax
801075c8:	0f 84 13 01 00 00    	je     801076e1 <trap+0x211>
    exit();
}
801075ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075d1:	5b                   	pop    %ebx
801075d2:	5e                   	pop    %esi
801075d3:	5f                   	pop    %edi
801075d4:	5d                   	pop    %ebp
801075d5:	c3                   	ret    
    ideintr();
801075d6:	e8 25 b1 ff ff       	call   80102700 <ideintr>
    lapiceoi();
801075db:	e8 00 b8 ff ff       	call   80102de0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801075e0:	e8 0b c9 ff ff       	call   80103ef0 <myproc>
801075e5:	85 c0                	test   %eax,%eax
801075e7:	75 8a                	jne    80107573 <trap+0xa3>
801075e9:	eb a5                	jmp    80107590 <trap+0xc0>
    if(cpuid() == 0){
801075eb:	e8 e0 c8 ff ff       	call   80103ed0 <cpuid>
801075f0:	85 c0                	test   %eax,%eax
801075f2:	75 e7                	jne    801075db <trap+0x10b>
      acquire(&tickslock);
801075f4:	83 ec 0c             	sub    $0xc,%esp
801075f7:	68 a0 7e 11 80       	push   $0x80117ea0
801075fc:	e8 3f e6 ff ff       	call   80105c40 <acquire>
      ticks++;
80107601:	a1 e0 86 11 80       	mov    0x801186e0,%eax
      wakeup(&ticks);
80107606:	c7 04 24 e0 86 11 80 	movl   $0x801186e0,(%esp)
      ticks++;
8010760d:	8d 70 01             	lea    0x1(%eax),%esi
80107610:	89 35 e0 86 11 80    	mov    %esi,0x801186e0
      wakeup(&ticks);
80107616:	e8 75 d0 ff ff       	call   80104690 <wakeup>
      release(&tickslock);
8010761b:	c7 04 24 a0 7e 11 80 	movl   $0x80117ea0,(%esp)
80107622:	e8 d9 e6 ff ff       	call   80105d00 <release>
      ageprocs(os_tick);
80107627:	89 34 24             	mov    %esi,(%esp)
8010762a:	e8 81 d6 ff ff       	call   80104cb0 <ageprocs>
8010762f:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80107632:	eb a7                	jmp    801075db <trap+0x10b>
    kbdintr();
80107634:	e8 67 b6 ff ff       	call   80102ca0 <kbdintr>
    lapiceoi();
80107639:	e8 a2 b7 ff ff       	call   80102de0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010763e:	e8 ad c8 ff ff       	call   80103ef0 <myproc>
80107643:	85 c0                	test   %eax,%eax
80107645:	0f 85 28 ff ff ff    	jne    80107573 <trap+0xa3>
8010764b:	e9 40 ff ff ff       	jmp    80107590 <trap+0xc0>
    uartintr();
80107650:	e8 4b 02 00 00       	call   801078a0 <uartintr>
    lapiceoi();
80107655:	e8 86 b7 ff ff       	call   80102de0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010765a:	e8 91 c8 ff ff       	call   80103ef0 <myproc>
8010765f:	85 c0                	test   %eax,%eax
80107661:	0f 85 0c ff ff ff    	jne    80107573 <trap+0xa3>
80107667:	e9 24 ff ff ff       	jmp    80107590 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010766c:	8b 7b 38             	mov    0x38(%ebx),%edi
8010766f:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80107673:	e8 58 c8 ff ff       	call   80103ed0 <cpuid>
80107678:	57                   	push   %edi
80107679:	56                   	push   %esi
8010767a:	50                   	push   %eax
8010767b:	68 28 97 10 80       	push   $0x80109728
80107680:	e8 3b 92 ff ff       	call   801008c0 <cprintf>
    lapiceoi();
80107685:	e8 56 b7 ff ff       	call   80102de0 <lapiceoi>
    break;
8010768a:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010768d:	e8 5e c8 ff ff       	call   80103ef0 <myproc>
80107692:	85 c0                	test   %eax,%eax
80107694:	0f 85 d9 fe ff ff    	jne    80107573 <trap+0xa3>
8010769a:	e9 f1 fe ff ff       	jmp    80107590 <trap+0xc0>
8010769f:	90                   	nop
  if(myproc() && myproc()->state == RUNNING &&
801076a0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801076a4:	0f 85 fe fe ff ff    	jne    801075a8 <trap+0xd8>
    yield();
801076aa:	e8 d1 cd ff ff       	call   80104480 <yield>
801076af:	e9 f4 fe ff ff       	jmp    801075a8 <trap+0xd8>
801076b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
801076b8:	e8 33 c8 ff ff       	call   80103ef0 <myproc>
801076bd:	8b 70 24             	mov    0x24(%eax),%esi
801076c0:	85 f6                	test   %esi,%esi
801076c2:	75 3c                	jne    80107700 <trap+0x230>
    myproc()->tf = tf;
801076c4:	e8 27 c8 ff ff       	call   80103ef0 <myproc>
801076c9:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801076cc:	e8 df ea ff ff       	call   801061b0 <syscall>
    if(myproc()->killed)
801076d1:	e8 1a c8 ff ff       	call   80103ef0 <myproc>
801076d6:	8b 48 24             	mov    0x24(%eax),%ecx
801076d9:	85 c9                	test   %ecx,%ecx
801076db:	0f 84 ed fe ff ff    	je     801075ce <trap+0xfe>
}
801076e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076e4:	5b                   	pop    %ebx
801076e5:	5e                   	pop    %esi
801076e6:	5f                   	pop    %edi
801076e7:	5d                   	pop    %ebp
      exit();
801076e8:	e9 53 cc ff ff       	jmp    80104340 <exit>
801076ed:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
801076f0:	e8 4b cc ff ff       	call   80104340 <exit>
801076f5:	e9 96 fe ff ff       	jmp    80107590 <trap+0xc0>
801076fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80107700:	e8 3b cc ff ff       	call   80104340 <exit>
80107705:	eb bd                	jmp    801076c4 <trap+0x1f4>
80107707:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010770a:	e8 c1 c7 ff ff       	call   80103ed0 <cpuid>
8010770f:	83 ec 0c             	sub    $0xc,%esp
80107712:	56                   	push   %esi
80107713:	57                   	push   %edi
80107714:	50                   	push   %eax
80107715:	ff 73 30             	pushl  0x30(%ebx)
80107718:	68 4c 97 10 80       	push   $0x8010974c
8010771d:	e8 9e 91 ff ff       	call   801008c0 <cprintf>
      panic("trap");
80107722:	83 c4 14             	add    $0x14,%esp
80107725:	68 21 97 10 80       	push   $0x80109721
8010772a:	e8 61 8c ff ff       	call   80100390 <panic>
8010772f:	90                   	nop

80107730 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80107730:	f3 0f 1e fb          	endbr32 
  if(!uart)
80107734:	a1 20 c6 10 80       	mov    0x8010c620,%eax
80107739:	85 c0                	test   %eax,%eax
8010773b:	74 1b                	je     80107758 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010773d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80107742:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80107743:	a8 01                	test   $0x1,%al
80107745:	74 11                	je     80107758 <uartgetc+0x28>
80107747:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010774c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010774d:	0f b6 c0             	movzbl %al,%eax
80107750:	c3                   	ret    
80107751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80107758:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010775d:	c3                   	ret    
8010775e:	66 90                	xchg   %ax,%ax

80107760 <uartputc.part.0>:
uartputc(int c)
80107760:	55                   	push   %ebp
80107761:	89 e5                	mov    %esp,%ebp
80107763:	57                   	push   %edi
80107764:	89 c7                	mov    %eax,%edi
80107766:	56                   	push   %esi
80107767:	be fd 03 00 00       	mov    $0x3fd,%esi
8010776c:	53                   	push   %ebx
8010776d:	bb 80 00 00 00       	mov    $0x80,%ebx
80107772:	83 ec 0c             	sub    $0xc,%esp
80107775:	eb 1b                	jmp    80107792 <uartputc.part.0+0x32>
80107777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010777e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80107780:	83 ec 0c             	sub    $0xc,%esp
80107783:	6a 0a                	push   $0xa
80107785:	e8 76 b6 ff ff       	call   80102e00 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010778a:	83 c4 10             	add    $0x10,%esp
8010778d:	83 eb 01             	sub    $0x1,%ebx
80107790:	74 07                	je     80107799 <uartputc.part.0+0x39>
80107792:	89 f2                	mov    %esi,%edx
80107794:	ec                   	in     (%dx),%al
80107795:	a8 20                	test   $0x20,%al
80107797:	74 e7                	je     80107780 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107799:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010779e:	89 f8                	mov    %edi,%eax
801077a0:	ee                   	out    %al,(%dx)
}
801077a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077a4:	5b                   	pop    %ebx
801077a5:	5e                   	pop    %esi
801077a6:	5f                   	pop    %edi
801077a7:	5d                   	pop    %ebp
801077a8:	c3                   	ret    
801077a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801077b0 <uartinit>:
{
801077b0:	f3 0f 1e fb          	endbr32 
801077b4:	55                   	push   %ebp
801077b5:	31 c9                	xor    %ecx,%ecx
801077b7:	89 c8                	mov    %ecx,%eax
801077b9:	89 e5                	mov    %esp,%ebp
801077bb:	57                   	push   %edi
801077bc:	56                   	push   %esi
801077bd:	53                   	push   %ebx
801077be:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801077c3:	89 da                	mov    %ebx,%edx
801077c5:	83 ec 0c             	sub    $0xc,%esp
801077c8:	ee                   	out    %al,(%dx)
801077c9:	bf fb 03 00 00       	mov    $0x3fb,%edi
801077ce:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801077d3:	89 fa                	mov    %edi,%edx
801077d5:	ee                   	out    %al,(%dx)
801077d6:	b8 0c 00 00 00       	mov    $0xc,%eax
801077db:	ba f8 03 00 00       	mov    $0x3f8,%edx
801077e0:	ee                   	out    %al,(%dx)
801077e1:	be f9 03 00 00       	mov    $0x3f9,%esi
801077e6:	89 c8                	mov    %ecx,%eax
801077e8:	89 f2                	mov    %esi,%edx
801077ea:	ee                   	out    %al,(%dx)
801077eb:	b8 03 00 00 00       	mov    $0x3,%eax
801077f0:	89 fa                	mov    %edi,%edx
801077f2:	ee                   	out    %al,(%dx)
801077f3:	ba fc 03 00 00       	mov    $0x3fc,%edx
801077f8:	89 c8                	mov    %ecx,%eax
801077fa:	ee                   	out    %al,(%dx)
801077fb:	b8 01 00 00 00       	mov    $0x1,%eax
80107800:	89 f2                	mov    %esi,%edx
80107802:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107803:	ba fd 03 00 00       	mov    $0x3fd,%edx
80107808:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80107809:	3c ff                	cmp    $0xff,%al
8010780b:	74 52                	je     8010785f <uartinit+0xaf>
  uart = 1;
8010780d:	c7 05 20 c6 10 80 01 	movl   $0x1,0x8010c620
80107814:	00 00 00 
80107817:	89 da                	mov    %ebx,%edx
80107819:	ec                   	in     (%dx),%al
8010781a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010781f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80107820:	83 ec 08             	sub    $0x8,%esp
80107823:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80107828:	bb 44 98 10 80       	mov    $0x80109844,%ebx
  ioapicenable(IRQ_COM1, 0);
8010782d:	6a 00                	push   $0x0
8010782f:	6a 04                	push   $0x4
80107831:	e8 1a b1 ff ff       	call   80102950 <ioapicenable>
80107836:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80107839:	b8 78 00 00 00       	mov    $0x78,%eax
8010783e:	eb 04                	jmp    80107844 <uartinit+0x94>
80107840:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80107844:	8b 15 20 c6 10 80    	mov    0x8010c620,%edx
8010784a:	85 d2                	test   %edx,%edx
8010784c:	74 08                	je     80107856 <uartinit+0xa6>
    uartputc(*p);
8010784e:	0f be c0             	movsbl %al,%eax
80107851:	e8 0a ff ff ff       	call   80107760 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80107856:	89 f0                	mov    %esi,%eax
80107858:	83 c3 01             	add    $0x1,%ebx
8010785b:	84 c0                	test   %al,%al
8010785d:	75 e1                	jne    80107840 <uartinit+0x90>
}
8010785f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107862:	5b                   	pop    %ebx
80107863:	5e                   	pop    %esi
80107864:	5f                   	pop    %edi
80107865:	5d                   	pop    %ebp
80107866:	c3                   	ret    
80107867:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010786e:	66 90                	xchg   %ax,%ax

80107870 <uartputc>:
{
80107870:	f3 0f 1e fb          	endbr32 
80107874:	55                   	push   %ebp
  if(!uart)
80107875:	8b 15 20 c6 10 80    	mov    0x8010c620,%edx
{
8010787b:	89 e5                	mov    %esp,%ebp
8010787d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80107880:	85 d2                	test   %edx,%edx
80107882:	74 0c                	je     80107890 <uartputc+0x20>
}
80107884:	5d                   	pop    %ebp
80107885:	e9 d6 fe ff ff       	jmp    80107760 <uartputc.part.0>
8010788a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107890:	5d                   	pop    %ebp
80107891:	c3                   	ret    
80107892:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801078a0 <uartintr>:

void
uartintr(void)
{
801078a0:	f3 0f 1e fb          	endbr32 
801078a4:	55                   	push   %ebp
801078a5:	89 e5                	mov    %esp,%ebp
801078a7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801078aa:	68 30 77 10 80       	push   $0x80107730
801078af:	e8 bc 91 ff ff       	call   80100a70 <consoleintr>
}
801078b4:	83 c4 10             	add    $0x10,%esp
801078b7:	c9                   	leave  
801078b8:	c3                   	ret    

801078b9 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801078b9:	6a 00                	push   $0x0
  pushl $0
801078bb:	6a 00                	push   $0x0
  jmp alltraps
801078bd:	e9 3a fb ff ff       	jmp    801073fc <alltraps>

801078c2 <vector1>:
.globl vector1
vector1:
  pushl $0
801078c2:	6a 00                	push   $0x0
  pushl $1
801078c4:	6a 01                	push   $0x1
  jmp alltraps
801078c6:	e9 31 fb ff ff       	jmp    801073fc <alltraps>

801078cb <vector2>:
.globl vector2
vector2:
  pushl $0
801078cb:	6a 00                	push   $0x0
  pushl $2
801078cd:	6a 02                	push   $0x2
  jmp alltraps
801078cf:	e9 28 fb ff ff       	jmp    801073fc <alltraps>

801078d4 <vector3>:
.globl vector3
vector3:
  pushl $0
801078d4:	6a 00                	push   $0x0
  pushl $3
801078d6:	6a 03                	push   $0x3
  jmp alltraps
801078d8:	e9 1f fb ff ff       	jmp    801073fc <alltraps>

801078dd <vector4>:
.globl vector4
vector4:
  pushl $0
801078dd:	6a 00                	push   $0x0
  pushl $4
801078df:	6a 04                	push   $0x4
  jmp alltraps
801078e1:	e9 16 fb ff ff       	jmp    801073fc <alltraps>

801078e6 <vector5>:
.globl vector5
vector5:
  pushl $0
801078e6:	6a 00                	push   $0x0
  pushl $5
801078e8:	6a 05                	push   $0x5
  jmp alltraps
801078ea:	e9 0d fb ff ff       	jmp    801073fc <alltraps>

801078ef <vector6>:
.globl vector6
vector6:
  pushl $0
801078ef:	6a 00                	push   $0x0
  pushl $6
801078f1:	6a 06                	push   $0x6
  jmp alltraps
801078f3:	e9 04 fb ff ff       	jmp    801073fc <alltraps>

801078f8 <vector7>:
.globl vector7
vector7:
  pushl $0
801078f8:	6a 00                	push   $0x0
  pushl $7
801078fa:	6a 07                	push   $0x7
  jmp alltraps
801078fc:	e9 fb fa ff ff       	jmp    801073fc <alltraps>

80107901 <vector8>:
.globl vector8
vector8:
  pushl $8
80107901:	6a 08                	push   $0x8
  jmp alltraps
80107903:	e9 f4 fa ff ff       	jmp    801073fc <alltraps>

80107908 <vector9>:
.globl vector9
vector9:
  pushl $0
80107908:	6a 00                	push   $0x0
  pushl $9
8010790a:	6a 09                	push   $0x9
  jmp alltraps
8010790c:	e9 eb fa ff ff       	jmp    801073fc <alltraps>

80107911 <vector10>:
.globl vector10
vector10:
  pushl $10
80107911:	6a 0a                	push   $0xa
  jmp alltraps
80107913:	e9 e4 fa ff ff       	jmp    801073fc <alltraps>

80107918 <vector11>:
.globl vector11
vector11:
  pushl $11
80107918:	6a 0b                	push   $0xb
  jmp alltraps
8010791a:	e9 dd fa ff ff       	jmp    801073fc <alltraps>

8010791f <vector12>:
.globl vector12
vector12:
  pushl $12
8010791f:	6a 0c                	push   $0xc
  jmp alltraps
80107921:	e9 d6 fa ff ff       	jmp    801073fc <alltraps>

80107926 <vector13>:
.globl vector13
vector13:
  pushl $13
80107926:	6a 0d                	push   $0xd
  jmp alltraps
80107928:	e9 cf fa ff ff       	jmp    801073fc <alltraps>

8010792d <vector14>:
.globl vector14
vector14:
  pushl $14
8010792d:	6a 0e                	push   $0xe
  jmp alltraps
8010792f:	e9 c8 fa ff ff       	jmp    801073fc <alltraps>

80107934 <vector15>:
.globl vector15
vector15:
  pushl $0
80107934:	6a 00                	push   $0x0
  pushl $15
80107936:	6a 0f                	push   $0xf
  jmp alltraps
80107938:	e9 bf fa ff ff       	jmp    801073fc <alltraps>

8010793d <vector16>:
.globl vector16
vector16:
  pushl $0
8010793d:	6a 00                	push   $0x0
  pushl $16
8010793f:	6a 10                	push   $0x10
  jmp alltraps
80107941:	e9 b6 fa ff ff       	jmp    801073fc <alltraps>

80107946 <vector17>:
.globl vector17
vector17:
  pushl $17
80107946:	6a 11                	push   $0x11
  jmp alltraps
80107948:	e9 af fa ff ff       	jmp    801073fc <alltraps>

8010794d <vector18>:
.globl vector18
vector18:
  pushl $0
8010794d:	6a 00                	push   $0x0
  pushl $18
8010794f:	6a 12                	push   $0x12
  jmp alltraps
80107951:	e9 a6 fa ff ff       	jmp    801073fc <alltraps>

80107956 <vector19>:
.globl vector19
vector19:
  pushl $0
80107956:	6a 00                	push   $0x0
  pushl $19
80107958:	6a 13                	push   $0x13
  jmp alltraps
8010795a:	e9 9d fa ff ff       	jmp    801073fc <alltraps>

8010795f <vector20>:
.globl vector20
vector20:
  pushl $0
8010795f:	6a 00                	push   $0x0
  pushl $20
80107961:	6a 14                	push   $0x14
  jmp alltraps
80107963:	e9 94 fa ff ff       	jmp    801073fc <alltraps>

80107968 <vector21>:
.globl vector21
vector21:
  pushl $0
80107968:	6a 00                	push   $0x0
  pushl $21
8010796a:	6a 15                	push   $0x15
  jmp alltraps
8010796c:	e9 8b fa ff ff       	jmp    801073fc <alltraps>

80107971 <vector22>:
.globl vector22
vector22:
  pushl $0
80107971:	6a 00                	push   $0x0
  pushl $22
80107973:	6a 16                	push   $0x16
  jmp alltraps
80107975:	e9 82 fa ff ff       	jmp    801073fc <alltraps>

8010797a <vector23>:
.globl vector23
vector23:
  pushl $0
8010797a:	6a 00                	push   $0x0
  pushl $23
8010797c:	6a 17                	push   $0x17
  jmp alltraps
8010797e:	e9 79 fa ff ff       	jmp    801073fc <alltraps>

80107983 <vector24>:
.globl vector24
vector24:
  pushl $0
80107983:	6a 00                	push   $0x0
  pushl $24
80107985:	6a 18                	push   $0x18
  jmp alltraps
80107987:	e9 70 fa ff ff       	jmp    801073fc <alltraps>

8010798c <vector25>:
.globl vector25
vector25:
  pushl $0
8010798c:	6a 00                	push   $0x0
  pushl $25
8010798e:	6a 19                	push   $0x19
  jmp alltraps
80107990:	e9 67 fa ff ff       	jmp    801073fc <alltraps>

80107995 <vector26>:
.globl vector26
vector26:
  pushl $0
80107995:	6a 00                	push   $0x0
  pushl $26
80107997:	6a 1a                	push   $0x1a
  jmp alltraps
80107999:	e9 5e fa ff ff       	jmp    801073fc <alltraps>

8010799e <vector27>:
.globl vector27
vector27:
  pushl $0
8010799e:	6a 00                	push   $0x0
  pushl $27
801079a0:	6a 1b                	push   $0x1b
  jmp alltraps
801079a2:	e9 55 fa ff ff       	jmp    801073fc <alltraps>

801079a7 <vector28>:
.globl vector28
vector28:
  pushl $0
801079a7:	6a 00                	push   $0x0
  pushl $28
801079a9:	6a 1c                	push   $0x1c
  jmp alltraps
801079ab:	e9 4c fa ff ff       	jmp    801073fc <alltraps>

801079b0 <vector29>:
.globl vector29
vector29:
  pushl $0
801079b0:	6a 00                	push   $0x0
  pushl $29
801079b2:	6a 1d                	push   $0x1d
  jmp alltraps
801079b4:	e9 43 fa ff ff       	jmp    801073fc <alltraps>

801079b9 <vector30>:
.globl vector30
vector30:
  pushl $0
801079b9:	6a 00                	push   $0x0
  pushl $30
801079bb:	6a 1e                	push   $0x1e
  jmp alltraps
801079bd:	e9 3a fa ff ff       	jmp    801073fc <alltraps>

801079c2 <vector31>:
.globl vector31
vector31:
  pushl $0
801079c2:	6a 00                	push   $0x0
  pushl $31
801079c4:	6a 1f                	push   $0x1f
  jmp alltraps
801079c6:	e9 31 fa ff ff       	jmp    801073fc <alltraps>

801079cb <vector32>:
.globl vector32
vector32:
  pushl $0
801079cb:	6a 00                	push   $0x0
  pushl $32
801079cd:	6a 20                	push   $0x20
  jmp alltraps
801079cf:	e9 28 fa ff ff       	jmp    801073fc <alltraps>

801079d4 <vector33>:
.globl vector33
vector33:
  pushl $0
801079d4:	6a 00                	push   $0x0
  pushl $33
801079d6:	6a 21                	push   $0x21
  jmp alltraps
801079d8:	e9 1f fa ff ff       	jmp    801073fc <alltraps>

801079dd <vector34>:
.globl vector34
vector34:
  pushl $0
801079dd:	6a 00                	push   $0x0
  pushl $34
801079df:	6a 22                	push   $0x22
  jmp alltraps
801079e1:	e9 16 fa ff ff       	jmp    801073fc <alltraps>

801079e6 <vector35>:
.globl vector35
vector35:
  pushl $0
801079e6:	6a 00                	push   $0x0
  pushl $35
801079e8:	6a 23                	push   $0x23
  jmp alltraps
801079ea:	e9 0d fa ff ff       	jmp    801073fc <alltraps>

801079ef <vector36>:
.globl vector36
vector36:
  pushl $0
801079ef:	6a 00                	push   $0x0
  pushl $36
801079f1:	6a 24                	push   $0x24
  jmp alltraps
801079f3:	e9 04 fa ff ff       	jmp    801073fc <alltraps>

801079f8 <vector37>:
.globl vector37
vector37:
  pushl $0
801079f8:	6a 00                	push   $0x0
  pushl $37
801079fa:	6a 25                	push   $0x25
  jmp alltraps
801079fc:	e9 fb f9 ff ff       	jmp    801073fc <alltraps>

80107a01 <vector38>:
.globl vector38
vector38:
  pushl $0
80107a01:	6a 00                	push   $0x0
  pushl $38
80107a03:	6a 26                	push   $0x26
  jmp alltraps
80107a05:	e9 f2 f9 ff ff       	jmp    801073fc <alltraps>

80107a0a <vector39>:
.globl vector39
vector39:
  pushl $0
80107a0a:	6a 00                	push   $0x0
  pushl $39
80107a0c:	6a 27                	push   $0x27
  jmp alltraps
80107a0e:	e9 e9 f9 ff ff       	jmp    801073fc <alltraps>

80107a13 <vector40>:
.globl vector40
vector40:
  pushl $0
80107a13:	6a 00                	push   $0x0
  pushl $40
80107a15:	6a 28                	push   $0x28
  jmp alltraps
80107a17:	e9 e0 f9 ff ff       	jmp    801073fc <alltraps>

80107a1c <vector41>:
.globl vector41
vector41:
  pushl $0
80107a1c:	6a 00                	push   $0x0
  pushl $41
80107a1e:	6a 29                	push   $0x29
  jmp alltraps
80107a20:	e9 d7 f9 ff ff       	jmp    801073fc <alltraps>

80107a25 <vector42>:
.globl vector42
vector42:
  pushl $0
80107a25:	6a 00                	push   $0x0
  pushl $42
80107a27:	6a 2a                	push   $0x2a
  jmp alltraps
80107a29:	e9 ce f9 ff ff       	jmp    801073fc <alltraps>

80107a2e <vector43>:
.globl vector43
vector43:
  pushl $0
80107a2e:	6a 00                	push   $0x0
  pushl $43
80107a30:	6a 2b                	push   $0x2b
  jmp alltraps
80107a32:	e9 c5 f9 ff ff       	jmp    801073fc <alltraps>

80107a37 <vector44>:
.globl vector44
vector44:
  pushl $0
80107a37:	6a 00                	push   $0x0
  pushl $44
80107a39:	6a 2c                	push   $0x2c
  jmp alltraps
80107a3b:	e9 bc f9 ff ff       	jmp    801073fc <alltraps>

80107a40 <vector45>:
.globl vector45
vector45:
  pushl $0
80107a40:	6a 00                	push   $0x0
  pushl $45
80107a42:	6a 2d                	push   $0x2d
  jmp alltraps
80107a44:	e9 b3 f9 ff ff       	jmp    801073fc <alltraps>

80107a49 <vector46>:
.globl vector46
vector46:
  pushl $0
80107a49:	6a 00                	push   $0x0
  pushl $46
80107a4b:	6a 2e                	push   $0x2e
  jmp alltraps
80107a4d:	e9 aa f9 ff ff       	jmp    801073fc <alltraps>

80107a52 <vector47>:
.globl vector47
vector47:
  pushl $0
80107a52:	6a 00                	push   $0x0
  pushl $47
80107a54:	6a 2f                	push   $0x2f
  jmp alltraps
80107a56:	e9 a1 f9 ff ff       	jmp    801073fc <alltraps>

80107a5b <vector48>:
.globl vector48
vector48:
  pushl $0
80107a5b:	6a 00                	push   $0x0
  pushl $48
80107a5d:	6a 30                	push   $0x30
  jmp alltraps
80107a5f:	e9 98 f9 ff ff       	jmp    801073fc <alltraps>

80107a64 <vector49>:
.globl vector49
vector49:
  pushl $0
80107a64:	6a 00                	push   $0x0
  pushl $49
80107a66:	6a 31                	push   $0x31
  jmp alltraps
80107a68:	e9 8f f9 ff ff       	jmp    801073fc <alltraps>

80107a6d <vector50>:
.globl vector50
vector50:
  pushl $0
80107a6d:	6a 00                	push   $0x0
  pushl $50
80107a6f:	6a 32                	push   $0x32
  jmp alltraps
80107a71:	e9 86 f9 ff ff       	jmp    801073fc <alltraps>

80107a76 <vector51>:
.globl vector51
vector51:
  pushl $0
80107a76:	6a 00                	push   $0x0
  pushl $51
80107a78:	6a 33                	push   $0x33
  jmp alltraps
80107a7a:	e9 7d f9 ff ff       	jmp    801073fc <alltraps>

80107a7f <vector52>:
.globl vector52
vector52:
  pushl $0
80107a7f:	6a 00                	push   $0x0
  pushl $52
80107a81:	6a 34                	push   $0x34
  jmp alltraps
80107a83:	e9 74 f9 ff ff       	jmp    801073fc <alltraps>

80107a88 <vector53>:
.globl vector53
vector53:
  pushl $0
80107a88:	6a 00                	push   $0x0
  pushl $53
80107a8a:	6a 35                	push   $0x35
  jmp alltraps
80107a8c:	e9 6b f9 ff ff       	jmp    801073fc <alltraps>

80107a91 <vector54>:
.globl vector54
vector54:
  pushl $0
80107a91:	6a 00                	push   $0x0
  pushl $54
80107a93:	6a 36                	push   $0x36
  jmp alltraps
80107a95:	e9 62 f9 ff ff       	jmp    801073fc <alltraps>

80107a9a <vector55>:
.globl vector55
vector55:
  pushl $0
80107a9a:	6a 00                	push   $0x0
  pushl $55
80107a9c:	6a 37                	push   $0x37
  jmp alltraps
80107a9e:	e9 59 f9 ff ff       	jmp    801073fc <alltraps>

80107aa3 <vector56>:
.globl vector56
vector56:
  pushl $0
80107aa3:	6a 00                	push   $0x0
  pushl $56
80107aa5:	6a 38                	push   $0x38
  jmp alltraps
80107aa7:	e9 50 f9 ff ff       	jmp    801073fc <alltraps>

80107aac <vector57>:
.globl vector57
vector57:
  pushl $0
80107aac:	6a 00                	push   $0x0
  pushl $57
80107aae:	6a 39                	push   $0x39
  jmp alltraps
80107ab0:	e9 47 f9 ff ff       	jmp    801073fc <alltraps>

80107ab5 <vector58>:
.globl vector58
vector58:
  pushl $0
80107ab5:	6a 00                	push   $0x0
  pushl $58
80107ab7:	6a 3a                	push   $0x3a
  jmp alltraps
80107ab9:	e9 3e f9 ff ff       	jmp    801073fc <alltraps>

80107abe <vector59>:
.globl vector59
vector59:
  pushl $0
80107abe:	6a 00                	push   $0x0
  pushl $59
80107ac0:	6a 3b                	push   $0x3b
  jmp alltraps
80107ac2:	e9 35 f9 ff ff       	jmp    801073fc <alltraps>

80107ac7 <vector60>:
.globl vector60
vector60:
  pushl $0
80107ac7:	6a 00                	push   $0x0
  pushl $60
80107ac9:	6a 3c                	push   $0x3c
  jmp alltraps
80107acb:	e9 2c f9 ff ff       	jmp    801073fc <alltraps>

80107ad0 <vector61>:
.globl vector61
vector61:
  pushl $0
80107ad0:	6a 00                	push   $0x0
  pushl $61
80107ad2:	6a 3d                	push   $0x3d
  jmp alltraps
80107ad4:	e9 23 f9 ff ff       	jmp    801073fc <alltraps>

80107ad9 <vector62>:
.globl vector62
vector62:
  pushl $0
80107ad9:	6a 00                	push   $0x0
  pushl $62
80107adb:	6a 3e                	push   $0x3e
  jmp alltraps
80107add:	e9 1a f9 ff ff       	jmp    801073fc <alltraps>

80107ae2 <vector63>:
.globl vector63
vector63:
  pushl $0
80107ae2:	6a 00                	push   $0x0
  pushl $63
80107ae4:	6a 3f                	push   $0x3f
  jmp alltraps
80107ae6:	e9 11 f9 ff ff       	jmp    801073fc <alltraps>

80107aeb <vector64>:
.globl vector64
vector64:
  pushl $0
80107aeb:	6a 00                	push   $0x0
  pushl $64
80107aed:	6a 40                	push   $0x40
  jmp alltraps
80107aef:	e9 08 f9 ff ff       	jmp    801073fc <alltraps>

80107af4 <vector65>:
.globl vector65
vector65:
  pushl $0
80107af4:	6a 00                	push   $0x0
  pushl $65
80107af6:	6a 41                	push   $0x41
  jmp alltraps
80107af8:	e9 ff f8 ff ff       	jmp    801073fc <alltraps>

80107afd <vector66>:
.globl vector66
vector66:
  pushl $0
80107afd:	6a 00                	push   $0x0
  pushl $66
80107aff:	6a 42                	push   $0x42
  jmp alltraps
80107b01:	e9 f6 f8 ff ff       	jmp    801073fc <alltraps>

80107b06 <vector67>:
.globl vector67
vector67:
  pushl $0
80107b06:	6a 00                	push   $0x0
  pushl $67
80107b08:	6a 43                	push   $0x43
  jmp alltraps
80107b0a:	e9 ed f8 ff ff       	jmp    801073fc <alltraps>

80107b0f <vector68>:
.globl vector68
vector68:
  pushl $0
80107b0f:	6a 00                	push   $0x0
  pushl $68
80107b11:	6a 44                	push   $0x44
  jmp alltraps
80107b13:	e9 e4 f8 ff ff       	jmp    801073fc <alltraps>

80107b18 <vector69>:
.globl vector69
vector69:
  pushl $0
80107b18:	6a 00                	push   $0x0
  pushl $69
80107b1a:	6a 45                	push   $0x45
  jmp alltraps
80107b1c:	e9 db f8 ff ff       	jmp    801073fc <alltraps>

80107b21 <vector70>:
.globl vector70
vector70:
  pushl $0
80107b21:	6a 00                	push   $0x0
  pushl $70
80107b23:	6a 46                	push   $0x46
  jmp alltraps
80107b25:	e9 d2 f8 ff ff       	jmp    801073fc <alltraps>

80107b2a <vector71>:
.globl vector71
vector71:
  pushl $0
80107b2a:	6a 00                	push   $0x0
  pushl $71
80107b2c:	6a 47                	push   $0x47
  jmp alltraps
80107b2e:	e9 c9 f8 ff ff       	jmp    801073fc <alltraps>

80107b33 <vector72>:
.globl vector72
vector72:
  pushl $0
80107b33:	6a 00                	push   $0x0
  pushl $72
80107b35:	6a 48                	push   $0x48
  jmp alltraps
80107b37:	e9 c0 f8 ff ff       	jmp    801073fc <alltraps>

80107b3c <vector73>:
.globl vector73
vector73:
  pushl $0
80107b3c:	6a 00                	push   $0x0
  pushl $73
80107b3e:	6a 49                	push   $0x49
  jmp alltraps
80107b40:	e9 b7 f8 ff ff       	jmp    801073fc <alltraps>

80107b45 <vector74>:
.globl vector74
vector74:
  pushl $0
80107b45:	6a 00                	push   $0x0
  pushl $74
80107b47:	6a 4a                	push   $0x4a
  jmp alltraps
80107b49:	e9 ae f8 ff ff       	jmp    801073fc <alltraps>

80107b4e <vector75>:
.globl vector75
vector75:
  pushl $0
80107b4e:	6a 00                	push   $0x0
  pushl $75
80107b50:	6a 4b                	push   $0x4b
  jmp alltraps
80107b52:	e9 a5 f8 ff ff       	jmp    801073fc <alltraps>

80107b57 <vector76>:
.globl vector76
vector76:
  pushl $0
80107b57:	6a 00                	push   $0x0
  pushl $76
80107b59:	6a 4c                	push   $0x4c
  jmp alltraps
80107b5b:	e9 9c f8 ff ff       	jmp    801073fc <alltraps>

80107b60 <vector77>:
.globl vector77
vector77:
  pushl $0
80107b60:	6a 00                	push   $0x0
  pushl $77
80107b62:	6a 4d                	push   $0x4d
  jmp alltraps
80107b64:	e9 93 f8 ff ff       	jmp    801073fc <alltraps>

80107b69 <vector78>:
.globl vector78
vector78:
  pushl $0
80107b69:	6a 00                	push   $0x0
  pushl $78
80107b6b:	6a 4e                	push   $0x4e
  jmp alltraps
80107b6d:	e9 8a f8 ff ff       	jmp    801073fc <alltraps>

80107b72 <vector79>:
.globl vector79
vector79:
  pushl $0
80107b72:	6a 00                	push   $0x0
  pushl $79
80107b74:	6a 4f                	push   $0x4f
  jmp alltraps
80107b76:	e9 81 f8 ff ff       	jmp    801073fc <alltraps>

80107b7b <vector80>:
.globl vector80
vector80:
  pushl $0
80107b7b:	6a 00                	push   $0x0
  pushl $80
80107b7d:	6a 50                	push   $0x50
  jmp alltraps
80107b7f:	e9 78 f8 ff ff       	jmp    801073fc <alltraps>

80107b84 <vector81>:
.globl vector81
vector81:
  pushl $0
80107b84:	6a 00                	push   $0x0
  pushl $81
80107b86:	6a 51                	push   $0x51
  jmp alltraps
80107b88:	e9 6f f8 ff ff       	jmp    801073fc <alltraps>

80107b8d <vector82>:
.globl vector82
vector82:
  pushl $0
80107b8d:	6a 00                	push   $0x0
  pushl $82
80107b8f:	6a 52                	push   $0x52
  jmp alltraps
80107b91:	e9 66 f8 ff ff       	jmp    801073fc <alltraps>

80107b96 <vector83>:
.globl vector83
vector83:
  pushl $0
80107b96:	6a 00                	push   $0x0
  pushl $83
80107b98:	6a 53                	push   $0x53
  jmp alltraps
80107b9a:	e9 5d f8 ff ff       	jmp    801073fc <alltraps>

80107b9f <vector84>:
.globl vector84
vector84:
  pushl $0
80107b9f:	6a 00                	push   $0x0
  pushl $84
80107ba1:	6a 54                	push   $0x54
  jmp alltraps
80107ba3:	e9 54 f8 ff ff       	jmp    801073fc <alltraps>

80107ba8 <vector85>:
.globl vector85
vector85:
  pushl $0
80107ba8:	6a 00                	push   $0x0
  pushl $85
80107baa:	6a 55                	push   $0x55
  jmp alltraps
80107bac:	e9 4b f8 ff ff       	jmp    801073fc <alltraps>

80107bb1 <vector86>:
.globl vector86
vector86:
  pushl $0
80107bb1:	6a 00                	push   $0x0
  pushl $86
80107bb3:	6a 56                	push   $0x56
  jmp alltraps
80107bb5:	e9 42 f8 ff ff       	jmp    801073fc <alltraps>

80107bba <vector87>:
.globl vector87
vector87:
  pushl $0
80107bba:	6a 00                	push   $0x0
  pushl $87
80107bbc:	6a 57                	push   $0x57
  jmp alltraps
80107bbe:	e9 39 f8 ff ff       	jmp    801073fc <alltraps>

80107bc3 <vector88>:
.globl vector88
vector88:
  pushl $0
80107bc3:	6a 00                	push   $0x0
  pushl $88
80107bc5:	6a 58                	push   $0x58
  jmp alltraps
80107bc7:	e9 30 f8 ff ff       	jmp    801073fc <alltraps>

80107bcc <vector89>:
.globl vector89
vector89:
  pushl $0
80107bcc:	6a 00                	push   $0x0
  pushl $89
80107bce:	6a 59                	push   $0x59
  jmp alltraps
80107bd0:	e9 27 f8 ff ff       	jmp    801073fc <alltraps>

80107bd5 <vector90>:
.globl vector90
vector90:
  pushl $0
80107bd5:	6a 00                	push   $0x0
  pushl $90
80107bd7:	6a 5a                	push   $0x5a
  jmp alltraps
80107bd9:	e9 1e f8 ff ff       	jmp    801073fc <alltraps>

80107bde <vector91>:
.globl vector91
vector91:
  pushl $0
80107bde:	6a 00                	push   $0x0
  pushl $91
80107be0:	6a 5b                	push   $0x5b
  jmp alltraps
80107be2:	e9 15 f8 ff ff       	jmp    801073fc <alltraps>

80107be7 <vector92>:
.globl vector92
vector92:
  pushl $0
80107be7:	6a 00                	push   $0x0
  pushl $92
80107be9:	6a 5c                	push   $0x5c
  jmp alltraps
80107beb:	e9 0c f8 ff ff       	jmp    801073fc <alltraps>

80107bf0 <vector93>:
.globl vector93
vector93:
  pushl $0
80107bf0:	6a 00                	push   $0x0
  pushl $93
80107bf2:	6a 5d                	push   $0x5d
  jmp alltraps
80107bf4:	e9 03 f8 ff ff       	jmp    801073fc <alltraps>

80107bf9 <vector94>:
.globl vector94
vector94:
  pushl $0
80107bf9:	6a 00                	push   $0x0
  pushl $94
80107bfb:	6a 5e                	push   $0x5e
  jmp alltraps
80107bfd:	e9 fa f7 ff ff       	jmp    801073fc <alltraps>

80107c02 <vector95>:
.globl vector95
vector95:
  pushl $0
80107c02:	6a 00                	push   $0x0
  pushl $95
80107c04:	6a 5f                	push   $0x5f
  jmp alltraps
80107c06:	e9 f1 f7 ff ff       	jmp    801073fc <alltraps>

80107c0b <vector96>:
.globl vector96
vector96:
  pushl $0
80107c0b:	6a 00                	push   $0x0
  pushl $96
80107c0d:	6a 60                	push   $0x60
  jmp alltraps
80107c0f:	e9 e8 f7 ff ff       	jmp    801073fc <alltraps>

80107c14 <vector97>:
.globl vector97
vector97:
  pushl $0
80107c14:	6a 00                	push   $0x0
  pushl $97
80107c16:	6a 61                	push   $0x61
  jmp alltraps
80107c18:	e9 df f7 ff ff       	jmp    801073fc <alltraps>

80107c1d <vector98>:
.globl vector98
vector98:
  pushl $0
80107c1d:	6a 00                	push   $0x0
  pushl $98
80107c1f:	6a 62                	push   $0x62
  jmp alltraps
80107c21:	e9 d6 f7 ff ff       	jmp    801073fc <alltraps>

80107c26 <vector99>:
.globl vector99
vector99:
  pushl $0
80107c26:	6a 00                	push   $0x0
  pushl $99
80107c28:	6a 63                	push   $0x63
  jmp alltraps
80107c2a:	e9 cd f7 ff ff       	jmp    801073fc <alltraps>

80107c2f <vector100>:
.globl vector100
vector100:
  pushl $0
80107c2f:	6a 00                	push   $0x0
  pushl $100
80107c31:	6a 64                	push   $0x64
  jmp alltraps
80107c33:	e9 c4 f7 ff ff       	jmp    801073fc <alltraps>

80107c38 <vector101>:
.globl vector101
vector101:
  pushl $0
80107c38:	6a 00                	push   $0x0
  pushl $101
80107c3a:	6a 65                	push   $0x65
  jmp alltraps
80107c3c:	e9 bb f7 ff ff       	jmp    801073fc <alltraps>

80107c41 <vector102>:
.globl vector102
vector102:
  pushl $0
80107c41:	6a 00                	push   $0x0
  pushl $102
80107c43:	6a 66                	push   $0x66
  jmp alltraps
80107c45:	e9 b2 f7 ff ff       	jmp    801073fc <alltraps>

80107c4a <vector103>:
.globl vector103
vector103:
  pushl $0
80107c4a:	6a 00                	push   $0x0
  pushl $103
80107c4c:	6a 67                	push   $0x67
  jmp alltraps
80107c4e:	e9 a9 f7 ff ff       	jmp    801073fc <alltraps>

80107c53 <vector104>:
.globl vector104
vector104:
  pushl $0
80107c53:	6a 00                	push   $0x0
  pushl $104
80107c55:	6a 68                	push   $0x68
  jmp alltraps
80107c57:	e9 a0 f7 ff ff       	jmp    801073fc <alltraps>

80107c5c <vector105>:
.globl vector105
vector105:
  pushl $0
80107c5c:	6a 00                	push   $0x0
  pushl $105
80107c5e:	6a 69                	push   $0x69
  jmp alltraps
80107c60:	e9 97 f7 ff ff       	jmp    801073fc <alltraps>

80107c65 <vector106>:
.globl vector106
vector106:
  pushl $0
80107c65:	6a 00                	push   $0x0
  pushl $106
80107c67:	6a 6a                	push   $0x6a
  jmp alltraps
80107c69:	e9 8e f7 ff ff       	jmp    801073fc <alltraps>

80107c6e <vector107>:
.globl vector107
vector107:
  pushl $0
80107c6e:	6a 00                	push   $0x0
  pushl $107
80107c70:	6a 6b                	push   $0x6b
  jmp alltraps
80107c72:	e9 85 f7 ff ff       	jmp    801073fc <alltraps>

80107c77 <vector108>:
.globl vector108
vector108:
  pushl $0
80107c77:	6a 00                	push   $0x0
  pushl $108
80107c79:	6a 6c                	push   $0x6c
  jmp alltraps
80107c7b:	e9 7c f7 ff ff       	jmp    801073fc <alltraps>

80107c80 <vector109>:
.globl vector109
vector109:
  pushl $0
80107c80:	6a 00                	push   $0x0
  pushl $109
80107c82:	6a 6d                	push   $0x6d
  jmp alltraps
80107c84:	e9 73 f7 ff ff       	jmp    801073fc <alltraps>

80107c89 <vector110>:
.globl vector110
vector110:
  pushl $0
80107c89:	6a 00                	push   $0x0
  pushl $110
80107c8b:	6a 6e                	push   $0x6e
  jmp alltraps
80107c8d:	e9 6a f7 ff ff       	jmp    801073fc <alltraps>

80107c92 <vector111>:
.globl vector111
vector111:
  pushl $0
80107c92:	6a 00                	push   $0x0
  pushl $111
80107c94:	6a 6f                	push   $0x6f
  jmp alltraps
80107c96:	e9 61 f7 ff ff       	jmp    801073fc <alltraps>

80107c9b <vector112>:
.globl vector112
vector112:
  pushl $0
80107c9b:	6a 00                	push   $0x0
  pushl $112
80107c9d:	6a 70                	push   $0x70
  jmp alltraps
80107c9f:	e9 58 f7 ff ff       	jmp    801073fc <alltraps>

80107ca4 <vector113>:
.globl vector113
vector113:
  pushl $0
80107ca4:	6a 00                	push   $0x0
  pushl $113
80107ca6:	6a 71                	push   $0x71
  jmp alltraps
80107ca8:	e9 4f f7 ff ff       	jmp    801073fc <alltraps>

80107cad <vector114>:
.globl vector114
vector114:
  pushl $0
80107cad:	6a 00                	push   $0x0
  pushl $114
80107caf:	6a 72                	push   $0x72
  jmp alltraps
80107cb1:	e9 46 f7 ff ff       	jmp    801073fc <alltraps>

80107cb6 <vector115>:
.globl vector115
vector115:
  pushl $0
80107cb6:	6a 00                	push   $0x0
  pushl $115
80107cb8:	6a 73                	push   $0x73
  jmp alltraps
80107cba:	e9 3d f7 ff ff       	jmp    801073fc <alltraps>

80107cbf <vector116>:
.globl vector116
vector116:
  pushl $0
80107cbf:	6a 00                	push   $0x0
  pushl $116
80107cc1:	6a 74                	push   $0x74
  jmp alltraps
80107cc3:	e9 34 f7 ff ff       	jmp    801073fc <alltraps>

80107cc8 <vector117>:
.globl vector117
vector117:
  pushl $0
80107cc8:	6a 00                	push   $0x0
  pushl $117
80107cca:	6a 75                	push   $0x75
  jmp alltraps
80107ccc:	e9 2b f7 ff ff       	jmp    801073fc <alltraps>

80107cd1 <vector118>:
.globl vector118
vector118:
  pushl $0
80107cd1:	6a 00                	push   $0x0
  pushl $118
80107cd3:	6a 76                	push   $0x76
  jmp alltraps
80107cd5:	e9 22 f7 ff ff       	jmp    801073fc <alltraps>

80107cda <vector119>:
.globl vector119
vector119:
  pushl $0
80107cda:	6a 00                	push   $0x0
  pushl $119
80107cdc:	6a 77                	push   $0x77
  jmp alltraps
80107cde:	e9 19 f7 ff ff       	jmp    801073fc <alltraps>

80107ce3 <vector120>:
.globl vector120
vector120:
  pushl $0
80107ce3:	6a 00                	push   $0x0
  pushl $120
80107ce5:	6a 78                	push   $0x78
  jmp alltraps
80107ce7:	e9 10 f7 ff ff       	jmp    801073fc <alltraps>

80107cec <vector121>:
.globl vector121
vector121:
  pushl $0
80107cec:	6a 00                	push   $0x0
  pushl $121
80107cee:	6a 79                	push   $0x79
  jmp alltraps
80107cf0:	e9 07 f7 ff ff       	jmp    801073fc <alltraps>

80107cf5 <vector122>:
.globl vector122
vector122:
  pushl $0
80107cf5:	6a 00                	push   $0x0
  pushl $122
80107cf7:	6a 7a                	push   $0x7a
  jmp alltraps
80107cf9:	e9 fe f6 ff ff       	jmp    801073fc <alltraps>

80107cfe <vector123>:
.globl vector123
vector123:
  pushl $0
80107cfe:	6a 00                	push   $0x0
  pushl $123
80107d00:	6a 7b                	push   $0x7b
  jmp alltraps
80107d02:	e9 f5 f6 ff ff       	jmp    801073fc <alltraps>

80107d07 <vector124>:
.globl vector124
vector124:
  pushl $0
80107d07:	6a 00                	push   $0x0
  pushl $124
80107d09:	6a 7c                	push   $0x7c
  jmp alltraps
80107d0b:	e9 ec f6 ff ff       	jmp    801073fc <alltraps>

80107d10 <vector125>:
.globl vector125
vector125:
  pushl $0
80107d10:	6a 00                	push   $0x0
  pushl $125
80107d12:	6a 7d                	push   $0x7d
  jmp alltraps
80107d14:	e9 e3 f6 ff ff       	jmp    801073fc <alltraps>

80107d19 <vector126>:
.globl vector126
vector126:
  pushl $0
80107d19:	6a 00                	push   $0x0
  pushl $126
80107d1b:	6a 7e                	push   $0x7e
  jmp alltraps
80107d1d:	e9 da f6 ff ff       	jmp    801073fc <alltraps>

80107d22 <vector127>:
.globl vector127
vector127:
  pushl $0
80107d22:	6a 00                	push   $0x0
  pushl $127
80107d24:	6a 7f                	push   $0x7f
  jmp alltraps
80107d26:	e9 d1 f6 ff ff       	jmp    801073fc <alltraps>

80107d2b <vector128>:
.globl vector128
vector128:
  pushl $0
80107d2b:	6a 00                	push   $0x0
  pushl $128
80107d2d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107d32:	e9 c5 f6 ff ff       	jmp    801073fc <alltraps>

80107d37 <vector129>:
.globl vector129
vector129:
  pushl $0
80107d37:	6a 00                	push   $0x0
  pushl $129
80107d39:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107d3e:	e9 b9 f6 ff ff       	jmp    801073fc <alltraps>

80107d43 <vector130>:
.globl vector130
vector130:
  pushl $0
80107d43:	6a 00                	push   $0x0
  pushl $130
80107d45:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107d4a:	e9 ad f6 ff ff       	jmp    801073fc <alltraps>

80107d4f <vector131>:
.globl vector131
vector131:
  pushl $0
80107d4f:	6a 00                	push   $0x0
  pushl $131
80107d51:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80107d56:	e9 a1 f6 ff ff       	jmp    801073fc <alltraps>

80107d5b <vector132>:
.globl vector132
vector132:
  pushl $0
80107d5b:	6a 00                	push   $0x0
  pushl $132
80107d5d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107d62:	e9 95 f6 ff ff       	jmp    801073fc <alltraps>

80107d67 <vector133>:
.globl vector133
vector133:
  pushl $0
80107d67:	6a 00                	push   $0x0
  pushl $133
80107d69:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107d6e:	e9 89 f6 ff ff       	jmp    801073fc <alltraps>

80107d73 <vector134>:
.globl vector134
vector134:
  pushl $0
80107d73:	6a 00                	push   $0x0
  pushl $134
80107d75:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107d7a:	e9 7d f6 ff ff       	jmp    801073fc <alltraps>

80107d7f <vector135>:
.globl vector135
vector135:
  pushl $0
80107d7f:	6a 00                	push   $0x0
  pushl $135
80107d81:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107d86:	e9 71 f6 ff ff       	jmp    801073fc <alltraps>

80107d8b <vector136>:
.globl vector136
vector136:
  pushl $0
80107d8b:	6a 00                	push   $0x0
  pushl $136
80107d8d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107d92:	e9 65 f6 ff ff       	jmp    801073fc <alltraps>

80107d97 <vector137>:
.globl vector137
vector137:
  pushl $0
80107d97:	6a 00                	push   $0x0
  pushl $137
80107d99:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107d9e:	e9 59 f6 ff ff       	jmp    801073fc <alltraps>

80107da3 <vector138>:
.globl vector138
vector138:
  pushl $0
80107da3:	6a 00                	push   $0x0
  pushl $138
80107da5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107daa:	e9 4d f6 ff ff       	jmp    801073fc <alltraps>

80107daf <vector139>:
.globl vector139
vector139:
  pushl $0
80107daf:	6a 00                	push   $0x0
  pushl $139
80107db1:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107db6:	e9 41 f6 ff ff       	jmp    801073fc <alltraps>

80107dbb <vector140>:
.globl vector140
vector140:
  pushl $0
80107dbb:	6a 00                	push   $0x0
  pushl $140
80107dbd:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107dc2:	e9 35 f6 ff ff       	jmp    801073fc <alltraps>

80107dc7 <vector141>:
.globl vector141
vector141:
  pushl $0
80107dc7:	6a 00                	push   $0x0
  pushl $141
80107dc9:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80107dce:	e9 29 f6 ff ff       	jmp    801073fc <alltraps>

80107dd3 <vector142>:
.globl vector142
vector142:
  pushl $0
80107dd3:	6a 00                	push   $0x0
  pushl $142
80107dd5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107dda:	e9 1d f6 ff ff       	jmp    801073fc <alltraps>

80107ddf <vector143>:
.globl vector143
vector143:
  pushl $0
80107ddf:	6a 00                	push   $0x0
  pushl $143
80107de1:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107de6:	e9 11 f6 ff ff       	jmp    801073fc <alltraps>

80107deb <vector144>:
.globl vector144
vector144:
  pushl $0
80107deb:	6a 00                	push   $0x0
  pushl $144
80107ded:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107df2:	e9 05 f6 ff ff       	jmp    801073fc <alltraps>

80107df7 <vector145>:
.globl vector145
vector145:
  pushl $0
80107df7:	6a 00                	push   $0x0
  pushl $145
80107df9:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80107dfe:	e9 f9 f5 ff ff       	jmp    801073fc <alltraps>

80107e03 <vector146>:
.globl vector146
vector146:
  pushl $0
80107e03:	6a 00                	push   $0x0
  pushl $146
80107e05:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107e0a:	e9 ed f5 ff ff       	jmp    801073fc <alltraps>

80107e0f <vector147>:
.globl vector147
vector147:
  pushl $0
80107e0f:	6a 00                	push   $0x0
  pushl $147
80107e11:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107e16:	e9 e1 f5 ff ff       	jmp    801073fc <alltraps>

80107e1b <vector148>:
.globl vector148
vector148:
  pushl $0
80107e1b:	6a 00                	push   $0x0
  pushl $148
80107e1d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107e22:	e9 d5 f5 ff ff       	jmp    801073fc <alltraps>

80107e27 <vector149>:
.globl vector149
vector149:
  pushl $0
80107e27:	6a 00                	push   $0x0
  pushl $149
80107e29:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107e2e:	e9 c9 f5 ff ff       	jmp    801073fc <alltraps>

80107e33 <vector150>:
.globl vector150
vector150:
  pushl $0
80107e33:	6a 00                	push   $0x0
  pushl $150
80107e35:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107e3a:	e9 bd f5 ff ff       	jmp    801073fc <alltraps>

80107e3f <vector151>:
.globl vector151
vector151:
  pushl $0
80107e3f:	6a 00                	push   $0x0
  pushl $151
80107e41:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107e46:	e9 b1 f5 ff ff       	jmp    801073fc <alltraps>

80107e4b <vector152>:
.globl vector152
vector152:
  pushl $0
80107e4b:	6a 00                	push   $0x0
  pushl $152
80107e4d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107e52:	e9 a5 f5 ff ff       	jmp    801073fc <alltraps>

80107e57 <vector153>:
.globl vector153
vector153:
  pushl $0
80107e57:	6a 00                	push   $0x0
  pushl $153
80107e59:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107e5e:	e9 99 f5 ff ff       	jmp    801073fc <alltraps>

80107e63 <vector154>:
.globl vector154
vector154:
  pushl $0
80107e63:	6a 00                	push   $0x0
  pushl $154
80107e65:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107e6a:	e9 8d f5 ff ff       	jmp    801073fc <alltraps>

80107e6f <vector155>:
.globl vector155
vector155:
  pushl $0
80107e6f:	6a 00                	push   $0x0
  pushl $155
80107e71:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107e76:	e9 81 f5 ff ff       	jmp    801073fc <alltraps>

80107e7b <vector156>:
.globl vector156
vector156:
  pushl $0
80107e7b:	6a 00                	push   $0x0
  pushl $156
80107e7d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107e82:	e9 75 f5 ff ff       	jmp    801073fc <alltraps>

80107e87 <vector157>:
.globl vector157
vector157:
  pushl $0
80107e87:	6a 00                	push   $0x0
  pushl $157
80107e89:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107e8e:	e9 69 f5 ff ff       	jmp    801073fc <alltraps>

80107e93 <vector158>:
.globl vector158
vector158:
  pushl $0
80107e93:	6a 00                	push   $0x0
  pushl $158
80107e95:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107e9a:	e9 5d f5 ff ff       	jmp    801073fc <alltraps>

80107e9f <vector159>:
.globl vector159
vector159:
  pushl $0
80107e9f:	6a 00                	push   $0x0
  pushl $159
80107ea1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107ea6:	e9 51 f5 ff ff       	jmp    801073fc <alltraps>

80107eab <vector160>:
.globl vector160
vector160:
  pushl $0
80107eab:	6a 00                	push   $0x0
  pushl $160
80107ead:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107eb2:	e9 45 f5 ff ff       	jmp    801073fc <alltraps>

80107eb7 <vector161>:
.globl vector161
vector161:
  pushl $0
80107eb7:	6a 00                	push   $0x0
  pushl $161
80107eb9:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107ebe:	e9 39 f5 ff ff       	jmp    801073fc <alltraps>

80107ec3 <vector162>:
.globl vector162
vector162:
  pushl $0
80107ec3:	6a 00                	push   $0x0
  pushl $162
80107ec5:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107eca:	e9 2d f5 ff ff       	jmp    801073fc <alltraps>

80107ecf <vector163>:
.globl vector163
vector163:
  pushl $0
80107ecf:	6a 00                	push   $0x0
  pushl $163
80107ed1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107ed6:	e9 21 f5 ff ff       	jmp    801073fc <alltraps>

80107edb <vector164>:
.globl vector164
vector164:
  pushl $0
80107edb:	6a 00                	push   $0x0
  pushl $164
80107edd:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107ee2:	e9 15 f5 ff ff       	jmp    801073fc <alltraps>

80107ee7 <vector165>:
.globl vector165
vector165:
  pushl $0
80107ee7:	6a 00                	push   $0x0
  pushl $165
80107ee9:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107eee:	e9 09 f5 ff ff       	jmp    801073fc <alltraps>

80107ef3 <vector166>:
.globl vector166
vector166:
  pushl $0
80107ef3:	6a 00                	push   $0x0
  pushl $166
80107ef5:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107efa:	e9 fd f4 ff ff       	jmp    801073fc <alltraps>

80107eff <vector167>:
.globl vector167
vector167:
  pushl $0
80107eff:	6a 00                	push   $0x0
  pushl $167
80107f01:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107f06:	e9 f1 f4 ff ff       	jmp    801073fc <alltraps>

80107f0b <vector168>:
.globl vector168
vector168:
  pushl $0
80107f0b:	6a 00                	push   $0x0
  pushl $168
80107f0d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107f12:	e9 e5 f4 ff ff       	jmp    801073fc <alltraps>

80107f17 <vector169>:
.globl vector169
vector169:
  pushl $0
80107f17:	6a 00                	push   $0x0
  pushl $169
80107f19:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107f1e:	e9 d9 f4 ff ff       	jmp    801073fc <alltraps>

80107f23 <vector170>:
.globl vector170
vector170:
  pushl $0
80107f23:	6a 00                	push   $0x0
  pushl $170
80107f25:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107f2a:	e9 cd f4 ff ff       	jmp    801073fc <alltraps>

80107f2f <vector171>:
.globl vector171
vector171:
  pushl $0
80107f2f:	6a 00                	push   $0x0
  pushl $171
80107f31:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107f36:	e9 c1 f4 ff ff       	jmp    801073fc <alltraps>

80107f3b <vector172>:
.globl vector172
vector172:
  pushl $0
80107f3b:	6a 00                	push   $0x0
  pushl $172
80107f3d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107f42:	e9 b5 f4 ff ff       	jmp    801073fc <alltraps>

80107f47 <vector173>:
.globl vector173
vector173:
  pushl $0
80107f47:	6a 00                	push   $0x0
  pushl $173
80107f49:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107f4e:	e9 a9 f4 ff ff       	jmp    801073fc <alltraps>

80107f53 <vector174>:
.globl vector174
vector174:
  pushl $0
80107f53:	6a 00                	push   $0x0
  pushl $174
80107f55:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107f5a:	e9 9d f4 ff ff       	jmp    801073fc <alltraps>

80107f5f <vector175>:
.globl vector175
vector175:
  pushl $0
80107f5f:	6a 00                	push   $0x0
  pushl $175
80107f61:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107f66:	e9 91 f4 ff ff       	jmp    801073fc <alltraps>

80107f6b <vector176>:
.globl vector176
vector176:
  pushl $0
80107f6b:	6a 00                	push   $0x0
  pushl $176
80107f6d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107f72:	e9 85 f4 ff ff       	jmp    801073fc <alltraps>

80107f77 <vector177>:
.globl vector177
vector177:
  pushl $0
80107f77:	6a 00                	push   $0x0
  pushl $177
80107f79:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107f7e:	e9 79 f4 ff ff       	jmp    801073fc <alltraps>

80107f83 <vector178>:
.globl vector178
vector178:
  pushl $0
80107f83:	6a 00                	push   $0x0
  pushl $178
80107f85:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107f8a:	e9 6d f4 ff ff       	jmp    801073fc <alltraps>

80107f8f <vector179>:
.globl vector179
vector179:
  pushl $0
80107f8f:	6a 00                	push   $0x0
  pushl $179
80107f91:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107f96:	e9 61 f4 ff ff       	jmp    801073fc <alltraps>

80107f9b <vector180>:
.globl vector180
vector180:
  pushl $0
80107f9b:	6a 00                	push   $0x0
  pushl $180
80107f9d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107fa2:	e9 55 f4 ff ff       	jmp    801073fc <alltraps>

80107fa7 <vector181>:
.globl vector181
vector181:
  pushl $0
80107fa7:	6a 00                	push   $0x0
  pushl $181
80107fa9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107fae:	e9 49 f4 ff ff       	jmp    801073fc <alltraps>

80107fb3 <vector182>:
.globl vector182
vector182:
  pushl $0
80107fb3:	6a 00                	push   $0x0
  pushl $182
80107fb5:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107fba:	e9 3d f4 ff ff       	jmp    801073fc <alltraps>

80107fbf <vector183>:
.globl vector183
vector183:
  pushl $0
80107fbf:	6a 00                	push   $0x0
  pushl $183
80107fc1:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107fc6:	e9 31 f4 ff ff       	jmp    801073fc <alltraps>

80107fcb <vector184>:
.globl vector184
vector184:
  pushl $0
80107fcb:	6a 00                	push   $0x0
  pushl $184
80107fcd:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107fd2:	e9 25 f4 ff ff       	jmp    801073fc <alltraps>

80107fd7 <vector185>:
.globl vector185
vector185:
  pushl $0
80107fd7:	6a 00                	push   $0x0
  pushl $185
80107fd9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107fde:	e9 19 f4 ff ff       	jmp    801073fc <alltraps>

80107fe3 <vector186>:
.globl vector186
vector186:
  pushl $0
80107fe3:	6a 00                	push   $0x0
  pushl $186
80107fe5:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107fea:	e9 0d f4 ff ff       	jmp    801073fc <alltraps>

80107fef <vector187>:
.globl vector187
vector187:
  pushl $0
80107fef:	6a 00                	push   $0x0
  pushl $187
80107ff1:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107ff6:	e9 01 f4 ff ff       	jmp    801073fc <alltraps>

80107ffb <vector188>:
.globl vector188
vector188:
  pushl $0
80107ffb:	6a 00                	push   $0x0
  pushl $188
80107ffd:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80108002:	e9 f5 f3 ff ff       	jmp    801073fc <alltraps>

80108007 <vector189>:
.globl vector189
vector189:
  pushl $0
80108007:	6a 00                	push   $0x0
  pushl $189
80108009:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010800e:	e9 e9 f3 ff ff       	jmp    801073fc <alltraps>

80108013 <vector190>:
.globl vector190
vector190:
  pushl $0
80108013:	6a 00                	push   $0x0
  pushl $190
80108015:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010801a:	e9 dd f3 ff ff       	jmp    801073fc <alltraps>

8010801f <vector191>:
.globl vector191
vector191:
  pushl $0
8010801f:	6a 00                	push   $0x0
  pushl $191
80108021:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80108026:	e9 d1 f3 ff ff       	jmp    801073fc <alltraps>

8010802b <vector192>:
.globl vector192
vector192:
  pushl $0
8010802b:	6a 00                	push   $0x0
  pushl $192
8010802d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80108032:	e9 c5 f3 ff ff       	jmp    801073fc <alltraps>

80108037 <vector193>:
.globl vector193
vector193:
  pushl $0
80108037:	6a 00                	push   $0x0
  pushl $193
80108039:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010803e:	e9 b9 f3 ff ff       	jmp    801073fc <alltraps>

80108043 <vector194>:
.globl vector194
vector194:
  pushl $0
80108043:	6a 00                	push   $0x0
  pushl $194
80108045:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010804a:	e9 ad f3 ff ff       	jmp    801073fc <alltraps>

8010804f <vector195>:
.globl vector195
vector195:
  pushl $0
8010804f:	6a 00                	push   $0x0
  pushl $195
80108051:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80108056:	e9 a1 f3 ff ff       	jmp    801073fc <alltraps>

8010805b <vector196>:
.globl vector196
vector196:
  pushl $0
8010805b:	6a 00                	push   $0x0
  pushl $196
8010805d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80108062:	e9 95 f3 ff ff       	jmp    801073fc <alltraps>

80108067 <vector197>:
.globl vector197
vector197:
  pushl $0
80108067:	6a 00                	push   $0x0
  pushl $197
80108069:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010806e:	e9 89 f3 ff ff       	jmp    801073fc <alltraps>

80108073 <vector198>:
.globl vector198
vector198:
  pushl $0
80108073:	6a 00                	push   $0x0
  pushl $198
80108075:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010807a:	e9 7d f3 ff ff       	jmp    801073fc <alltraps>

8010807f <vector199>:
.globl vector199
vector199:
  pushl $0
8010807f:	6a 00                	push   $0x0
  pushl $199
80108081:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80108086:	e9 71 f3 ff ff       	jmp    801073fc <alltraps>

8010808b <vector200>:
.globl vector200
vector200:
  pushl $0
8010808b:	6a 00                	push   $0x0
  pushl $200
8010808d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80108092:	e9 65 f3 ff ff       	jmp    801073fc <alltraps>

80108097 <vector201>:
.globl vector201
vector201:
  pushl $0
80108097:	6a 00                	push   $0x0
  pushl $201
80108099:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010809e:	e9 59 f3 ff ff       	jmp    801073fc <alltraps>

801080a3 <vector202>:
.globl vector202
vector202:
  pushl $0
801080a3:	6a 00                	push   $0x0
  pushl $202
801080a5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801080aa:	e9 4d f3 ff ff       	jmp    801073fc <alltraps>

801080af <vector203>:
.globl vector203
vector203:
  pushl $0
801080af:	6a 00                	push   $0x0
  pushl $203
801080b1:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801080b6:	e9 41 f3 ff ff       	jmp    801073fc <alltraps>

801080bb <vector204>:
.globl vector204
vector204:
  pushl $0
801080bb:	6a 00                	push   $0x0
  pushl $204
801080bd:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801080c2:	e9 35 f3 ff ff       	jmp    801073fc <alltraps>

801080c7 <vector205>:
.globl vector205
vector205:
  pushl $0
801080c7:	6a 00                	push   $0x0
  pushl $205
801080c9:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801080ce:	e9 29 f3 ff ff       	jmp    801073fc <alltraps>

801080d3 <vector206>:
.globl vector206
vector206:
  pushl $0
801080d3:	6a 00                	push   $0x0
  pushl $206
801080d5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801080da:	e9 1d f3 ff ff       	jmp    801073fc <alltraps>

801080df <vector207>:
.globl vector207
vector207:
  pushl $0
801080df:	6a 00                	push   $0x0
  pushl $207
801080e1:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801080e6:	e9 11 f3 ff ff       	jmp    801073fc <alltraps>

801080eb <vector208>:
.globl vector208
vector208:
  pushl $0
801080eb:	6a 00                	push   $0x0
  pushl $208
801080ed:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801080f2:	e9 05 f3 ff ff       	jmp    801073fc <alltraps>

801080f7 <vector209>:
.globl vector209
vector209:
  pushl $0
801080f7:	6a 00                	push   $0x0
  pushl $209
801080f9:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801080fe:	e9 f9 f2 ff ff       	jmp    801073fc <alltraps>

80108103 <vector210>:
.globl vector210
vector210:
  pushl $0
80108103:	6a 00                	push   $0x0
  pushl $210
80108105:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010810a:	e9 ed f2 ff ff       	jmp    801073fc <alltraps>

8010810f <vector211>:
.globl vector211
vector211:
  pushl $0
8010810f:	6a 00                	push   $0x0
  pushl $211
80108111:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80108116:	e9 e1 f2 ff ff       	jmp    801073fc <alltraps>

8010811b <vector212>:
.globl vector212
vector212:
  pushl $0
8010811b:	6a 00                	push   $0x0
  pushl $212
8010811d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80108122:	e9 d5 f2 ff ff       	jmp    801073fc <alltraps>

80108127 <vector213>:
.globl vector213
vector213:
  pushl $0
80108127:	6a 00                	push   $0x0
  pushl $213
80108129:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010812e:	e9 c9 f2 ff ff       	jmp    801073fc <alltraps>

80108133 <vector214>:
.globl vector214
vector214:
  pushl $0
80108133:	6a 00                	push   $0x0
  pushl $214
80108135:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010813a:	e9 bd f2 ff ff       	jmp    801073fc <alltraps>

8010813f <vector215>:
.globl vector215
vector215:
  pushl $0
8010813f:	6a 00                	push   $0x0
  pushl $215
80108141:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80108146:	e9 b1 f2 ff ff       	jmp    801073fc <alltraps>

8010814b <vector216>:
.globl vector216
vector216:
  pushl $0
8010814b:	6a 00                	push   $0x0
  pushl $216
8010814d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80108152:	e9 a5 f2 ff ff       	jmp    801073fc <alltraps>

80108157 <vector217>:
.globl vector217
vector217:
  pushl $0
80108157:	6a 00                	push   $0x0
  pushl $217
80108159:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010815e:	e9 99 f2 ff ff       	jmp    801073fc <alltraps>

80108163 <vector218>:
.globl vector218
vector218:
  pushl $0
80108163:	6a 00                	push   $0x0
  pushl $218
80108165:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010816a:	e9 8d f2 ff ff       	jmp    801073fc <alltraps>

8010816f <vector219>:
.globl vector219
vector219:
  pushl $0
8010816f:	6a 00                	push   $0x0
  pushl $219
80108171:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80108176:	e9 81 f2 ff ff       	jmp    801073fc <alltraps>

8010817b <vector220>:
.globl vector220
vector220:
  pushl $0
8010817b:	6a 00                	push   $0x0
  pushl $220
8010817d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80108182:	e9 75 f2 ff ff       	jmp    801073fc <alltraps>

80108187 <vector221>:
.globl vector221
vector221:
  pushl $0
80108187:	6a 00                	push   $0x0
  pushl $221
80108189:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010818e:	e9 69 f2 ff ff       	jmp    801073fc <alltraps>

80108193 <vector222>:
.globl vector222
vector222:
  pushl $0
80108193:	6a 00                	push   $0x0
  pushl $222
80108195:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010819a:	e9 5d f2 ff ff       	jmp    801073fc <alltraps>

8010819f <vector223>:
.globl vector223
vector223:
  pushl $0
8010819f:	6a 00                	push   $0x0
  pushl $223
801081a1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801081a6:	e9 51 f2 ff ff       	jmp    801073fc <alltraps>

801081ab <vector224>:
.globl vector224
vector224:
  pushl $0
801081ab:	6a 00                	push   $0x0
  pushl $224
801081ad:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801081b2:	e9 45 f2 ff ff       	jmp    801073fc <alltraps>

801081b7 <vector225>:
.globl vector225
vector225:
  pushl $0
801081b7:	6a 00                	push   $0x0
  pushl $225
801081b9:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801081be:	e9 39 f2 ff ff       	jmp    801073fc <alltraps>

801081c3 <vector226>:
.globl vector226
vector226:
  pushl $0
801081c3:	6a 00                	push   $0x0
  pushl $226
801081c5:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801081ca:	e9 2d f2 ff ff       	jmp    801073fc <alltraps>

801081cf <vector227>:
.globl vector227
vector227:
  pushl $0
801081cf:	6a 00                	push   $0x0
  pushl $227
801081d1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801081d6:	e9 21 f2 ff ff       	jmp    801073fc <alltraps>

801081db <vector228>:
.globl vector228
vector228:
  pushl $0
801081db:	6a 00                	push   $0x0
  pushl $228
801081dd:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801081e2:	e9 15 f2 ff ff       	jmp    801073fc <alltraps>

801081e7 <vector229>:
.globl vector229
vector229:
  pushl $0
801081e7:	6a 00                	push   $0x0
  pushl $229
801081e9:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801081ee:	e9 09 f2 ff ff       	jmp    801073fc <alltraps>

801081f3 <vector230>:
.globl vector230
vector230:
  pushl $0
801081f3:	6a 00                	push   $0x0
  pushl $230
801081f5:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801081fa:	e9 fd f1 ff ff       	jmp    801073fc <alltraps>

801081ff <vector231>:
.globl vector231
vector231:
  pushl $0
801081ff:	6a 00                	push   $0x0
  pushl $231
80108201:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80108206:	e9 f1 f1 ff ff       	jmp    801073fc <alltraps>

8010820b <vector232>:
.globl vector232
vector232:
  pushl $0
8010820b:	6a 00                	push   $0x0
  pushl $232
8010820d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80108212:	e9 e5 f1 ff ff       	jmp    801073fc <alltraps>

80108217 <vector233>:
.globl vector233
vector233:
  pushl $0
80108217:	6a 00                	push   $0x0
  pushl $233
80108219:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010821e:	e9 d9 f1 ff ff       	jmp    801073fc <alltraps>

80108223 <vector234>:
.globl vector234
vector234:
  pushl $0
80108223:	6a 00                	push   $0x0
  pushl $234
80108225:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010822a:	e9 cd f1 ff ff       	jmp    801073fc <alltraps>

8010822f <vector235>:
.globl vector235
vector235:
  pushl $0
8010822f:	6a 00                	push   $0x0
  pushl $235
80108231:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80108236:	e9 c1 f1 ff ff       	jmp    801073fc <alltraps>

8010823b <vector236>:
.globl vector236
vector236:
  pushl $0
8010823b:	6a 00                	push   $0x0
  pushl $236
8010823d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80108242:	e9 b5 f1 ff ff       	jmp    801073fc <alltraps>

80108247 <vector237>:
.globl vector237
vector237:
  pushl $0
80108247:	6a 00                	push   $0x0
  pushl $237
80108249:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010824e:	e9 a9 f1 ff ff       	jmp    801073fc <alltraps>

80108253 <vector238>:
.globl vector238
vector238:
  pushl $0
80108253:	6a 00                	push   $0x0
  pushl $238
80108255:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010825a:	e9 9d f1 ff ff       	jmp    801073fc <alltraps>

8010825f <vector239>:
.globl vector239
vector239:
  pushl $0
8010825f:	6a 00                	push   $0x0
  pushl $239
80108261:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80108266:	e9 91 f1 ff ff       	jmp    801073fc <alltraps>

8010826b <vector240>:
.globl vector240
vector240:
  pushl $0
8010826b:	6a 00                	push   $0x0
  pushl $240
8010826d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80108272:	e9 85 f1 ff ff       	jmp    801073fc <alltraps>

80108277 <vector241>:
.globl vector241
vector241:
  pushl $0
80108277:	6a 00                	push   $0x0
  pushl $241
80108279:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010827e:	e9 79 f1 ff ff       	jmp    801073fc <alltraps>

80108283 <vector242>:
.globl vector242
vector242:
  pushl $0
80108283:	6a 00                	push   $0x0
  pushl $242
80108285:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010828a:	e9 6d f1 ff ff       	jmp    801073fc <alltraps>

8010828f <vector243>:
.globl vector243
vector243:
  pushl $0
8010828f:	6a 00                	push   $0x0
  pushl $243
80108291:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80108296:	e9 61 f1 ff ff       	jmp    801073fc <alltraps>

8010829b <vector244>:
.globl vector244
vector244:
  pushl $0
8010829b:	6a 00                	push   $0x0
  pushl $244
8010829d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801082a2:	e9 55 f1 ff ff       	jmp    801073fc <alltraps>

801082a7 <vector245>:
.globl vector245
vector245:
  pushl $0
801082a7:	6a 00                	push   $0x0
  pushl $245
801082a9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801082ae:	e9 49 f1 ff ff       	jmp    801073fc <alltraps>

801082b3 <vector246>:
.globl vector246
vector246:
  pushl $0
801082b3:	6a 00                	push   $0x0
  pushl $246
801082b5:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801082ba:	e9 3d f1 ff ff       	jmp    801073fc <alltraps>

801082bf <vector247>:
.globl vector247
vector247:
  pushl $0
801082bf:	6a 00                	push   $0x0
  pushl $247
801082c1:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801082c6:	e9 31 f1 ff ff       	jmp    801073fc <alltraps>

801082cb <vector248>:
.globl vector248
vector248:
  pushl $0
801082cb:	6a 00                	push   $0x0
  pushl $248
801082cd:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801082d2:	e9 25 f1 ff ff       	jmp    801073fc <alltraps>

801082d7 <vector249>:
.globl vector249
vector249:
  pushl $0
801082d7:	6a 00                	push   $0x0
  pushl $249
801082d9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801082de:	e9 19 f1 ff ff       	jmp    801073fc <alltraps>

801082e3 <vector250>:
.globl vector250
vector250:
  pushl $0
801082e3:	6a 00                	push   $0x0
  pushl $250
801082e5:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801082ea:	e9 0d f1 ff ff       	jmp    801073fc <alltraps>

801082ef <vector251>:
.globl vector251
vector251:
  pushl $0
801082ef:	6a 00                	push   $0x0
  pushl $251
801082f1:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801082f6:	e9 01 f1 ff ff       	jmp    801073fc <alltraps>

801082fb <vector252>:
.globl vector252
vector252:
  pushl $0
801082fb:	6a 00                	push   $0x0
  pushl $252
801082fd:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80108302:	e9 f5 f0 ff ff       	jmp    801073fc <alltraps>

80108307 <vector253>:
.globl vector253
vector253:
  pushl $0
80108307:	6a 00                	push   $0x0
  pushl $253
80108309:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010830e:	e9 e9 f0 ff ff       	jmp    801073fc <alltraps>

80108313 <vector254>:
.globl vector254
vector254:
  pushl $0
80108313:	6a 00                	push   $0x0
  pushl $254
80108315:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010831a:	e9 dd f0 ff ff       	jmp    801073fc <alltraps>

8010831f <vector255>:
.globl vector255
vector255:
  pushl $0
8010831f:	6a 00                	push   $0x0
  pushl $255
80108321:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80108326:	e9 d1 f0 ff ff       	jmp    801073fc <alltraps>
8010832b:	66 90                	xchg   %ax,%ax
8010832d:	66 90                	xchg   %ax,%ax
8010832f:	90                   	nop

80108330 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80108330:	55                   	push   %ebp
80108331:	89 e5                	mov    %esp,%ebp
80108333:	57                   	push   %edi
80108334:	56                   	push   %esi
80108335:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80108337:	c1 ea 16             	shr    $0x16,%edx
{
8010833a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010833b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010833e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80108341:	8b 1f                	mov    (%edi),%ebx
80108343:	f6 c3 01             	test   $0x1,%bl
80108346:	74 28                	je     80108370 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80108348:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010834e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80108354:	89 f0                	mov    %esi,%eax
}
80108356:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80108359:	c1 e8 0a             	shr    $0xa,%eax
8010835c:	25 fc 0f 00 00       	and    $0xffc,%eax
80108361:	01 d8                	add    %ebx,%eax
}
80108363:	5b                   	pop    %ebx
80108364:	5e                   	pop    %esi
80108365:	5f                   	pop    %edi
80108366:	5d                   	pop    %ebp
80108367:	c3                   	ret    
80108368:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010836f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80108370:	85 c9                	test   %ecx,%ecx
80108372:	74 2c                	je     801083a0 <walkpgdir+0x70>
80108374:	e8 d7 a7 ff ff       	call   80102b50 <kalloc>
80108379:	89 c3                	mov    %eax,%ebx
8010837b:	85 c0                	test   %eax,%eax
8010837d:	74 21                	je     801083a0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010837f:	83 ec 04             	sub    $0x4,%esp
80108382:	68 00 10 00 00       	push   $0x1000
80108387:	6a 00                	push   $0x0
80108389:	50                   	push   %eax
8010838a:	e8 c1 d9 ff ff       	call   80105d50 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010838f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80108395:	83 c4 10             	add    $0x10,%esp
80108398:	83 c8 07             	or     $0x7,%eax
8010839b:	89 07                	mov    %eax,(%edi)
8010839d:	eb b5                	jmp    80108354 <walkpgdir+0x24>
8010839f:	90                   	nop
}
801083a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801083a3:	31 c0                	xor    %eax,%eax
}
801083a5:	5b                   	pop    %ebx
801083a6:	5e                   	pop    %esi
801083a7:	5f                   	pop    %edi
801083a8:	5d                   	pop    %ebp
801083a9:	c3                   	ret    
801083aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801083b0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801083b0:	55                   	push   %ebp
801083b1:	89 e5                	mov    %esp,%ebp
801083b3:	57                   	push   %edi
801083b4:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801083b6:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
801083ba:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801083bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
801083c0:	89 d6                	mov    %edx,%esi
{
801083c2:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801083c3:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
801083c9:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801083cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
801083cf:	8b 45 08             	mov    0x8(%ebp),%eax
801083d2:	29 f0                	sub    %esi,%eax
801083d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801083d7:	eb 1f                	jmp    801083f8 <mappages+0x48>
801083d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
801083e0:	f6 00 01             	testb  $0x1,(%eax)
801083e3:	75 45                	jne    8010842a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
801083e5:	0b 5d 0c             	or     0xc(%ebp),%ebx
801083e8:	83 cb 01             	or     $0x1,%ebx
801083eb:	89 18                	mov    %ebx,(%eax)
    if(a == last)
801083ed:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801083f0:	74 2e                	je     80108420 <mappages+0x70>
      break;
    a += PGSIZE;
801083f2:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
801083f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801083fb:	b9 01 00 00 00       	mov    $0x1,%ecx
80108400:	89 f2                	mov    %esi,%edx
80108402:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80108405:	89 f8                	mov    %edi,%eax
80108407:	e8 24 ff ff ff       	call   80108330 <walkpgdir>
8010840c:	85 c0                	test   %eax,%eax
8010840e:	75 d0                	jne    801083e0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80108410:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108413:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108418:	5b                   	pop    %ebx
80108419:	5e                   	pop    %esi
8010841a:	5f                   	pop    %edi
8010841b:	5d                   	pop    %ebp
8010841c:	c3                   	ret    
8010841d:	8d 76 00             	lea    0x0(%esi),%esi
80108420:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108423:	31 c0                	xor    %eax,%eax
}
80108425:	5b                   	pop    %ebx
80108426:	5e                   	pop    %esi
80108427:	5f                   	pop    %edi
80108428:	5d                   	pop    %ebp
80108429:	c3                   	ret    
      panic("remap");
8010842a:	83 ec 0c             	sub    $0xc,%esp
8010842d:	68 4c 98 10 80       	push   $0x8010984c
80108432:	e8 59 7f ff ff       	call   80100390 <panic>
80108437:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010843e:	66 90                	xchg   %ax,%ax

80108440 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80108440:	55                   	push   %ebp
80108441:	89 e5                	mov    %esp,%ebp
80108443:	57                   	push   %edi
80108444:	56                   	push   %esi
80108445:	89 c6                	mov    %eax,%esi
80108447:	53                   	push   %ebx
80108448:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010844a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80108450:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80108456:	83 ec 1c             	sub    $0x1c,%esp
80108459:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010845c:	39 da                	cmp    %ebx,%edx
8010845e:	73 5b                	jae    801084bb <deallocuvm.part.0+0x7b>
80108460:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80108463:	89 d7                	mov    %edx,%edi
80108465:	eb 14                	jmp    8010847b <deallocuvm.part.0+0x3b>
80108467:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010846e:	66 90                	xchg   %ax,%ax
80108470:	81 c7 00 10 00 00    	add    $0x1000,%edi
80108476:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80108479:	76 40                	jbe    801084bb <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010847b:	31 c9                	xor    %ecx,%ecx
8010847d:	89 fa                	mov    %edi,%edx
8010847f:	89 f0                	mov    %esi,%eax
80108481:	e8 aa fe ff ff       	call   80108330 <walkpgdir>
80108486:	89 c3                	mov    %eax,%ebx
    if(!pte)
80108488:	85 c0                	test   %eax,%eax
8010848a:	74 44                	je     801084d0 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
8010848c:	8b 00                	mov    (%eax),%eax
8010848e:	a8 01                	test   $0x1,%al
80108490:	74 de                	je     80108470 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80108492:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108497:	74 47                	je     801084e0 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80108499:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010849c:	05 00 00 00 80       	add    $0x80000000,%eax
801084a1:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
801084a7:	50                   	push   %eax
801084a8:	e8 e3 a4 ff ff       	call   80102990 <kfree>
      *pte = 0;
801084ad:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801084b3:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
801084b6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801084b9:	77 c0                	ja     8010847b <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
801084bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801084be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801084c1:	5b                   	pop    %ebx
801084c2:	5e                   	pop    %esi
801084c3:	5f                   	pop    %edi
801084c4:	5d                   	pop    %ebp
801084c5:	c3                   	ret    
801084c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801084cd:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801084d0:	89 fa                	mov    %edi,%edx
801084d2:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
801084d8:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
801084de:	eb 96                	jmp    80108476 <deallocuvm.part.0+0x36>
        panic("kfree");
801084e0:	83 ec 0c             	sub    $0xc,%esp
801084e3:	68 3e 8f 10 80       	push   $0x80108f3e
801084e8:	e8 a3 7e ff ff       	call   80100390 <panic>
801084ed:	8d 76 00             	lea    0x0(%esi),%esi

801084f0 <seginit>:
{
801084f0:	f3 0f 1e fb          	endbr32 
801084f4:	55                   	push   %ebp
801084f5:	89 e5                	mov    %esp,%ebp
801084f7:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801084fa:	e8 d1 b9 ff ff       	call   80103ed0 <cpuid>
  pd[0] = size-1;
801084ff:	ba 2f 00 00 00       	mov    $0x2f,%edx
80108504:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
8010850a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010850e:	c7 80 18 4e 11 80 ff 	movl   $0xffff,-0x7feeb1e8(%eax)
80108515:	ff 00 00 
80108518:	c7 80 1c 4e 11 80 00 	movl   $0xcf9a00,-0x7feeb1e4(%eax)
8010851f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80108522:	c7 80 20 4e 11 80 ff 	movl   $0xffff,-0x7feeb1e0(%eax)
80108529:	ff 00 00 
8010852c:	c7 80 24 4e 11 80 00 	movl   $0xcf9200,-0x7feeb1dc(%eax)
80108533:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80108536:	c7 80 28 4e 11 80 ff 	movl   $0xffff,-0x7feeb1d8(%eax)
8010853d:	ff 00 00 
80108540:	c7 80 2c 4e 11 80 00 	movl   $0xcffa00,-0x7feeb1d4(%eax)
80108547:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010854a:	c7 80 30 4e 11 80 ff 	movl   $0xffff,-0x7feeb1d0(%eax)
80108551:	ff 00 00 
80108554:	c7 80 34 4e 11 80 00 	movl   $0xcff200,-0x7feeb1cc(%eax)
8010855b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010855e:	05 10 4e 11 80       	add    $0x80114e10,%eax
  pd[1] = (uint)p;
80108563:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80108567:	c1 e8 10             	shr    $0x10,%eax
8010856a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010856e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80108571:	0f 01 10             	lgdtl  (%eax)
}
80108574:	c9                   	leave  
80108575:	c3                   	ret    
80108576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010857d:	8d 76 00             	lea    0x0(%esi),%esi

80108580 <switchkvm>:
{
80108580:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108584:	a1 e4 86 11 80       	mov    0x801186e4,%eax
80108589:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010858e:	0f 22 d8             	mov    %eax,%cr3
}
80108591:	c3                   	ret    
80108592:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801085a0 <switchuvm>:
{
801085a0:	f3 0f 1e fb          	endbr32 
801085a4:	55                   	push   %ebp
801085a5:	89 e5                	mov    %esp,%ebp
801085a7:	57                   	push   %edi
801085a8:	56                   	push   %esi
801085a9:	53                   	push   %ebx
801085aa:	83 ec 1c             	sub    $0x1c,%esp
801085ad:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801085b0:	85 f6                	test   %esi,%esi
801085b2:	0f 84 cb 00 00 00    	je     80108683 <switchuvm+0xe3>
  if(p->kstack == 0)
801085b8:	8b 46 08             	mov    0x8(%esi),%eax
801085bb:	85 c0                	test   %eax,%eax
801085bd:	0f 84 da 00 00 00    	je     8010869d <switchuvm+0xfd>
  if(p->pgdir == 0)
801085c3:	8b 46 04             	mov    0x4(%esi),%eax
801085c6:	85 c0                	test   %eax,%eax
801085c8:	0f 84 c2 00 00 00    	je     80108690 <switchuvm+0xf0>
  pushcli();
801085ce:	e8 6d d5 ff ff       	call   80105b40 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801085d3:	e8 88 b8 ff ff       	call   80103e60 <mycpu>
801085d8:	89 c3                	mov    %eax,%ebx
801085da:	e8 81 b8 ff ff       	call   80103e60 <mycpu>
801085df:	89 c7                	mov    %eax,%edi
801085e1:	e8 7a b8 ff ff       	call   80103e60 <mycpu>
801085e6:	83 c7 08             	add    $0x8,%edi
801085e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801085ec:	e8 6f b8 ff ff       	call   80103e60 <mycpu>
801085f1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801085f4:	ba 67 00 00 00       	mov    $0x67,%edx
801085f9:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80108600:	83 c0 08             	add    $0x8,%eax
80108603:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010860a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010860f:	83 c1 08             	add    $0x8,%ecx
80108612:	c1 e8 18             	shr    $0x18,%eax
80108615:	c1 e9 10             	shr    $0x10,%ecx
80108618:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010861e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80108624:	b9 99 40 00 00       	mov    $0x4099,%ecx
80108629:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80108630:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80108635:	e8 26 b8 ff ff       	call   80103e60 <mycpu>
8010863a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80108641:	e8 1a b8 ff ff       	call   80103e60 <mycpu>
80108646:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010864a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010864d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108653:	e8 08 b8 ff ff       	call   80103e60 <mycpu>
80108658:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010865b:	e8 00 b8 ff ff       	call   80103e60 <mycpu>
80108660:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80108664:	b8 28 00 00 00       	mov    $0x28,%eax
80108669:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010866c:	8b 46 04             	mov    0x4(%esi),%eax
8010866f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108674:	0f 22 d8             	mov    %eax,%cr3
}
80108677:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010867a:	5b                   	pop    %ebx
8010867b:	5e                   	pop    %esi
8010867c:	5f                   	pop    %edi
8010867d:	5d                   	pop    %ebp
  popcli();
8010867e:	e9 0d d5 ff ff       	jmp    80105b90 <popcli>
    panic("switchuvm: no process");
80108683:	83 ec 0c             	sub    $0xc,%esp
80108686:	68 52 98 10 80       	push   $0x80109852
8010868b:	e8 00 7d ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80108690:	83 ec 0c             	sub    $0xc,%esp
80108693:	68 7d 98 10 80       	push   $0x8010987d
80108698:	e8 f3 7c ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
8010869d:	83 ec 0c             	sub    $0xc,%esp
801086a0:	68 68 98 10 80       	push   $0x80109868
801086a5:	e8 e6 7c ff ff       	call   80100390 <panic>
801086aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801086b0 <inituvm>:
{
801086b0:	f3 0f 1e fb          	endbr32 
801086b4:	55                   	push   %ebp
801086b5:	89 e5                	mov    %esp,%ebp
801086b7:	57                   	push   %edi
801086b8:	56                   	push   %esi
801086b9:	53                   	push   %ebx
801086ba:	83 ec 1c             	sub    $0x1c,%esp
801086bd:	8b 45 0c             	mov    0xc(%ebp),%eax
801086c0:	8b 75 10             	mov    0x10(%ebp),%esi
801086c3:	8b 7d 08             	mov    0x8(%ebp),%edi
801086c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801086c9:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801086cf:	77 4b                	ja     8010871c <inituvm+0x6c>
  mem = kalloc();
801086d1:	e8 7a a4 ff ff       	call   80102b50 <kalloc>
  memset(mem, 0, PGSIZE);
801086d6:	83 ec 04             	sub    $0x4,%esp
801086d9:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801086de:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801086e0:	6a 00                	push   $0x0
801086e2:	50                   	push   %eax
801086e3:	e8 68 d6 ff ff       	call   80105d50 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801086e8:	58                   	pop    %eax
801086e9:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801086ef:	5a                   	pop    %edx
801086f0:	6a 06                	push   $0x6
801086f2:	b9 00 10 00 00       	mov    $0x1000,%ecx
801086f7:	31 d2                	xor    %edx,%edx
801086f9:	50                   	push   %eax
801086fa:	89 f8                	mov    %edi,%eax
801086fc:	e8 af fc ff ff       	call   801083b0 <mappages>
  memmove(mem, init, sz);
80108701:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108704:	89 75 10             	mov    %esi,0x10(%ebp)
80108707:	83 c4 10             	add    $0x10,%esp
8010870a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010870d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80108710:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108713:	5b                   	pop    %ebx
80108714:	5e                   	pop    %esi
80108715:	5f                   	pop    %edi
80108716:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80108717:	e9 d4 d6 ff ff       	jmp    80105df0 <memmove>
    panic("inituvm: more than a page");
8010871c:	83 ec 0c             	sub    $0xc,%esp
8010871f:	68 91 98 10 80       	push   $0x80109891
80108724:	e8 67 7c ff ff       	call   80100390 <panic>
80108729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108730 <loaduvm>:
{
80108730:	f3 0f 1e fb          	endbr32 
80108734:	55                   	push   %ebp
80108735:	89 e5                	mov    %esp,%ebp
80108737:	57                   	push   %edi
80108738:	56                   	push   %esi
80108739:	53                   	push   %ebx
8010873a:	83 ec 1c             	sub    $0x1c,%esp
8010873d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108740:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80108743:	a9 ff 0f 00 00       	test   $0xfff,%eax
80108748:	0f 85 99 00 00 00    	jne    801087e7 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
8010874e:	01 f0                	add    %esi,%eax
80108750:	89 f3                	mov    %esi,%ebx
80108752:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108755:	8b 45 14             	mov    0x14(%ebp),%eax
80108758:	01 f0                	add    %esi,%eax
8010875a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
8010875d:	85 f6                	test   %esi,%esi
8010875f:	75 15                	jne    80108776 <loaduvm+0x46>
80108761:	eb 6d                	jmp    801087d0 <loaduvm+0xa0>
80108763:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108767:	90                   	nop
80108768:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
8010876e:	89 f0                	mov    %esi,%eax
80108770:	29 d8                	sub    %ebx,%eax
80108772:	39 c6                	cmp    %eax,%esi
80108774:	76 5a                	jbe    801087d0 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108776:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108779:	8b 45 08             	mov    0x8(%ebp),%eax
8010877c:	31 c9                	xor    %ecx,%ecx
8010877e:	29 da                	sub    %ebx,%edx
80108780:	e8 ab fb ff ff       	call   80108330 <walkpgdir>
80108785:	85 c0                	test   %eax,%eax
80108787:	74 51                	je     801087da <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80108789:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010878b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010878e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80108793:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80108798:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010879e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801087a1:	29 d9                	sub    %ebx,%ecx
801087a3:	05 00 00 00 80       	add    $0x80000000,%eax
801087a8:	57                   	push   %edi
801087a9:	51                   	push   %ecx
801087aa:	50                   	push   %eax
801087ab:	ff 75 10             	pushl  0x10(%ebp)
801087ae:	e8 cd 97 ff ff       	call   80101f80 <readi>
801087b3:	83 c4 10             	add    $0x10,%esp
801087b6:	39 f8                	cmp    %edi,%eax
801087b8:	74 ae                	je     80108768 <loaduvm+0x38>
}
801087ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801087bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801087c2:	5b                   	pop    %ebx
801087c3:	5e                   	pop    %esi
801087c4:	5f                   	pop    %edi
801087c5:	5d                   	pop    %ebp
801087c6:	c3                   	ret    
801087c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801087ce:	66 90                	xchg   %ax,%ax
801087d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801087d3:	31 c0                	xor    %eax,%eax
}
801087d5:	5b                   	pop    %ebx
801087d6:	5e                   	pop    %esi
801087d7:	5f                   	pop    %edi
801087d8:	5d                   	pop    %ebp
801087d9:	c3                   	ret    
      panic("loaduvm: address should exist");
801087da:	83 ec 0c             	sub    $0xc,%esp
801087dd:	68 ab 98 10 80       	push   $0x801098ab
801087e2:	e8 a9 7b ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801087e7:	83 ec 0c             	sub    $0xc,%esp
801087ea:	68 4c 99 10 80       	push   $0x8010994c
801087ef:	e8 9c 7b ff ff       	call   80100390 <panic>
801087f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801087fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801087ff:	90                   	nop

80108800 <allocuvm>:
{
80108800:	f3 0f 1e fb          	endbr32 
80108804:	55                   	push   %ebp
80108805:	89 e5                	mov    %esp,%ebp
80108807:	57                   	push   %edi
80108808:	56                   	push   %esi
80108809:	53                   	push   %ebx
8010880a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
8010880d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80108810:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80108813:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108816:	85 c0                	test   %eax,%eax
80108818:	0f 88 b2 00 00 00    	js     801088d0 <allocuvm+0xd0>
  if(newsz < oldsz)
8010881e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80108821:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80108824:	0f 82 96 00 00 00    	jb     801088c0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010882a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80108830:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80108836:	39 75 10             	cmp    %esi,0x10(%ebp)
80108839:	77 40                	ja     8010887b <allocuvm+0x7b>
8010883b:	e9 83 00 00 00       	jmp    801088c3 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80108840:	83 ec 04             	sub    $0x4,%esp
80108843:	68 00 10 00 00       	push   $0x1000
80108848:	6a 00                	push   $0x0
8010884a:	50                   	push   %eax
8010884b:	e8 00 d5 ff ff       	call   80105d50 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80108850:	58                   	pop    %eax
80108851:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80108857:	5a                   	pop    %edx
80108858:	6a 06                	push   $0x6
8010885a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010885f:	89 f2                	mov    %esi,%edx
80108861:	50                   	push   %eax
80108862:	89 f8                	mov    %edi,%eax
80108864:	e8 47 fb ff ff       	call   801083b0 <mappages>
80108869:	83 c4 10             	add    $0x10,%esp
8010886c:	85 c0                	test   %eax,%eax
8010886e:	78 78                	js     801088e8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80108870:	81 c6 00 10 00 00    	add    $0x1000,%esi
80108876:	39 75 10             	cmp    %esi,0x10(%ebp)
80108879:	76 48                	jbe    801088c3 <allocuvm+0xc3>
    mem = kalloc();
8010887b:	e8 d0 a2 ff ff       	call   80102b50 <kalloc>
80108880:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80108882:	85 c0                	test   %eax,%eax
80108884:	75 ba                	jne    80108840 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80108886:	83 ec 0c             	sub    $0xc,%esp
80108889:	68 c9 98 10 80       	push   $0x801098c9
8010888e:	e8 2d 80 ff ff       	call   801008c0 <cprintf>
  if(newsz >= oldsz)
80108893:	8b 45 0c             	mov    0xc(%ebp),%eax
80108896:	83 c4 10             	add    $0x10,%esp
80108899:	39 45 10             	cmp    %eax,0x10(%ebp)
8010889c:	74 32                	je     801088d0 <allocuvm+0xd0>
8010889e:	8b 55 10             	mov    0x10(%ebp),%edx
801088a1:	89 c1                	mov    %eax,%ecx
801088a3:	89 f8                	mov    %edi,%eax
801088a5:	e8 96 fb ff ff       	call   80108440 <deallocuvm.part.0>
      return 0;
801088aa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801088b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801088b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801088b7:	5b                   	pop    %ebx
801088b8:	5e                   	pop    %esi
801088b9:	5f                   	pop    %edi
801088ba:	5d                   	pop    %ebp
801088bb:	c3                   	ret    
801088bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801088c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801088c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801088c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801088c9:	5b                   	pop    %ebx
801088ca:	5e                   	pop    %esi
801088cb:	5f                   	pop    %edi
801088cc:	5d                   	pop    %ebp
801088cd:	c3                   	ret    
801088ce:	66 90                	xchg   %ax,%ax
    return 0;
801088d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801088d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801088da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801088dd:	5b                   	pop    %ebx
801088de:	5e                   	pop    %esi
801088df:	5f                   	pop    %edi
801088e0:	5d                   	pop    %ebp
801088e1:	c3                   	ret    
801088e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801088e8:	83 ec 0c             	sub    $0xc,%esp
801088eb:	68 e1 98 10 80       	push   $0x801098e1
801088f0:	e8 cb 7f ff ff       	call   801008c0 <cprintf>
  if(newsz >= oldsz)
801088f5:	8b 45 0c             	mov    0xc(%ebp),%eax
801088f8:	83 c4 10             	add    $0x10,%esp
801088fb:	39 45 10             	cmp    %eax,0x10(%ebp)
801088fe:	74 0c                	je     8010890c <allocuvm+0x10c>
80108900:	8b 55 10             	mov    0x10(%ebp),%edx
80108903:	89 c1                	mov    %eax,%ecx
80108905:	89 f8                	mov    %edi,%eax
80108907:	e8 34 fb ff ff       	call   80108440 <deallocuvm.part.0>
      kfree(mem);
8010890c:	83 ec 0c             	sub    $0xc,%esp
8010890f:	53                   	push   %ebx
80108910:	e8 7b a0 ff ff       	call   80102990 <kfree>
      return 0;
80108915:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010891c:	83 c4 10             	add    $0x10,%esp
}
8010891f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108922:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108925:	5b                   	pop    %ebx
80108926:	5e                   	pop    %esi
80108927:	5f                   	pop    %edi
80108928:	5d                   	pop    %ebp
80108929:	c3                   	ret    
8010892a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108930 <deallocuvm>:
{
80108930:	f3 0f 1e fb          	endbr32 
80108934:	55                   	push   %ebp
80108935:	89 e5                	mov    %esp,%ebp
80108937:	8b 55 0c             	mov    0xc(%ebp),%edx
8010893a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010893d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80108940:	39 d1                	cmp    %edx,%ecx
80108942:	73 0c                	jae    80108950 <deallocuvm+0x20>
}
80108944:	5d                   	pop    %ebp
80108945:	e9 f6 fa ff ff       	jmp    80108440 <deallocuvm.part.0>
8010894a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108950:	89 d0                	mov    %edx,%eax
80108952:	5d                   	pop    %ebp
80108953:	c3                   	ret    
80108954:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010895b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010895f:	90                   	nop

80108960 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108960:	f3 0f 1e fb          	endbr32 
80108964:	55                   	push   %ebp
80108965:	89 e5                	mov    %esp,%ebp
80108967:	57                   	push   %edi
80108968:	56                   	push   %esi
80108969:	53                   	push   %ebx
8010896a:	83 ec 0c             	sub    $0xc,%esp
8010896d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80108970:	85 f6                	test   %esi,%esi
80108972:	74 55                	je     801089c9 <freevm+0x69>
  if(newsz >= oldsz)
80108974:	31 c9                	xor    %ecx,%ecx
80108976:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010897b:	89 f0                	mov    %esi,%eax
8010897d:	89 f3                	mov    %esi,%ebx
8010897f:	e8 bc fa ff ff       	call   80108440 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108984:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010898a:	eb 0b                	jmp    80108997 <freevm+0x37>
8010898c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108990:	83 c3 04             	add    $0x4,%ebx
80108993:	39 df                	cmp    %ebx,%edi
80108995:	74 23                	je     801089ba <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80108997:	8b 03                	mov    (%ebx),%eax
80108999:	a8 01                	test   $0x1,%al
8010899b:	74 f3                	je     80108990 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010899d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801089a2:	83 ec 0c             	sub    $0xc,%esp
801089a5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801089a8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801089ad:	50                   	push   %eax
801089ae:	e8 dd 9f ff ff       	call   80102990 <kfree>
801089b3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801089b6:	39 df                	cmp    %ebx,%edi
801089b8:	75 dd                	jne    80108997 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801089ba:	89 75 08             	mov    %esi,0x8(%ebp)
}
801089bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801089c0:	5b                   	pop    %ebx
801089c1:	5e                   	pop    %esi
801089c2:	5f                   	pop    %edi
801089c3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801089c4:	e9 c7 9f ff ff       	jmp    80102990 <kfree>
    panic("freevm: no pgdir");
801089c9:	83 ec 0c             	sub    $0xc,%esp
801089cc:	68 fd 98 10 80       	push   $0x801098fd
801089d1:	e8 ba 79 ff ff       	call   80100390 <panic>
801089d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801089dd:	8d 76 00             	lea    0x0(%esi),%esi

801089e0 <setupkvm>:
{
801089e0:	f3 0f 1e fb          	endbr32 
801089e4:	55                   	push   %ebp
801089e5:	89 e5                	mov    %esp,%ebp
801089e7:	56                   	push   %esi
801089e8:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801089e9:	e8 62 a1 ff ff       	call   80102b50 <kalloc>
801089ee:	89 c6                	mov    %eax,%esi
801089f0:	85 c0                	test   %eax,%eax
801089f2:	74 42                	je     80108a36 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
801089f4:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801089f7:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
801089fc:	68 00 10 00 00       	push   $0x1000
80108a01:	6a 00                	push   $0x0
80108a03:	50                   	push   %eax
80108a04:	e8 47 d3 ff ff       	call   80105d50 <memset>
80108a09:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80108a0c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80108a0f:	83 ec 08             	sub    $0x8,%esp
80108a12:	8b 4b 08             	mov    0x8(%ebx),%ecx
80108a15:	ff 73 0c             	pushl  0xc(%ebx)
80108a18:	8b 13                	mov    (%ebx),%edx
80108a1a:	50                   	push   %eax
80108a1b:	29 c1                	sub    %eax,%ecx
80108a1d:	89 f0                	mov    %esi,%eax
80108a1f:	e8 8c f9 ff ff       	call   801083b0 <mappages>
80108a24:	83 c4 10             	add    $0x10,%esp
80108a27:	85 c0                	test   %eax,%eax
80108a29:	78 15                	js     80108a40 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108a2b:	83 c3 10             	add    $0x10,%ebx
80108a2e:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80108a34:	75 d6                	jne    80108a0c <setupkvm+0x2c>
}
80108a36:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108a39:	89 f0                	mov    %esi,%eax
80108a3b:	5b                   	pop    %ebx
80108a3c:	5e                   	pop    %esi
80108a3d:	5d                   	pop    %ebp
80108a3e:	c3                   	ret    
80108a3f:	90                   	nop
      freevm(pgdir);
80108a40:	83 ec 0c             	sub    $0xc,%esp
80108a43:	56                   	push   %esi
      return 0;
80108a44:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80108a46:	e8 15 ff ff ff       	call   80108960 <freevm>
      return 0;
80108a4b:	83 c4 10             	add    $0x10,%esp
}
80108a4e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108a51:	89 f0                	mov    %esi,%eax
80108a53:	5b                   	pop    %ebx
80108a54:	5e                   	pop    %esi
80108a55:	5d                   	pop    %ebp
80108a56:	c3                   	ret    
80108a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108a5e:	66 90                	xchg   %ax,%ax

80108a60 <kvmalloc>:
{
80108a60:	f3 0f 1e fb          	endbr32 
80108a64:	55                   	push   %ebp
80108a65:	89 e5                	mov    %esp,%ebp
80108a67:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108a6a:	e8 71 ff ff ff       	call   801089e0 <setupkvm>
80108a6f:	a3 e4 86 11 80       	mov    %eax,0x801186e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108a74:	05 00 00 00 80       	add    $0x80000000,%eax
80108a79:	0f 22 d8             	mov    %eax,%cr3
}
80108a7c:	c9                   	leave  
80108a7d:	c3                   	ret    
80108a7e:	66 90                	xchg   %ax,%ax

80108a80 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108a80:	f3 0f 1e fb          	endbr32 
80108a84:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108a85:	31 c9                	xor    %ecx,%ecx
{
80108a87:	89 e5                	mov    %esp,%ebp
80108a89:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80108a8c:	8b 55 0c             	mov    0xc(%ebp),%edx
80108a8f:	8b 45 08             	mov    0x8(%ebp),%eax
80108a92:	e8 99 f8 ff ff       	call   80108330 <walkpgdir>
  if(pte == 0)
80108a97:	85 c0                	test   %eax,%eax
80108a99:	74 05                	je     80108aa0 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
80108a9b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80108a9e:	c9                   	leave  
80108a9f:	c3                   	ret    
    panic("clearpteu");
80108aa0:	83 ec 0c             	sub    $0xc,%esp
80108aa3:	68 0e 99 10 80       	push   $0x8010990e
80108aa8:	e8 e3 78 ff ff       	call   80100390 <panic>
80108aad:	8d 76 00             	lea    0x0(%esi),%esi

80108ab0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108ab0:	f3 0f 1e fb          	endbr32 
80108ab4:	55                   	push   %ebp
80108ab5:	89 e5                	mov    %esp,%ebp
80108ab7:	57                   	push   %edi
80108ab8:	56                   	push   %esi
80108ab9:	53                   	push   %ebx
80108aba:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108abd:	e8 1e ff ff ff       	call   801089e0 <setupkvm>
80108ac2:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108ac5:	85 c0                	test   %eax,%eax
80108ac7:	0f 84 9b 00 00 00    	je     80108b68 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108acd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80108ad0:	85 c9                	test   %ecx,%ecx
80108ad2:	0f 84 90 00 00 00    	je     80108b68 <copyuvm+0xb8>
80108ad8:	31 f6                	xor    %esi,%esi
80108ada:	eb 46                	jmp    80108b22 <copyuvm+0x72>
80108adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80108ae0:	83 ec 04             	sub    $0x4,%esp
80108ae3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80108ae9:	68 00 10 00 00       	push   $0x1000
80108aee:	57                   	push   %edi
80108aef:	50                   	push   %eax
80108af0:	e8 fb d2 ff ff       	call   80105df0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108af5:	58                   	pop    %eax
80108af6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80108afc:	5a                   	pop    %edx
80108afd:	ff 75 e4             	pushl  -0x1c(%ebp)
80108b00:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108b05:	89 f2                	mov    %esi,%edx
80108b07:	50                   	push   %eax
80108b08:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108b0b:	e8 a0 f8 ff ff       	call   801083b0 <mappages>
80108b10:	83 c4 10             	add    $0x10,%esp
80108b13:	85 c0                	test   %eax,%eax
80108b15:	78 61                	js     80108b78 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80108b17:	81 c6 00 10 00 00    	add    $0x1000,%esi
80108b1d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80108b20:	76 46                	jbe    80108b68 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108b22:	8b 45 08             	mov    0x8(%ebp),%eax
80108b25:	31 c9                	xor    %ecx,%ecx
80108b27:	89 f2                	mov    %esi,%edx
80108b29:	e8 02 f8 ff ff       	call   80108330 <walkpgdir>
80108b2e:	85 c0                	test   %eax,%eax
80108b30:	74 61                	je     80108b93 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80108b32:	8b 00                	mov    (%eax),%eax
80108b34:	a8 01                	test   $0x1,%al
80108b36:	74 4e                	je     80108b86 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80108b38:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80108b3a:	25 ff 0f 00 00       	and    $0xfff,%eax
80108b3f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80108b42:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80108b48:	e8 03 a0 ff ff       	call   80102b50 <kalloc>
80108b4d:	89 c3                	mov    %eax,%ebx
80108b4f:	85 c0                	test   %eax,%eax
80108b51:	75 8d                	jne    80108ae0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80108b53:	83 ec 0c             	sub    $0xc,%esp
80108b56:	ff 75 e0             	pushl  -0x20(%ebp)
80108b59:	e8 02 fe ff ff       	call   80108960 <freevm>
  return 0;
80108b5e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108b65:	83 c4 10             	add    $0x10,%esp
}
80108b68:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108b6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108b6e:	5b                   	pop    %ebx
80108b6f:	5e                   	pop    %esi
80108b70:	5f                   	pop    %edi
80108b71:	5d                   	pop    %ebp
80108b72:	c3                   	ret    
80108b73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108b77:	90                   	nop
      kfree(mem);
80108b78:	83 ec 0c             	sub    $0xc,%esp
80108b7b:	53                   	push   %ebx
80108b7c:	e8 0f 9e ff ff       	call   80102990 <kfree>
      goto bad;
80108b81:	83 c4 10             	add    $0x10,%esp
80108b84:	eb cd                	jmp    80108b53 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80108b86:	83 ec 0c             	sub    $0xc,%esp
80108b89:	68 32 99 10 80       	push   $0x80109932
80108b8e:	e8 fd 77 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80108b93:	83 ec 0c             	sub    $0xc,%esp
80108b96:	68 18 99 10 80       	push   $0x80109918
80108b9b:	e8 f0 77 ff ff       	call   80100390 <panic>

80108ba0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108ba0:	f3 0f 1e fb          	endbr32 
80108ba4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108ba5:	31 c9                	xor    %ecx,%ecx
{
80108ba7:	89 e5                	mov    %esp,%ebp
80108ba9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80108bac:	8b 55 0c             	mov    0xc(%ebp),%edx
80108baf:	8b 45 08             	mov    0x8(%ebp),%eax
80108bb2:	e8 79 f7 ff ff       	call   80108330 <walkpgdir>
  if((*pte & PTE_P) == 0)
80108bb7:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80108bb9:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80108bba:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108bbc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80108bc1:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108bc4:	05 00 00 00 80       	add    $0x80000000,%eax
80108bc9:	83 fa 05             	cmp    $0x5,%edx
80108bcc:	ba 00 00 00 00       	mov    $0x0,%edx
80108bd1:	0f 45 c2             	cmovne %edx,%eax
}
80108bd4:	c3                   	ret    
80108bd5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108be0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108be0:	f3 0f 1e fb          	endbr32 
80108be4:	55                   	push   %ebp
80108be5:	89 e5                	mov    %esp,%ebp
80108be7:	57                   	push   %edi
80108be8:	56                   	push   %esi
80108be9:	53                   	push   %ebx
80108bea:	83 ec 0c             	sub    $0xc,%esp
80108bed:	8b 75 14             	mov    0x14(%ebp),%esi
80108bf0:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108bf3:	85 f6                	test   %esi,%esi
80108bf5:	75 3c                	jne    80108c33 <copyout+0x53>
80108bf7:	eb 67                	jmp    80108c60 <copyout+0x80>
80108bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80108c00:	8b 55 0c             	mov    0xc(%ebp),%edx
80108c03:	89 fb                	mov    %edi,%ebx
80108c05:	29 d3                	sub    %edx,%ebx
80108c07:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80108c0d:	39 f3                	cmp    %esi,%ebx
80108c0f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80108c12:	29 fa                	sub    %edi,%edx
80108c14:	83 ec 04             	sub    $0x4,%esp
80108c17:	01 c2                	add    %eax,%edx
80108c19:	53                   	push   %ebx
80108c1a:	ff 75 10             	pushl  0x10(%ebp)
80108c1d:	52                   	push   %edx
80108c1e:	e8 cd d1 ff ff       	call   80105df0 <memmove>
    len -= n;
    buf += n;
80108c23:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80108c26:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80108c2c:	83 c4 10             	add    $0x10,%esp
80108c2f:	29 de                	sub    %ebx,%esi
80108c31:	74 2d                	je     80108c60 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80108c33:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80108c35:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80108c38:	89 55 0c             	mov    %edx,0xc(%ebp)
80108c3b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80108c41:	57                   	push   %edi
80108c42:	ff 75 08             	pushl  0x8(%ebp)
80108c45:	e8 56 ff ff ff       	call   80108ba0 <uva2ka>
    if(pa0 == 0)
80108c4a:	83 c4 10             	add    $0x10,%esp
80108c4d:	85 c0                	test   %eax,%eax
80108c4f:	75 af                	jne    80108c00 <copyout+0x20>
  }
  return 0;
}
80108c51:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108c54:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108c59:	5b                   	pop    %ebx
80108c5a:	5e                   	pop    %esi
80108c5b:	5f                   	pop    %edi
80108c5c:	5d                   	pop    %ebp
80108c5d:	c3                   	ret    
80108c5e:	66 90                	xchg   %ax,%ax
80108c60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108c63:	31 c0                	xor    %eax,%eax
}
80108c65:	5b                   	pop    %ebx
80108c66:	5e                   	pop    %esi
80108c67:	5f                   	pop    %edi
80108c68:	5d                   	pop    %ebp
80108c69:	c3                   	ret    
