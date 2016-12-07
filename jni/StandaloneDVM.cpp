/*
 * Copyright (C) 2015 mutter
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#include <jni.h>
#include <dlfcn.h>
#include <stddef.h>
#include <stdlib.h>
#include <stdio.h>

int main(int argc, char **argv) {

	jint (*func)(JavaVM**, JNIEnv**, void*);
	JavaVM* jvm;
	JNIEnv* env;
	JavaVMInitArgs args;
	JavaVMOption options[2];
	void* handle;
	const char* error;
	int result = EXIT_SUCCESS;

	options[0].optionString = "-Djava.class.path=./Hello.dex";
	options[1].optionString = "-verbose:class";
	args.options = options;
	args.nOptions = sizeof(options) / sizeof(JavaVMOption);
	args.version = JNI_VERSION_1_6;
	args.ignoreUnrecognized = JNI_FALSE;

	if ((handle = dlopen("/system/lib/libdvm.so", RTLD_LAZY)) == NULL) {
		printf("Can't open dalvik share library\n");
		printf("Try to open ART library\n");
		if ((handle = dlopen("/system/lib/libart.so", RTLD_LAZY)) == NULL) {
			printf("Can't open ART library, Quit!!!!!!\n");
			exit(EXIT_FAILURE);
		}
	}

	dlerror();

	*(void**) (&func) = dlsym(handle, "JNI_CreateJavaVM");
	if ((error = dlerror()) != NULL) {
		fprintf(stderr, "%s\n", error);
		exit(EXIT_FAILURE);
	}

	if ((*func)(&jvm, &env, reinterpret_cast<void*>(&args)) != JNI_OK) {
		fprintf(stderr, "%s\n", "create JVM error");
		exit(EXIT_FAILURE);
	}

	JNIEnv* penv;
	jvm->AttachCurrentThread(&penv, NULL);

	jclass cls = env->FindClass("com/mutter/standalonedvm/Hello");
	if (env->ExceptionCheck()) {
		fprintf(stderr, "%s\n", "can't find class");
		exit(EXIT_FAILURE);
	}

	jmethodID m = env->GetStaticMethodID(cls, "main", "([Ljava/lang/String;)V");
	if (env->ExceptionCheck()) {
		fprintf(stderr, "%s\n", "can't find method");
		exit(EXIT_FAILURE);
	}

	// we pass empty string argument
	jclass stringClz = env->FindClass("java/lang/String");
	if (env->ExceptionCheck()) {
		fprintf(stderr, "%s\n", "find class java/lang/String error");
		exit(EXIT_FAILURE);
	}

	jobjectArray stringArray = env->NewObjectArray(1, stringClz, NULL);
	if (env->ExceptionCheck()) {
		fprintf(stderr, "%s\n", "create string array error");
		result = EXIT_FAILURE;
		goto bail;
	}

	env->CallStaticVoidMethod(cls, m, stringArray);
	if (env->ExceptionCheck()) {
		fprintf(stderr, "%s\n", "call static void method error");
		result = EXIT_FAILURE;
		goto bail;
	}

bail:
	if (jvm != NULL) {
		if (jvm->DetachCurrentThread() != JNI_OK) {
			fprintf(stderr, "%s\n", "detach error");
			result = EXIT_FAILURE;
		}
		if (jvm->DestroyJavaVM() != JNI_OK) {
			fprintf(stderr, "%s\n", "destroy JavaVM error");
			result = EXIT_FAILURE;
		}
	}
	if (handle != NULL) {
		dlclose(handle);
	}
	exit(result);
}
