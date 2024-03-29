﻿//=============================================================================================================================
//
// EasyAR 3.0.0-beta-read4b2a1
// Copyright (c) 2015-2018 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_BUFFER_H__
#define __EASYAR_BUFFER_H__

#include "easyar/types.h"

#ifdef __cplusplus
extern "C" {
#endif

void easyar_Buffer_create(int size, /* OUT */ easyar_Buffer * * Return);
void * easyar_Buffer_data(const easyar_Buffer * This);
int easyar_Buffer_size(const easyar_Buffer * This);
bool easyar_Buffer_copyFrom(easyar_Buffer * This, void * src, int srcPos, int destPos, int length);
void easyar_Buffer__dtor(easyar_Buffer * This);
void easyar_Buffer__retain(const easyar_Buffer * This, /* OUT */ easyar_Buffer * * Return);
const char * easyar_Buffer__typeName(const easyar_Buffer * This);

#ifdef __cplusplus
}
#endif

#endif
