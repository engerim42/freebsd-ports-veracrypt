/*
 Derived from source code of TrueCrypt 7.1a, which is
 Copyright (c) 2008-2012 TrueCrypt Developers Association and which is governed
 by the TrueCrypt License 3.0.

 Modifications and additions to the original source code (contained in this file) 
 and all other portions of this file are Copyright (c) 2013-2015 IDRIX
 and are governed by the Apache License 2.0 the full text of which is
 contained in the file License.txt included in VeraCrypt binary and source
 code distribution packages.
*/

#include "System.h"
#include <wx/stdpaths.h>
#include "Main.h"
#include "Application.h"
#include "CommandLineInterface.h"
#ifndef TC_NO_GUI
#include "GraphicUserInterface.h"
#endif
#include "TextUserInterface.h"

namespace VeraCrypt
{
	wxApp* Application::CreateConsoleApp ()
	{
		mUserInterface = new TextUserInterface;
		mUserInterfaceType = UserInterfaceType::Text;
		return mUserInterface;
	} 

#ifndef TC_NO_GUI
	wxApp* Application::CreateGuiApp ()
	{
		mUserInterface = new GraphicUserInterface;
		mUserInterfaceType = UserInterfaceType::Graphic;
		return mUserInterface;
	} 
#endif

	FilePath Application::GetConfigFilePath (const wxString &configFileName, bool createConfigDir)
	{
		DirectoryPath configDir;
		
		if (!Core->IsInPortableMode())
		{
#ifdef TC_MACOSX
			wxFileName configPath (L"~/Library/Application Support/VeraCrypt");
			configPath.Normalize();
			configDir = wstring (configPath.GetFullPath());
#else
#if 0
			wxStandardPaths& stdPaths = wxStandardPaths::Get();
			configDir = wstring (stdPaths.GetUserDataDir());
#endif
#endif
		}
		else
			configDir = GetExecutableDirectory();

		if (createConfigDir && !configDir.IsDirectory())
			Directory::Create (configDir);

		FilePath filePath = wstring (wxFileName (wstring (configDir), configFileName).GetFullPath());
		return filePath;
	}

	DirectoryPath Application::GetExecutableDirectory ()
	{
		return wstring (wxFileName (wxStandardPaths::Get().GetExecutablePath()).GetPath());
	}

	FilePath Application::GetExecutablePath ()
	{
		return wstring (wxStandardPaths::Get().GetExecutablePath());
	}

	void Application::Initialize (UserInterfaceType::Enum type)
	{
		switch (type)
		{
		case UserInterfaceType::Text:
			{
				wxAppInitializer wxTheAppInitializer((wxAppInitializerFunction) CreateConsoleApp);
				break;
			}

#ifndef TC_NO_GUI
		case UserInterfaceType::Graphic:
			{
				wxAppInitializer wxTheAppInitializer((wxAppInitializerFunction) CreateGuiApp);
				break;
			}
#endif

		default:
			throw ParameterIncorrect (SRC_POS);
		}
	}

	int Application::ExitCode = 0;
	UserInterface *Application::mUserInterface = nullptr;
	UserInterfaceType::Enum Application::mUserInterfaceType;
}
