package design

import (
	. "goa.design/model/dsl"
	"goa.design/model/expr"
)

var _ = Design(func() {
	Enterprise("Enterprise")
	Version("v0.0")

	Person("External User", "A person outside the enterprise", func() {
		Uses("oCIS", "manages files, folders and shares with")

		Tag("Person")
	})
	/*var EndUser =*/ Person("End User", "A person part of an enterprise", func() {
		External()

		Uses("oCIS", "manages files, folders and shares with", Synchronous, func() {
			Tag("Relationship", "Synchronous")
		})
		Uses("oCIS/Android App", "manages files, folders and shares with", Synchronous, func() {
			Tag("Relationship", "Synchronous")
		})
		Uses("oCIS/iOS App", "manages files, folders and shares with", Synchronous, func() {
			Tag("Relationship", "Synchronous")
		})
		Uses("oCIS/Web Single-Page Application", "manages files, folders and shares with", "HTTPS", Synchronous, func() {
			Tag("Relationship", "Synchronous")
		})
		Uses("oCIS/Desktop client", "syncs and manages files, folders and shares with", Synchronous, func() {
			Tag("Relationship", "Synchronous")
		})
		Uses("Identity Management", "authenticates using", Synchronous, func() {
			Tag("Relationship", "Synchronous")
		})
		Tag("Person")
	})
	/*var Admin =*/ Person("Admin", "Manages the EFSS Platform", func() {
		Uses("oCIS", "provisions storage")
		Uses("Identity Management", "authenticates using")

		Tag("Person")
	})

	var IdentityManagementSystem = SoftwareSystem("Identity Management", "Manages and authenticates users", func() {

		External()

		Tag("Software System", "Existing System")
	})
	// TODO is actually a component?
	var StorageSystem = SoftwareSystem("Storage System", "persists all data", func() {

		External()

		Tag("Software System", "Existing System")
	})

	var (
		// Forward declaration so variables can be used to define views.

		// Containers aka every deployable thing

		// clients
		WebSinglePageApp *expr.Container
		//AndroidApp       *expr.Container
		//IOSApp           *expr.Container
		//DesktopClient    *expr.Container

		OcisProxy *expr.Container
		//OcisWeb        *expr.Container
		LibreGraph     *expr.Container
		OcisThumbnails *expr.Container

		// frontend
		RevaOCDav *expr.Container
		RevaOCS   *expr.Container

		// reva
		RevaGateway              *expr.Container
		RevaStorageRegistry      *expr.Container
		RevaHomeStorageProvider  *expr.Container
		RevaUsersStorageProvider *expr.Container
		//RevaPublicStorageProvider *expr.Container
		// Components aka things inside Containers

	)

	var oCISSystem = SoftwareSystem("oCIS", "Enterprise File Sync and Share", func() {

		Uses("Identity Management", "Authenticates and identifies users with", "OpenID Connect, LDAP", Synchronous)
		Uses("Storage System", "Manages access to", "POSIX, SMB, S3", Synchronous)

		Tag("Software System")

		/*AndroidApp =*/
		Container("Android App", "Provides a limited subset of the Internet banking functionality to customers via their mobile device.", "kotlin", func() {
			Uses(IdentityManagementSystem, "Makes API calls to", "OpenId Connect", Synchronous, func() {
				Tag("Relationship", "Synchronous")
			})
			Uses(OcisProxy, "syncs with", "WebDAV, OCS, LibreGraph", Synchronous, func() {
				Tag("Relationship", "Synchronous")
			})
			Tag("Element", "Container", "Mobile App")
		})

		/*IOSApp =*/
		Container("iOS App", "Provides a limited subset of the Internet banking functionality to customers via their mobile device.", "xcode", func() {
			Uses(IdentityManagementSystem, "Makes API calls to", "OpenId Connect", Synchronous, func() {
				Tag("Relationship", "Synchronous")
			})
			Uses(OcisProxy, "syncs with", "WebDAV, OCS, LibreGraph", Synchronous, func() {
				Tag("Relationship", "Synchronous")
			})
			Tag("Element", "Container", "Mobile App")
		})

		WebSinglePageApp = Container("Web Single-Page Application", "Provides all of the Internet banking functionality to customers via their web browser.", "JavaScript and Angular", func() {
			Uses(IdentityManagementSystem, "Makes API calls to", "OpenId Connect", Synchronous, func() {
				Tag("Relationship", "Synchronous")
			})
			Uses(OcisProxy, "syncs with", "WebDAV, OCS, LibreGraph", Synchronous, func() {
				Tag("Relationship", "Synchronous")
			})
			Tag("Element", "Container", "Web Browser")
		})

		/*OcisWeb =*/
		Container("ocis web", "Delivers the static content and the ocis web single page application.", "golang and vue", func() {
			Uses(WebSinglePageApp, "Delivers to the users web browser", Synchronous, func() {
				Tag("Relationship", "Synchronous")
			})
			Tag("Element", "Container")
		})

		/*DesktopClient =*/
		Container("Desktop client", "syncs files with the users computer", "C++", func() {
			Uses(IdentityManagementSystem, "Makes API calls to", "OpenId Connect", Synchronous, func() {
				Tag("Relationship", "Synchronous")
			})
			Uses(OcisProxy, "syncs with", "WebDAV, OCS, LibreGraph", Synchronous, func() {
				Tag("Relationship", "Synchronous")
			})
			Tag("Element", "Container", "Desktop Client")
		})

		// TODO hide this it only clutters the container diagram, similar to a message bus
		// TODO all clients "Makes API calls to" ... the proxy. better to show actual calls to the graph, frontend ...
		// TODO indicate that there is an API gateway that can route based on user ... where? in the label of a relationship?

		OcisProxy = Container("ocis proxy", "routes requests based on the logged in user", "golang, go-micro", func() {
			Uses(IdentityManagementSystem, "forwards and makes API calls to", "OpenId Connect", Synchronous, func() {
				Tag("Relationship", "Synchronous")
			})
			Uses(RevaOCDav, "forwards /(web)dav WebDAV API calls to", "HTTP", Synchronous, func() {
				Tag("Relationship", "Synchronous")
			})
			Uses(RevaOCS, "forwards /ocs API calls to", "HTTP", Synchronous, func() {
				Tag("Relationship", "Synchronous")
			})
			Uses(LibreGraph, "forwards /graph API calls to", "HTTP", Synchronous, func() {
				Tag("Relationship", "Synchronous")
			})
			Uses(OcisThumbnails, "forwards thumbnail preview API calls to", "HTTP", Synchronous, func() {
				Tag("Relationship", "Synchronous")
			})
			// TODO OCM
			Tag("Element", "Container")
		})

		LibreGraph = Container("graph", "implements libregraph for /me/drives and more", "golang, reva", func() {
			Uses(RevaGateway, "Uses", "CS3/GRPC", Synchronous, func() {
				Tag("Relationship", "Synchronous")
			})
			Tag("Element", "Component")
		})
		OcisThumbnails = Container("ocis thumbnails", "generates thumbnails", "golang, go-micro", func() {
			Uses(RevaOCDav, "fetch public thumbnails", "HTTP", Synchronous, func() {
				Tag("Relationship", "Synchronous")
			})
			Uses(RevaGateway, "fetch privats thumbnails", "CS3/GRPC", Synchronous, func() {
				Tag("Relationship", "Synchronous")
			})
			Tag("Element", "Container")
		})
		RevaOCDav = Container("ocdav", "implements ownCloud flavoured WebDAV", "golang, reva", func() {
			Uses(RevaGateway, "Uses", "CS3/GRPC", Synchronous, func() {
				Tag("Relationship", "Synchronous")
			})
			Tag("Element", "Component")
		})
		RevaOCS = Container("ocs", "implements openCollaborationServices for sharing and user provisioning", "golang, reva", func() {
			Uses(RevaGateway, "Uses", "CS3/GRPC", Synchronous, func() {
				Tag("Relationship", "Synchronous")
			})
			Tag("Element", "Component")
		})
		RevaGateway = Container("reva gateway", "the gateway to all reva services", "golang, reva", func() {
			Uses(RevaStorageRegistry, "looks up storage provider address and port", "POSIX, SMB, S3", Synchronous, func() {
				Tag("Relationship", "Synchronous")
			})
			Uses(RevaHomeStorageProvider, "forwards cs3:///home requests", "POSIX, SMB, S3", Synchronous, func() {
				Tag("Relationship", "Synchronous")
			})
			Uses(RevaUsersStorageProvider, "forwards cs3:///users requests", "POSIX, SMB, S3", Synchronous, func() {
				Tag("Relationship", "Synchronous")
			})
			Tag("Element", "Container")

		})

		RevaStorageRegistry = Container("reva storage registry", "api gateway for reva", "golang, reva", func() {
			Tag("Element", "Container")
		})
		RevaHomeStorageProvider = Container("reva home storage provider", "api gateway for reva", "golang, reva", func() {
			Uses(StorageSystem, "reads and writes to", Synchronous, func() {
				Tag("Relationship", "Synchronous")
			})
			Component("storage driver", "a storage driver", "Go storage.FS interface", func() {
				Uses(StorageSystem, "reads and writes to", Synchronous, func() {
					Tag("Relationship", "Synchronous")
				})
			})
			Tag("Element", "Container")
		})
		RevaUsersStorageProvider = Container("reva users storage provider", "api gateway for reva", "golang, reva", func() {
			Uses(StorageSystem, "reads and writes to", Synchronous, func() {
				Tag("Relationship", "Synchronous")
			})
			Component("storage driver", "a storage driver", "Go storage.FS interface", func() {
				Uses(StorageSystem, "reads and writes to", Synchronous, func() {
					Tag("Relationship", "Synchronous")
				})
			})
			Tag("Element", "Container")
		})
		/*RevaPublicStorageProvider =*/ Container("reva public storage provider", "api gateway for reva", "golang, reva", func() {
			Uses(RevaGateway, "reads and writes to", Synchronous, func() {
				Tag("Relationship", "Synchronous")
			})
			Tag("Element", "Container")
		})

	})

	Views(func() {
		SystemContextView(oCISSystem, "oCIS Context", "C4 System Context diagram for oCIS", func() {
			EnterpriseBoundaryVisible()
			AddAll()
			AutoLayout(RankTopBottom, func() {

				// Separation between ranks in pixels, defaults to 300.
				RankSeparation(300)

				// Separation between nodes in the same rank in pixels, defaults to 600.
				NodeSeparation(600)

				// Separation between edges in pixels, defaults to 200.
				EdgeSeparation(200)

				// Create vertices during automatic layout, false by default.
				RenderVertices()
			})
		})

		ContainerView(oCISSystem, "oCIS Containers", "The container diagram for the oCIS System.", func() {
			PaperSize(SizeA5Landscape)
			AddContainers()
			// Make software system boundaries visible for "external" containers
			// (those outside the software system in scope).
			SystemBoundariesVisible()

			AutoLayout(RankTopBottom)
		})

		Styles(func() {
			ElementStyle("Software System", func() {
				Background("#1168bd")
				Color("#ffffff")
			})
			ElementStyle("Container", func() {
				Background("#438dd5")
				Color("#ffffff")
			})
			ElementStyle("Component", func() {
				Background("#85bbf0")
				Color("#000000")
			})
			ElementStyle("Person", func() {
				Background("#08427b")
				Color("#ffffff")
				FontSize(22)
				Shape(ShapePerson)
			})
			ElementStyle("Existing System", func() {
				Background("#999999")
				Color("#ffffff")
			})
			ElementStyle("Web Browser", func() {
				Shape(ShapeWebBrowser)
			})
			ElementStyle("Mobile App", func() {
				Shape(ShapeMobileDeviceLandscape)
			})
			ElementStyle("Desktop Client", func() {
				Shape(ShapeRoundedBox)
			})
			ElementStyle("Database", func() {
				Shape(ShapeCylinder)
			})
			ElementStyle("Failover", func() {
				Opacity(25)
			})
			RelationshipStyle("Failover", func() {
				Opacity(25)
			})
		})
	})

})
