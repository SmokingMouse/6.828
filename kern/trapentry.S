/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>

#include <kern/picirq.h>


###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
	TRAPHANDLER_NOEC(T_DIVIDE_handler, T_DIVIDE)
	TRAPHANDLER_NOEC(T_DEBUG_handler, T_DEBUG)
	TRAPHANDLER_NOEC(T_NMI_handler, T_NMI)
	TRAPHANDLER_NOEC(T_BRKPT_handler, T_BRKPT)
	TRAPHANDLER_NOEC(T_OFLOW_handler, T_OFLOW)
	TRAPHANDLER_NOEC(T_BOUND_handler, T_BOUND)
	TRAPHANDLER_NOEC(T_ILLOP_handler, T_ILLOP)
	TRAPHANDLER_NOEC(T_DEVICE_handler, T_DEVICE)
	TRAPHANDLER(T_DBLFLT_handler, T_DBLFLT)
	TRAPHANDLER(T_TSS_handler, T_TSS)
	TRAPHANDLER(T_SEGNP_handler, T_SEGNP)
	TRAPHANDLER(T_STACK_handler, T_STACK)
	TRAPHANDLER(T_GPFLT_handler, T_GPFLT)
	TRAPHANDLER(T_PGFLT_handler, T_PGFLT)
	TRAPHANDLER_NOEC(T_FPERR_handler, T_FPERR)
	TRAPHANDLER(T_ALIGN_handler, T_ALIGN)
	TRAPHANDLER_NOEC(T_MCHK_handler, T_MCHK)
	TRAPHANDLER_NOEC(T_SIMDERR_handler, T_SIMDERR)
	TRAPHANDLER_NOEC(T_SYSCALL_handler, T_SYSCALL)

	TRAPHANDLER_NOEC(irq_handler0, 32);
	TRAPHANDLER_NOEC(irq_handler1, 33);
	TRAPHANDLER_NOEC(irq_handler2, 34);
	TRAPHANDLER_NOEC(irq_handler3, 35);
	TRAPHANDLER_NOEC(irq_handler4, 36);
	TRAPHANDLER_NOEC(irq_handler5, 37);
	TRAPHANDLER_NOEC(irq_handler6, 38);
	TRAPHANDLER_NOEC(irq_handler7, 39);
	TRAPHANDLER_NOEC(irq_handler8, 40);
	TRAPHANDLER_NOEC(irq_handler9, 41);
	TRAPHANDLER_NOEC(irq_handler10, 42);
	TRAPHANDLER_NOEC(irq_handler11, 43);
	TRAPHANDLER_NOEC(irq_handler12, 44);
	TRAPHANDLER_NOEC(irq_handler13, 45);
	TRAPHANDLER_NOEC(irq_handler14, 46);
	TRAPHANDLER_NOEC(irq_handler15, 47);


/*
 * Lab 3: Your code here for _alltraps
 */
_alltraps:
	pushl %ds
	pushl %es
	pushal

	pushl %esp
	
	movw $GD_KD, %ax
    movw %ax, %ds
    movw %ax, %es
    call trap