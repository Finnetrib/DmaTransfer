/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include <xil_io.h>
#include "sleep.h"
#include "xil_cache.h"
#include "xil_mem.h"

#pragma pack (1)
struct SGDesc
{
	u32 NXTDESC;
	u32 NXTDESC_MSB;
	u32 BUFFER_ADDRESS;
	u32 BUFFER_ADDRESS_MSB;
	u32 RESERVED0;
	u32 RESERVED1;
	u32 CONTROL;
	u32 STATUS;
	u32 APP0;
	u32 APP1;
	u32 APP2;
	u32 APP3;
	u32 APP4;
};

#define BUFFER_SIZE 102400
#define DESC_COUNT 256

u8 TxBuffer[DESC_COUNT][BUFFER_SIZE];
u8 RxBuffer[DESC_COUNT][BUFFER_SIZE];

int main()
{
    /** Descriptors for receive */
	struct SGDesc RxDesc[DESC_COUNT];

	/** Descriptors for transmit */
	struct SGDesc TxDesc[DESC_COUNT];

	/** Address for work with descriptors */
	u32 DescAddr;

	/** Status of descriptor */
	u32 status;

	/** Count wait cycle */
	u32 countWait = 0x0;

	init_platform();

	/** Flush Cache */
	Xil_DCacheFlush();

	/** Disable Cache */
	Xil_DCacheDisable();

	xil_printf("Hello World\n\r");

	/** Fill buffer for transmit */
	for (u16 desc = 0; desc < DESC_COUNT; desc++)
	{
		for (u32 i = 0; i < BUFFER_SIZE; i++)
		{
			TxBuffer[desc][i] = desc + i;
		}
	}

	/** Fill descriptor for transmit */
	for (u16 i = 0; i < DESC_COUNT; i++)
	{
		TxDesc[i].NXTDESC = &TxDesc[i];
		TxDesc[i].NXTDESC_MSB = 0x0;
		TxDesc[i].BUFFER_ADDRESS = &TxBuffer[i][0];
		TxDesc[i].BUFFER_ADDRESS_MSB = 0x0;
		TxDesc[i].RESERVED0 = 0x0;
		TxDesc[i].RESERVED1 = 0x0;
		TxDesc[i].CONTROL = 0xC000000 + sizeof(TxBuffer[i]);
		TxDesc[i].STATUS = 0x0;
		TxDesc[i].APP0 = 0x0;
		TxDesc[i].APP1 = 0x0;
		TxDesc[i].APP2 = 0x0;
		TxDesc[i].APP3 = 0x0;
		TxDesc[i].APP4 = 0x0;
	}

	/** Copy transmit descriptor for memory of descriptors */
	DescAddr = 0x40000000;
	for (u16 i = 0; i < DESC_COUNT; i++)
	{
		Xil_MemCpy(DescAddr, &TxDesc[i], sizeof(TxDesc[i]));
		DescAddr += 0x40;
	}

	/** Write pointer to next pointer */
	DescAddr = 0x40000000;
	for (u16 i = 0; i < DESC_COUNT - 1; i++)
	{
		Xil_Out32(DescAddr, DescAddr + 0x40);
		DescAddr += 0x40;
	}

	/** Write pointer for last descriptor */
	Xil_Out32(DescAddr, DescAddr);

	/** Fill descriptor to receive */
	for (u16 i = 0; i < DESC_COUNT; i++)
	{
		RxDesc[i].NXTDESC = &RxDesc[i];
		RxDesc[i].NXTDESC_MSB = 0x0;
		RxDesc[i].BUFFER_ADDRESS = &RxBuffer[i][0];
		RxDesc[i].BUFFER_ADDRESS_MSB = 0x0;
		RxDesc[i].RESERVED0 = 0x0;
		RxDesc[i].RESERVED1 = 0x0;
		RxDesc[i].CONTROL = sizeof(RxBuffer[i]);
		RxDesc[i].STATUS = 0x0;
		RxDesc[i].APP0 = 0x0;
		RxDesc[i].APP1 = 0x0;
		RxDesc[i].APP2 = 0x0;
		RxDesc[i].APP3 = 0x0;
		RxDesc[i].APP4 = 0x0;
	}

	/** Copy receive descriptor for memory of descriptors */
	DescAddr = 0x40000000 + 0x4000;
	for (u16 i = 0; i < DESC_COUNT; i++)
	{
		Xil_MemCpy(DescAddr, &RxDesc[i], sizeof(RxDesc[i]));
		DescAddr += 0x40;
	}

	/** Write pointer to next pointer */
	DescAddr = 0x40000000 + 0x4000;
	for (u16 i = 0; i < DESC_COUNT - 1; i++)
	{
		Xil_Out32(DescAddr, DescAddr + 0x40);
		DescAddr += 0x40;
	}

	/** Write pointer for last descriptor */
	Xil_Out32(DescAddr, DescAddr);

	/** Reset DMA and setup */

	/** MM2S */
    Xil_Out32(0x40400000, 0x0001dfe6);
    Xil_Out32(0x40400000, 0x0001dfe2);

    /** S2MM */
    Xil_Out32(0x40400030, 0x0001dfe6);
    Xil_Out32(0x40400030, 0x0001dfe2);

    /** PL => PS */
    Xil_Out32(0x4040003c, 0x00000000);
    Xil_Out32(0x40400038, 0x40004000);
    Xil_Out32(0x40400030, 0x0001dfe3);
    Xil_Out32(0x40400044, 0x00000000);
    Xil_Out32(0x40400040, 0x40007FC0);

    /** PS => PL */
    Xil_Out32(0x4040000C, 0x00000000);
    Xil_Out32(0x40400008, 0x40000000);
    Xil_Out32(0x40400000, 0x0001dfe3);
    Xil_Out32(0x40400014, 0x00000000);
    Xil_Out32(0x40400010, 0x40003FC0);

    /** Wait ready in last descriptor */
    while (1)
    {
    	status = Xil_In32(0x40003FDC);
    	if ((status & 0x80000000) == 0x80000000)
    	{
    		break;
    	}
    	else
    	{
    		countWait++;
    		usleep(100);
    	}
    }

    xil_printf("Time %x \n\r", countWait);

    while (1)
    {

    }

    cleanup_platform();
    return 0;
}
