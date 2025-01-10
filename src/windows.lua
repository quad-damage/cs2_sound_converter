local ffi = require("ffi")

local TRUE = 1
local FALSE = 0
local NULL = ffi.cast("void*", 0)

ffi.cdef([[
    typedef void* HKEY;
    typedef unsigned short WORD;
    typedef unsigned long DWORD;
    typedef DWORD* LPDWORD;
    typedef char* LPSTR;
    typedef const char* LPCSTR;
    typedef char CHAR;
    typedef void* PVOID;
    typedef PVOID HANDLE;
    typedef HANDLE HINSTANCE;
    typedef HANDLE* PHANDLE;
    typedef long LSTATUS;
    typedef int BOOL;
    typedef PVOID HWND;
    typedef void* LPVOID;
    typedef int INT;
    typedef unsigned char BYTE;
    typedef BYTE *LPBYTE;

    typedef struct tagOFNA {
        DWORD        lStructSize;
        HWND         hwndOwner;
        PVOID        hInstance;
        LPCSTR       lpstrFilter;
        LPSTR        lpstrCustomFilter;
        DWORD        nMaxCustFilter;
        DWORD        nFilterIndex;
        LPSTR        lpstrFile;
        DWORD        nMaxFile;
        LPSTR        lpstrFileTitle;
        DWORD        nMaxFileTitle;
        LPCSTR       lpstrInitialDir;
        LPCSTR       lpstrTitle;
        DWORD        Flags;
        WORD         nFileOffset;
        WORD         nFileExtension;
        LPCSTR       lpstrDefExt;
        PVOID        lCustData;
        PVOID        lpfnHook;
        LPCSTR       lpTemplateName;
        void *        pvReserved;
        DWORD        dwReserved;
        DWORD        FlagsEx;
    } OPENFILENAMEA, *LPOPENFILENAMEA;
    BOOL GetOpenFileNameA(LPOPENFILENAMEA unnamedParam1);
    DWORD CommDlgExtendedError();

    DWORD GetLastError();

    LSTATUS RegGetValueA(HKEY hkey, LPCSTR lpSubKey, LPCSTR lpValue, DWORD dwFlags, LPDWORD pdwType, PVOID pvData, LPDWORD pcbData);

    BOOL PathFileExistsA(LPCSTR pszPath);

    typedef struct _SECURITY_ATTRIBUTES {
        DWORD  nLength;
        LPVOID lpSecurityDescriptor;
        BOOL   bInheritHandle;
    } SECURITY_ATTRIBUTES, *PSECURITY_ATTRIBUTES, *LPSECURITY_ATTRIBUTES;
    BOOL CreateDirectoryA(LPCSTR lpPathName, LPSECURITY_ATTRIBUTES lpSecurityAttributes);
    
    BOOL CopyFileA(LPCSTR lpExistingFileName, LPCSTR lpNewFileName, BOOL bFailIfExists);

    typedef struct _STARTUPINFOA {
        DWORD  cb;
        LPSTR  lpReserved;
        LPSTR  lpDesktop;
        LPSTR  lpTitle;
        DWORD  dwX;
        DWORD  dwY;
        DWORD  dwXSize;
        DWORD  dwYSize;
        DWORD  dwXCountChars;
        DWORD  dwYCountChars;
        DWORD  dwFillAttribute;
        DWORD  dwFlags;
        WORD   wShowWindow;
        WORD   cbReserved2;
        LPBYTE lpReserved2;
        HANDLE hStdInput;
        HANDLE hStdOutput;
        HANDLE hStdError;
    } STARTUPINFOA, *LPSTARTUPINFOA;

    typedef struct _PROCESS_INFORMATION {
        HANDLE hProcess;
        HANDLE hThread;
        DWORD  dwProcessId;
        DWORD  dwThreadId;
    } PROCESS_INFORMATION, *PPROCESS_INFORMATION, *LPPROCESS_INFORMATION;
    BOOL CreateProcessA(LPCSTR lpApplicationName, LPSTR lpCommandLine, LPSECURITY_ATTRIBUTES lpProcessAttributes, LPSECURITY_ATTRIBUTES lpThreadAttributes, BOOL bInheritHandles, DWORD dwCreationFlags, LPVOID lpEnvironment, LPCSTR lpCurrentDirectory, LPSTARTUPINFOA lpStartupInfo, LPPROCESS_INFORMATION lpProcessInformation);

    BOOL CreatePipe(PHANDLE hReadPipe, PHANDLE hWritePipe, LPSECURITY_ATTRIBUTES lpPipeAttributes, DWORD nSize);
    BOOL SetHandleInformation(HANDLE hObject, DWORD dwMask, DWORD dwFlags);

    BOOL CloseHandle(HANDLE hObject);

    BOOL ReadFile(HANDLE hFile, LPVOID lpBuffer, DWORD nNumberOfBytesToRead, LPDWORD lpNumberOfBytesRead, LPVOID lpOverlapped);

    DWORD WaitForSingleObject(HANDLE hHandle, DWORD dwMilliseconds);

    HANDLE GetStdHandle(DWORD nStdHandle);
    BOOL GetConsoleMode(HANDLE hConsoleHandle, DWORD* lpMode);
    BOOL SetConsoleMode(HANDLE hConsoleHandle, DWORD dwMode);

]])

local comdlg32 = ffi.load("comdlg32.dll")
local shlwapi = ffi.load("shlwapi.dll")
local shell32 = ffi.load("Shell32.dll")
local kernel32 = ffi.load("kernel32.dll")

local windows = { 
    -- Predefined Keys - https://learn.microsoft.com/en-us/windows/win32/sysinfo/predefined-keys
    HKEY_CLASSES_ROOT         =   ffi.cast("HKEY", ffi.cast("uintptr_t", 0x80000000)),
    HKEY_CURRENT_CONFIG       =   ffi.cast("HKEY", ffi.cast("uintptr_t", 0x80000005)),
    HKEY_CURRENT_USER         =   ffi.cast("HKEY", ffi.cast("uintptr_t", 0x80000001)),
    HKEY_LOCAL_MACHINE        =   ffi.cast("HKEY", ffi.cast("uintptr_t", 0x80000002)),
    HKEY_PERFORMANCE_DATA     =   ffi.cast("HKEY", ffi.cast("uintptr_t", 0x80000004)),
    HKEY_PERFORMANCE_NLSTEXT  =   ffi.cast("HKEY", ffi.cast("uintptr_t", 0x80000060)),
    HKEY_PERFORMANCE_TEXT     =   ffi.cast("HKEY", ffi.cast("uintptr_t", 0x80000050)),
    HKEY_USERS                =   ffi.cast("HKEY", ffi.cast("uintptr_t", 0x80000003)),

    -- RegGetValueA dwFlags - https://learn.microsoft.com/en-us/windows/win32/api/winreg/nf-winreg-reggetvaluea#parameters
    RRF_RT_ANY                =   0x0000ffff,
    RRF_RT_DWORD              =   0x00000018,
    RRF_RT_QWORD              =   0x00000048,
    RRF_RT_REG_BINARY         =   0x00000008,
    RRF_RT_REG_DWORD          =   0x00000010,
    RRF_RT_REG_EXPAND_SZ      =   0x00000004,
    RRF_RT_REG_MULTI_SZ       =   0x00000020,
    RRF_RT_REG_NONE           =   0x00000001,
    RRF_RT_REG_QWORD          =   0x00000040,
    RRF_RT_REG_SZ             =   0x00000002,
    RRF_NOEXPAND              =   0x10000000,
    RRF_ZEROONFAILURE         =   0x20000000,
    RRF_SUBKEY_WOW6464KEY     =   0x00010000,
    RRF_SUBKEY_WOW6432KEY     =   0x00020000,

    -- System error codes - https://learn.microsoft.com/en-us/windows/win32/debug/system-error-codes--0-499-
    ERROR_INVALID_PARAMETER = 87,       -- The parameter is incorrect.
    ERROR_ALREADY_EXISTS    = 183,      -- Cannot create a file when that file already exists.
    ERROR_PATH_NOT_FOUND    = 3,        -- The system cannot find the path specified.
    ERROR_MORE_DATA         = 0xEA,     -- More data is available.
    ERROR_FILE_NOT_FOUND    = 2,        -- The system cannot find the file specified.
    ERROR_ACCESS_DENIED     = 5,        -- Access is denied.
    ERROR_NO_MORE_FILES     = 0x12,     -- There are no more files.
    ERROR_SUCCESS           = 0,        -- :slight_smile:

    -- https://learn.microsoft.com/en-us/windows/win32/api/handleapi/nf-handleapi-sethandleinformation#parameters
    HANDLE_FLAG_INHERIT             =   0x00000001, -- If this flag is set, a child process created with the bInheritHandles parameter of CreateProcess set to TRUE will inherit the object handle. 
    HANDLE_FLAG_PROTECT_FROM_CLOSE  =   0x00000002, -- If this flag is set, calling the CloseHandle function will not close the object handle. 

    -- https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/ns-processthreadsapi-startupinfoa#members
    STARTF_USESTDHANDLES    =   0x00000100, -- The hStdInput, hStdOutput, and hStdError members contain additional information. 
    -- Can't be arsed to do the rest...

    -- https://learn.microsoft.com/en-us/windows/win32/procthread/process-creation-flags#flags
    CREATE_NO_WINDOW    =   0x08000000, -- The process is a console application that is being run without a console window. Therefore, the console handle for the application is not set. This flag is ignored if the application is not a console application, or if it is used with either CREATE_NEW_CONSOLE or DETACHED_PROCESS.

    INFINITE = 4294967295, -- Taken straight from Visual Studio

    -- https://learn.microsoft.com/en-us/windows/console/getstdhandle
    STD_OUTPUT_HANDLE = -11,

    -- https://learn.microsoft.com/en-us/windows/console/getconsolemode
    ENABLE_VIRTUAL_TERMINAL_PROCESSING = 0x0004 -- When writing with WriteFile or WriteConsole, characters are parsed for VT100 and similar control character sequences that control cursor movement, color/font mode, and other operations that can also be performed via the existing Console APIs. 
}

function windows:GetStdHandle(nStdHandle)
    return ffi.C.GetStdHandle(nStdHandle)
end

function windows:GetConsoleMode(hConsoleHandle)
    local lpMode = ffi.new("DWORD[1]")
    if(kernel32.GetConsoleMode(hConsoleHandle, lpMode) ~= 0) then
        return lpMode[0]
    end

    error("kernel32.GetConsoleMode returned 0")
    return 0
end

function windows:SetConsoleMode(hConsoleHandle, dwMode)
    if(kernel32.SetConsoleMode(hConsoleHandle, dwMode) ~= 0) then
        return True
    end

    error("kernel32.SetConsoleMode returned 0")
    return False
end

function windows:EnableVirtualTerminalProcessing()
    local std_handle = self:GetStdHandle(self.STD_OUTPUT_HANDLE)
    local console_mode = bit.bor(self:GetConsoleMode(std_handle), self.ENABLE_VIRTUAL_TERMINAL_PROCESSING)
    self:SetConsoleMode(std_handle, console_mode)
end

function windows:RegGetValueA(hkey, lpSubKey, lpValue)
    local pvData_len = 1024

    -- Safe to say no string is 1MB. If we keep getting ERROR_MORE_DATA obviously something went wrong.
    while(pvData_len < 1048576) do
        local pdata = ffi.cast("char*", ffi.new("char[?]", pvData_len))
        local plen = ffi.new("DWORD[1]", pvData_len)

        local return_value = ffi.C.RegGetValueA(
            hkey,
            lpSubKey,
            lpValue,
            self.RRF_RT_ANY,
            nil,
            pdata,
            plen
        )

        if(return_value == self.ERROR_SUCCESS) then
            return ffi.string(pdata)
        elseif(return_value == self.ERROR_MORE_DATA) then
            pvData_len = pvData_len * 2
        elseif(return_value == self.ERROR_FILE_NOT_FOUND) then
            return nil
        else
            return nil -- TODO: Maybe throw error()?
        end
    end

    return nil
end

function windows:GetOpenFileNameA(filter, title)
    local lpstrFile = ffi.cast("LPSTR", ffi.new("char[?]", 512))
    local nMaxFile = ffi.cast("DWORD", 512)

    local unnamedParam1 = ffi.new("OPENFILENAMEA[1]")
    unnamedParam1[0].lStructSize = ffi.cast("DWORD", ffi.sizeof("OPENFILENAMEA"))
    unnamedParam1[0].lpstrFilter = table.concat(filter, "\0") .. "\0\0"
    unnamedParam1[0].lpstrFile = lpstrFile
    unnamedParam1[0].nMaxFile = nMaxFile
    unnamedParam1[0].lpstrTitle = title

    local return_value = comdlg32.GetOpenFileNameA(ffi.cast("LPOPENFILENAMEA", unnamedParam1)) 
    if(return_value == 0) then
        return nil, comdlg32.CommDlgExtendedError()
    else
        return ffi.string(lpstrFile)
    end
end

function windows:FileExists(path)
    return shlwapi.PathFileExistsA(path) == 1
end

function windows:CreateDirectoryA(path)
    local security_attributes = ffi.cast("LPSECURITY_ATTRIBUTES", 0)
    ffi.C.CreateDirectoryA(path, security_attributes)
end

function windows:CopyFileA(source, destination, fail_on_overwrite)
    if(ffi.C.CopyFileA(source, destination, fail_on_overwrite and 1 or 0) == 0) then
        return false, ffi.C.GetLastError()
    end
end

function windows:ShellExecuteA(lpOperation, lpFile, lpParameters, lpDirectory, nShowCmd)
    return shell32.ShellExecuteA(ffi.cast("HWND", 0), lpOperation, lpFile, lpParameters, ffi.cast("LPCSTR", 0), nShowCmd)
end

function windows:GetLastError()
    return ffi.C.GetLastError()
end

function windows:WaitForSingleObject(hHandle, dwMilliseconds)
    return ffi.C.WaitForSingleObject(hHandle, dwMilliseconds)
end

function windows:CreateProcess_WaitForFinish_ReadOut(cmd)
    local security_attributes = ffi.new("SECURITY_ATTRIBUTES[1]")
    local startup_info = ffi.new("STARTUPINFOA[1]")
    local process_information = ffi.new("PROCESS_INFORMATION[1]")
    local childprocess_out_rd = ffi.new("HANDLE[1]")
    local childprocess_out_wr = ffi.new("HANDLE[1]")

    security_attributes[0].nLength = ffi.sizeof("SECURITY_ATTRIBUTES")
    security_attributes[0].bInheritHandle = TRUE;
    security_attributes[0].lpSecurityDescriptor = ffi.cast("void*", NULL);

    if(ffi.C.CreatePipe(childprocess_out_rd, childprocess_out_wr, security_attributes, 0) == 0) then
        logger:error("Failed to create pipe.")
        return false, nil
    end

    if(ffi.C.SetHandleInformation(childprocess_out_rd[0], self.HANDLE_FLAG_INHERIT, 0) == 0) then
        logger:error("Failed to set handle information. %s", ffi.C.GetLastError())
        return false, nil
    end

    startup_info[0].cb = ffi.sizeof("STARTUPINFOA")
    startup_info[0].hStdOutput = childprocess_out_wr[0]
    startup_info[0].hStdError = childprocess_out_wr[0]
    startup_info[0].dwFlags = bit.bor(startup_info[0].dwFlags, self.STARTF_USESTDHANDLES)

    local cstr_cmd = ffi.new("char[?]", #cmd + 1)
    ffi.copy(cstr_cmd, cmd)

    if(ffi.C.CreateProcessA(
        NULL,
        cstr_cmd,
        NULL,
        NULL,
        TRUE,
        self.CREATE_NO_WINDOW,
        NULL,
        NULL,
        startup_info,
        process_information ) == 0) then
            logger:error("CreateProcess failed. %s", ffi.C.GetLastError())

            return false, nil
    end

    ffi.C.WaitForSingleObject(process_information[0].hProcess, self.INFINITE)

    local buffer = ffi.new("char[?]", 4096)
    if(ffi.C.ReadFile(childprocess_out_rd[0], buffer, 4095, NULL, NULL) == 0) then
        logger:error("ReadFile failed. %s", ffi.C.GetLastError())
        return false, nil
    end

    ffi.C.CloseHandle(childprocess_out_rd[0])
    ffi.C.CloseHandle(childprocess_out_wr[0])
    ffi.C.CloseHandle(process_information[0].hProcess)
    ffi.C.CloseHandle(process_information[0].hThread)

    return true, ffi.string(buffer)
end

return windows